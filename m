Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab0CSUq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:46:56 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:42938 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301Ab0CSUqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:46:52 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Subject: [PATCH 2/4] virtio-balloon: implement balloon reset
To: linux-kernel@vger.kernel.org
Cc: pv-drivers@vmware.com, Alok Kataria <akataria@vmware.com>,
       Saileshkumar Jain <sajain@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 19 Mar 2010 13:46:52 -0700
Message-ID: <20100319204652.4418.93863.stgit@localhost.localdomain>
In-Reply-To: <20100319204628.4418.84674.stgit@localhost.localdomain>
References: <20100319204628.4418.84674.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMware hypervisor in certain cases may release all locked pages and
signal "reset" condition to the guest. In this case guest is expected
to free all pages allocated by its balloon but should not notify host
that pages have been released.

Note that hypervisors that require guest to tell about pages being
released should implement 'reset' by simply setting target ballon
size to 0.

Reviewed-by: Alok Kataria <akataria@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---

 drivers/virtio/virtio_balloon.c |   52 +++++++++++++++++++++++++++++++++++++--
 include/linux/virtio_balloon.h  |    5 ++++
 2 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 444c929..ff6299c 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -197,6 +197,20 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
 	}
 }
 
+static void pop_balloon(struct virtio_balloon *vb)
+{
+	struct page *page, *next;
+
+	list_for_each_entry_safe(page, next, &vb->pages, lru) {
+		list_del(&page->lru);
+		__free_page(page);
+		vb->num_pages--;
+		totalram_pages++;
+	}
+
+	release_refused_pages(vb);
+}
+
 static inline void update_stat(struct virtio_balloon *vb, int idx,
 			       u16 tag, u64 val)
 {
@@ -270,9 +284,10 @@ static void virtballoon_changed(struct virtio_device *vdev)
 	wake_up(&vb->config_change);
 }
 
-static inline s64 towards_target(struct virtio_balloon *vb)
+static s64 towards_target(struct virtio_balloon *vb)
 {
 	u32 v;
+
 	vb->vdev->config->get(vb->vdev,
 			      offsetof(struct virtio_balloon_config, num_pages),
 			      &v, sizeof(v));
@@ -288,21 +303,51 @@ static void update_balloon_size(struct virtio_balloon *vb)
 			      &actual, sizeof(actual));
 }
 
+static bool check_need_reset(struct virtio_balloon *vb)
+{
+	bool reset_pending;
+
+	if (!virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_CAN_RESET))
+		return false;
+
+	vb->vdev->config->get(vb->vdev,
+			offsetof(struct virtio_balloon_config, reset_pending),
+			&reset_pending, sizeof(reset_pending));
+	return reset_pending;
+}
+
+static void mark_balloon_reset(struct virtio_balloon *vb)
+{
+	bool reset_completed = true;
+
+	vb->vdev->config->set(vb->vdev,
+			offsetof(struct virtio_balloon_config, reset_completed),
+			&reset_completed, sizeof(reset_completed));
+}
+
+
 static int balloon(void *_vballoon)
 {
 	struct virtio_balloon *vb = _vballoon;
 
 	set_freezable();
 	while (!kthread_should_stop()) {
-		s64 diff;
+		s64 diff = 0;
+		bool reset;
 
 		try_to_freeze();
 		wait_event_interruptible(vb->config_change,
-					 (diff = towards_target(vb)) != 0
+					    (reset = check_need_reset(vb))
+					 || (diff = towards_target(vb)) != 0
 					 || vb->need_stats_update
 					 || kthread_should_stop()
 					 || freezing(current));
 
+		if (reset) {
+			pop_balloon(vb);
+			mark_balloon_reset(vb);
+		}
+
 		if (vb->need_stats_update)
 			stats_handle_request(vb);
 
@@ -411,6 +456,7 @@ static unsigned int features[] = {
 	VIRTIO_BALLOON_F_MUST_TELL_HOST,
 	VIRTIO_BALLOON_F_STATS_VQ,
 	VIRTIO_BALLOON_F_HOST_MAY_REFUSE,
+	VIRTIO_BALLOON_F_CAN_RESET,
 };
 
 static struct virtio_driver virtio_balloon_driver = {
diff --git a/include/linux/virtio_balloon.h b/include/linux/virtio_balloon.h
index 4baad1c..d83c690 100644
--- a/include/linux/virtio_balloon.h
+++ b/include/linux/virtio_balloon.h
@@ -9,6 +9,7 @@
 #define VIRTIO_BALLOON_F_MUST_TELL_HOST		0 /* Tell before reclaiming pages */
 #define VIRTIO_BALLOON_F_STATS_VQ		1 /* Memory Stats virtqueue */
 #define VIRTIO_BALLOON_F_HOST_MAY_REFUSE	2 /* Host may refuse some pages */
+#define VIRTIO_BALLOON_F_CAN_RESET		3 /* Guest can reset balloon */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12
@@ -22,6 +23,10 @@ struct virtio_balloon_config
 	__le32 num_pages;
 	/* Number of pages we've actually got in balloon. */
 	__le32 actual;
+	/* Host wants guest to reset balloon. */
+	bool reset_pending;
+	/* Guest performed reset. */
+	bool reset_completed;
 };
 
 #define VIRTIO_BALLOON_S_SWAP_IN  0   /* Amount of memory swapped in */

