Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab0HPVHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 17:07:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:34528 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab0HPVHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 17:07:44 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/5] vt,console,kdb: preserve console_blanked while in kdb
Date: Mon, 16 Aug 2010 16:06:29 -0500
Message-Id: <1281992789-2471-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281992789-2471-5-git-send-email-jason.wessel@windriver.com>
References: <1281992789-2471-1-git-send-email-jason.wessel@windriver.com>
 <1281992789-2471-2-git-send-email-jason.wessel@windriver.com>
 <1281992789-2471-3-git-send-email-jason.wessel@windriver.com>
 <1281992789-2471-4-git-send-email-jason.wessel@windriver.com>
 <1281992789-2471-5-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 16 Aug 2010 21:06:38.0932 (UTC) FILETIME=[EB17F940:01CB3D86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b45cfba4e9005d64d419718e7ff7f7cab44c1994 (vt,console,kdb:
implement atomic console enter/leave functions) introduced the ability
to atomically change the console mode with kernel mode setting but did
not preserve the state of the console_blanked variable.

The console_blanked variable must be restored when executing the
con_debug_leave() or further kernel mode set changes (such as using
chvt X) will fail to correctly set the state of console.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/char/vt.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 3af1a22..50590c7 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -198,6 +198,7 @@ static int saved_fg_console;
 static int saved_last_console;
 static int saved_want_console;
 static int saved_vc_mode;
+static int saved_console_blanked;
 
 /*
  * For each existing display, we have a pointer to console currently visible
@@ -3449,6 +3450,7 @@ int con_debug_enter(struct vc_data *vc)
 	saved_last_console = last_console;
 	saved_want_console = want_console;
 	saved_vc_mode = vc->vc_mode;
+	saved_console_blanked = console_blanked;
 	vc->vc_mode = KD_TEXT;
 	console_blanked = 0;
 	if (vc->vc_sw->con_debug_enter)
@@ -3492,6 +3494,7 @@ int con_debug_leave(void)
 	fg_console = saved_fg_console;
 	last_console = saved_last_console;
 	want_console = saved_want_console;
+	console_blanked = saved_console_blanked;
 	vc_cons[fg_console].d->vc_mode = saved_vc_mode;
 
 	vc = vc_cons[fg_console].d;
-- 
1.6.3.3

