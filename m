Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0GFQao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 12:30:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56655 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab0GFQam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 12:30:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GV1kA/RZfSX1d/KLOV9UpQ/kQ9FMJo8VT/d/q0byDROMsDNj06SbN+vD44Ja5coBuw
         zwYLhUGQYd8deYbgQf4kjhpmjgij6XxHq9kvnP1Hin9vTeHMFcxvKf9K0yQjK/9kYjZJ
         LOsdR9wfMfU7l5X+9JnwX5/I68KTfTogVgAKM=
MIME-Version: 1.0
In-Reply-To: <20100706132825.GT10072@secunet.com>
References: <AANLkTinyPGjXjlvJxB8WYB3EYFBtANXMzpTdUixyBRHW@mail.gmail.com>
	<20100702091726.GH10072@secunet.com>
	<AANLkTiltuZTkG5ZoG4TG9fA0anwRLFa__lHLnZpY2n4U@mail.gmail.com>
	<20100702111138.GI10072@secunet.com>
	<AANLkTimEgKGJ5pi7GzOnvP42ivJ4GCKX59LdKK0x4fnx@mail.gmail.com>
	<20100706053612.GQ10072@secunet.com>
	<20100706054406.GR10072@secunet.com>
	<AANLkTil4pbOOVvhIKN1_sI8kNdBFFebMVEGEmqrb45YR@mail.gmail.com>
	<20100706074641.GS10072@secunet.com>
	<AANLkTimYK_4PcVrAniOE3pQjgYNwYNjI6q8p1FMZntEa@mail.gmail.com>
	<20100706132825.GT10072@secunet.com>
Date: Tue, 6 Jul 2010 20:30:40 +0400
X-Google-Sender-Auth: y53JmrV4EHG7sliKDIUry6ZlUGw
Message-ID: <AANLkTilNz3YWxTaUSE3TBm-Q-ZCUaV72o6jJCh77bRH0@mail.gmail.com>
Subject: Re: [PATCH 1/3] padata: separate serial and parallel cpumasks
From: Dan Kruchinin <dkruchinin@acm.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 6, 2010 at 5:28 PM, Steffen Klassert
<steffen.klassert@secunet.com> wrote:
> On Tue, Jul 06, 2010 at 12:31:21PM +0400, Dan Kruchinin wrote:
>>
>> Would't it be the same as with a pointer to cpumask_var_t? I mean:
>
> Using a pointer to cpumask_var_t is a bit problematic because
> you don't know a priori about the type of cpumask_var_t.
> The type depends whether the cpumasks are on/off stack.
> So the easiest thing is to embed it to a struct, then you don't
> need to care about the type. If you allocate a struct of type
> pcrypt_cpumask you get what you want to have.

Oh, I meant pointer to pointer of course. Anyway you're probably right.
I modified my patches according to the results of our discussion. So
I'm waiting for your fixes.

>
>> struct pcrypt {
>>   ...
>>   struct pcrypt_cpumask *mask;
>>   ...
>> } pencrypt;
>>
>> To assign a pointer via RCU:
>>
>> int cpumask_change_nitify(...) {
>>    ...
>>   struct pcrypt_cpumask *new_mask = kmalloc(sizeof(*mask), GFP);
>>   struct pcrypt_cpumask *old_mask = pencrypt.mask;
>>
>>   if (!new_mask)
>>      error();
>>   if (!alloc_cpumask_var(&new_mask->smask, GFP_KERNEL))
>>      error();
>>
>>   get_serial_cpumask_from_padata(new_mask->mask);
>>   rcu_assign_pointer(pencrypt.mask, new_mask);
>>   synchronize_rcu_bh();
>>
>>   free_cpumask_var(old_mask->smask);
>>   kfree(old_mask);
>>   ...
>> }
>>
>> It's a bit hard to read this code because at the first sight it
>> appears unclear and odd why we allocate the structure with only one
>> member.
>>
>
> We can easily add a code comment if this appears to be unclear :)
>



-- 
W.B.R.
Dan Kruchinin
