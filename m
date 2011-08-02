Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab1HBIDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 04:03:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab1HBIDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 04:03:17 -0400
Date: Tue, 2 Aug 2011 10:03:15 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Venki Pallipadi <venki@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH resend] x86, PAT: honor CONFIG_STRICT_DEVMEM if pat is
 disabled
Message-ID: <20110802080315.GA9473@tiehlicka.suse.cz>
References: <20110801094611.AAF738A95F@mx2.suse.de>
 <CABeCy1Y6ZO3igfRhdDQTSS0i2w9k2WTtJYwWUxuRT56UG9Zd8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABeCy1Y6ZO3igfRhdDQTSS0i2w9k2WTtJYwWUxuRT56UG9Zd8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 01-08-11 16:33:18, Venki Pallipadi wrote:
> On Fri, Jul 22, 2011 at 2:01 AM, Michal Hocko <mhocko@suse.cz> wrote:
> >
> > since 0124cecf (x86, PAT: disable /dev/mem mmap RAM with PAT) we are
> > disabling access to the system RAM as if STRICT_DEVMEM was enabled by
> > default. If we, however, disable pat by nopat kernel parameter we can
> > access that memory without considering CONFIG_STRICT_DEVMEM.
> 
> Looking at the code, I don't think this problem exists. Code in pat.c
> disables /dev/mem mmap only when !CONFIG_STRICT_DEVMEM.

Ahh yes, you are right. I got confused by having two separate
range_is_allowed functions and didn't realize which one is called from
which context.
	mmap_mem
	  -> range_is_allowed [drivers/char/mem.c]
	       -EPERM
	  -> phys_mem_access_prot_allowed
	       -> range_is_allowed [arch/x86/mm/pat.c]

So we really get stopped at the first check and do not get to the later
one.

While we are at it. {read,write}_mem checks only range_is_allowed (mem.c
version) and it doesn't call phys_mem_access_prot_allowed so we do not
consider PAT. {read,write}_kmem doesn't check the range at all.
Is this correct?
Why do we care _only_ about mmap?

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
