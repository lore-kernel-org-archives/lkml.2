Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503Ab2CMKMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:12:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41174 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760195Ab2CMKMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:12:39 -0400
Message-ID: <4F5F1D70.1030708@gmail.com>
Date: Tue, 13 Mar 2012 18:12:00 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] module: use rcu to protect module list read
References: <1331389203-3309-1-git-send-email-xiyou.wangcong@gmail.com> <87mx7lz6fn.fsf@rustcorp.com.au>
In-Reply-To: <87mx7lz6fn.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 08:32 AM, Rusty Russell wrote:
> On Sat, 10 Mar 2012 22:20:02 +0800, Cong Wang<xiyou.wangcong@gmail.com>  wrote:
>> Now the read of module list is protected by preempt disable + *_rcu
>> list operations, this is odd, as RCU read lock should be able to
>> protect it directly. This patch makes the read of module list
>> protected by RCU read lock and the write still protected by
>> module_mutex.
>
> OK, please split these patches further.  Locking is subtle, so it's
> great to be able to bisect more finely if we catch a problem.
>
> eg.  First replace all the preempt_disable()/enable with
> rcu_read_lock()/unlock.  Then replace lock in set_all_modules_text.
> And so on...
>

Fair enough, will do!

>> @@ -1810,11 +1810,11 @@ void *__symbol_get(const char *symbol)
>> 	struct module *owner;
>> 	const struct kernel_symbol *sym;
>>
>> -	preempt_disable();
>> +	rcu_read_lock();
>> 	sym = find_symbol(symbol,&owner, NULL, true, true);
>> +	rcu_read_unlock();
>> 	if (sym&&  strong_try_module_get(owner))
>> 		sym = NULL;
>> -	preempt_enable();
>>
>> 	return sym ? (void *)sym->value : NULL;
>>   }
>
> This is wrong: the symbol can vanish between find_symbol() and
> strong_try_module_get().  We need protection around the whole thing.

This is my mistake. Sorry. :(

>
>> @@ -3302,7 +3309,7 @@ static char *module_flags(struct module *mod, char *buf)
>>   /* Called by the /proc file system to return a list of modules. */
>>   static void *m_start(struct seq_file *m, loff_t *pos)
>>   {
>> -	mutex_lock(&module_mutex);
>> +	rcu_read_lock();
>>   	return seq_list_start(&modules, *pos);
>>   }
>>
>> @@ -3313,7 +3320,7 @@ static void *m_next(struct seq_file *m, void *p, loff_t *pos)
>>
>>   static void m_stop(struct seq_file *m, void *p)
>>   {
>> -	mutex_unlock(&module_mutex);
>> +	rcu_read_unlock();
>>   }
>>
>>   static int m_show(struct seq_file *m, void *p)
>
> Interesting.  I assume that these functions needed to sleep.  But it
> looks like I was wrong.
>

I didn't touch this part in V2, because seq_list_start() doesn't use 
_rcu operations on the list. Maybe we need a seq_list_start_rcu()?

Thanks!
