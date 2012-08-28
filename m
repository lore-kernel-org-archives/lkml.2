Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab2H1S2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 14:28:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab2H1S21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 14:28:27 -0400
Date: Tue, 28 Aug 2012 11:28:11 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andi Kleen <andi@firstfloor.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: PER_LINUX32, Was: [PATCH v2 21/31] arm64: 32-bit (compat)
 applications support
In-Reply-To: <201208230646.31276.arnd@arndb.de>
Message-ID: <alpine.LNX.2.00.1208281124520.22447@pobox.suse.cz>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <201208151434.05145.arnd@arndb.de> <20120816102808.GH31784@mudshark.cambridge.arm.com> <201208230646.31276.arnd@arndb.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2012, Arnd Bergmann wrote:

> > > > +asmlinkage int compat_sys_personality(compat_ulong_t personality)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	if (personality(current->personality) == PER_LINUX32 &&
> > > > +		personality == PER_LINUX)
> > > > +		personality = PER_LINUX32;
> > > > +	ret = sys_personality(personality);
> > > > +	if (ret == PER_LINUX32)
> > > > +		ret = PER_LINUX;
> > > > +	return ret;
> > > > +}
> > > 
> > > Where did you get this from?
> > > 
> > > You should not need compat_sys_personality, just call the native function.
> > 
> > Hmm, but in that case an aarch32 application doing a personality(PER_LINUX)
> > syscall will start seeing the wrong uname.
> 
> Coming back at this topic, I noticed another issue. Jiri Kosina
> has recently posted patches to fix this function in the other architectures

Yeah, there were quite a few broken ones, some of them since the beginning 
of time.

> in order to mask out the other personality bits, which is a correct fix,
> but the above function is odd for other reasons.
> 
> * On MIPS, it is used only for compat tasks, like you have it above.
> * On PA-RISC, it is used for native 32 bit tasks and for compat 32 bit tasks,
>   but not for native 64 bit ones.
> * On IA64, it was used for compat tasks (support for which has since
>   been removed from the kernel), plus all 32 bit tasks would start with
>   PER_LINUX32.
> * On PowerPC, Sparc and s390, it is used for native 64 bit tasks and for
>   compat 32 bit tasks, but not for native 32 bit ones.
> * On Tile, it was never used.
> * On x86_64, it used to be defined (copied from ia64) but not used
>   throughout the git history.
> 
> The semantics of the function are also interesting: The intention seems
> to be that to a compat task, PER_LINUX32 would appear as PER_LINUX.
> The effect is that any process can set PER_LINUX32 but it can never
> be unset except by a 64 bit MIPS or PA-RISC task.
> 
> Since x86_64 does not implement this behavior at all, I suspect that
> there are now lots of things depending on not having it, while all
> the other architectures might also have some (even predating the
> x86_64 port) use cases that depend on depend on not being able to
> observe PER_LINUX32 in 32 bit compat tasks.
> 
> I think we should try to agree on how this is all supposed to work
> and use common code, either put the ppc/sparc/s390 version into
> sys_personality, or remove all of them and just do what x86 and tile
> do, using the regular sys_personality for all tasks.

How about rather introducing common compat_sys_personality() and switching 
the archs that are using it to it? Unifying the behavior (PER_LINUX / 
PER_LINUX32 masquerading) should be painless.

Thanks,

-- 
Jiri Kosina
SUSE Labs
