Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab2EVBEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:04:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6690 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab2EVBET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:04:19 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=jy51kqRoUrIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=js3BcyrTZknK6NlHJmMA:9 a=S4lHzMzErPNU3OejnD4A:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337648657.13348.26.camel@gandalf.stny.rr.com>
Subject: [PATCH] sysctl: Suppress kmemleak messages
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 21 May 2012 21:04:17 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure who the owner is of kernel/sysctl.c, so I'm just sending this
patch to you :-)

The register_sysctl_table() is a strange function, as it makes internal
allocations (a header) to register a sysctl_table. This header is a
handle to the table that is created, and can be used to unregister the
table. But if the table is permanent and never unregistered, the header
acts the same as a static variable.

Unfortunately, this allocation of memory that is never expected to be
freed, fools kmemleak in thinking that we have leaked memory. For those
sysctl tables that are never unregistered, and have no pointer
referencing them, kmemleak will think that these are memory leaks:

unreferenced object 0xffff880079fb9d40 (size 192):
  comm "swapper/0", pid 0, jiffies 4294667316 (age 12614.152s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8146b590>] kmemleak_alloc+0x73/0x98
    [<ffffffff8110a935>] kmemleak_alloc_recursive.constprop.42+0x16/0x18
    [<ffffffff8110b852>] __kmalloc+0x107/0x153
    [<ffffffff8116fa72>] kzalloc.constprop.8+0xe/0x10
    [<ffffffff811703c9>] __register_sysctl_paths+0xe1/0x160
    [<ffffffff81170463>] register_sysctl_paths+0x1b/0x1d
    [<ffffffff8117047d>] register_sysctl_table+0x18/0x1a
    [<ffffffff81afb0a1>] sysctl_init+0x10/0x14
    [<ffffffff81b05a6f>] proc_sys_init+0x2f/0x31
    [<ffffffff81b0584c>] proc_root_init+0xa5/0xa7
    [<ffffffff81ae5b7e>] start_kernel+0x3d0/0x40a
    [<ffffffff81ae52a7>] x86_64_start_reservations+0xae/0xb2
    [<ffffffff81ae53ad>] x86_64_start_kernel+0x102/0x111
    [<ffffffffffffffff>] 0xffffffffffffffff


The sysctl_base_table used by sysctl itself is one such instance that
registers the table to never be unregistered.

Use kmemleak_not_leak() to suppress the kmemleak false positive.

[ applied against 3.4 ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4ab1187..ad115bc 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -30,6 +30,7 @@
 #include <linux/security.h>
 #include <linux/ctype.h>
 #include <linux/kmemcheck.h>
+#include <linux/kmemleak.h>
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -1551,7 +1552,10 @@ static struct ctl_table dev_table[] = {
 
 int __init sysctl_init(void)
 {
-	register_sysctl_table(sysctl_base_table);
+	struct ctl_table_header *hdr;
+
+	hdr = register_sysctl_table(sysctl_base_table);
+	kmemleak_not_leak(hdr);
 	return 0;
 }
 


