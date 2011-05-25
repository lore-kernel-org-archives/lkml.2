Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab1EYS7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:59:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40737 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568Ab1EYS7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:59:33 -0400
Date: Wed, 25 May 2011 20:59:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525185912.GB17864@elte.hu>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
 <20110525065451.GC429@elte.hu>
 <20110525165436.GA14958@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525165436.GA14958@tassilo.jf.intel.com>
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


* Andi Kleen <ak@linux.intel.com> wrote:

> On Wed, May 25, 2011 at 08:54:51AM +0200, Ingo Molnar wrote:
> >
> > >  /* Index into per_cpu list: */
> > >   u16                     cpu_index;
> > >
> > > +	/* CPU update signature */
> > > +	u32			x86_cpu_update;
> > 
> > This should be cpu_microcode_version instead. We already know its x86 so the 
> > x86_ prefix is superfluous. 'cpu_update' is also rather ambigious and does not 
>
> I followed the convention of the other fields in cpu_data, [...]

Look at the context diff above, it has 'cpu_index', so no, there was no
consistent convention to follow.

The fields are arguably pretty inconsistent in 'struct cpuinfo_x86', 
but when adding new fields they should be sane.

> [...] but I'll drop the prefix.
>
> "cpu update" was the name that was suggested to me. Sorry if it's a 
> bit vague. Apparently calling it microcode is not politically 
> correct. I'll keep it for now. If you want to really change it 
> please send another email.
> 
> > So, during the course of developing this, did it occur to you 
> > that other x86 CPUs should fill in this information as well?
> 
> Yes, it did in fact, but I hope someone else will do that because I 
> have no way to test it.

And not Cc:-ing anyone and not mentioning that the microcode driver 
of other vendors needs to be updated was the right solution to raise 
attention to that lack of means of testing? :-)

> > > -	/* see notes above for revision 1.07.  Apparent chip bug */
> 
> This particular code pattern has no chip bug. The CPUID is required 
> by the documentation! So whoever wrote it didn't read the 
> documentation. So yes I dropped that obviously bogus comment.

And you thus 'obviously' forked away the reading of the microcode 
version into another file, with the same 'obviously wrong' comment 
left behind in another place?

Not very smart from you.

> > Why? If you think it's not a bug (but got documented meanwhile as 
> > the official
>
> It always was documented this way.

FYI, the x86 microcode driver actually predates official public 
documentation on the topic, so no, it was not always documented that 
way ;-)

[ I suspect the CPUID was 'documented' after it was found out the 
  hard way that writing the MSR and reading it out without the CPUID 
  can give random junk as the version number. ]

> > way of updating the microcode and reading out the version) then 
> > update the comments in a *separate* patch, and update the *other* 
> > reference to it as well.
> 
> I'm not sure about the other references. The documentation just
> states the CPUID is needed for reading the revision.
> 
> Anyways I'll just leave the comment around for now.
>
> > > +
> > > +	seq_printf(m, "\n");
> > 
> > This too should say microcode version.
> > 
> > Also, please move the field to the logical place, next to 
> > "stepping:". The argument about parsers is bogus - anyone parsing 
> > /proc/cpuinfo is not in a fastpath, full stop.
> 
> The rationale was not cycles, but if someone was stupid enough to 
> hardcode the line number offsets while parsing. You never know with 
> user space /proc parsers and assuming the worst is always the best.
> 
> I thought it was safest to add new fields at the end.

No, it's not a problem to add /proc/cpuinfo fields in the middle - 
please add this new field to the logical place.

> > Also, the above sequence is rather suboptimal to begin with - we can and only 
> > want to execute a *single* seq_printf() there.
> 
> Sorry I don't understand the comment. Anyways as you say above 
> it's no fast path, so it shouldn't matter.
>
> > Please factor out the reading of the microcode version - you have now created 
> > two duplicated open-coded versions of it in cpu.c and microcode_intel.c, with 
> > mismatching comments - not good.
> 
> Huh? There's only a single one now.

That's not actually true. With your patches applied a trivial git 
grep shows the two places reading the microcode version:

 arch/x86/kernel/cpu/intel.c:            wrmsr(MSR_IA32_UCODE_REV, 0, 0);
 arch/x86/kernel/cpu/intel.c:            rdmsr(MSR_IA32_UCODE_REV, lo, c->x86_cpu_update);
 arch/x86/kernel/microcode_intel.c:      wrmsr(MSR_IA32_UCODE_REV, 0, 0);
 arch/x86/kernel/microcode_intel.c:      rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);

As i said you have now created two duplicated open-coded versions of 
it in cpu.c and microcode_intel.c, with mismatching comments - not 
good.

Andi, are you being obtuse and are you wasting my time intentionally? 
You could have checked this yourself.

Thanks,

	Ingo
