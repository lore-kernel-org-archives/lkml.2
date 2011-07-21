Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab1GUSjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:39:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46486 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab1GUSjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:39:12 -0400
Date: Thu, 21 Jul 2011 20:38:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Andi Kleen <ak@linux.intel.com>, mingo@redhat.com, wzt <wzt.wzt@gmail.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        hpa@zytor.com, Michal Hocko <mhocko@suse.cz>,
        Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
Subject: Re: [PATCH] x86: Fix memory leak of init_vdso_vars()
Message-ID: <20110721183820.GA381@elte.hu>
References: <20110705062148.GA6056@program>
 <d1a1b6416d71a5062fb3b3e364f9db6b6d4ef6b2.1311258580.git.luto@mit.edu>
 <20110721170824.GA28974@tassilo.jf.intel.com>
 <CAObL_7HyjsPKnyDEEa0T8iTetpkd9Hq7RTBymieazzGOsXQLdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7HyjsPKnyDEEa0T8iTetpkd9Hq7RTBymieazzGOsXQLdA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Andrew Lutomirski <luto@mit.edu> wrote:

> On Thu, Jul 21, 2011 at 1:08 PM, Andi Kleen <ak@linux.intel.com> wrote:
> > On Thu, Jul 21, 2011 at 10:33:14AM -0400, Andy Lutomirski wrote:
> >> From: Zhitong Wang <wzt.wzt@gmail.com>
> >>
> >> If init_vdso_vars ran out of memory (not very likely), then it would
> >> leak a few pages as well.
> >>
> >> Also rename init_vdso_vars to just init_vdso, since initializing
> >> vvars is just about the only thing this function doesn't do.
> >
> > Just add a GFP_PANIC, there's no way to recover from this.
> > Your system will not work without a vdso.
>
> Ingo objected to this before, although I'm not convinved.  Calling 
> init_vdso_vars more than once will cause major problems (like 
> double-patching of alternatives).  If there's too little memory for 
> it to work, then presumably there's also too little memory to start 
> init.
>
>  (Also, I bet that no one ever audited whether the ELF loader works 
> right if the vDSO failed to load.)
> 
> Ingo?

This assumes that the system actually needs an ELF loader - if a 
static binary is booted via a init= boot parameter it might not be 
needed.

Memory failure injection code will also cause this to panic early 
during bootup spuriously.

Really, we should cleanly tear down what we built up and fail cleanly 
as well, no need to be sloppy since we already have the patch. That 
some other code down the boot chain might be sloppy is no excuse to 
be sloppy here.

Would be nice to stick a WARN_ON() into the oom branch though, as 
it's clearly an anomalous condition.

(btw., there's no GFP_PANIC, we never had any such flag for the page 
allocator.)

Thanks,

	Ingo
