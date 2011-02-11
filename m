Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab1BKR5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 12:57:47 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:54678
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757429Ab1BKR5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 12:57:46 -0500
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Feb 2011 12:57:46 EST
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/3]: Staging: hv: Use native page allocation/free functions
Date: Fri, 11 Feb 2011 09:59:00 -0800
Message-Id: <1297447140-21777-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preperation for getting rid of the osd.[ch] files; 
change all page allocation/free functions to use native interfaces.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel.c    |   12 +++++++-----
 drivers/staging/hv/connection.c |   13 ++++++++-----
 drivers/staging/hv/hv.c         |   15 ++++++++++-----
 drivers/staging/hv/netvsc.c     |   14 ++++++++------
 4 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index ba9afda..6c292e6 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -180,8 +180,9 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	newchannel->channel_callback_context = context;
 
 	/* Allocate the ring buffer */
-	out = osd_page_alloc((send_ringbuffer_size + recv_ringbuffer_size)
-			     >> PAGE_SHIFT);
+	out = (void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
+		get_order(send_ringbuffer_size + recv_ringbuffer_size));
+
 	if (!out)
 		return -ENOMEM;
 
@@ -300,8 +301,8 @@ Cleanup:
 errorout:
 	ringbuffer_cleanup(&newchannel->outbound);
 	ringbuffer_cleanup(&newchannel->inbound);
-	osd_page_free(out, (send_ringbuffer_size + recv_ringbuffer_size)
-		     >> PAGE_SHIFT);
+	free_pages((unsigned long)out,
+		get_order(send_ringbuffer_size + recv_ringbuffer_size));
 	kfree(openInfo);
 	return err;
 }
@@ -686,7 +687,8 @@ void vmbus_close(struct vmbus_channel *channel)
 	ringbuffer_cleanup(&channel->outbound);
 	ringbuffer_cleanup(&channel->inbound);
 
-	osd_page_free(channel->ringbuffer_pages, channel->ringbuffer_pagecount);
+	free_pages((unsigned long)channel->ringbuffer_pages,
+		get_order(channel->ringbuffer_pagecount * PAGE_SIZE));
 
 	kfree(info);
 
diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index b3ac66e..ed0976a 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -66,7 +66,8 @@ int vmbus_connect(void)
 	 * Setup the vmbus event connection for channel interrupt
 	 * abstraction stuff
 	 */
-	vmbus_connection.int_page = osd_page_alloc(1);
+	vmbus_connection.int_page =
+	(void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO, 0);
 	if (vmbus_connection.int_page == NULL) {
 		ret = -1;
 		goto Cleanup;
@@ -81,7 +82,8 @@ int vmbus_connect(void)
 	 * Setup the monitor notification facility. The 1st page for
 	 * parent->child and the 2nd page for child->parent
 	 */
-	vmbus_connection.monitor_pages = osd_page_alloc(2);
+	vmbus_connection.monitor_pages =
+	(void *)__get_free_pages((GFP_KERNEL|__GFP_ZERO), 1);
 	if (vmbus_connection.monitor_pages == NULL) {
 		ret = -1;
 		goto Cleanup;
@@ -162,12 +164,12 @@ Cleanup:
 		destroy_workqueue(vmbus_connection.work_queue);
 
 	if (vmbus_connection.int_page) {
-		osd_page_free(vmbus_connection.int_page, 1);
+		free_pages((unsigned long)vmbus_connection.int_page, 0);
 		vmbus_connection.int_page = NULL;
 	}
 
 	if (vmbus_connection.monitor_pages) {
-		osd_page_free(vmbus_connection.monitor_pages, 2);
+		free_pages((unsigned long)vmbus_connection.monitor_pages, 1);
 		vmbus_connection.monitor_pages = NULL;
 	}
 
@@ -203,7 +205,8 @@ int vmbus_disconnect(void)
 	if (ret != 0)
 		goto Cleanup;
 
-	osd_page_free(vmbus_connection.int_page, 1);
+	free_pages((unsigned long)vmbus_connection.int_page, 0);
+	free_pages((unsigned long)vmbus_connection.monitor_pages, 1);
 
 	/* TODO: iterate thru the msg list and free up */
 	destroy_workqueue(vmbus_connection.work_queue);
diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
index 021acba..419b4d6 100644
--- a/drivers/staging/hv/hv.c
+++ b/drivers/staging/hv/hv.c
@@ -230,7 +230,12 @@ int hv_init(void)
 	* Allocate the hypercall page memory
 	* virtaddr = osd_page_alloc(1);
 	*/
-	virtaddr = osd_virtual_alloc_exec(PAGE_SIZE);
+#ifdef __x86_64__
+	virtaddr = __vmalloc(PAGE_SIZE, GFP_KERNEL, PAGE_KERNEL_EXEC);
+#else
+	virtaddr =  __vmalloc(PAGE_SIZE, GFP_KERNEL,
+			__pgprot(__PAGE_KERNEL & (~_PAGE_NX)));
+#endif
 
 	if (!virtaddr) {
 		DPRINT_ERR(VMBUS,
@@ -462,10 +467,10 @@ void hv_synic_init(void *irqarg)
 
 Cleanup:
 	if (hv_context.synic_event_page[cpu])
-		osd_page_free(hv_context.synic_event_page[cpu], 1);
+		free_page((unsigned long)hv_context.synic_event_page[cpu]);
 
 	if (hv_context.synic_message_page[cpu])
-		osd_page_free(hv_context.synic_message_page[cpu], 1);
+		free_page((unsigned long)hv_context.synic_message_page[cpu]);
 	return;
 }
 
@@ -502,6 +507,6 @@ void hv_synic_cleanup(void *arg)
 
 	wrmsrl(HV_X64_MSR_SIEFP, siefp.as_uint64);
 
-	osd_page_free(hv_context.synic_message_page[cpu], 1);
-	osd_page_free(hv_context.synic_event_page[cpu], 1);
+	free_page((unsigned long)hv_context.synic_message_page[cpu]);
+	free_page((unsigned long)hv_context.synic_event_page[cpu]);
 }
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 4319363..a271aa7 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -223,7 +223,8 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	/* ASSERT((netDevice->ReceiveBufferSize & (PAGE_SIZE - 1)) == 0); */
 
 	net_device->recv_buf =
-		osd_page_alloc(net_device->recv_buf_size >> PAGE_SHIFT);
+		(void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
+				get_order(net_device->recv_buf_size));
 	if (!net_device->recv_buf) {
 		DPRINT_ERR(NETVSC,
 			   "unable to allocate receive buffer of size %d",
@@ -360,7 +361,8 @@ static int netvsc_init_send_buf(struct hv_device *device)
 	/* ASSERT((netDevice->SendBufferSize & (PAGE_SIZE - 1)) == 0); */
 
 	net_device->send_buf =
-		osd_page_alloc(net_device->send_buf_size >> PAGE_SHIFT);
+		(void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
+				get_order(net_device->send_buf_size));
 	if (!net_device->send_buf) {
 		DPRINT_ERR(NETVSC, "unable to allocate send buffer of size %d",
 			   net_device->send_buf_size);
@@ -498,8 +500,8 @@ static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 		DPRINT_INFO(NETVSC, "Freeing up receive buffer...");
 
 		/* Free up the receive buffer */
-		osd_page_free(net_device->recv_buf,
-			     net_device->recv_buf_size >> PAGE_SHIFT);
+		free_pages((unsigned long)net_device->recv_buf,
+			get_order(net_device->recv_buf_size));
 		net_device->recv_buf = NULL;
 	}
 
@@ -574,8 +576,8 @@ static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
 		DPRINT_INFO(NETVSC, "Freeing up send buffer...");
 
 		/* Free up the receive buffer */
-		osd_page_free(net_device->send_buf,
-			     net_device->send_buf_size >> PAGE_SHIFT);
+		free_pages((unsigned long)net_device->send_buf,
+				get_order(net_device->send_buf_size));
 		net_device->send_buf = NULL;
 	}
 
-- 
1.5.5.6

