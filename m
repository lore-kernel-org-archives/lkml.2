Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab1FQSGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 14:06:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38789 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab1FQSGf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 14:06:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=G6TkC12WZ3ot1AHpJKMPU6HTy72i91tIEk44DrBu3h2+H+AD+m7PBlOPNE9dylj0S0
         cr0fbfRRDE+MpO9ivcQsN6hhYfcSa1+CmRGf+xe+lDjo4QadtdNFHThyV1V/EFINrqV9
         iHOaam+rwB5Cp+pqSIibI+bXQ5iu0taTI4/C0=
MIME-Version: 1.0
In-Reply-To: <4DFB93C1.9000901@fb.com>
References: <20110615163115.773d072e.akpm@linux-foundation.org>
 <1308187784-3815-1-git-send-email-asharma@fb.com> <BANLkTi=f2N+dO2nBLobM73jCg0U0QSqxNQ@mail.gmail.com>
 <4DFB8AAF.1040002@fb.com> <BANLkTindmEA7NsaRjuukh1-oRCtVWpeuCA@mail.gmail.com>
 <4DFB93C1.9000901@fb.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 17 Jun 2011 14:06:14 -0400
Message-ID: <BANLkTim5zEo=Rn2sqUExL-8n=p4inLEpuQ@mail.gmail.com>
Subject: Re: [PATCH] atomic: cleanup asm-generic atomic*.h inclusion
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 13:49, Arun Sharma wrote:
> On 6/17/11 10:28 AM, Mike Frysinger wrote:
>> On Fri, Jun 17, 2011 at 13:11, Arun Sharma wrote:
>>> On 6/16/11 11:36 PM, Mike Frysinger wrote:
>>>>
>>>> i'm not sure this doesnt break things.  what tree exactly should i
>>>> apply this patch to to verify things ?
>>>
>>> I tested 3.0-rc2 + patch 1 + patch 2 + this patch.
>>
>> not sure what those patches are, so i picked at random:
>> Subject: [PATCH 2/3] atomic: move atomic_add_unless to generic code
>> Date: Tue,  7 Jun 2011 17:07:18 -0700
>> Message-Id:<1307491639-9864-2-git-send-email-asharma@fb.com>
>>
>> Subject: [PATCH 1/3] atomic: use<linux/atomic.h>
>> Date:   Mon,  6 Jun 2011 10:27:29 -0700
>> Message-Id:<1307381251-15729-1-git-send-email-asharma@fb.com>
>
> Yes - these are the right patches.
>
>>
>> but even after just these two, things fail because
>> include/asm-generic/atomic.h provides atomic_add_unless() already.
>> i'm guessing your patch 2/3 should have fixed that somehow since it
>> adds the func to linux/atomic.h.
>
> Thanks for catching this. I missed it because I tested only on i386 and
> x86_64. Looks like only 4 archs are affected:
>
> $ grep -r asm-generic.atomic.h *
> blackfin/include/asm/atomic.h:# include <asm-generic/atomic.h>
> microblaze/include/asm/atomic.h:#include <asm-generic/atomic.h>
> mn10300/include/asm/atomic.h:#include <asm-generic/atomic.h>
> score/include/asm/atomic.h:#include <asm-generic/atomic.h>
>
> I believe the correct fix is:
>
> --- a/include/asm-generic/atomic.h
> +++ b/include/asm-generic/atomic.h
> @@ -129,17 +129,6 @@ static inline void atomic_dec(atomic_t *v)
>
>  #define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o),
> (n))
>
> -static inline int atomic_add_unless(atomic_t *v, int a, int u)
> -{
> -  int c, old;
> -  c = atomic_read(v);
> -  while (c != u && (old = atomic_cmpxchg(v, c, c + a)) != c)
> -    c = old;
> -  return c != u;
> -}
> -
> -#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
> -
>  static inline void atomic_clear_mask(unsigned long mask, unsigned long
> *addr)
>  {
>        unsigned long flags;
>
> Could you help test this? I'll resend the patch series once I get
> confirmation.

fixes one thing while breaking another.  linux/atomic.h includes
asm/atomic.h which includes asm-generic/atomic.h which includes
asm-generic/atomic-long.h which needs atomic_add_unless(), but that
isnt provided until after the asm/atomic.h include in linux/atomic.h.

but linux/atomic.h needs asm/atomic.h before atomic_add_unless()
because it relies on the new __atomic_add_unless().

having linux/atomic.h and asm-generic/atomic.h just strikes me as
wrong.  the point of asm-generic is to unify things, but now we have
two places to unify things without 0 indication as to which is for
which ?  i'm wondering if we shouldnt convert all arches to
asm-generic/atomic.h and then add your new logic there and just skip
this whole linux/atomic.h mess.
-mike
