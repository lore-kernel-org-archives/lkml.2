Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab1DZVnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:43:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758531Ab1DZVnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:43:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110426195002.GF8520@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com> <20110426194822.GA8520@redhat.com> <20110426195002.GF8520@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Apr 2011 14:43:00 -0700
Message-ID: <BANLkTinp8FGQu2D1NVVc7xfEsqopook7Hg@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] signal: sys_sigprocmask() needs retarget_shared_pending()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +               sigemptyset(&new_full_set);
> +               if (how == SIG_SETMASK)
> +                       new_full_set = current->blocked;
> +               new_full_set.sig[0] = new_set;

Ugh. This is just ugly.

Could we not instead turn the whole thing into a "clear these bits"
and "set these bits", and get rid of the "how" entirely for the helper
function?

IOW, we'd have

  switch (how) {
  case SIG_BLOCK:
      clear_bits = 0;
      set_bits = new_set;
      break;
  case SIG_UNBLOCK:
      clear_bits = new_set;
      set_bits = 0;
      break
  case SIG_SET:
     clear_bits = low_bits;
     set_bits = new_set;
     break;
   default:
     return -EINVAL;
  }

and notice how you now can do that helper function *WITHOUT* any
conditionals, and just make it do

    sigprocmask(&clear, &set, NULL);

which handles all cases correctly (just "andn clear" + "or set") with
no if's or switch'es.

This is why I _detest_ that idiotic "sigprocmask()" interface. That
"how" parameter is the invention of somebody who didn't understand
sets. It's stupid. There is no reason to have multiple different set
operations, when in practice all anybody ever wants is the "clear
these bits and set those other bits" - an operation that is not only
more generic than the idiotic "how", but is _faster_ too, because it
involves no conditionals.

So I realize that we cannot get away from the broken user interface,
but I do not believe that that means that our _internal_ helper
functions should use that idiotic and broken interface!

I had basically this same comment earlier when you did something
similarly mindless for another case.

So basic rule should be: if you ever pass "how" to any helper
functions, it's broken.

                                     Linus
