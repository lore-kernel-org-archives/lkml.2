Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab1DBSUr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 14:20:47 -0400
Received: from mail.aknet.ru ([78.158.192.28]:59906 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135Ab1DBSUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 14:20:46 -0400
Message-ID: <4D9768DB.6050409@aknet.ru>
Date: Sat, 02 Apr 2011 22:20:11 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
References: <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru> <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com> <4D94BE19.7050001@aknet.ru> <20110331181816.GA17101@redhat.com> <4D94EAEE.2010505@aknet.ru> <20110402135523.GA26316@redhat.com>
In-Reply-To: <20110402135523.GA26316@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02.04.2011 17:55, Oleg Nesterov wrote:
>> OK, I'll try to break it into a small chunks then.
>> But the fact that such a seemingly simple functionality
>> requires so many changes, is IMHO bad by itself.
> Indeed. You are trying to do something unnatural ;)
Well, the fact that fork/exit was always used to detach
from parent, doesn't mean that it was natural: a single
syscall looks more natural. :)

> Indeed. You suggest the exotic and non-portable feature, almost
> nobody will use it. But every user should pay for that. This is
> not fair.
If that is true, then of course this should not be ever applied.
But why do you think so? What gets slowed down? wait()?
But if the detached_sibling list is empty, then why?

> The kernel is already huge. I simply can't understand why do
> you think this is good idea to add more bloat for this feature.
That depends on the final code (if it will ever be produced).
Maybe it can be very simple? :) I don't want to add bloat, I
want a small and simple patch.

> And this is not enough to daemonize anyway. setsid() won't work.
But TIOCNOTTY will.

> Stas, please do not try to convince me, you can't. OTOH, let me
> repeat, you do not need to convince me. I'd suggest you to discuss
> this with Linus. If he agrees - then we can look at your patch
Well, if the patch is bloated or buggy, there is no reason to
discuss it with Linus. :) If the patch is small and simple, that
alone will give it lots of credits.

 > Hmm... Again, I didn't really read the patch... But iiuc, the
 > detached child can exit and init can reap it, after that the
 > old parent gets ECHLD?
Yes. Because making sure that both parents wait()ed, probably
cannot be reliably implemented without the write_lock_irq(&tasklist_lock),
while the current code uses only read lock. Or you really need
a fake task_struct...

>  do_wait() from parent should
>  always work or it should always return ECHLD, but it should
>  not depend on /dev/random. This is really weird, imho.
OK, in this case, I guess, the fake task_struct is the last chance.

>  does list_del_init(&p->detached_sibling). This is too late. If the
>  old parent has already called wait_task_detached() and cleared
>  ->detaching, this child will add the unnecessary cost to every
>  subsequent do_wait() call.
OK, will add the forgotten "if (->detaching)" check before calling
wait_task_detached(), thanks.

>  If the old parent exits, list_del_init()
>  can crash the kernel.
Why?

Yes, I can read Russian, as you asked in another e-mail. :)
Let me clarify once again: I don't want to add neither bloat, nor
the slowdown on the common path. But I haven't yet convinced myself
that this is unavoidable. If you haven't noticed, I shrunk the
patch 3 times, and fixed most of the bugs already. :)) And I am not
even trying to convince you (or Linus) in anything, before the pach
is made simple. If it can't be made simple, then I'll leave it to
my project only. That was the intention anyway. :)

