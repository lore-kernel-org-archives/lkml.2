Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab1BIIaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 03:30:55 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:36829 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab1BIIay convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Wed, 9 Feb 2011 03:30:54 -0500
Message-Id: <4D525EF00200007800030F0F@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 09 Feb 2011 08:31:28 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Tim Deegan" <Tim.Deegan@citrix.com>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>, "Jiri Slaby" <jslaby@suse.cz>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix jiffy calculations in calibrate_delay_direct to
	 handle overflow
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a hang when booting as dom0 under Xen, when jiffies can be
quite large by the time the kernel init gets this far.

Signed-off-by: Tim Deegan <Tim.Deegan@citrix.com>

!time_after() -> time_before_eq() as per suggestion from Jiri Slaby.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

---
 init/calibrate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- 2.6.38-rc4/init/calibrate.c
+++ 2.6.38-rc4-calibrate-jiffy-overflow/init/calibrate.c
@@ -66,7 +66,7 @@ static unsigned long __cpuinit calibrate
 		pre_start = 0;
 		read_current_timer(&start);
 		start_jiffies = jiffies;
-		while (jiffies <= (start_jiffies + 1)) {
+		while (time_before_eq(jiffies, start_jiffies + 1)) {
 			pre_start = start;
 			read_current_timer(&start);
 		}
@@ -74,8 +74,8 @@ static unsigned long __cpuinit calibrate
 
 		pre_end = 0;
 		end = post_start;
-		while (jiffies <=
-		       (start_jiffies + 1 + DELAY_CALIBRATION_TICKS)) {
+		while (time_before_eq(jiffies, start_jiffies + 1 +
+					       DELAY_CALIBRATION_TICKS)) {
 			pre_end = end;
 			read_current_timer(&end);
 		}



