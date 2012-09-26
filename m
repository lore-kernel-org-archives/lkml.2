Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab2IZO45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:56:57 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34086 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab2IZO44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:56:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120925130443.GF2436@linux.vnet.ibm.com>
References: <505EA09B.6040105@gmail.com>
	<CAFTL4hwqzS8iO2zOOGaizzMtT85MJExTxEgGbponJ4_gfv0nwA@mail.gmail.com>
	<5060E31B.3070203@gmail.com>
	<5060E498.7030003@gmail.com>
	<CAFTL4hzVSBkcDRnzvpmXyBHqydqy=nJxdMtjUHrvR8MwN_M0jQ@mail.gmail.com>
	<5060E863.6020006@gmail.com>
	<CAFTL4hyOMSb2LW+HX1LG+KJCLzazKFmp+nHtEW8CnxG4MX_bsQ@mail.gmail.com>
	<CAFTL4hw7+t8fzcphCyMAQoCBNb6RndQ7hiUnR6qhk6nYa+93fw@mail.gmail.com>
	<20120925040420.GB2436@linux.vnet.ibm.com>
	<20120925115917.GB2310@somewhere.redhat.com>
	<20120925130443.GF2436@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2012 16:56:55 +0200
Message-ID: <CAFTL4hwuQ-smZiH46KCqAw7+01J7aLmthbjL5_Mg9kHJ4CBzuw@mail.gmail.com>
Subject: Re: RCU idle CPU detection is broken in linux-next
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/25 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Tue, Sep 25, 2012 at 01:59:26PM +0200, Frederic Weisbecker wrote:
>> Given that we have:
>>
>> rcu_irq_enter()
>>       rcu_user_exit()
>>       rcu_user_enter()
>> rcu_irq_exit()
>
> Indeed, the code to deal with irq misnestings won't like that at all.
> And we are in the kernel between rcu_user_exit() and rcu_user_enter()
> (right?), so we could in fact see irq misnestings.

Exactly.

>
>> And we already have rcu_user_exit_after_irq(), this starts to be confusing
>> if we allow that nesting. Although if we find a solution that, in the end,
>> merge rcu_user_exit() with rcu_user_exit_after_irq() and same for the enter version,
>> this would probably be a good thing. Provided this doesn't involve some more
>> complicated rdtp->dyntick_nesting trickies nor more overhead.
>>
>> Otherwise we could avoid to call rcu_user_* when we are in an irq. When we'll have
>> the user_hooks layer, we can perhaps manage that from that place. For
>> now may be we can return after in_interrupt() in the rcu user apis.
>
> This last sounds best.

Ok.

>
> My main concern is irq misnesting.  We might need to do something ugly
> like record the interrupt nesting level at rcu_user_exit() and restore
> it at rcu_user_enter().  Sigh!!!

Right, but that doesn't seem to apply in x86? I suggest we start
simple and think
about some wider solution when more architecture implement this.
