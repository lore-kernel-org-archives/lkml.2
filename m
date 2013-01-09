Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab3AIUg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:36:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:41180 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932861Ab3AIUgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:36:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ming Lei <ming.lei@canonical.com>,
        liu chuansheng <chuansheng.liu@intel.com>
Subject: [ 003/123] firmware loader: Fix the concurrent request_firmware() race for kref_get/put
Date: Wed,  9 Jan 2013 12:34:02 -0800
Message-Id: <20130109201458.822333129@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuansheng Liu <chuansheng.liu@intel.com>

commit bd9eb7fbe69111ea0ff1f999ef4a5f26d223d1d5 upstream.

There is one race that both request_firmware() with the same
firmware name.

The race scenerio is as below:
CPU1                                                  CPU2
request_firmware() -->
_request_firmware_load() return err                   another request_firmware() is coming -->
_request_firmware_cleanup is called -->               _request_firmware_prepare -->
release_firmware --->                                 fw_lookup_and_allocate_buf -->
                                                      spin_lock(&fwc->lock)
...                                                   __fw_lookup_buf() return true
fw_free_buf() will be called -->                      ...
kref_put -->
decrease the refcount to 0
                                                      kref_get(&tmp->ref) ==> it will trigger warning
                                                                              due to refcount == 0
__fw_free_buf() -->
...                                                   spin_unlock(&fwc->lock)
spin_lock(&fwc->lock)
list_del(&buf->list)
spin_unlock(&fwc->lock)
kfree(buf)
                                                      After that, the freed buf will be used.

The key race is decreasing refcount to 0 and list_del is not protected together by
fwc->lock, and it is possible another thread try to get it between refcount==0
and list_del.

Fix it here to protect it together.

Acked-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/firmware_class.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -246,7 +246,6 @@ static void __fw_free_buf(struct kref *r
 		 __func__, buf->fw_id, buf, buf->data,
 		 (unsigned int)buf->size);
 
-	spin_lock(&fwc->lock);
 	list_del(&buf->list);
 	spin_unlock(&fwc->lock);
 
@@ -263,7 +262,10 @@ static void __fw_free_buf(struct kref *r
 
 static void fw_free_buf(struct firmware_buf *buf)
 {
-	kref_put(&buf->ref, __fw_free_buf);
+	struct firmware_cache *fwc = buf->fwc;
+	spin_lock(&fwc->lock);
+	if (!kref_put(&buf->ref, __fw_free_buf))
+		spin_unlock(&fwc->lock);
 }
 
 /* direct firmware loading support */


