Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192Ab0JZKPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:15:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46627 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab0JZKPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:15:52 -0400
Date: Tue, 26 Oct 2010 12:15:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Borislav Petkov <petkovbb@googlemail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
Message-ID: <20101026101536.GC16552@elte.hu>
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com>
 <1287992610-14996-10-git-send-email-ying.huang@intel.com>
 <20101025084553.GA27119@elte.hu>
 <alpine.LFD.2.00.1010252058370.11036@localhost.localdomain>
 <alpine.LFD.2.00.1010260629560.3955@localhost6.localdomain6>
 <1288083163.2862.592.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288083163.2862.592.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang Ying <ying.huang@intel.com> wrote:

> Hi, Thomas,
> 
> On Tue, 2010-10-26 at 12:53 +0800, Thomas Gleixner wrote:
> > B1;2401;0cLen,
> > 
> > On Mon, 25 Oct 2010, Len Brown wrote:
> > 
> > > >  NAKed-by: Ingo Molnar <mingo@elte.hu>
> > > 
> > > Everybody knows that Linux has a lot to learn about RAS.
> > > 
> > > I think to catch up, we need to play to Linux's strengths
> > > of continuous improvement.  If we halt patches in this area
> > > then we could wait forever for the "perfect design".
> > 
> > it's not about perfect design. It's about creating new user space
> > ABIs. The patches introduce another error reporting user space ABI
> > with an ad hoc "fits the needs" design.
> > 
> > This is my major point of objection. 
> > 
> > I agree that Linux needs improvement on the RAS side, but does this
> > lack of features justify a new user space ABI which is totally
> > disconnected to existing RAS facilities ?
> > 
> > No, it does not. It's not our problem that Intel wasted time on
> > creating another character device driver to report errors to user
> > space. The time spent to do so would have been sufficient to do a
> > proper integration into the existing infrastructure.
> > 
> > I would not care at all if these patches would just introduce some
> > weird in kernel interfaces as we can clean that up at will. But
> > introducing a new user space ABI is setting the disconnect of RAS
> > related facilities into stone.
> > 
> > From Kconfig:
> > 
> >   EDAC is designed to report errors in the core system.
> >   These are low-level errors that are reported in the CPU or
> >   supporting chipset or other subsystems:
> >   memory errors, cache errors, PCI errors, thermal throttling, etc..
> >   If unsure, select 'Y'.
> > 
> > So please explain why your error reporting is so different from the
> > above that it justifies a separate facility. And you better come up
> > with a real good explanation other than we looked at EDAC and it did
> > not fit our needs.
> 
> As far as I know, EDAC guys plan to use some other "perfect interface" in the 
> future. So I think the current state is really waiting for the "perfect design".

Not sure what you mean by this, but Boris has posted links to his latest patch-set 
in this thread, see:

  http://kerneltrap.org/mailarchive/linux-kernel/2010/8/6/4603847

The Git coordinates are:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git, branch tip/perf/parse-events

The 'persistent events' facility he has prototyped there appears to be a good 
potential match for the ERST store.

It would be very useful to have another feature there: to mark persistent events as 
'dump into syslog on bootup', so that for example the contents of the ERST log could 
be dumped right on bootup. [but ERST would not be the only persistent event that 
could be marked like that.]

Note that we dont need/want other ABI accesses to the ERST log (i.e. we dont want 
/dev/erst-dbg), because we want the benefits of the generalization: tooling (RAS and 
other tooling) should learn how to deal with persistent events - not learn how to 
deal with ERST logs ... or with warm bootup RAM-embedded logs ... or to deal with 
kcrash embedded kernel logs ... etc.

There are many obvious advantages from implementing it like that: there's no need to 
special-code ERST to printk or ERST to whatever other facility cross links - it 
would be part of a generic/uniform event logging facility to begin with. ERST would 
only implement its own, narrow, hardware-specific event accessor methods - nothing 
else. Basically a small 'event driver'. This would be the most optimal, smallest, 
easiest to maintain approach - with no facility duplication and no fragmentation.

It's certainly more work as well _for the first such example_ - but from that point 
on any new hardware facility can be added with ease, and those too will fit into 
existing tooling in a very natural way.

So please help out with the persistent events work. If you need any pointers we'd be 
glad to help.

Thanks,

	Ingo
