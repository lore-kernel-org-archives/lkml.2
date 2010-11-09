Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab0KIEU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 23:20:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45812 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab0KIEU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 23:20:28 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=G8nEuqI5rvEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=TBVoxVdAAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=foYzmIb4j8EzVg5wDOMA:9 a=MBrjrYFkM3LJr2Pv4WUwdMPMZL0A:4 a=PUjeQqilurYA:10 a=rW6DTWptwo0A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH] PCI hotplug: ibmphp: Add check to prevent reading beyond
 mapped area
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chandru Siddalingappa <chandru@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 08 Nov 2010 23:20:27 -0500
Message-ID: <1289276427.12418.86.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing various randconfigs with ktest.pl, I hit the following panic:

BUG: unable to handle kernel paging request at f7e54b03
IP: [<c0d63409>] ibmphp_access_ebda+0x101/0x19bb

Adding printks, I found that the loop that reads the ebda blocks
can move out of the mapped section.

ibmphp_access_ebda: start=f7e44c00 size=5120 end=f7e46000
ibmphp_access_ebda: io_mem=f7e44d80 offset=384
ibmphp_access_ebda: io_mem=f7e54b03 offset=65283

The start of the iomap was at f7e44c00 and had a size of 5120,
making the end f7e46000. We start with an offset of 0x180 or
384, giving the first read at 0xf7e44d80. Reading that location
yields 65283, which is much bigger than the 5120 that was allocated
and makes the next read at f7e54b03 which is outside the mapped area.

Perhaps this is a bug in the driver, or buggy hardware, but this patch
is more about not crashing my box on start up and just giving a warning
if it detects this error.

This patch at least lets my box boot with just a warning.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Chandru Siddalingappa <chandru@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

---
 drivers/pci/hotplug/ibmphp_ebda.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-test.git/drivers/pci/hotplug/ibmphp_ebda.c
===================================================================
--- linux-test.git.orig/drivers/pci/hotplug/ibmphp_ebda.c	2010-11-08 23:02:04.514138224 -0500
+++ linux-test.git/drivers/pci/hotplug/ibmphp_ebda.c	2010-11-08 23:02:38.021316682 -0500
@@ -276,6 +276,12 @@ int __init ibmphp_access_ebda (void)
 
 	for (;;) {
 		offset = next_offset;
+
+		/* Make sure what we read is still in the mapped section */
+		if (WARN(offset > (ebda_sz * 1024 - 4),
+			 "ibmphp_ebda: next read is beyond ebda_sz\n"))
+			break;
+
 		next_offset = readw (io_mem + offset);	/* offset of next blk */
 
 		offset += 2;


