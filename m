Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1GLNZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 09:25:06 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35844 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1GLNZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 09:25:04 -0400
Date: Tue, 12 Jul 2011 15:24:49 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v2 1/8] x86-64: Improve vsyscall emulation CS and RIP
 handling
Message-ID: <20110712132449.GB11336@aftab>
References: <cover.1310267866.git.luto@mit.edu>
 <2215c119e580b40f243c37d284e7bced309d975f.1310267866.git.luto@mit.edu>
 <20110711221432.GA10164@liondog.tnic>
 <CAObL_7ERJ4D_R5k1C7OHLz1etZzxcaTA7rzFmtRu0-gpq_YpMQ@mail.gmail.com>
 <20110712071832.GA17616@liondog.tnic>
 <CAObL_7F5KQA+GaSsU5nD+7gAY2JFv+XE0BRu+sRg0Mv24dBzaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAObL_7F5KQA+GaSsU5nD+7gAY2JFv+XE0BRu+sRg0Mv24dBzaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 08:58:58AM -0400, Andrew Lutomirski wrote:
> On Tue, Jul 12, 2011 at 3:18 AM, Borislav Petkov <bp@alien8.de> wrote:
> > On Mon, Jul 11, 2011 at 06:20:50PM -0400, Andrew Lutomirski wrote:
> >> > I'm wondering: why don't you make this function return negative value on
> >> > error, i.e. -EINVAL and the vsyscall number on success so that you can
> >> > get rid of returning it through the arg pointer?
> >> >
> >> > Then at the callsite you can do:
> >> >
> >> >        vsyscall_nr = addr_to_vsyscall_nr(addr);
> >> >        if (vsyscall_nr < 0)
> >> >                warn_bad_vsyscall(...)
> >>
> >> Because I don't want a warning about ret being used without being initialized.
> >
> > not if you preinit it...
> 
> I kind of like that warning as a sanity check, and preiniting it
> grates against my irrational desire to over-optimize :)

:-)

> >
> >> With the code in this patch, the compiler is smart enough to figure
> >> out that either vsyscall_nr is 0, 1, or 2 or that the EINVAL branch is
> >> taken.  I'll see if it works the other way.
> >
> > here's what i mean, I changed your patch a bit:
> 
> How about this:
> 
> static int addr_to_vsyscall_nr(unsigned long addr)
> {
> 	int nr;
> 
> 	if ((addr & ~0xC00UL) != VSYSCALL_START)
> 		return -EINVAL;
> 
> 	nr = (addr & 0xC00UL) >> 10;
> 	if (nr >= 3)
> 		return -EINVAL;
> 
> 	return nr;
> }
> 
> ...
> 
> 	int vsyscall_nr;
> 
> ...
> 
> 	vsyscall_nr = addr_to_vsyscall_nr(regs->ip - 2);
> 	if (vsyscall_nr < 0) {
> 		warn_bad_vsyscall(KERN_WARNING, regs,
> 				  "illegal int 0xcc (exploit attempt?)");
> 		goto sigsegv;
> 	}
> 
> gcc 4.6 at least does not warn.

Yep, looks good.

> Also, IRQ disabling was still mismatched in the sigsegv path.  I'll
> fix that as well.

oh yeah.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
