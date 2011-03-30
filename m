Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965446Ab1C3V7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:59:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:65216 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933228Ab1C3VGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132954"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: Tim.Deegan@citrix.com, ak@linux.intel.com, jbeulich@novell.com,
        jslaby@suse.cz, jeremy@goop.org, torvalds@linux-foundation.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [63/275] fix jiffy calculations in calibrate_delay_direct to handle overflow
Message-Id: <20110330210500.065CC3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Tim Deegan <Tim.Deegan@citrix.com>

commit 70a062286b9dfcbd24d2e11601aecfead5cf709a upstream.

Fixes a hang when booting as dom0 under Xen, when jiffies can be
quite large by the time the kernel init gets this far.

Signed-off-by: Tim Deegan <Tim.Deegan@citrix.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[jbeulich@novell.com: !time_after() -> time_before_eq() as suggested by Jiri Slaby]
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 init/calibrate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/init/calibrate.c
===================================================================
--- linux-2.6.35.y.orig/init/calibrate.c	2011-03-29 22:51:44.697579468 -0700
+++ linux-2.6.35.y/init/calibrate.c	2011-03-29 23:02:59.497313032 -0700
@@ -66,7 +66,7 @@
 		pre_start = 0;
 		read_current_timer(&start);
 		start_jiffies = jiffies;
-		while (jiffies <= (start_jiffies + 1)) {
+		while (time_before_eq(jiffies, start_jiffies + 1)) {
 			pre_start = start;
 			read_current_timer(&start);
 		}
@@ -74,8 +74,8 @@
 
 		pre_end = 0;
 		end = post_start;
-		while (jiffies <=
-		       (start_jiffies + 1 + DELAY_CALIBRATION_TICKS)) {
+		while (time_before_eq(jiffies, start_jiffies + 1 +
+					       DELAY_CALIBRATION_TICKS)) {
 			pre_end = end;
 			read_current_timer(&end);
 		}
