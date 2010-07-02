Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab0GBJcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:32:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55426 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab0GBJcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:32:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oSrpWqnPd9g1MGyJ1lFYT5qPbCrJxx4RXRGloGAwOT3FCS5//6ShtuPKkd+NDDVGS6
         e1bpK5JxB6p2Erx+dgYG2aa31ejFt/3N5/F5LDW3bt9czHgYfQB7o+XFXBKM49sxzKZQ
         gkMmjXtTGHEdP6QlFYiGLDRFfkXe9hmdrSJYk=
MIME-Version: 1.0
In-Reply-To: <20100702091726.GH10072@secunet.com>
References: <AANLkTikeDE4hvZ3spyTBSHZsdQPc-2wlD5nTfb1aF-VD@mail.gmail.com>
	<20100702085323.GF10072@secunet.com>
	<AANLkTinyPGjXjlvJxB8WYB3EYFBtANXMzpTdUixyBRHW@mail.gmail.com>
	<20100702091726.GH10072@secunet.com>
Date: Fri, 2 Jul 2010 13:32:29 +0400
Message-ID: <AANLkTiltuZTkG5ZoG4TG9fA0anwRLFa__lHLnZpY2n4U@mail.gmail.com>
Subject: Re: [PATCH 1/3] padata: separate serial and parallel cpumasks
From: Dan Kruchinin <dan.kruchinin@gmail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 1:17 PM, Steffen Klassert
<steffen.klassert@secunet.com> wrote:
> On Fri, Jul 02, 2010 at 01:07:44PM +0400, Dan Kruchinin wrote:
>> >
>> > The above is not save against cpu hotplug. You initialize ctx->cb_cpu
>> > to -1 when the transformation is initialized. So you choose your
>> > callback cpu with the first call to pcrypt_do_parallel() and then never
>> > again. What if the coosen callback cpu goes offline?
>> >
>> > Also I don't understand why you changed the prototype of pcrypt_do_parallel
>> > and added a 'count' to pcrypt_aead_ctx. The only change you have to do, is
>> > to
>> > check whether the choosen callback cpu is still in the cpu_active_mask
>> > _and_
>> > in your new padata callback cpumask and update the callback cpu accordingly
>> > if not. Checking whether the callback cpu is in the callback cpumask needs
>> > some special care in your other patch of course, because you can change
>> > this
>> > cpumask from userspace then.
>> >
>>
>> Well, my point was to reduce the code and select callback CPU only once
>> according to
>> serial cpumask of given data instance. In case when  I modify serial cpumask
>> of given padata
>> instance I have to do callback cpu calculation twice in worst case. The
>> first time in pcrypt_aead_init_tfm
>> and the second time in pcrypt_do_parallel if cb_cpu is not set in my serial
>> cpumask.
>> So I decided to do it only once in pcrypt_do_parallel.
>>
>
> But the active cpumask, and now also your serial cpumask might change.
> We need to catch this changes somehow, that's why I checked the active
> cpumask against the callback cpu.

You're right, now I get it. Hence the right solution is to check if
callback CPU is set in serial cpumask every time we do
padata_do_serial and if it's not, recalculate its value.
The only thing that embarrasses me in this scheme is the fact that we
have to allocate cpumask_var_t in pcrypt_do_parallel every time we
call it then copy serial cpumask into allocated one and then check the
cb_cpu.
I think it would be better if we somehow could avoid dynamic cpumask
allocation. I see the following solutions:

1) Do the check and cb_cpu value recalculation in padata_do_parallel.
It may check if cb_cpu is in serial_cpumask and recalculate its value
if it isn't. The drawback of this scheme is that padata_do_parallel
now doesn't guaranty it will forward serialization job to the same
callback CPU we passed to it. If passed CPU is not in serial cpumask
it will forward serialization to another CPU and we won't know its
number. The only thing we'll know is that this CPU is in the
serial_cpumask.
2) Create new structure describing pcrypt instance in pcrypt.c which
will include waitqueue, padata instance and preallocated cpumask which
will be used for getting padata instance serial cpumsak. It'll help to
avoid dynamic cpumask allocation but it looks a bit awkward.

>
> Steffen
>
>



-- 
W.B.R.
Dan Kruchinin
