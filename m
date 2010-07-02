Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab0GBNBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 09:01:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39326 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758535Ab0GBNB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 09:01:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aIZynCFgYz4FuWdv6nYi5bUacG/061xjI+omTytqlmEJt5VgRYjQmcKbhN2kNNQQuE
         88XZzQac4Ce841pDdNZpgZKNorVweuIX2R4BU/e+vv54H//vmBfVUQnO5d6jiGWDJR07
         I90IcfGiM2Q/sCSZHfKXDNGQ86xdOOKkHg5Os=
MIME-Version: 1.0
In-Reply-To: <20100702111138.GI10072@secunet.com>
References: <AANLkTikeDE4hvZ3spyTBSHZsdQPc-2wlD5nTfb1aF-VD@mail.gmail.com>
	<20100702085323.GF10072@secunet.com>
	<AANLkTinyPGjXjlvJxB8WYB3EYFBtANXMzpTdUixyBRHW@mail.gmail.com>
	<20100702091726.GH10072@secunet.com>
	<AANLkTiltuZTkG5ZoG4TG9fA0anwRLFa__lHLnZpY2n4U@mail.gmail.com>
	<20100702111138.GI10072@secunet.com>
Date: Fri, 2 Jul 2010 17:01:28 +0400
Message-ID: <AANLkTil3pa-WKRKo3IQzgxkKc0I5qs5UPpgpiNiKlVBO@mail.gmail.com>
Subject: Re: [PATCH 1/3] padata: separate serial and parallel cpumasks
From: Dan Kruchinin <dan.kruchinin@gmail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 3:11 PM, Steffen Klassert
<steffen.klassert@secunet.com> wrote:
> On Fri, Jul 02, 2010 at 01:32:29PM +0400, Dan Kruchinin wrote:
>> >
>> > But the active cpumask, and now also your serial cpumask might change.
>> > We need to catch this changes somehow, that's why I checked the active
>> > cpumask against the callback cpu.
>>
>> You're right, now I get it. Hence the right solution is to check if
>> callback CPU is set in serial cpumask every time we do
>> padata_do_serial and if it's not, recalculate its value.
>> The only thing that embarrasses me in this scheme is the fact that we
>> have to allocate cpumask_var_t in pcrypt_do_parallel every time we
>> call it then copy serial cpumask into allocated one and then check the
>> cb_cpu.
>> I think it would be better if we somehow could avoid dynamic cpumask
>> allocation. I see the following solutions:
>>
>> 1) Do the check and cb_cpu value recalculation in padata_do_parallel.
>> It may check if cb_cpu is in serial_cpumask and recalculate its value
>> if it isn't. The drawback of this scheme is that padata_do_parallel
>> now doesn't guaranty it will forward serialization job to the same
>> callback CPU we passed to it. If passed CPU is not in serial cpumask
>> it will forward serialization to another CPU and we won't know its
>> number. The only thing we'll know is that this CPU is in the
>> serial_cpumask.
>> 2) Create new structure describing pcrypt instance in pcrypt.c which
>> will include waitqueue, padata instance and preallocated cpumask which
>> will be used for getting padata instance serial cpumsak. It'll help to
>> avoid dynamic cpumask allocation but it looks a bit awkward.
>>
>
> I think the cleanest way to do it, is to maintain notifier chains
> for parallel/serial cpumask changes in padata. Users can register to
> these notifier chains if they are interestet in these events.
> pcrypt is probaply just in changes of the serial cpumsk interested,
> so you could alloc and initialize such a cpumask in pcrypt_aead_init_tfm
> and add a pointer to it to pcrypt_aead_ctx.
> Then you could update the cpumask with the notifier callback function.
> cpumask changes are rare and slow anyway, so copying the cpumask there does
> not matter that much. Since cpumask changes are rare, you can protect
> pcrypt_do_parallel with RCU against cpumask changes.

Sounds good. But if I understand linux crypto framework right, it
calls init_tfm every time it creates new security association. Ideally
pcrypt should have only two cpumasks one for pencrypt instance and
another for pdecrypt.
If we'll initialize these cpumasks in pcrypt_alloc_tfm they'll be
initialized every time new SA appears.
>
> Steffen
>



-- 
W.B.R.
Dan Kruchinin
