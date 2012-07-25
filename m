Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030301Ab2GYPO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:14:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:30025 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933160Ab2GYPKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:10:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="171267537"
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 03/16] Documentation: fix the VM knobs descritpion WRT pdflush
Date: Wed, 25 Jul 2012 18:12:01 +0300
Message-Id: <1343229134-29487-4-git-send-email-artem.bityutskiy@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The pdflush thread is long gone, however we still mention it incorrectly in the
kernel documentation. This patch fixes the situation.

Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---

I expect this patch to be merged via Al Viro's VFS tree.

 Documentation/laptops/laptop-mode.txt |   12 ++++++------
 Documentation/sysctl/vm.txt           |   25 ++++++++++++++-----------
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/Documentation/laptops/laptop-mode.txt b/Documentation/laptops/laptop-mode.txt
index 0bf25ee..4ebbfc3 100644
--- a/Documentation/laptops/laptop-mode.txt
+++ b/Documentation/laptops/laptop-mode.txt
@@ -262,9 +262,9 @@ MINIMUM_BATTERY_MINUTES=10
 
 #
 # Allowed dirty background ratio, in percent.  Once DIRTY_RATIO has been
-# exceeded, the kernel will wake pdflush which will then reduce the amount
-# of dirty memory to dirty_background_ratio.  Set this nice and low, so once
-# some writeout has commenced, we do a lot of it.
+# exceeded, the kernel will wake flusher threads which will then reduce the
+# amount of dirty memory to dirty_background_ratio.  Set this nice and low,
+# so once some writeout has commenced, we do a lot of it.
 #
 #DIRTY_BACKGROUND_RATIO=5
 
@@ -384,9 +384,9 @@ CPU_MAXFREQ=${CPU_MAXFREQ:-'slowest'}
 
 #
 # Allowed dirty background ratio, in percent.  Once DIRTY_RATIO has been
-# exceeded, the kernel will wake pdflush which will then reduce the amount
-# of dirty memory to dirty_background_ratio.  Set this nice and low, so once
-# some writeout has commenced, we do a lot of it.
+# exceeded, the kernel will wake flusher threads which will then reduce the
+# amount of dirty memory to dirty_background_ratio.  Set this nice and low,
+# so once some writeout has commenced, we do a lot of it.
 #
 DIRTY_BACKGROUND_RATIO=${DIRTY_BACKGROUND_RATIO:-'5'}
 
diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 96f0ee8..cec12bb 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -77,8 +77,8 @@ huge pages although processes will also directly compact memory as required.
 
 dirty_background_bytes
 
-Contains the amount of dirty memory at which the pdflush background writeback
-daemon will start writeback.
+Contains the amount of dirty memory at which the background kernel
+flusher threads will start writeback.
 
 Note: dirty_background_bytes is the counterpart of dirty_background_ratio. Only
 one of them may be specified at a time. When one sysctl is written it is
@@ -90,7 +90,7 @@ other appears as 0 when read.
 dirty_background_ratio
 
 Contains, as a percentage of total system memory, the number of pages at which
-the pdflush background writeback daemon will start writing out dirty data.
+the background kernel flusher threads will start writing out dirty data.
 
 ==============================================================
 
@@ -113,9 +113,9 @@ retained.
 dirty_expire_centisecs
 
 This tunable is used to define when dirty data is old enough to be eligible
-for writeout by the pdflush daemons.  It is expressed in 100'ths of a second.
-Data which has been dirty in-memory for longer than this interval will be
-written out next time a pdflush daemon wakes up.
+for writeout by the kernel flusher threads.  It is expressed in 100'ths
+of a second.  Data which has been dirty in-memory for longer than this
+interval will be written out next time a flusher thread wakes up.
 
 ==============================================================
 
@@ -129,7 +129,7 @@ data.
 
 dirty_writeback_centisecs
 
-The pdflush writeback daemons will periodically wake up and write `old' data
+The kernel flusher threads will periodically wake up and write `old' data
 out to disk.  This tunable expresses the interval between those wakeups, in
 100'ths of a second.
 
@@ -428,11 +428,14 @@ See Documentation/vm/hugetlbpage.txt
 
 nr_pdflush_threads
 
-The current number of pdflush threads.  This value is read-only.
-The value changes according to the number of dirty pages in the system.
+This is not used by the kernel since version 2.6.32, this is read-only
+and is always set to 1.  Preserve for backward-compatibility reasons.
 
-When necessary, additional pdflush threads are created, one per second, up to
-nr_pdflush_threads_max.
+In the past, it contained the current number of pdflush threads.  The
+value changed according to the number of dirty pages in the system.
+When necessary, additional pdflush threads were created, one per second.
+However, in kernel version 2.6.32 the pdflush thread was removed in
+favour of per-block device bdi flusher threads.
 
 ==============================================================
 
-- 
1.7.10

