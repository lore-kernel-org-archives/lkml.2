Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504Ab1EaJCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:02:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47612 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab1EaJCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:02:23 -0400
Date: Tue, 31 May 2011 11:02:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [PATCH] kvm: Fix build warnings
Message-ID: <20110531090219.GA26762@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
References: <20110530124600.GB494@eferding.osrc.amd.com>
 <1306786278-12219-1-git-send-email-bp@alien8.de>
 <20110531073824.GA17999@elte.hu>
 <4DE4A4E7.80503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DE4A4E7.80503@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 11:20:55AM +0300, Avi Kivity wrote:
> On 05/31/2011 10:38 AM, Ingo Molnar wrote:
> >* Borislav Petkov<bp@alien8.de>  wrote:
> >
> >>  +++ b/arch/x86/kvm/paging_tmpl.h
> >>  @@ -121,7 +121,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
> >>   				gva_t addr, u32 access)
> >>   {
> >>   	pt_element_t pte;
> >>  -	pt_element_t __user *ptep_user;
> >>  +	pt_element_t __user *uninitialized_var(ptep_user);
> >
> >Note that doing this is actually actively dangerous for two reasons.
> >
> >
> 
> <snip lots of good advice>
> 
> >Please fix it instead.
> 
> s/instead/in addition/; while all those changes are good, they are
> much too large for 3.0.  Let's push the simple fix for 3.0 and queue
> the bigger refactoring to 3.1.

Just to clarify: Hell, it is _not_ I who's fixing this! Virtualization
folks are crazy anyway and I'm not touching their code except for
trivial fixes :-).

The story: I saw the humongous function and being lazier than Ingo, I
just wanted to shut up the warning. Knowing that uninitialized_var()
is a dangerous thing to use, I asked whether people who know the code
can guarantee that ptep_user is not going to be used uninitialized and
Takuya confirmed.

But yes, it'll be much better if kvm people could take a good hard look
at it and try to simplify it. Also, while they're at it, I'd suggest
they actually trace whether that unlikely() annotation actually brings
any performance speedup - if it doesn't, out the door with it and here's
more simplification right there.

Thanks.

-- 
Regards/Gruss,
    Boris.
