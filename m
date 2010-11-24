Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0KXEjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 23:39:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34062 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab0KXEjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 23:39:41 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=P0F2LszeXZAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=9Gyem38ArbnIDJfho_kA:9 a=DeC5oJRnNrc4TaWHOhwA:7 a=4Sz3LNUZdI8usXfrxE5A4CrudtUA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: isdn: icn: Fix stack overflow bug
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Karsten Keil <isdn@linux-pingi.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 23 Nov 2010 23:39:38 -0500
Message-ID: <1290573578.30543.461.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running randconfig with ktest.pl I hit this bug:

[   16.101158] ICN-ISDN-driver Rev 1.65.6.8 mem=0x000d0000
[   16.106376] icn: (line0) ICN-2B, port 0x320 added
[   16.111064] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: c1642880
[   16.111066] 
[   16.121214] Pid: 1, comm: swapper Not tainted 2.6.37-rc2-test-00124-g6656b3f #8
[   16.128499] Call Trace:
[   16.130942]  [<c0f51662>] ? printk+0x1d/0x23
[   16.135200]  [<c0f5153f>] panic+0x5c/0x162
[   16.139286]  [<c0d62a9a>] ? icn_addcard+0x6d/0xbe
[   16.143975]  [<c0445783>] print_tainted+0x0/0x8c
[   16.148582]  [<c1642880>] ? icn_init+0xd8/0xdf
[   16.153012]  [<c1642880>] icn_init+0xd8/0xdf
[   16.157271]  [<c04012e5>] do_one_initcall+0x8c/0x143
[   16.162222]  [<c16427a8>] ? icn_init+0x0/0xdf
[   16.166566]  [<c15f1a05>] kernel_init+0x13f/0x1da
[   16.171256]  [<c15f18c6>] ? kernel_init+0x0/0x1da
[   16.175945]  [<c0403bfe>] kernel_thread_helper+0x6/0x10
[   16.181181] panic occurred, switching back to text console

Looking into it I found that the stack was corrupted by the assignment
of the Rev #. The variable rev is given 10 bytes, and in this output the
characters that were copied was: " 1.65.6.8 $". Which was 11 characters
plus the null ending character for a total of 12 bytes, thus corrupting
the stack.

This patch ups the variable size to 20 bytes as well as changes the
strcpy to strncpy. I also added a check to make sure '$' is found.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/drivers/isdn/icn/icn.c b/drivers/isdn/icn/icn.c
index 2e847a9..f2b5bab 100644
--- a/drivers/isdn/icn/icn.c
+++ b/drivers/isdn/icn/icn.c
@@ -1627,7 +1627,7 @@ __setup("icn=", icn_setup);
 static int __init icn_init(void)
 {
 	char *p;
-	char rev[10];
+	char rev[20];
 
 	memset(&dev, 0, sizeof(icn_dev));
 	dev.memaddr = (membase & 0x0ffc000);
@@ -1637,9 +1637,10 @@ static int __init icn_init(void)
 	spin_lock_init(&dev.devlock);
 
 	if ((p = strchr(revision, ':'))) {
-		strcpy(rev, p + 1);
+		strncpy(rev, p + 1, 20);
 		p = strchr(rev, '$');
-		*p = 0;
+		if (p)
+			*p = 0;
 	} else
 		strcpy(rev, " ??? ");
 	printk(KERN_NOTICE "ICN-ISDN-driver Rev%smem=0x%08lx\n", rev,


