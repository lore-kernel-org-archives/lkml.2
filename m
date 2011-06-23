Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab1FWRbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:31:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:65259 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012Ab1FWR35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:29:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Tim Deegan <Tim.Deegan@citrix.com>,
        Jan Beulich <jbeulich@novell.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 059/247] fix jiffy calculations in calibrate_delay_direct to handle overflow
Date: Thu, 23 Jun 2011 13:25:58 -0400
Message-Id: <1308850146-15061-18-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Deegan <Tim.Deegan@citrix.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 70a062286b9dfcbd24d2e11601aecfead5cf709a upstream.

Fixes a hang when booting as dom0 under Xen, when jiffies can be
quite large by the time the kernel init gets this far.

Signed-off-by: Tim Deegan <Tim.Deegan@citrix.com>
[jbeulich@novell.com: !time_after() -> time_before_eq() as suggested by Jiri Slaby]
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 init/calibrate.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index 6eb48e5..24fe022 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -66,7 +66,7 @@ static unsigned long __cpuinit calibrate_delay_direct(void)
 		pre_start = 0;
 		read_current_timer(&start);
 		start_jiffies = jiffies;
-		while (jiffies <= (start_jiffies + 1)) {
+		while (time_before_eq(jiffies, start_jiffies + 1)) {
 			pre_start = start;
 			read_current_timer(&start);
 		}
@@ -74,8 +74,8 @@ static unsigned long __cpuinit calibrate_delay_direct(void)
 
 		pre_end = 0;
 		end = post_start;
-		while (jiffies <=
-		       (start_jiffies + 1 + DELAY_CALIBRATION_TICKS)) {
+		while (time_before_eq(jiffies, start_jiffies + 1 +
+					       DELAY_CALIBRATION_TICKS)) {
 			pre_end = end;
 			read_current_timer(&end);
 		}
-- 
1.7.4.4

