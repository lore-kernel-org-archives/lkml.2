Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab1CaSSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:18:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758902Ab1CaSSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:18:35 -0400
Date: Thu, 31 Mar 2011 20:18:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
Message-ID: <20110331181816.GA17101@redhat.com>
References: <4D6510A3.90905@aknet.ru> <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru> <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com> <4D94BE19.7050001@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D94BE19.7050001@aknet.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Stas Sergeev wrote:
>
> 31.03.2011 21:02, Oleg Nesterov wrote:
>> I only looked at sys_prctl() code, and almost every line looks wrong.
> Well, the lines you pointed, were also in the
> previous patch, and, as you didn't complained
> back then, I thought they were fine. :)

Of course, I forgot completely what the previous patch did ;)
Perhaps I missed them before, or perhaps I stopped looking after
I noticed other problems.

>>> +			if (notif != DEATH_REAP) {
>>> +				list_add_tail(&me->detached_sibling,
>>> +					&me->real_parent->detached_children);
>>> +				me->exit_state = EXIT_DETACHED;
>> No, no, we can't set ->exit_state != 0. This means the task is dead.
> Does this really break things? I mean, there are
> probably no checks like "if (task->exit_state)",

There are. zap_other_threads() for example. More importantly, we
can have more of them. exit_state != 0 means: this task has passed
exit_notify(), we shouldn't break this.

>>> +			/* detaching makes us a group leader */
>>> +			me->group_leader = me;
>> How? Now, we can't change ->group_leader, this is simply not possible
>> and very wrong. If nothing else, think about tid/tgid, but there are
>> a lot more problems.
> OK, thats why in the previous patch I was allowing only
> the group leader to detach, but you complained. Should
> I return that back?

Ah, I _seem_ to recall... Yes, it seems strange that only group leader
can do PR_DETACH. If we implement this, I think any thread should be
allowed to call prctl(DETACH). But why do we need to change the leader?

>> Well. Once again, I never argue with new features, but you need to
>> convince lkml. Probably it is simple to implement PR_DETACH so that
>> the task just "disappears" from the old_parent's radar.
> Yes, that worked for me too:
> https://lkml.org/lkml/2010/12/25/37
> Yes, I know there are bugs too. :) But, at least the patch
> is just few lines.

I didn't look at the patch above, but probably it makes more sense.
At least for the start.

>> Otherwise
>> we need more complications, but I'd rather add the fake TASK_ZOMBIE
>> task_struct for that. This will be much, much simply although not
>> pretty anyway.
> Well, maybe the patch looks more complex than it actually is.
> How it works:

I didn't mean it is very hard to understand the intent. What is
really hard (at least to me) to see if it is correct or not.

And in any case it adds a lot of the code, and complicates the things.

So, just in case, I have to admit: yes, personally I dislike this
new feature ;) But, again, I am not going to argue.

> There were some rearrangements in the exit.c code, that are
> not directly related to the new feature. I can split them to the
> separate patches, if that will help.

Yes, this always help.

> As for convincing LKML... Well, when the code is right, maybe. :))

Maybe ;)

But, otoh. It is quite possible you will get the quick nack...

Oleg.

