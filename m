Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508Ab0HEOnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:43:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:41213 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933318Ab0HEOis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:38:48 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 17/17] debug_core,kdb: fix crash when arch does not have single step
Date: Thu,  5 Aug 2010 09:37:58 -0500
Message-Id: <1281019078-6636-18-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019078-6636-17-git-send-email-jason.wessel@windriver.com>
References: <1281019078-6636-1-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-2-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-3-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-4-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-5-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-6-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-7-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-8-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-9-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-10-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-11-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-12-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-13-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-14-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-15-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-16-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-17-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:38:24.0933 (UTC) FILETIME=[DC3E8D50:01CB34AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an arch such as mips and microblaze does not implement either HW
or software single stepping the debug core should re-enter kdb.  The
kdb code will properly ignore the single step operation.  Attempting
to single step the kernel without software or hardware support causes
unpredictable kernel crashes.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/debug_core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 8bc5eef..9ed9307 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -605,6 +605,8 @@ cpu_master_loop:
 		if (dbg_kdb_mode) {
 			kgdb_connected = 1;
 			error = kdb_stub(ks);
+			if (error == -1)
+				continue;
 			kgdb_connected = 0;
 		} else {
 			error = gdb_serial_stub(ks);
-- 
1.6.3.3

