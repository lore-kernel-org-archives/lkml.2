Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690Ab2FQRfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 13:35:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61911 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602Ab2FQRfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 13:35:08 -0400
Date: Sun, 17 Jun 2012 19:34:56 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, John Stultz <johnstul@us.ibm.com>,
        stable@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -stable]  ntp: Correct TAI offset during leap second
Message-ID: <20120617173456.GA3684@netboy.at.omicron.at>
References: <4FDB8563.3030805@us.ibm.com>
 <1339944223.4942.240.camel@deadeye.wl.decadent.org.uk>
 <20120617164751.GJ12429@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120617164751.GJ12429@burratino>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 11:47:51AM -0500, Jonathan Nieder wrote:
> Ben Hutchings wrote:
> > On Fri, 2012-06-15 at 11:56 -0700, John Stultz wrote:
> 
> >> commit dd48d708ff3e917f6d6b6c2b696c3f18c019feed upstream.
> [...]
> > This doesn't apply to 3.2.y, unsurprisingly.  Let me know if there are
> > any urgent leap second fixes that will be needed there.
> 
> 6b43ae8a619d (ntp: Fix leap-second hrtimer livelock) sounds important,
> but the patch depends on bd3312681f69 (ntp: Add ntp_lock to replace
> xtime_locking) which does not have a commit message explaining its
> purpose (and that patch in turn depends on ea7cf49a7633).
> 
> John, is that bug present in 3.2.y and 3.0.y, too?  Any hints for
> fixing it?

It looks like incrementing the TAI offset was wrong even before 

   6b43ae8a ntp: Fix leap-second hrtimer livelock  v3.4-rc1~44^2~9

The offset should change upon entering state OOP, so something like
the following (untested) patch should fix it for 3.2.9.

Thanks,
Richard

---
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index f6117a4..d7bd953 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -365,6 +365,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 		break;
 	case TIME_INS:
 		timekeeping_leap_insert(-1);
+		time_tai++;
 		time_state = TIME_OOP;
 		printk(KERN_NOTICE
 			"Clock: inserting leap second 23:59:60 UTC\n");
@@ -379,7 +380,6 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 			"Clock: deleting leap second 23:59:59 UTC\n");
 		break;
 	case TIME_OOP:
-		time_tai++;
 		time_state = TIME_WAIT;
 		/* fall through */
 	case TIME_WAIT:
