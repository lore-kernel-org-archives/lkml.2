Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab1BPBu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:50:57 -0500
Received: from kroah.org ([198.145.64.141]:49038 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758278Ab1BPBu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:50:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:00 2011
Message-Id: <20110216014700.275270755@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tim Deegan <Tim.Deegan@citrix.com>, Jan Beulich <jbeulich@novell.com>,
        Jiri Slaby <jslaby@suse.cz>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [060/115] fix jiffy calculations in calibrate_delay_direct to handle overflow
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Tim Deegan <Tim.Deegan@citrix.com>

commit 70a062286b9dfcbd24d2e11601aecfead5cf709a upstream.

Fixes a hang when booting as dom0 under Xen, when jiffies can be
quite large by the time the kernel init gets this far.

Signed-off-by: Tim Deegan <Tim.Deegan@citrix.com>
[jbeulich@novell.com: !time_after() -> time_before_eq() as suggested by Jiri Slaby]
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 init/calibrate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/init/calibrate.c
+++ b/init/calibrate.c
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


