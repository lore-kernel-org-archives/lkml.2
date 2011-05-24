Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab1EXXAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:00:48 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:57756 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab1EXXAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:00:47 -0400
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
In-Reply-To: <20110524211644.GJ27634@elte.hu>
References: <1306269105.21443.20.camel@dan> <20110524211644.GJ27634@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 19:00:38 -0400
Message-ID: <1306278038.1921.5.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 23:16 +0200, Ingo Molnar wrote:
> * Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> 
> > Comments/Questions:
> > 
> > * Since RDRAND is relatively new, only the most recent version of
> > binutils supports assembling it.  To avoid breaking builds for people
> > who use older toolchains but want this feature, I hardcoded the opcodes.
> > If anyone has a better approach, please let me know.
> 
> This is generally the best approach. Maybe mention it here:
> 
> > +	/* rdrand %eax */
> > +	.byte	0x0f, 0xc7, 0xf0
> 
> ... that this is done to work on older GAS as well. Putting that into 
> changelogs is good, putting it into comments is better.
> 

Will do.


> > * In order to increase the entropy for the randomized base, I changed
> > the default value of CONFIG_PHYSICAL_ALIGN back to 2mb.  It had
> > previously been raised to 16mb as a hack so that relocatable kernels
> > wouldn't load below that minimum.  I address this by changing the
> > meaning of CONFIG_PHYSICAL_START such that it now represents a minimum
> > address that relocatable kernels can be loaded at (rather than being
> > ignored by relocatable kernels).  So, if a relocatable kernel determines
> > it should be loaded at an address below CONFIG_PHYSICAL_START (which
> > defaults to 16mb), I just bump it up.
> 
> This would need a real fix, right? The PHYSICAL_ALIGN hack looks worth fixing 
> in its own right.
> 

I'm not sure of a better way to do this than what I've done, which is
essentially introduce a lower bound on the start location rather than
restricting the alignment.  Suggestions welcome.

> > * CONFIG_RANDOMIZE_BASE automatically sets the default value of kptr_restrict 
> > and dmesg_restrict to 1, since it's nonsensical to use this without the other 
> > two.  I considered removing CONFIG_SECURITY_DMESG_RESTRICT altogether (it 
> > currently sets the default value for dmesg_restrict), but just in case 
> > distros want to keep the CONFIG as a toggle switch but don't want to use 
> > CONFIG_RANDOMIZE_BASE, I kept it around.  So, now CONFIG_RANDOMIZE_BASE sets 
> > the default value for CONFIG_SECURITY_DMESG_RESTRICT.
> 
> No, the right solution is what i suggested a few mails ago: /proc/kallsyms (and 
> other RIP printing places) should report the non-randomized RIP.
> 
> That way we do not have to change the kptr_restrict default and tools will 
> continue to work ...
> 

Ok, I'll do it this way, and leave the kptr_restrict default to 0.  But
I still think having the dmesg_restrict default depend on randomization
makes sense, since kernel .text is explicitly revealed in the syslog.

> > * x86-64 is still "to-do". Because it calculates the kernel text address 
> > twice, this may be a little trickier.
> 
> Note that 64-bit is obviously a must-have condition for the eventual acceptance 
> of this patch.

Of course, just wanted early feedback.

> 
> > * Finding a middle ground instead of the current "all-or-nothing" behavior of 
> > kptr_restrict that allows perf users to use this feature is future work.
> 
> Well, for perf we need to transform back the RIPs that get passed along in the 
> stack-dump/call-chain code, see:
> 
>  arch/x86/kernel/dumpstack_64.c
>  arch/x86/kernel/dumpstack.c
>  arch/x86/kernel/dumpstack_32.c
> 
> That, combined with /proc/kallsyms unrandomization makes 'perf top' will just 
> work and produce non-randomized RIPs.
> 
> The canonical RIP to report is the one that the kernel would have if it was 
> loaded non-randomized.
> 

Will do.

> > * Tested by repeatedly booting and observing kallsyms output on both i386.  
> > Passed the "looks random to me" test, and saw no bad behavior. Tested that 
> > changing CONFIG_PHYSICAL_ALIGN to 2mb still boots and runs fine on amd64.
> 
> Please run it over rngtest to measure how much true randomness is in it, on 
> your testbox.
> 

Will do.

> > * Could use testing of CPU hotplugging and suspend/resume.
> 
> and kexec/crashdump. and perf ;-)
> 

Will do.

Thanks very much for the feedback.

