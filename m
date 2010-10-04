Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab0JDQQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 12:16:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab0JDQQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 12:16:13 -0400
Date: Mon, 4 Oct 2010 13:15:56 -0300
From: Glauber Costa <glommer@redhat.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] use a stable clock reference in vdso vgetns
Message-ID: <20101004161555.GG1230@mothafucka.localdomain>
References: <1285938596-2186-1-git-send-email-glommer@redhat.com>
 <AANLkTimdukAnwtPooFJYTxtzoT+Scy9JwWoxkkj3g0zO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimdukAnwtPooFJYTxtzoT+Scy9JwWoxkkj3g0zO@mail.gmail.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 10:49:53AM -0700, john stultz wrote:
> On Fri, Oct 1, 2010 at 6:09 AM, Glauber Costa <glommer@redhat.com> wrote:
> > When using vdso services for clock_gettime, we test for the ability
> > of a fine-grained measurement through the existance of a vread() function.
> >
> > However, from the time we test it, to the time we use it, vread() reference
> > may not be valid anymore. It happens, for example, when we change the current
> > clocksource from one that provides vread (say tsc) to one that lacks it
> > (say acpi_pm), in the middle of clock_gettime routine.
> >
> > seqlock does not really protect us, since readers here won't stop the writers
> > to change references. The proposed solution is to grab a copy of the clock
> > structure early, and use it as a stable reference onwards.
> 
> Ah. Good find! The fix looks reasonable to me. However, its likely the
> similar code in arch/x86/kernel/vsyscall_64.c will need a similar fix.
> 
> Awhile back there was some motivation to merge the two vdso/vsyscall
> implementations to avoid the duplication, but my memory is failing on
> why that didn't happen. I feel like it had to do with complication
> with the way the two implementations are mapped out to userland. Even
> so, it seems a shared forced inline method would resolve the issue, so
> maybe it just fell off the todo list?
Ok, I just stated that vsyscall is safe because of update_vsyscall. This is
just not the case. Update vsyscall will update the timer structures but leave
us with the problem that it will do it regardless of any readers. What makes
vsyscall "safe", is this:

                vread = __vsyscall_gtod_data.clock.vread; 
                ^
                |--- saves reference to vread                    uses --.
                if (unlikely(!__vsyscall_gtod_data.sysctl_enabled || !vread)) {
                        gettimeofday(tv,NULL);
                        return;
                }

                now = vread(); <=== uses again

This was, actually, my first idea on how to solve the problem for vdso. If we are
always reading this inside the seqlock, it should be okay.

In the way vdso's clock_gettime is structured, however, it would involve passing
down the expected seq + vread pointer down the function call chain, or wrapping
all callees inside the lock. Honestly, I believe the solution I posted is cleaner
than both, even having a slight difference wrt vsyscall's today implementation.

What do you think ?



