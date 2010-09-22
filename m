Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab0IVL4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 07:56:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35344 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0IVL4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 07:56:49 -0400
Message-ID: <4a8f3ad8416ed61cba1746883da1f839.squirrel@www.firstfloor.org>
In-Reply-To: <20100922113114.GA14179@Krystal>
References: <1285150102-5506-1-git-send-email-andi@firstfloor.org>
    <1285150102-5506-2-git-send-email-andi@firstfloor.org>
    <20100922113114.GA14179@Krystal>
Date: Wed, 22 Sep 2010 13:56:48 +0200
Subject: Re: [PATCH 2/2] Rewrite jump_label.c to use binary search
From: "Andi Kleen" <andi@firstfloor.org>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Cc: "Andi Kleen" <andi@firstfloor.org>, jbaron@redhat.com,
        rusty@rustcorp.co.au, rostedt@goodmis.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
        tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, "Andi Kleen" <ak@linux.intel.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for the review.

> If you really want to sort this table, then you should move it from
> RODATA to DATA. I just looked at the bug table: it does not seem to be
> sorted, so for that one it looks fine to leave it into RODATA.

FWIW  the table was already sorted before, i didn't actually
change that code except for writing it a bit more cleanly.

But you're right. If it's rodata it could fault. Normally
it shouldn't be though because the loader has to relocate it
for modules. I didn't test with rodata enabled, but will see
what happens. Maybe this happens at the right place that
it doesn't matter.

I suspect the original version had the same problem
if this one has.


> Ideally we'd like to do this sorting at a post-compilation stage, so we
> can leave the section RODATA.

That's complicated because you would need to fix relocations too.
I guess doing that would need to put significant parts of a linker
into modpost. Since the goal of this was to reduce complexity ...

This is patterned after the exception tables which always were
sorted at runtime, which is much easier.

Besides I don't see a lot of value of having this rodata

>
>>  }
>>
>> -static struct jump_label_entry *get_jump_label_entry(jump_label_t key)
>> +static struct jump_entry *
>> +search_jump_table(struct jump_entry *first, struct jump_entry *last,
>> +		  unsigned long key)
>>  {
>> -	struct hlist_head *head;
>> -	struct hlist_node *node;
>> -	struct jump_label_entry *e;
>> -	u32 hash = jhash((void *)&key, sizeof(jump_label_t), 0);
>> -
>> -	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
>> -	hlist_for_each_entry(e, node, head, hlist) {
>> -		if (key == e->key)
>> -			return e;
>> +	while (first <= last) {
>
> There seems to be a mismatch between the caller and this function. The
> module patch_jump_table() caller passes first and first + len, while
> this expects first and last. This looks a little off by one to me.

True. Will fix that.


>> +	for (; entry < stop && entry->key == key; entry++)
>> +		if (kernel_text_address(entry->code))
>
> This does not work for modules I'm afraid, only for the core kernel. You
> should test for __module_text_address() somewhere.

I thought it was shared now, but ok.

> Dumb question: why do you need this test at all ?

I just copied that from the original code. In fact I was wondering
too why it's needed. Jason?


>> -	}
>> +	patch_jump_table(key, type, __start___jump_table,
>> __stop___jump_table);
>> +	for_each_module(module_patch_jump_table, &args);
>
> Can we have a for_each_module that keeps preemption on ? Calling
> arch_jump_label_transform() with preemption off is wrong, as it locks
> the text_mutex and get/put online cpus, not to mention that
> text_poke_smp() is probably still based on stop_machine().
>
> Maybe we could stick a synchronize_rcu() in module delete and use a
> proper RCU read-side C.S. in for_each_module ?

Hmpf. Ok I didn't read that code.

I guess could just take the module mutex or whatever it's called
during the walk.

Copying Rusty, maybe he has ideas how to handle this.


>> -		return 1;
>> +	struct jump_entry *entry;
>>
>> +	for (entry = jstart; entry < jstop; entry++)
>> +		if (entry->code <= (unsigned long)start &&
>
> start -> end ?

I copied this from the original code too. I remember stumbling
over it too. Yes it was probably wrong in the original too.

>
>> +		entry->code + JUMP_LABEL_NOP_SIZE > (unsigned long)start)
>
> Maybe it's my mail client, but indentation looks wrong here.

All the horrors you do for the holy 80 columns.


>>
>> -#ifdef CONFIG_MODULES
>
> Why make it build when modules are configured out ?

Because it's shared code for the module and non module case.


>> +	args.conflict = check_conflict(__start___jump_table,
>> +				       __stop___jump_table, start, end);
>>  	/* now check modules */
>>  #ifdef CONFIG_MODULES
>
> ifdef could be removed from within this function body by replacing it
> with a #ifdef CONFIG_MODULES #else #endif that defines an empty static
> inline when disabled. Also for_each_module for be defined as an empty
> static inline when modules are disabled.

It could yes, but really a single clean #ifdef is imho fine
and much simpler.

-Andi


