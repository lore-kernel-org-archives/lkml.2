Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab2FTSV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:21:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab2FTSVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:21:18 -0400
Message-Id: <20120620173021.770261165@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 09/61] xen/hvc: Collapse error logic.
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 2e5ad6b9c45d43cc4e7b8ac5ded1c55a7c4a3893 upstream.

All of the error paths are doing the same logic. In which
case we might as well collapse them in one path.

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/hvc/hvc_xen.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -216,22 +216,16 @@ static int xen_hvm_console_init(void)
 		return 0;
 
 	r = hvm_get_parameter(HVM_PARAM_CONSOLE_EVTCHN, &v);
-	if (r < 0) {
-		kfree(info);
-		return -ENODEV;
-	}
+	if (r < 0)
+		goto err;
 	info->evtchn = v;
 	hvm_get_parameter(HVM_PARAM_CONSOLE_PFN, &v);
-	if (r < 0) {
-		kfree(info);
-		return -ENODEV;
-	}
+	if (r < 0)
+		goto err;
 	mfn = v;
 	info->intf = ioremap(mfn << PAGE_SHIFT, PAGE_SIZE);
-	if (info->intf == NULL) {
-		kfree(info);
-		return -ENODEV;
-	}
+	if (info->intf == NULL)
+		goto err;
 	info->vtermno = HVC_COOKIE;
 
 	spin_lock(&xencons_lock);
@@ -239,6 +233,9 @@ static int xen_hvm_console_init(void)
 	spin_unlock(&xencons_lock);
 
 	return 0;
+err:
+	kfree(info);
+	return -ENODEV;
 }
 
 static int xen_pv_console_init(void)


