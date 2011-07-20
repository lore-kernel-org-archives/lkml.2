Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1GTPl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 11:41:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab1GTPl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 11:41:26 -0400
Date: Wed, 20 Jul 2011 11:41:24 -0400
From: Don Zickus <dzickus@redhat.com>
To: ZAK Magnus <zakmagnus@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Track hard and soft "short lockups" or "stalls."
Message-ID: <20110720154124.GS3765@redhat.com>
References: <1310760670-32232-1-git-send-email-zakmagnus@google.com>
 <20110718122820.GB1808@redhat.com>
 <CAAuSN9106qmYF27oRrfUBtqwOmSQgDJWwv3iz_NmTTuYNEymHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAuSN9106qmYF27oRrfUBtqwOmSQgDJWwv3iz_NmTTuYNEymHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 02:45:55PM -0700, ZAK Magnus wrote:
> Okay, great. I'm eager to hear anything you may discover, good or bad. By
> the way, would you mind sharing a bit about how you do your testing for
> this?

Sorry for getting back to you late, busy week.

Most of the testing I do is from the lkdtm module

modprobe lkdtm
mount -t debugfs none /sys/kernel/debug
cd /sys/kernel/debug/provoke-crashing/
service cpuspeed stop
echo HARDLOCKUP > DIRECT #or SOFTLOCKUP or HUNG_TASK

I then count to 10 seconds to make sure the timer is within reason.

So I did the above test and noticed the panic looked funny because it spit
out the 

new worst hard stall seen on CPU#0: 3 interrupts missed

and then 

new worst hard stall seen on CPU#0: 4 interrupts missed

and then finally the HARDLOCKUP message

I am not sure that is what we want as it confuses people as to where the
panic really is.

What if you moved the 'update_hardstall()' to just underneath the zero'ing
out of the hrtimer_interrupts_missed?  This only then prints out the
interrupts missed line when you know the end point.  And avoids printing
it all together in the case of a true HARDLOCKUP.  Like the patch below

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 7d37cc2..ba41a74 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -238,13 +238,14 @@ static int is_hardlockup(int this_cpu)
 
 	if (hrint_saved == hrint)
 		ints_missed = per_cpu(hrtimer_interrupts_missed, this_cpu)++;
-	else
+	else {
 		__this_cpu_write(hrtimer_interrupts_missed, 0);
+		update_hardstall(ints_missed, this_cpu);
+	}
 
 	if (ints_missed >= hardlockup_thresh)
 		return 1;
 
-	update_hardstall(ints_missed, this_cpu);
 	return 0;
 }
 #endif

The softlockup case probably needs the same.

Thoughts?

Cheers,
Don
