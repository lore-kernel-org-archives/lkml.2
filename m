Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405Ab1DYKpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 06:45:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35636 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366Ab1DYKpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 06:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=keeecQQr7RSldJ0dsKv4ifBLQYeCARS6o3BjkGLu9gLxG4OLkOJ45VJZpiP4vdguEy
         a/XCaHNd2IEVQSqf/iyxGvOnbHPj1hzfYnSRoxkKU7dJppWoIjvUcsrKHOwXygqM3E42
         PaBVouy1Ai5uGenCXysrTi8g7lCwhC6OOPXG4=
From: Geunsik Lim <leemgs1@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH 4/4] munmap: documentation of munmap operation interface
Date: Mon, 25 Apr 2011 19:44:32 +0900
Message-Id: <1303728272-11408-5-git-send-email-leemgs1@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1303728272-11408-1-git-send-email-leemgs1@gmail.com>
References: <1303728272-11408-1-git-send-email-leemgs1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geunsik Lim <geunsik.lim@samsung.com>

kernel documentation to utilize flexible memory unmap operation
interface for the ideal scheduler latency.

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
Acked-by: Hyunjin Choi <hj89.choi@samsung.com>
---
 Documentation/sysctl/vm.txt |   36 ++++++++++++++++++++++++++++++++++++
 MAINTAINERS                 |    7 +++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 30289fa..9dc4c0a 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -40,6 +40,7 @@ Currently, these files are in /proc/sys/vm:
 - min_slab_ratio
 - min_unmapped_ratio
 - mmap_min_addr
+- munmap_unit_size
 - nr_hugepages
 - nr_overcommit_hugepages
 - nr_pdflush_threads
@@ -409,6 +410,41 @@ against future potential kernel bugs.
 
 ==============================================================
 
+munmap_unit_size
+
+unmap_vmas(=unmap a range of memory covered by a list of vma) is treading
+a delicate and uncomfortable line between hi-performance and low-latency.
+We've chosen to improve performance at the expense of latency.
+
+So although there may be no need to resched right now,
+if we keep on gathering more and more without flushing,
+we'll be very unresponsive when a resched is needed later on.
+
+Consider the best suitable result between high performance and low latency
+on preemption mode.
+Select optimal munmap size to return memory space that is allocated by mmap system call.
+
+For example, For recording mass files, if we try to unmap memory that we allocated
+with 100MB for recording in embedded devices, we have to wait for more than 3seconds to
+change mode from play mode to recording mode. This results from the unit of memory
+unmapped size when we are recording mass files like camcorder particularly.
+
+This value can be changed after boot using the
+/proc/sys/vm/munmap_unit_size tunable.
+
+Examples:
+         2048 => 8,388,608bytes : for straight-line efficiency
+         1024 => 4,194,304bytes
+          512 => 2,097,152bytes
+          256 => 1,048,576bytes
+          128 =>   524,288bytes
+           64 =>   262,144bytes
+           32 =>   131,072bytes
+           16 =>    65,536bytes
+            8 =>    32,768bytes : for low-latency
+
+==============================================================
+
 nr_hugepages
 
 Change the minimum size of the hugepage pool.
diff --git a/MAINTAINERS b/MAINTAINERS
index 1380312..07f4123 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4128,6 +4128,13 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/memcontrol.c
 
+MEMORY UNMAP OPERATION UNIT INTERFACE
+M:      Geunsik Lim <geunsik.lim@samsung.com>
+L:	linux-rt-users@vger.kernel.org
+S:      Maintained
+F:      mm/munmap_unit_size.c
+F:      include/linux/munmap_unit_size.h
+
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	David Woodhouse <dwmw2@infradead.org>
 L:	linux-mtd@lists.infradead.org
-- 
1.7.3.4

