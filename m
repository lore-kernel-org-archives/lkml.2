Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab0CZMqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:46:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab0CZMqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:46:07 -0400
Date: Fri, 26 Mar 2010 18:13:40 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, a.p.zijlstra@chello.nl,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Anton Blanchard <anton@samba.org>,
       tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
       mingo@elte.hu, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/7] hvc_console: Fix race between hvc_close and
	hvc_remove
Message-ID: <20100326124340.GB7039@amit-x200.redhat.com>
References: <20100319151326.GC8541@kroah.com> <1269011916-8836-4-git-send-email-gregkh@suse.de> <1269119079.8599.65.camel@pasglop> <20100321043725.GA21566@amit-x200.redhat.com> <20100324121902.GJ15789@amit-x200.redhat.com> <4BAC7AD4.4030309@in.ibm.com> <20100326095821.GA7039@amit-x200.redhat.com> <4BAC9D9E.5070901@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAC9D9E.5070901@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) Mar 26 2010 [17:12:22], Sachin Sant wrote:
> Amit Shah wrote:
>> On (Fri) Mar 26 2010 [14:43:56], Sachin Sant wrote:
>>   
>>>> And this suggests that hvc_kick() is called before hvc_task is
>>>> initialised, ie, before hvc_init() is called.
>>>>
>>>> Does this help?
>>>>         
>>> Hi Amit,
>>>
>>> I too ran into this issue as reported by Anton. Unfortunately in my
>>> case the following suggested patch does not help boot the powerpc
>>> box successfully. The boot still hangs with following messages
>>>     
>>
>> Was the hang you saw before applying this patch at the same place / for
>> the same reason?
>>   
> Yes the machine hangs at the same place with or without the patch.

OK.

>>> mount: can't find /root/proc in /etc/fstab or /etc/mtab
>>> /sbin/smart_agetty: can not determine 'console' speed
>>>     
>>
>> OK, this gets even murkier. I don't know why taking a few krefs modifies
>> hvc_console behaviour to such an extent.
>>   
> Looking at the commit e74d098c66543d0731de62eb747ccd5b636a6f4c,
> i see that for every tty_kref_get() there is a corresponding
> tty_kref_put() except maybe for the one in the following patch snippet
>
>        spin_lock_irqsave(&hp->lock, flags);
>        /* Check and then increment for fast path open. */
>        if (hp->count++ > 0) {
> +               tty_kref_get(tty);
>                spin_unlock_irqrestore(&hp->lock, flags);
>                hvc_kick();
>                return 0;
>
> I don't know this code very well but we might be missing a
> corresponding tty_kref_put() some place ?

See hvc_hangup:

	temp_open_count = hp->count;
	...
	while(temp_open_count) {
		--temp_open_count;
		tty_kref_put(tty);
		kref_put(&hp->kref, destroy_hvc_struct);
	}

> If i comment out the above tty_kref_get() call, the machine
> boots fine with or without the suggested patch.

Hm, so as Alan suggests, it could be a timing issue in getting the ref
and returning back from hvc_open(). I don't know how the tty layer
works, but delays in getting the open() succeed results in badness?
Guess we'll have to poke at the other drivers to see how they handle
open() calls.

		Amit
