Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab2CKKyA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 06:54:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61864 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab2CKKx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 06:53:58 -0400
Message-ID: <4F5C8440.7000907@gmail.com>
Date: Sun, 11 Mar 2012 18:53:52 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] module: use rcu to protect module list read
References: <1331389203-3309-1-git-send-email-xiyou.wangcong@gmail.com> <1331393157.2453.15.camel@edumazet-laptop>
In-Reply-To: <1331393157.2453.15.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2012 11:25 PM, Eric Dumazet wrote:
> Le samedi 10 mars 2012 à 22:20 +0800, Cong Wang a écrit :
>> Now the read of module list is protected by preempt disable + *_rcu
>> list operations, this is odd, as RCU read lock should be able to
>> protect it directly. This patch makes the read of module list
>> protected by RCU read lock and the write still protected by
>> module_mutex.
>>
>
> Problem is that your patch does more than that.
>
> In set_all_modules_text_rw() and set_all_modules_text_ro() you removed
> the mutex in favor of rcu_read_lock()

Yeah, I was wrong, set_all_modules_text_rw() and 
set_all_modules_text_ro() mean to block module add/del, it is correct to 
use module_mutex.

>
> Also, module code uses synchronize_sched(), not synchronize_rcu()

Stupid me, I totally missed this, should use rcu_read_lock_sched()...

>
> Take a look at Documentation/RCU/whatisRCU.txt and see that
> preempt_disable() / preempt_enable() are documented as a right protect
> code, in line 333.
>
> You added races in /proc/modules as well.

Yeah, that list iteration is not protected by rcu yet.

>
> So I would say your patch is not needed at all : module code already
> uses RCU.
>
> What particular problem do you have with current code ?

preempt_disable() + list_*_rcu() looks a little weird for me, 
rcu_read_lock_sched() + list_*_rcu() is better, although they are 
functionally equal.

I will send out a new version.

Thanks for review!
