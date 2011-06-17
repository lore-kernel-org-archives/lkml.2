Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab1FQTH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 15:07:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61772 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435Ab1FQTHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 15:07:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GORU8i0a767u6/vRSGQrcpHJlmyF3uMrYeDHA6iZVbrZ9H/YXBDTtWtX3n/18nVtV7
         x9DMCAwtCTSyg/BAjXCqyY0SleWK8yj+A33qgmUbGlA4Eg7ZiiTKbEF2/MfXRxamoPYi
         JEH7iNQJxAcaBwgqT6YdXfrhbIFVs12/DWhJc=
MIME-Version: 1.0
In-Reply-To: <4DFBA001.4010500@fb.com>
References: <20110615163115.773d072e.akpm@linux-foundation.org>
 <1308187784-3815-1-git-send-email-asharma@fb.com> <BANLkTi=f2N+dO2nBLobM73jCg0U0QSqxNQ@mail.gmail.com>
 <4DFB8AAF.1040002@fb.com> <BANLkTindmEA7NsaRjuukh1-oRCtVWpeuCA@mail.gmail.com>
 <4DFB93C1.9000901@fb.com> <BANLkTim5zEo=Rn2sqUExL-8n=p4inLEpuQ@mail.gmail.com>
 <4DFBA001.4010500@fb.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 17 Jun 2011 15:07:04 -0400
Message-ID: <BANLkTinQhBfAJd5-ZaPXbiV778c9fvXeWg@mail.gmail.com>
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

On Fri, Jun 17, 2011 at 14:42, Arun Sharma wrote:
> On 6/17/11 11:06 AM, Mike Frysinger wrote:
>> fixes one thing while breaking another.  linux/atomic.h includes
>> asm/atomic.h which includes asm-generic/atomic.h which includes
>> asm-generic/atomic-long.h which needs atomic_add_unless(), but that
>> isnt provided until after the asm/atomic.h include in linux/atomic.h.
>>
>> but linux/atomic.h needs asm/atomic.h before atomic_add_unless()
>> because it relies on the new __atomic_add_unless().
>
> Right. I think we need to get rid of that include as well:

ok, then we get to your proposed asm-generic/atomic.h change not being
correct.  instead of deleting atomic_add_unless(), it probably should
redo it to __atomic_add_unless().  people using asm-generic/atomic.h
are not defining __atomic_add_unless() themselves.

  CC      arch/blackfin/kernel/asm-offsets.s
In file included from include/linux/spinlock.h:387,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:57,
                 from arch/blackfin/kernel/asm-offsets.c:10:
include/linux/atomic.h: In function ‘atomic_add_unless’:
include/linux/atomic.h:17: error: implicit declaration of function
‘__atomic_add_unless’
make[1]: *** [arch/blackfin/kernel/asm-offsets.s] Error 1

>> having linux/atomic.h and asm-generic/atomic.h just strikes me as
>> wrong.  the point of asm-generic is to unify things, but now we have
>> two places to unify things without 0 indication as to which is for
>> which ?  i'm wondering if we shouldnt convert all arches to
>> asm-generic/atomic.h and then add your new logic there and just skip
>> this whole linux/atomic.h mess.
>
> I believe the logic is:
>
> <asm-generic/atomic.h> shared code for simple archs that don't want to
> define their own primitives. Only used by 4 archs.

i think the 4 is only really because asm-generic/atomic.h is so new.
those arches are also new and started with it, or did work to convert
over.  i imagine a lot of the existing arches could convert over to
it.

> <linux/atomic.h> a header file that's usable in machine independent kernel
> code.

if that's the direction we want to take things, then this needs to be
documented at the top of both files.  i also see quite a lot of
primitives in asm-generic/atomic.h that would be better placed using
your definitions in linux/atomic.h.

i would refine your asm-generic/atomic.h definition as "simple C
definitions useful for UP systems only"

> My guess is that if <linux/atomic.h> existed in 2006, people would've added
> shared code over there.

i'd propose that the guy adding linux/atomic.h was lazy and punked out
rather than doing real work

> Also, the code in <asm-generic/atomic.h> is not truly generic:

sure it is.  it'll work on any arch in a UP setup.  it (currently)
does not support SMP by design.
-mike
