Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0JNBhC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 21:37:02 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59526 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab0JNBhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 21:37:01 -0400
Subject: Re: [PATCH] use a stable clock reference in vdso vgetns
From: john stultz <johnstul@us.ibm.com>
To: Glauber Costa <glommer@redhat.com>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20101013140746.GM5590@mothafucka.localdomain>
References: <1285938596-2186-1-git-send-email-glommer@redhat.com>
	 <AANLkTimdukAnwtPooFJYTxtzoT+Scy9JwWoxkkj3g0zO@mail.gmail.com>
	 <20101013140746.GM5590@mothafucka.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 18:36:55 -0700
Message-ID: <1287020215.3467.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 11:07 -0300, Glauber Costa wrote:
> On Fri, Oct 01, 2010 at 10:49:53AM -0700, john stultz wrote:
> > On Fri, Oct 1, 2010 at 6:09 AM, Glauber Costa <glommer@redhat.com> wrote:
> > > When using vdso services for clock_gettime, we test for the ability
> > > of a fine-grained measurement through the existance of a vread() function.
> > >
> > > However, from the time we test it, to the time we use it, vread() reference
> > > may not be valid anymore. It happens, for example, when we change the current
> > > clocksource from one that provides vread (say tsc) to one that lacks it
> > > (say acpi_pm), in the middle of clock_gettime routine.
> > >
> > > seqlock does not really protect us, since readers here won't stop the writers
> > > to change references. The proposed solution is to grab a copy of the clock
> > > structure early, and use it as a stable reference onwards.
> > 
> > Ah. Good find! The fix looks reasonable to me. However, its likely the
> > similar code in arch/x86/kernel/vsyscall_64.c will need a similar fix.
> > 
> > Awhile back there was some motivation to merge the two vdso/vsyscall
> > implementations to avoid the duplication, but my memory is failing on
> > why that didn't happen. I feel like it had to do with complication
> > with the way the two implementations are mapped out to userland. Even
> > so, it seems a shared forced inline method would resolve the issue, so
> > maybe it just fell off the todo list?
> News here?

Errr.. Sorry, are you waiting for me to implement this? Or did you want
a comment on your earlier mail? (Apologies, I've been a bit scattered
here).

I think trying to unify the two implementations would be nice if you're
up to trying, but if not, go ahead and push your patch and that will fix
the bug until I can get around to looking at the unification.

I don't think the unification would be *that* complicated, since its
just a matter of grabbing the right reference to the mapped out data
(either the __vsyscall_gtod_data or the vdso_vsyscall_gtod_data) and
then just passing a pointer to the right reference to the common inlined
functions). 


thanks
-john


