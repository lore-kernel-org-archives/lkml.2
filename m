Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab0LASez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:34:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618Ab0LASey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:34:54 -0500
Date: Wed, 1 Dec 2010 19:27:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Milton Miller <miltonm@bga.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>
Subject: Re: (No subject header)
Message-ID: <20101201182747.GB6143@redhat.com>
References: <20101130200129.GG11905@redhat.com> <compat-not-unlikely@mdm.bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <compat-not-unlikely@mdm.bga.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01, Milton Miller wrote:
>
> On Tue, 30 Nov 2010 about 20:01:29 -0000, Oleg Nesterov wrote:
> > Teach get_arg_ptr() to handle compat = T case correctly.
>
> >  #include <asm/uaccess.h>
> >  #include <asm/mmu_context.h>
> > @@ -395,6 +396,18 @@ get_arg_ptr(const char __user * const __
> >  {
> >  	const char __user *ptr;
> >
> > +#ifdef CONFIG_COMPAT
> > +	if (unlikely(compat)) {
>
> This should not be marked unlikely.  Unlikely tells gcc the path
> with over 99% confidence and disables branch predictors on some
> architectures.  If called from a compat processes this will result
> in a mispredicted branch every iteration.  Just use if (compat)
> and let the hardware branch predictors do their job.

This applies to almost every likely/unlikely, and I think that compat
processes should fall into "unlikely category". But I don't really mind,
I can remove this hint, I added it mostly as documentation.

> > +#ifdef CONFIG_COMPAT
> > +int compat_do_execve(char * filename,
> > +	compat_uptr_t __user *argv,
> > +	compat_uptr_t __user *envp,
> > +	struct pt_regs * regs)
> > +{
> > +	return do_execve_common(filename,
> > +				(void __user*)argv, (void __user*)envp,
>
> Shouldn't these be compat_ptr(argv)?  (makes a difference on s390)

I'll recheck, but I don't think so. Please note that compat_ptr()
accepts "compat_uptr_t", not "compat_uptr_t *".

argv should be correct as a pointer to user-space, otherwise the
current code is buggy. For example, compat_do_execve() passes
argv to compat_count() which does get_user(argv) without any
conversion.

IOW, even if this should be fixed, I think this have nothing to
do with this patch. But I'll recheck, thanks.

Oleg.

