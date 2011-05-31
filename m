Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab1EaW32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 18:29:28 -0400
Received: from canuck.infradead.org ([134.117.69.58]:58866 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771Ab1EaW3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 18:29:16 -0400
X-Greylist: delayed 33403 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 May 2011 18:29:16 EDT
Subject: Re: [tip:sched/urgent] sched: Fix cross-cpu clock sync on remote
 wakeups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@amd64.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        markus@trippelsdorf.de, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20110531125621.GA24439@gere.osrc.amd.com>
References: <1306835745.2353.3.camel@twins>
	 <tip-f01114cb59d670e9b4f2c335930dd57db96e9360@git.kernel.org>
	 <20110531125621.GA24439@gere.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 31 May 2011 15:11:56 +0200
Message-ID: <1306847516.2353.80.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 14:56 +0200, Borislav Petkov wrote:
> Hey Peter,
> 
> On Tue, May 31, 2011 at 12:31:20PM +0000, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  f01114cb59d670e9b4f2c335930dd57db96e9360
> > Gitweb:     http://git.kernel.org/tip/f01114cb59d670e9b4f2c335930dd57db96e9360
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Tue, 31 May 2011 12:26:55 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Tue, 31 May 2011 14:19:56 +0200
> > 
> > sched: Fix cross-cpu clock sync on remote wakeups
> > 
> > Markus reported that commit 317f394160e ("sched: Move the second half
> > of ttwu() to the remote cpu") caused some accounting funnies on his AMD
> > Phenom II X4, such as weird 'top' results.
> > 
> > It turns out that this is due to non-synced TSC
> 
> this would mean that his machine doesn't pass the TSC sync check at boot
> but that's a F10h and they usu. have synchronized TSCs?
> 
> I'm confused.

Well, I don't have a modern AMD system to verify on, but the only
explanation is sched_clock weirdness (different code from the GTOD tsc
stuff). I could not reproduce on an Intel Westmere machine, but could on
a Core2.

The sched_clock_cpu stuff basically takes a GTOD timestamp every tick
and uses sched_clock() (tsc + cyc2ns) to provide delta increments, when
TSCs are synced every cpu should return the same value and the patch is
a nop.

If they aren't synced the per-cpu sched_clock_cpu() values can drift up
to about 2 jiffies (when the ticks drift about 1 and the slower of the
two has a stuck tsc while the faster of the two does progress at the
normal rate). In that case doing a clock update cross-cpu will ensure
time monotonicity between those two cpus.

So by this patch making a difference we prove that sched_clock_cpu()'s
aren't synced on the affected machines. That leaves two options, either
the TSC are screwy or there's a bug somewhere in the sched_clock* code.

I'd be more than happy if you could take a look at the relevant code
since all code can use more eyes :-)
