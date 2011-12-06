Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab1LFTuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:50:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab1LFTuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:50:13 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Virtualization List <virtualization@lists.linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v4 12/12] virtio: balloon: Add freeze, restore handlers to support S4
Date: Wed,  7 Dec 2011 01:18:50 +0530
Message-Id: <5deccc36afa59032f0e3b10a653773bad511f303.1323199985.git.amit.shah@redhat.com>
In-Reply-To: <cover.1323199985.git.amit.shah@redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com>
In-Reply-To: <cover.1323199985.git.amit.shah@redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handling balloon hibernate / restore is tricky.  If the balloon was
inflated before going into the hibernation state, upon resume, the host
will not have any memory of that.  Any pages that were passed on to the
host earlier would most likely be invalid, and the host will have to
re-balloon to the previous value to get in the pre-hibernate state.

So the only sane thing for the guest to do here is to discard all the
pages that were put in the balloon.  When to discard the pages is the
next question.

One solution is to deflate the balloon just before writing the image to
the disk (in the freeze() PM callback).  However, asking for pages from
the host just to discard them immediately after seems wasteful of
resources.  Hence, it makes sense to do this by just fudging our
counters soon after wakeup.  This means we don't deflate the balloon
before sleep, and also don't put unnecessary pressure on the host.

This also helps in the thaw case: if the freeze fails for whatever
reason, the balloon should continue to remain in the inflated state.
This was tested by issuing 'swapoff -a' and trying to go into the S4
state.  That fails, and the balloon stays inflated, as expected.  Both
the host and the guest are happy.

Now to not race with a host issuing ballooning requests while we are in
the process of freezing, we just exit from the vballoon kthread when the
processes are asked to freeze.  Upon thaw and restore, we re-start the
thread.

Finally, in the restore() callback, we empty the list of pages that were
previously given off to the host, add the appropriate number of pages to
the totalram_pages counter, reset the num_pages counter to 0, and
all is fine.

As a last step, delete the vqs on the freeze callback to prepare for
hibernation, and re-create them in the restore and thaw callbacks to
resume normal operation.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/virtio/virtio_balloon.c |   79 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 78 insertions(+), 1 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 8bf99be..10ec638 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -258,7 +258,13 @@ static int balloon(void *_vballoon)
 	while (!kthread_should_stop()) {
 		s64 diff;
 
-		try_to_freeze();
+		/*
+		 * On suspend, we want to exit this thread.  We will
+		 * start a new thread on resume.
+		 */
+		if (freezing(current))
+			break;
+
 		wait_event_interruptible(vb->config_change,
 					 (diff = towards_target(vb)) != 0
 					 || vb->need_stats_update
@@ -365,6 +371,72 @@ static void __devexit virtballoon_remove(struct virtio_device *vdev)
 	kfree(vb);
 }
 
+#ifdef CONFIG_PM
+static int virtballoon_freeze(struct virtio_device *vdev)
+{
+	/* Ensure we don't get any more requests from the host */
+	vdev->config->reset(vdev);
+
+	/*
+	 * The kthread is already gone as a result of the PM code
+	 * issuing a freeze request.
+	 */
+
+	vdev->config->del_vqs(vdev);
+	return 0;
+}
+
+static int restore_common(struct virtio_device *vdev)
+{
+	struct virtio_balloon *vb = vdev->priv;
+	int err;
+
+	/*
+	 * If init_vqs below fails, a subsequent module removal
+	 * shouldn't cause us to dereference invalid pointers!
+	 */
+	vb->thread = NULL;
+
+	err = init_vqs(vdev->priv);
+	if (err)
+		return err;
+
+	vb->thread = kthread_run(balloon, vb, "vballoon");
+	if (IS_ERR(vb->thread)) {
+		err = PTR_ERR(vb->thread);
+		vb->thread = NULL;
+	}
+	return err;
+}
+
+static int virtballoon_thaw(struct virtio_device *vdev)
+{
+	return restore_common(vdev);
+}
+
+static int virtballoon_restore(struct virtio_device *vdev)
+{
+	struct virtio_balloon *vb = vdev->priv;
+	struct page *page, *page2;
+
+	/* We're starting from a clean slate */
+	vb->num_pages = 0;
+
+	/*
+	 * If a request wasn't complete at the time of freezing, this
+	 * could have been set.
+	 */
+	vb->need_stats_update = 0;
+
+	/* We don't have these pages in the balloon anymore! */
+	list_for_each_entry_safe(page, page2, &vb->pages, lru) {
+		list_del(&page->lru);
+		totalram_pages++;
+	}
+	return restore_common(vdev);
+}
+#endif
+
 static unsigned int features[] = {
 	VIRTIO_BALLOON_F_MUST_TELL_HOST,
 	VIRTIO_BALLOON_F_STATS_VQ,
@@ -379,6 +451,11 @@ static struct virtio_driver virtio_balloon_driver = {
 	.probe =	virtballoon_probe,
 	.remove =	__devexit_p(virtballoon_remove),
 	.config_changed = virtballoon_changed,
+#ifdef CONFIG_PM
+	.freeze	=	virtballoon_freeze,
+	.restore =	virtballoon_restore,
+	.thaw =		virtballoon_thaw,
+#endif
 };
 
 static int __init init(void)
-- 
1.7.7.3

