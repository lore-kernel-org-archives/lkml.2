Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab2K1SAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:00:40 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:41179 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754317Ab2K1SAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:00:39 -0500
Message-ID: <1354125623.2788.23.camel@thor>
Subject: [BUG -next-20121127] kernel BUG at kernel/softirq.c:471!
From: Peter Hurley <peter@hurleysoftware.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Date: Wed, 28 Nov 2012 13:00:23 -0500
In-Reply-To: <20121105173707.94602896.akpm@linux-foundation.org>
References: <1351824534-2861-1-git-send-email-xtfeng@gmail.com>
	 <20121105145207.6d2fae92.akpm@linux-foundation.org>
	 <CAJn8CcF=2=XBV0T661LnAxHi8+fT8KAVapCFaiDZgS6TyieNOA@mail.gmail.com>
	 <20121105173707.94602896.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 17:37 -0800, Andrew Morton wrote:
> On Tue, 6 Nov 2012 09:22:16 +0800 Xiaotian Feng <xtfeng@gmail.com> wrote:
> 
> > On Tue, Nov 6, 2012 at 6:52 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Fri,  2 Nov 2012 10:48:54 +0800
> > > Xiaotian Feng <xtfeng@gmail.com> wrote:
> > >
> > >> We met a ksoftirqd 100% issue, the perf top shows kernel is busy
> > >> with tasklet_action(), but no actual action is shown. From dumped
> > >> kernel, there's only one disabled tasklet on the tasklet_vec.
> > >>
> > >> tasklet_action might be handled after tasklet is disabled, this will
> > >> make disabled tasklet stayed on tasklet_vec. tasklet_action will not
> > >> handle disabled tasklet, but place it on the tail of tasklet_vec,
> > >> still raise softirq for this tasklet. Things will become worse if
> > >> device driver uses tasklet_disable on its device remove/close code.
> > >> The disabled tasklet will stay on the vec, frequently __raise_softirq_off()
> > >> and make ksoftirqd wakeup even if no tasklets need to be handled.
> > >>
> > >> This patch introduced a new TASKLET_STATE_HI bit to indicate HI_SOFTIRQ,
> > >> in tasklet_action(), simply ignore the disabled tasklet and don't raise
> > >> the softirq nr. In my previous patch, I remove tasklet_hi_enable() since
> > >> it is the same as tasklet_enable(). So only tasklet_enable() needs to be
> > >> modified, if tasklet state is changed from disable to enable, use
> > >> __tasklet_schedule() to put it on the right vec.
> > >
> > > gee, I haven't looked at the tasklet code in 100 years.  I think I'll
> > > send this in Thomas's direction ;)
> > >
> > > The race description seems real and the patch looks sane to me.  Are
> > > you sure we can get away with never clearing TASKLET_STATE_HI?  For
> > > example, what would happen if code does a tasklet_hi_schedule(t) and
> > > later does a tasklet_schedule(t)?
> > 
> > hmm, that will be a nightmare...
> > tasklet_schedule(t)/tasklet_hi_schedule(t) doesn't use list_head, they
> > simply
> > make t->next = NULL, then put t on the tail of
> > tasklet_vec/tasklet_hi_vec. If the code does a tasklet_hi_schedule()
> > and then a tasklet_schedule, the tasklet will stay on tasklet_vec and
> > tasklet_hi_vec .... tasklet_hi_action will handle it first and clear
> > the TASKLET_SCHED_SCHED bit, later, in tasklet_action, it will be
> > handled again and hit a BUG_ON ...
> 
> Well, actually I meant if the caller reuses the tassklet_struct after
> its softirq has been run.
> 
> > But if code does a tasklet_hi_schedule(), then tasklet_kil and later
> > does a tasklet_schedule(), we do need clear the TASKLET_STATE_HI.
> 
> That as well ;)
> 
> > Also
> > we need to remove the tasklet_hi_enable() as it is the same as
> > tasklet_enable() and there's
> > only one user..
> > 
> > I'll send you V2 patch soon, thanks.
> 
> Sounds good.

Hi all,

I couldn't find the v2 patch of this on linux-kernel but this commit

  4660e32 "tasklet: ignore disabled tasklet in tasklet_action()"

BUGS in -next-20121127.

-----------[cut here ]----------
kernel BUG at /home/peter/src/kernels/next/kernel/softirq.c:471!
invalid opcode: 0000 [#1] PREEMPT SMP
....

The registers/stack dump isn't useful so I didn't include it here.

I'm still trying to track down the execution sequence that causes this,
but the high-level trigger is a firewire bus reset.

Hopefully I'll have more information soon.

Regards,
Peter Hurley

PS - My new staging/fwserial driver isn't to blame because it isn't
loaded when this happens ;)



