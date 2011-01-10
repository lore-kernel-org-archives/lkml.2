Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab1AJWAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:00:42 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59967 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab1AJWAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:00:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uHj0l9OvhFHxtmi2pB5wtxFeeYmVXcbU4+LjUu+71GSs8KiA0VTHEh6TNNljqdvHgW
         roMxPV+PSn+7yPbe7KtfSNxSNSuABAJs5dpgoOS4h68Udfuwatv3Lkr4c7iTrDpol8Lu
         CcGUAxrdKlmfgo5YDQ+ZvBN1JlgJx5c30oHzA=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1101101232580.11969@chino.kir.corp.google.com>
References: <20110110181133.14995.12364.stgit@e102109-lin.cambridge.arm.com>
	<alpine.DEB.2.00.1101101232580.11969@chino.kir.corp.google.com>
Date: Mon, 10 Jan 2011 22:00:39 +0000
X-Google-Sender-Auth: LmzK4Ya5LYCecdlwh2vT7A_QIJo
Message-ID: <AANLkTik-NwSioPg96EFUDzuK=zK0kNbvUeQbt0rwQAtX@mail.gmail.com>
Subject: Re: [PATCH] kmemleak: Reduce verbosity when memory allocation fails
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Rientjes <rientjes@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>, "Ted Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 10 January 2011, David Rientjes <rientjes@google.com> wrote:
> On Mon, 10 Jan 2011, Catalin Marinas wrote:
>
>> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
>> index bd9bc21..eee8e31 100644
>> --- a/mm/kmemleak.c
>> +++ b/mm/kmemleak.c
>> @@ -113,7 +113,8 @@
>>  #define BYTES_PER_POINTER    sizeof(void *)
>>
>>  /* GFP bitmask for kmemleak internal allocations */
>> -#define GFP_KMEMLEAK_MASK    (GFP_KERNEL | GFP_ATOMIC)
>> +#define gfp_kmemleak_mask(gfp)       ((gfp) & (GFP_KERNEL | GFP_ATOMIC) | \
>> +                              __GFP_NOWARN)
>
> It would be a shame if the allocation were __GFP_NORETRY and kmemleak
> ended up looping forever because it suppresses the bit for a single page,
> it uses __GFP_NOMEMALLOC and kmemleak ends up allocating from memory
> reserves, or it uses __GFP_HARDWALL and kmemleak is allocating metadata in
> a different cpuset.
>
> I'm not sure why you're not just masking __GFP_NOFAIL and __GFP_REPEAT and
> then failing gracefully?  (And __GFP_ZERO and __GFP_COMP, too, of course.)

The reason I wouldn't allow kmemleak allocations to fail is that once
it happened kmemleak cannot recover. Once it missed an allocation for
its metadata, the corresponding memory block cannot be tracked nor
scanned leading to false positives. I had thought about even passing
__GFP_REPEAT but I think this is kind of implied for 0-order
allocations.

If the user calling the kernel alloc function cannot get memory,
kmemleak won't be called anyway.

-- 
Catalin
