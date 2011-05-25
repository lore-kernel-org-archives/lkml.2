Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab1EYO3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:29:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34854 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394Ab1EYO3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:29:48 -0400
Date: Wed, 25 May 2011 16:29:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110525142934.GA29179@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <20110524211644.GJ27634@elte.hu>
 <1306278038.1921.5.camel@dan>
 <20110525112339.GC30983@elte.hu>
 <1306333251.2211.22.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306333251.2211.22.camel@dan>
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


* Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> On Wed, 2011-05-25 at 13:23 +0200, Ingo Molnar wrote:
> > * Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> > 
> > > > No, the right solution is what i suggested a few mails ago: 
> > > > /proc/kallsyms (and other RIP printing places) should report the 
> > > > non-randomized RIP.
> > > > 
> > > > That way we do not have to change the kptr_restrict default and 
> > > > tools will continue to work ...
> > > 
> > > Ok, I'll do it this way, and leave the kptr_restrict default to 0.  
> > > But I still think having the dmesg_restrict default depend on 
> > > randomization makes sense, since kernel .text is explicitly 
> > > revealed in the syslog.
> > 
> > Hm, where is it revealed beyond intcall addresses, which ought to be 
> > handled if they are printed via %pK?
> > 
> > All such information leaks need to be fixed. (This will be the 
> > slowest part of the process i suspect - there's many channels.)
> > 
> > in the syslog we obviously want any RIPs converted to the canonical 
> > 'unrandomized' address, so that it can be matched against 
> > /proc/kallsyms, etc. Their randomized value isnt very useful. That 
> > will also protect the randomization secret as a side effect.
> > 
> 
> %pK doesn't seem like the right thing to do in many cases, since 
> the capability check doesn't have proper meaning if the caller 
> isn't in process context. [...]

Oh, ok, i see what you mean.

I was not thinking of %pK as a way to restrict access really. I am 
thinking of it as a nicely central way to create constant RIPs out of 
random RIPs.

In that sense if %pK cannot be called everywhere please introduce a 
%pk variant that just prints a raw kernel address value and does no 
access check, just the unrandomization.

> [...]  If I'm understanding you right (correct if I'm wrong), 
> you're looking for kptr_restrict to be completely separate from 
> this randomization, and when randomization is enabled, all pointers 
> are unconditionally de-randomized.  It seems like the right way to 
> do this is to include code in vsprintf.c for all %p-type specifiers 
> that would normally print the actual pointer (as opposed to some of 
> the specialized cases that print other data) that does something 
> like this:
> 
> if((unsigned long)ptr >= (unsigned long)_stext &&
>    (unsigned long)ptr <= (unsigned long)_end)
> 	ptr -= (_text - (CONFIG_PHYSICAL_START + PAGE_OFFSET));
> 
> This way, we don't have to go tracking down every printk caller and 
> convert them to %pK, which isn't usable anyway in some cases.

Yeah, but please also provide %pk to not have to hunt down every 
single place that might print a kernel address via a "%016Lx" or "%p" 
and thus leaks the randomization secret.

That way you can convert *every* known kernel-address-printing format 
string to one of the %p variants and thus have the above 
unrandomization step done automatically.

Perhaps as a debugging help also try to flag %p printouts that are 
suspiciously within kernel image boundaries. (Note: you dont want to 
printk from that place though, as you could already be executing 
within printk.) Maybe even %x/%X printouts that are in that range. As 
a debugging help, there could easily be false positives.

> I'm tempted to just say "leave OOPS alone", and if you want to preserve
> secrecy past an OOPS, you should be disabling dmesg access anyway.  But
> I'll think more about this.

It's definitely a good first-approximation answer. We only do perfect 
kernels anyway, so they wont oops.

Please convert RIPs in oops decoding nevertheless, so that it can be 
correlated with the symbol table...

Thanks,

	Ingo
