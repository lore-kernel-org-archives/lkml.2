Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab1JJT6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:58:24 -0400
Received: from claw.goop.org ([74.207.240.146]:41563 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704Ab1JJT6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:58:22 -0400
Message-ID: <4E934E5B.3000603@goop.org>
Date: Mon, 10 Oct 2011 12:58:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been initialized,
 don't nop it out
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com> <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com> <20111010153631.GA2413@redhat.com>
In-Reply-To: <20111010153631.GA2413@redhat.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2011 08:36 AM, Jason Baron wrote:
> On Sat, Oct 01, 2011 at 02:55:35PM -0700, Jeremy Fitzhardinge wrote:
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> If a key has been enabled before jump_label_init() is called, don't
>> nop it out.
>>
>> This removes arch_jump_label_text_poke_early() (which can only nop
>> out a site) and uses arch_jump_label_transform() instead.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> ---
>>  include/linux/jump_label.h |    3 ++-
>>  kernel/jump_label.c        |   20 ++++++++------------
>>  2 files changed, 10 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
>> index 1213e9d..c8fb1b3 100644
>> --- a/include/linux/jump_label.h
>> +++ b/include/linux/jump_label.h
>> @@ -45,7 +45,8 @@ extern void jump_label_lock(void);
>>  extern void jump_label_unlock(void);
>>  extern void arch_jump_label_transform(struct jump_entry *entry,
>>  				 enum jump_label_type type);
>> -extern void arch_jump_label_text_poke_early(jump_label_t addr);
>> +extern void arch_jump_label_transform_early(struct jump_entry *entry,
>> +				 enum jump_label_type type);
>>  extern int jump_label_text_reserved(void *start, void *end);
>>  extern void jump_label_inc(struct jump_label_key *key);
>>  extern void jump_label_dec(struct jump_label_key *key);
>> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
>> index a8ce450..059202d5 100644
>> --- a/kernel/jump_label.c
>> +++ b/kernel/jump_label.c
>> @@ -121,13 +121,6 @@ static void __jump_label_update(struct jump_label_key *key,
>>  	}
>>  }
>>  
>> -/*
>> - * Not all archs need this.
>> - */
>> -void __weak arch_jump_label_text_poke_early(jump_label_t addr)
>> -{
>> -}
>> -
>>  static __init int jump_label_init(void)
>>  {
>>  	struct jump_entry *iter_start = __start___jump_table;
>> @@ -139,12 +132,15 @@ static __init int jump_label_init(void)
>>  	jump_label_sort_entries(iter_start, iter_stop);
>>  
>>  	for (iter = iter_start; iter < iter_stop; iter++) {
>> -		arch_jump_label_text_poke_early(iter->code);
>> -		if (iter->key == (jump_label_t)(unsigned long)key)
>> +		struct jump_label_key *iterk;
>> +
>> +		iterk = (struct jump_label_key *)(unsigned long)iter->key;
>> +		arch_jump_label_transform(iter, jump_label_enabled(iterk) ?
>> +					  JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
>> +		if (iterk == key)
>>  			continue;
>>  
>> -		key = (struct jump_label_key *)(unsigned long)iter->key;
>> -		atomic_set(&key->enabled, 0);
>> +		key = iterk;
>>  		key->entries = iter;
>>  #ifdef CONFIG_MODULES
>>  		key->next = NULL;
>> @@ -212,7 +208,7 @@ void jump_label_apply_nops(struct module *mod)
>>  		return;
>>  
>>  	for (iter = iter_start; iter < iter_stop; iter++)
>> -		arch_jump_label_text_poke_early(iter->code);
>> +		arch_jump_label_transform(iter, JUMP_LABEL_DISABLE);
>>  }
>>  
>>  static int jump_label_add_module(struct module *mod)
>> -- 
>> 1.7.6.2
>>
> Hi,
>
> I just realized that the early call to jump_label_inc(), isn't being
> honored with this patch until later when we invoke jump_label_init().
> That strikes me as being inconsistent. When jump_label_inc() returns we
> should expect the branch to be updated.

Why is that?  It looks to me like it will unconditionally update the
instruction, irrespective of whether _init() has been called?

> Thus, I think what probably want is to add a new 'int jump_label_init'
> flag. If its not set we can call 'jump_label_init()' from
> jump_label_inc()/dec().

Hm.  I worry that it may end up calling jump_label_init() in an
unexpected context, especially since it may well be config-dependent, or
adding a jump_label_inc() later on starts mysteriously failing.

>  And jump_label_init() can avoid initialization
> if its already set.

That doesn't seem worthwhile in itself.  I suspect the number of "early"
jump_label_incs will be very small (or we should look at doing the init
earlier).

    J
