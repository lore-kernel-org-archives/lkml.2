Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab1FFVbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:31:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64632 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1FFVba convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=ohJaw/vQz/fcVYj2tuK7MX3C9m85RDGMYOnyGhGFLEgUcz75XXxMEeA8WEzk3ak7B4
         X0Lp4VL0BBWjq7m2UJ80O9GeRBYJOy6xadVo6FT5FVfO5ikE6rPPrJAH6SuXnFICeUoN
         qQGwKXnh3uVNlBAToC4CLO7qGGHsu5vguH0XE=
MIME-Version: 1.0
In-Reply-To: <20110606142301.c0a570da.akpm@linux-foundation.org>
References: <1306725568-10922-1-git-send-email-vapier@gentoo.org> <20110606142301.c0a570da.akpm@linux-foundation.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 6 Jun 2011 17:31:08 -0400
X-Google-Sender-Auth: bAMFV1BSp_8tfejEc-EwSaWRVpQ
Message-ID: <BANLkTikq5-a8a5A4iq=3Br-m+PhuKYSePA@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH/RFC] asm-generic/mutex-dec.h: add SMP support
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, Piggin <npiggin@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Nick@blackfin.uclinux.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 17:23, Andrew Morton wrote:
> On Sun, 29 May 2011 23:19:28 -0400 Mike Frysinger wrote:
>> To make these guys work on SMP systems, we just need to sprinkle a few
>> barriers around.
>>
>> diff --git a/include/asm-generic/mutex-dec.h b/include/asm-generic/mutex-dec.h
>> index f104af7..e746c3c 100644
>> --- a/include/asm-generic/mutex-dec.h
>> +++ b/include/asm-generic/mutex-dec.h
>> @@ -22,6 +22,8 @@ __mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
>>  {
>>       if (unlikely(atomic_dec_return(count) < 0))
>>               fail_fn(count);
>> +     else
>> +             smp_mb();
>>  }
>>
>>  /**
>> @@ -39,6 +41,7 @@ __mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
>>  {
>>       if (unlikely(atomic_dec_return(count) < 0))
>>               return fail_fn(count);
>> +     smp_mb();
>>       return 0;
>>  }
>>
>> @@ -58,6 +61,7 @@ __mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
>>  static inline void
>>  __mutex_fastpath_unlock(atomic_t *count, void (*fail_fn)(atomic_t *))
>>  {
>> +     smp_mb();
>>       if (unlikely(atomic_inc_return(count) <= 0))
>>               fail_fn(count);
>>  }
>> @@ -82,8 +86,10 @@ __mutex_fastpath_unlock(atomic_t *count, void (*fail_fn)(atomic_t *))
>>  static inline int
>>  __mutex_fastpath_trylock(atomic_t *count, int (*fail_fn)(atomic_t *))
>>  {
>> -     if (likely(atomic_cmpxchg(count, 1, 0) == 1))
>> +     if (likely(atomic_cmpxchg(count, 1, 0) == 1)) {
>> +             smp_mb();
>>               return 1;
>> +     }
>>       return 0;
>>  }
>
> This patch basically reverts Nick's a8ddac7e53e89cb ("mutex: speed up
> generic mutex implementations").  What's up with that?
>
> I could try to review this patch but I'm pathetic with barriers.  Help.

thanks for that tip.  i think we can chalk this patch up to the
origins of the Blackfin SMP port ... it branched this code before
Nick's patch, and never incorporated common changes back.  so i'll
just drop it once i boot up a system to double check and convert the
Blackfin code over to the asm-generic version completely to avoid
future issues.
-mike
