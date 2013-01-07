Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3AGUFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 15:05:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44129 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3AGUFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:05:20 -0500
Message-ID: <50EB2A47.9030302@oracle.com>
Date: Mon, 07 Jan 2013 15:04:23 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        jamie.iles@oracle.com
Subject: Re: [PATCH] jump_label: constify jump_label_text_reserved and friends
References: <1357567093-31136-1-git-send-email-sasha.levin@oracle.com> <20130107163955.GB2948@redhat.com>
In-Reply-To: <20130107163955.GB2948@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 11:40 AM, Jason Baron wrote:
> On Mon, Jan 07, 2013 at 08:58:09AM -0500, Sasha Levin wrote:
>> jump_label_text_reserved() doesn't modify the memory it works on, it just
>> checks whether there are any jump labels there.
>>
>> Constify the parameters of it to prevent warnings when working with it.
>>
> 
> I don't see any 'const' data passed to jump_label_text_reserved()? Where is the
> warning coming from? New users?

Out of tree code.

Though once we constify jump_label_text_reserved() and some other similar helper
functions, we can constify more existing code in kprobes/jumplabels/etc as well.

Take check_kprobe_address_safe() for example, the 'struct kprobe *p' it accepts
should probably be const as well.

> Also, does this mean 'ftrace_text_reserved()' and 'alternatives_text_reserved()'
> need to be updated as well?

Jamie has raised this point in private as well. It would make sense to fix
them as well, I haven't done that here only because we haven't stumbled on this
issue with those functions.

I'd be happy to send a patch that fixes it for all of them.


Thanks,
Sasha

> Thanks,
> 
> -Jason
> 
> 
>> Reviewed-by: Jamie Iles <jamie.iles@oracle.com>
>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>> ---
>>  include/linux/jump_label.h |  4 ++--
>>  kernel/jump_label.c        | 10 ++++++----
>>  2 files changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
>> index 0976fc4..d917a2a 100644
>> --- a/include/linux/jump_label.h
>> +++ b/include/linux/jump_label.h
>> @@ -116,7 +116,7 @@ extern void arch_jump_label_transform(struct jump_entry *entry,
>>  				      enum jump_label_type type);
>>  extern void arch_jump_label_transform_static(struct jump_entry *entry,
>>  					     enum jump_label_type type);
>> -extern int jump_label_text_reserved(void *start, void *end);
>> +extern int jump_label_text_reserved(const void *start, const void *end);
>>  extern void static_key_slow_inc(struct static_key *key);
>>  extern void static_key_slow_dec(struct static_key *key);
>>  extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
>> @@ -174,7 +174,7 @@ static inline void static_key_slow_dec_deferred(struct static_key_deferred *key)
>>  	static_key_slow_dec(&key->key);
>>  }
>>  
>> -static inline int jump_label_text_reserved(void *start, void *end)
>> +static inline int jump_label_text_reserved(const void *start, const void *end)
>>  {
>>  	return 0;
>>  }
>> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
>> index 60f48fa..6dc71c6 100644
>> --- a/kernel/jump_label.c
>> +++ b/kernel/jump_label.c
>> @@ -120,7 +120,8 @@ void jump_label_rate_limit(struct static_key_deferred *key,
>>  }
>>  EXPORT_SYMBOL_GPL(jump_label_rate_limit);
>>  
>> -static int addr_conflict(struct jump_entry *entry, void *start, void *end)
>> +static int addr_conflict(struct jump_entry *entry,
>> +				const void *start, const void *end)
>>  {
>>  	if (entry->code <= (unsigned long)end &&
>>  		entry->code + JUMP_LABEL_NOP_SIZE > (unsigned long)start)
>> @@ -130,7 +131,8 @@ static int addr_conflict(struct jump_entry *entry, void *start, void *end)
>>  }
>>  
>>  static int __jump_label_text_reserved(struct jump_entry *iter_start,
>> -		struct jump_entry *iter_stop, void *start, void *end)
>> +		struct jump_entry *iter_stop,
>> +		const void *start, const void *end)
>>  {
>>  	struct jump_entry *iter;
>>  
>> @@ -222,7 +224,7 @@ struct static_key_mod {
>>  	struct module *mod;
>>  };
>>  
>> -static int __jump_label_mod_text_reserved(void *start, void *end)
>> +static int __jump_label_mod_text_reserved(const void *start, const void *end)
>>  {
>>  	struct module *mod;
>>  
>> @@ -419,7 +421,7 @@ early_initcall(jump_label_init_module);
>>   *
>>   * returns 1 if there is an overlap, 0 otherwise
>>   */
>> -int jump_label_text_reserved(void *start, void *end)
>> +int jump_label_text_reserved(const void *start, const void *end)
>>  {
>>  	int ret = __jump_label_text_reserved(__start___jump_table,
>>  			__stop___jump_table, start, end);
>> -- 
>> 1.8.0.2
>>

