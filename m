Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab1D0M6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 08:58:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758007Ab1D0M6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 08:58:10 -0400
Date: Wed, 27 Apr 2011 14:57:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] signal: sys_sigprocmask() needs
	retarget_shared_pending()
Message-ID: <20110427125710.GA21281@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com> <20110426194822.GA8520@redhat.com> <20110426195002.GF8520@redhat.com> <BANLkTinp8FGQu2D1NVVc7xfEsqopook7Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinp8FGQu2D1NVVc7xfEsqopook7Hg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26, Linus Torvalds wrote:
>
> > +               sigemptyset(&new_full_set);
> > +               if (how == SIG_SETMASK)
> > +                       new_full_set = current->blocked;
> > +               new_full_set.sig[0] = new_set;
>
> Ugh. This is just ugly.

Agreed.

> Could we not instead turn the whole thing into a "clear these bits"
> and "set these bits", and get rid of the "how" entirely for the helper
> function?
>
> IOW, we'd have
>
>   switch (how) {
>   case SIG_BLOCK:
>       clear_bits = 0;
>       set_bits = new_set;
>       break;
>   case SIG_UNBLOCK:
>       clear_bits = new_set;
>       set_bits = 0;
>       break
>   case SIG_SET:
>      clear_bits = low_bits;
>      set_bits = new_set;
>      break;
>    default:
>      return -EINVAL;
>   }
>
> and notice how you now can do that helper function *WITHOUT* any
> conditionals, and just make it do
>
>     sigprocmask(&clear, &set, NULL);
>
> which handles all cases correctly (just "andn clear" + "or set") with
> no if's or switch'es.
>
> This is why I _detest_ that idiotic "sigprocmask()" interface.

Agreed, but...

Yes, sigprocmask(how) is ugly, but there are sys_rt_sigprocmask() and
sys_sigprocmask() which have to handle these SIG_* operations anyway.
So, I think we should do:

	1. Almost all callers of sigprocmask() use SIG_SETMASK, we can
	   simply change them to use set_current_blocked().

	2. Add the new helper (probably like you suggested) and convert
	   other 9 callers.

	3. Unexport sigprocmask() and remove the last "*oldset" argument,
	   it should be only used by sys_*sigprocmask() syscalls.

But firstly I'd like to finish this "don't change ->blocked directly"
conversion. And this patch changes sys_sigprocmask() so that it looks
similar to sys_rt_sigprocmask().

What do you think?

If you can't accept sys_sigprocmask()->sigprocmask(), will you agree
with

	SYSCALL_DEFINE3(sigprocmask, int, how, old_sigset_t __user *, nset,
			old_sigset_t __user *, oset)
	{
		old_sigset_t old_set, new_set;
		sigset_t new_blocked;

		old_set = current->blocked.sig[0];

		if (nset) {
			if (copy_from_user(&new_set, nset, sizeof(*nset)))
				return -EFAULT;
			new_set &= ~(sigmask(SIGKILL) | sigmask(SIGSTOP));

			new_blocked = current->blocked;

			switch (how) {
			case SIG_BLOCK:
				sigaddsetmask(&new_blocked, new_set);
				break;
			case SIG_UNBLOCK:
				sigdelsetmask(&new_blocked, new_set);
				break;
			case SIG_SETMASK:
				new_blocked.sig[0] = new_set;
				break;
			default:
				return -EINVAL;
			}

			set_current_blocked(&new_blocked);
		}

		if (oset) {
			if (copy_to_user(oset, &old_set, sizeof(*oset)))
				return -EFAULT;
		}

		return 0;
	}
?

Oleg.

