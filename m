Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab1BYSBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:01:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756304Ab1BYSBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:01:20 -0500
Date: Fri, 25 Feb 2011 18:52:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
Subject: [PATCH 0/4 RESEND] exec: unify compat/non-compat code
Message-ID: <20110225175202.GA19059@redhat.com>
References: <20101130200129.GG11905@redhat.com> <compat-not-unlikely@mdm.bga.com> <20101201182747.GB6143@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201182747.GB6143@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01, Oleg Nesterov wrote:
>
> On 12/01, Milton Miller wrote:
> >
> > > +#ifdef CONFIG_COMPAT
> > > +int compat_do_execve(char * filename,
> > > +	compat_uptr_t __user *argv,
> > > +	compat_uptr_t __user *envp,
> > > +	struct pt_regs * regs)
> > > +{
> > > +	return do_execve_common(filename,
> > > +				(void __user*)argv, (void __user*)envp,
> >
> > Shouldn't these be compat_ptr(argv)?  (makes a difference on s390)
>
> I'll recheck, but I don't think so. Please note that compat_ptr()
> accepts "compat_uptr_t", not "compat_uptr_t *".
>
> argv should be correct as a pointer to user-space, otherwise the
> current code is buggy. For example, compat_do_execve() passes
> argv to compat_count() which does get_user(argv) without any
> conversion.

So, once again, this should not (and can not) be compat_ptr(argv) afaics.

I don't understand the s390 asm, but compat_wrapper.S:sys32_execve_wrapper
looks correct. If not, the current code is already buggy and s390 should
be fixed. argv/envp are not compat ptrs, they just point to compat_ data,
we should not do any conversion.

I am resending this series unchanged, plus the trivial 5/5 to document
acct_arg_size().

----------------------------------------------------------------------

execve code in fs/compat.c must die. It is very hard to maintain this
copy-and-paste horror. And the only reason for this duplication is that
argv/envp point to char* or compat_uptr_t depending on compat. We can
add the trivial helper which hides the difference and unify the code.

Oleg.

