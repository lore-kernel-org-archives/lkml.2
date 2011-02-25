Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab1BYTLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 14:11:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932502Ab1BYTLh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 14:11:37 -0500
MIME-Version: 1.0
In-Reply-To: <20110225175314.GD19059@redhat.com>
References: <20101130200129.GG11905@redhat.com> <compat-not-unlikely@mdm.bga.com>
 <20101201182747.GB6143@redhat.com> <20110225175202.GA19059@redhat.com> <20110225175314.GD19059@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Feb 2011 11:10:46 -0800
Message-ID: <AANLkTik8epq5cx8n=k6ocMUfbg9kkUAZ8KL7ZiG4UuoU@mail.gmail.com>
Subject: Re: [PATCH 3/5] exec: unify compat_do_execve() code
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 9:53 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Teach get_arg_ptr() to handle compat = T case correctly.

Does it?

> +#ifdef CONFIG_COMPAT
> +int compat_do_execve(char *filename,
> +       compat_uptr_t __user *argv,
> +       compat_uptr_t __user *envp,
> +       struct pt_regs *regs)
> +{
> +       return do_execve_common(filename,
> +                               (void __user *)argv, (void __user*)envp,
> +                               regs, true);
> +}
> +#endif

I really suspect this should be something like

  typedef union {
     compat_uptr_t compat;
     const char __user *native;
   } conditional_user_ptr_t;

  ...

  int compat_do_execve(char *filename,
                  compat_uptr_t argv,
                  compat_uptr_t envp,
                  struct pt_regs *regs)
   {
             return do_execve_common(filename,
                      compat_ptr(argv), compat_ptr(envp), regs);

where that 'do_execve_common()' takes it's arguments as

    union conditional_user_ptr_t __user *argv,
    union conditional_user_ptr_t __user *envp

and then in get_arg_ptr() we do the proper union member dereference
depending on the "compat" flag.

THAT would actually have the type system help us track what is
actually going on, and would clarify the rules. It would also make it
clear that "do_execve_common()" does *not* take some kind of random
pointer to user space (much less a "const char __user *const char
__user *"). It really does take a pointer to user space, but what that
pointer contains in turn depends on the "compat" flag.

IOW, it really acts as a pointer to a user-space union, and I think
we'd be better off having the type show that.

                  Linus
