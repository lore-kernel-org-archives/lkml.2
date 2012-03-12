Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab2CLRRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:17:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab2CLRRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:17:36 -0400
Date: Mon, 12 Mar 2012 13:17:29 -0400
From: Dave Jones <davej@redhat.com>
To: David.Woodhouse@intel.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: only build arch specific raid6 routines on the arch they run on.
Message-ID: <20120312171728.GA1343@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, David.Woodhouse@intel.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed the altivec routines are being built even on x86.
Also it looks like mmx/sse get built on non-x86.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
index 8a38102..8549927 100644
--- a/lib/raid6/Makefile
+++ b/lib/raid6/Makefile
@@ -1,18 +1,23 @@
 obj-$(CONFIG_RAID6_PQ)	+= raid6_pq.o
 
 raid6_pq-y	+= algos.o recov.o tables.o int1.o int2.o int4.o \
-		   int8.o int16.o int32.o altivec1.o altivec2.o altivec4.o \
-		   altivec8.o mmx.o sse1.o sse2.o
-hostprogs-y	+= mktables
+		   int8.o int16.o int32.o
 
-quiet_cmd_unroll = UNROLL  $@
-      cmd_unroll = $(AWK) -f$(srctree)/$(src)/unroll.awk -vN=$(UNROLL) \
-                   < $< > $@ || ( rm -f $@ && exit 1 )
+ifeq ($(CONFIG_X86),y)
+raid6_pq-y	+= mmx.o sse1.o sse2.o
+endif
 
 ifeq ($(CONFIG_ALTIVEC),y)
+raid6_pq-y	+=  altivec1.o altivec2.o altivec4.o altivec8.o
 altivec_flags := -maltivec -mabi=altivec
 endif
 
+hostprogs-y	+= mktables
+
+quiet_cmd_unroll = UNROLL  $@
+      cmd_unroll = $(AWK) -f$(srctree)/$(src)/unroll.awk -vN=$(UNROLL) \
+                   < $< > $@ || ( rm -f $@ && exit 1 )
+
 targets += int1.c
 $(obj)/int1.c:   UNROLL := 1
 $(obj)/int1.c:   $(src)/int.uc $(src)/unroll.awk FORCE
