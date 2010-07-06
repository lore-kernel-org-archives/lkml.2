Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab0GFHkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 03:40:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35498 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab0GFHkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 03:40:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZYoHqtamny1yWR5LeleTda7hxH+0JwvbluCdU27Mb1DDR77iFBrbLy/D8M3PM5siMJ
         8lgxcB+2yM2mQH11NeX30m+Tqq4QNpN1nijhVGuUq+hBMVjohLmW2ZQ4OKKydiE84LLJ
         jAJT5WEyqXcJfQ1tNPbARFMP9v80JTkEs0qQU=
MIME-Version: 1.0
In-Reply-To: <20100706054406.GR10072@secunet.com>
References: <AANLkTikeDE4hvZ3spyTBSHZsdQPc-2wlD5nTfb1aF-VD@mail.gmail.com>
	<20100702085323.GF10072@secunet.com>
	<AANLkTinyPGjXjlvJxB8WYB3EYFBtANXMzpTdUixyBRHW@mail.gmail.com>
	<20100702091726.GH10072@secunet.com>
	<AANLkTiltuZTkG5ZoG4TG9fA0anwRLFa__lHLnZpY2n4U@mail.gmail.com>
	<20100702111138.GI10072@secunet.com>
	<AANLkTimEgKGJ5pi7GzOnvP42ivJ4GCKX59LdKK0x4fnx@mail.gmail.com>
	<20100706053612.GQ10072@secunet.com>
	<20100706054406.GR10072@secunet.com>
Date: Tue, 6 Jul 2010 11:40:11 +0400
X-Google-Sender-Auth: vZ082nAVh4AotROHtE3yWPjXg8o
Message-ID: <AANLkTil4pbOOVvhIKN1_sI8kNdBFFebMVEGEmqrb45YR@mail.gmail.com>
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

On Tue, Jul 6, 2010 at 9:44 AM, Steffen Klassert
<steffen.klassert@secunet.com> wrote:
> You removed everyone in the Cc, please don't do this unless you have
> good reason for that. I've added the Cc'ed people again, perhaps
> somebody has an opinion on this too.

Oh, I'm sorry I didn't notice.

>
> On Tue, Jul 06, 2010 at 07:36:12AM +0200, Steffen Klassert wrote:
>> On Mon, Jul 05, 2010 at 06:09:17PM +0400, Dan Kruchinin wrote:
>> >
>> > I tried to implement RCU protection on cpumask, but it appears a bit
>> > ugly because we can not safely assign cpumask_var_t(that is allocated
>> > via alloc_cpumask_var) to struct cpumask* via rcu_assign_pointer. The
>> > root of problem lies in cpumask_var_t definition. Depending on
>> > CONFIG_CPUMASK_OFFSTACK macro it may be a local variable on the stack
>> > or a pointer to struct cpumask:
>> > #ifdef CONFIG_CPUMASK_OFFSTACK
>> > typedef struct cpumask *cpumask_var_t
>> > ...
>> > #else
>> > typedef struct cpumask cpumask_var_t[1];
>> > ...
>> > #endif
>>
>> Hm, yes dealing with cpumasks is a bit special these days.
>>
>> >
>> > In this case rcu_assign_pointer may be safely used only if we deal
>> > with a pointer to cpumask_var_t that must be allocated via kmalloc
>> > before using alloc_cpumask_var and rcu_assign_pointer. I think it's -
>> > as I said earlier - a bit ugly and hard to read.
>> > My be it's better to use rw spinlock instead? In our situation it
>> > doesn't significantly differ from RCU. Also it'll make code more clear
>> > and easy to read.
>> >
>>
>> I think we can use RCU anyway. For instance we could use a structure
>>
>> struct pcrypt_cpumask {
>>       cpumask_var_t           pmask;
>>       cpumask_var_t           smask;
>> };
>>
>> and add a pointer to a structure of that type to the instance context.
>> Then we could use this pointer for RCU and replace the whole structure
>> if a cpumask changes.

But is pcrypt interested pmask? If it isn't, pmask field will be unused.

>>
>>
>



-- 
W.B.R.
Dan Kruchinin
