Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab1GAPg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:36:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41657 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab1GAPg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:36:56 -0400
Date: Fri, 1 Jul 2011 17:36:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
Message-ID: <20110701153634.GA27407@elte.hu>
References: <201106171038.25988.ptesarik@suse.cz>
 <20110701144129.GA10052@infradead.org>
 <20110701144641.GA23272@elte.hu>
 <201107011654.06651.ptesarik@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201107011654.06651.ptesarik@suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Petr Tesarik <ptesarik@suse.cz> wrote:

> Dne Pá 1. července 2011 16:46:41 Ingo Molnar napsal(a):
> > * Christoph Hellwig <hch@infradead.org> wrote:
> > > On Fri, Jul 01, 2011 at 04:37:35PM +0200, Ingo Molnar wrote:
> > > > After initial modules have loaded i essentially disable crash.ko
> > > > via /proc/sys/kernel/modules_disabled so rootkits have to work a
> > > > bit harder than that.
> > > 
> > > Not sure for fedora as I don'[t have a kernel tree at hand right
> > > now, but for x86 systems at least RHEL6 has the module built in.
> > > [...]
> > 
> > Fedora Rawhide has it modular:
> > 
> >  # grep CRASH /boot/config-2.6.38-0.rc7.git2.3.fc16.x86_64
> >  CONFIG_CRASH=m
> > 
> >  # rpm -ql kernel-2.6.38-0.rc7.git2.3.fc16.x86_64 | grep crash
> >  /lib/modules/2.6.38-0.rc7.git2.3.fc16.x86_64/kernel/drivers/char/crash.ko
> > 
> > > [...]  Either way we'll need some way to support crash properly in
> > > mainline, preferably in a boot-time opt-in way. [...]
> > 
> > Yes, boot-time opt-in was what i suggested.
> > 
> > > [...] I'd tend slightly toward optionally enabling /dev/mem for it
> > > instead of a separate driver, but if people prefer a different
> > > route I'm fine, too.
> > 
> > No, sharing the driver is perfectly fine and sane as long as this
> > weird usage is not enabled widely.
> 
> Note that if you want to solve the Fedora case, you want to make 
> STRICT_DEVMEM run-time configurable. My patch set does nothing 
> about it. It merely tries to fix the highmem deficiency (actually, 
> the first patch is a plain bugfix on any architecture where loff_t 
> is larger than long).

I'm not focused on Fedora here (i brought it up as an example). I'd 
like to improve upstream, and if that is done Fedora can just go use 
it and symlink /dev/mem to /dev/crash.

> The STRICT_DEVMEM logic is implemented in range_is_allowed(), and I 
> leave it as-is.
> 
> > > Note that for normal crash usage read only access is just fine.
> > 
> > That's true as well. Petr?
> 
> Yes, that's true. Although there is some write support in crash, I 
> have never ever felt the need to use it, and I've been using crash 
> a lot in the last 5 years.

If you make it a read-only thing then that removes many of the 
negative aspects of this feature.

Also, does Xorg really need the first 1MB truly write-mapped? Last i 
checked it needed it for the BIOS ...

So we could kill multiple birds with the same stone here:

 - remove various ugly uses of /dev/mem (including the rootkit usage),
   with or without strict-devmem

 - extending it to above-4G for inspection purposes

 - allowing to kill /dev/mem access runtime similar to the 
   disable_modules lock-down killswitch, for the so inclined.

Would you be interested in modifying your patch-set in such a 
fashion?

Thanks,

	Ingo
