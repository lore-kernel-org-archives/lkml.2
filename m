Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1HBRDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 13:03:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764Ab1HBRC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 13:02:58 -0400
Date: Tue, 2 Aug 2011 19:02:56 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Venki Pallipadi <venki@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH resend] x86, PAT: honor CONFIG_STRICT_DEVMEM if pat is
 disabled
Message-ID: <20110802170256.GB23698@tiehlicka.suse.cz>
References: <20110801094611.AAF738A95F@mx2.suse.de>
 <CABeCy1Y6ZO3igfRhdDQTSS0i2w9k2WTtJYwWUxuRT56UG9Zd8Q@mail.gmail.com>
 <20110802080315.GA9473@tiehlicka.suse.cz>
 <CABeCy1aCA_iGOYw65UK3Nr2W7u5zEOK24N-n0iCY=aQZNVcUEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABeCy1aCA_iGOYw65UK3Nr2W7u5zEOK24N-n0iCY=aQZNVcUEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02-08-11 09:33:28, Venki Pallipadi wrote:
> On Tue, Aug 2, 2011 at 1:03 AM, Michal Hocko <mhocko@suse.cz> wrote:
> > On Mon 01-08-11 16:33:18, Venki Pallipadi wrote:
> >> On Fri, Jul 22, 2011 at 2:01 AM, Michal Hocko <mhocko@suse.cz> wrote:
> >> >
> >> > since 0124cecf (x86, PAT: disable /dev/mem mmap RAM with PAT) we are
> >> > disabling access to the system RAM as if STRICT_DEVMEM was enabled by
> >> > default. If we, however, disable pat by nopat kernel parameter we can
> >> > access that memory without considering CONFIG_STRICT_DEVMEM.
> >>
> >> Looking at the code, I don't think this problem exists. Code in pat.c
> >> disables /dev/mem mmap only when !CONFIG_STRICT_DEVMEM.
> >
> > Ahh yes, you are right. I got confused by having two separate
> > range_is_allowed functions and didn't realize which one is called from
> > which context.
> >        mmap_mem
> >          -> range_is_allowed [drivers/char/mem.c]
> >               -EPERM
> >          -> phys_mem_access_prot_allowed
> >               -> range_is_allowed [arch/x86/mm/pat.c]
> >
> > So we really get stopped at the first check and do not get to the later
> > one.
> >
> > While we are at it. {read,write}_mem checks only range_is_allowed (mem.c
> > version) and it doesn't call phys_mem_access_prot_allowed so we do not
> > consider PAT. {read,write}_kmem doesn't check the range at all.
> > Is this correct?
> > Why do we care _only_ about mmap?
> >
> 
> Yes. The problem with PAT and /dev/mem mmap is with untracked mmaps in
> user address space. Once mapped the mappings can stay in user space
> and if there is a page attribute change for that physical address
> later kernel doesn't have handle on all such user space mappings that
> may exist.
> Read/Write on the other hand use direct mappings and will not cause
> this problem. I have generally been suggesting tools that want to
> access /dev/mem and are unable to mmap it due to PAT to use read/write
> instead. /dev/mem on 32 bit has some problems of its own and the
> recent patchset on mailing list fixes most of the issues there.

OK, understood. Thanks for the clarification.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
