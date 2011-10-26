Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab1JZGQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:16:58 -0400
Received: from mail.southpole.se ([193.12.106.18]:39381 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1JZGQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:16:55 -0400
Message-ID: <1319609801.2699.118.camel@satguru>
Subject: Re: [PATCH RFC 2/8] blackfin: implement syscall restart generically
From: Jonas Bonn <jonas@southpole.se>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
Date: Wed, 26 Oct 2011 08:16:41 +0200
In-Reply-To: <CAMjpGUeQch6_-wPRVrktLGFt5h3UV3usaD6XHu_gn82DFcEh1Q@mail.gmail.com>
References: <cover.1319364492.git.jonas@southpole.se>
	 <f33d604e18508d766a224f66f0bc9340af00ee89.1319364492.git.jonas@southpole.se>
	 <CAMjpGUeQch6_-wPRVrktLGFt5h3UV3usaD6XHu_gn82DFcEh1Q@mail.gmail.com>
Organization: South Pole Consulting AB
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11278) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 09813-03116
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2011-10-25 at 20:01 -0400, Mike Frysinger wrote:
> On Sun, Oct 23, 2011 at 06:19, Jonas Bonn <jonas@southpole.se> wrote:
> > --- a/arch/blackfin/include/asm/syscall.h
> > +++ b/arch/blackfin/include/asm/syscall.h
> >
> >  static inline long
> >  syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
> >  {
> > -       return regs->p0;
> > +       return regs->orig_p0;
> >  }
> 
> i'm not sure this is correct.  we set the orig_p0 to -1 when forcing
> the syscall to go to restart.  shouldn't syscall_get_nr() still return
> the right value ?

No, syscall_get_nr is only valid while processing a syscall (should
return -1 otherwise) and the syscall processing is effectively finished
once you've handled the restart requirements so returning -1 at that
point makes sense... patch 1/8 relies on that fact.

> 
> >  syscall_set_return_value(struct task_struct *task, struct pt_regs *regs,
> >                          int error, long val)
> >  {
> > -       regs->r0 = error ? -error : val;
> > +       regs->r0 = error ? error : val;
> >  }
> 
> this fix is unrelated (and unmentioned in the changelog).  i also see
> a bunch of other arches doing this.  so we should pull this change out
> into a dedicated patchset, and fix all the arches at the same time.

Agreed, this should go into a separate patch.  It's true that some
arches do the negation as above, but those arch's return positive error
numbers and indicate syscall error by setting a separate flag.  I'll
prepare a separate patch for this.

/Jonas

