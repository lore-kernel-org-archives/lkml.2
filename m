Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2FTSVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:21:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45916 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524Ab2FTSVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:21:25 -0400
Message-Id: <20120620173021.939625240@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 11/61] xen/hvc: Check HVM_PARAM_CONSOLE_[EVTCHN|PFN] for correctness.
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 5842f5768599094758931b74190cdf93641a8e35 upstream.

We need to make sure that those parameters are setup to be correct.
As such the value of 0 is deemed invalid and we find that we
bail out. The hypervisor sets by default all of them to be zero
and when the hypercall is done does a simple:

 a.value = d->arch.hvm_domain.params[a.index];

Which means that if the Xen toolstack forgot to setup the proper
HVM_PARAM_CONSOLE_EVTCHN (or the PFN one), we would get the
default value of 0 and use that.

Fixes-Oracle-Bug: 14091238
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/hvc/hvc_xen.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -214,14 +214,19 @@ static int xen_hvm_console_init(void)
 	/* already configured */
 	if (info->intf != NULL)
 		return 0;
-
+	/*
+	 * If the toolstack (or the hypervisor) hasn't set these values, the
+	 * default value is 0. Even though mfn = 0 and evtchn = 0 are
+	 * theoretically correct values, in practice they never are and they
+	 * mean that a legacy toolstack hasn't initialized the pv console correctly.
+	 */
 	r = hvm_get_parameter(HVM_PARAM_CONSOLE_EVTCHN, &v);
-	if (r < 0)
+	if (r < 0 || v == 0)
 		goto err;
 	info->evtchn = v;
 	v = 0;
 	r = hvm_get_parameter(HVM_PARAM_CONSOLE_PFN, &v);
-	if (r < 0)
+	if (r < 0 || v == 0)
 		goto err;
 	mfn = v;
 	info->intf = ioremap(mfn << PAGE_SHIFT, PAGE_SIZE);


