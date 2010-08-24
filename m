Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770Ab0HXXLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:11:38 -0400
Received: from kroah.org ([198.145.64.141]:41298 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933462Ab0HXXDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:11 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:08 2010
Message-Id: <20100824224508.268146014@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John Stultz <johnstul@us.ibm.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, Ingo Molnar <mingo@elte.hu>
Subject: [081/114] time: Workaround gcc loop optimization that causes 64bit div errors
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Stultz <johnstul@us.ibm.com>

commit c7dcf87a6881bf796faee83003163eb3de41a309 upstream.

Early 4.3 versions of gcc apparently aggressively optimize the raw
time accumulation loop, replacing it with a divide.

On 32bit systems, this causes the following link errors:
	undefined reference to `__umoddi3'
	undefined reference to `__udivdi3'

The gcc issue has been fixed in 4.4 and greater.

This patch replaces the accumulation loop with a do_div, as suggested
by Linus.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Jason Wessel <jason.wessel@windriver.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>
CC: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/timekeeping.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -756,9 +756,10 @@ static cycle_t logarithmic_accumulation(
 	/* Accumulate raw time */
 	raw_nsecs = timekeeper.raw_interval << shift;
 	raw_nsecs += raw_time.tv_nsec;
-	while (raw_nsecs >= NSEC_PER_SEC) {
-		raw_nsecs -= NSEC_PER_SEC;
-		raw_time.tv_sec++;
+	if (raw_nsecs >= NSEC_PER_SEC) {
+		u64 raw_secs = raw_nsecs;
+		raw_nsecs = do_div(raw_secs, NSEC_PER_SEC);
+		raw_time.tv_sec += raw_secs;
 	}
 	raw_time.tv_nsec = raw_nsecs;
 


