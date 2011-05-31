Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1EaJnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:43:47 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38009 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1EaJnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b3qol0pu3nBgJw2hErBDiDbSb7X1dasnZ7YFzhHQ0cKkVFhbpCV8zWBX+YrAgsEvYo
         or3V/bu0WT/2YknpnMUukCreYiURs2/d6SD9izYyqz9DEe+D4ARvOIYGyb3e/TVKwfxc
         Gj7Kyryn0mp+rL2yHa1tcAOIYLg9guAPa5ri8=
MIME-Version: 1.0
In-Reply-To: <4B858003-053B-4895-BAD7-71861AAFB00E@dilger.ca>
References: <1306763382-13817-1-git-send-email-akinobu.mita@gmail.com>
	<09010AAD-7443-4966-BF20-8580FBE8F389@dilger.ca>
	<20110530154357.GF2890@dhcp-172-31-194-241.cam.corp.google.com>
	<BANLkTimyCY9_tAOAtoxyNOw4=e+Y0pO_sw@mail.gmail.com>
	<7B5337F4-B0D7-48E1-8D1B-3669B37AA1D5@dilger.ca>
	<BANLkTin64T9-QEdE6DC6VoB=7d6m0qFcuQ@mail.gmail.com>
	<4B858003-053B-4895-BAD7-71861AAFB00E@dilger.ca>
Date: Tue, 31 May 2011 18:43:44 +0900
Message-ID: <BANLkTimnB5okiG_M9zhUG6F22PHPoAsZLw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ext4: use little-endian bitops directly
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: "Ted Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/31 Andreas Dilger <adilger@dilger.ca>:
> On 2011-05-30, at 9:45 PM, Akinobu Mita wrote:
>> 2011/5/31 Andreas Dilger <adilger@dilger.ca>:
>>> I would also encourage you to finish off this patch series by pushing up the generic ext2_{set,clear}_bit_atomic() to the few places that are currently using ext2_{set,clear}_bit_atomic() directly (looks like only fs/nilfs2/alloc.h and include/linux/ext3.h) and then removing them from the arch headers.
>>
>> The difficulty of doing this is that there are two different
>> implementations of ext2_{set,clear}_bit_atomic (spin lock version and
>> test_and_{set,clear}_bit_le version).  If we can switch to one of which
>> on all architectures, the change is easy.  But I don't have less messy idea
>> to keep current behavior on all architectures.
>
> It looks like all of the versions that are #defined in arch/*/asm/bitops.h are really just re-implementations of test_and_{set,clear}_bit_le(), since they ignore the "lock" parameter entirely.
>
> It would be sufficient to replace all of those implementations with:
>
> #define ARCH_NO_EXT2_ATOMIC_SPINLOCK
> #include <asm-generic/bitops/ext2-atomic.h>
>
> and then change the ext2-atomic.h to check for this:
>
> #ifdef ARCH_NO_EXT2_ATOMIC_SPINLOCK
> #define EXT2_SPIN_LOCK(lock)   do {} while(0)
> #define EXT2_SPIN_UNLOCK(lock) do {} while(0)
> #else
> #define EXT2_SPIN_LOCK(lock)   spin_lock(lock)
> #define EXT2_SPIN_UNLOCK(lock) spin_unlock(lock)
> #endif
>
> #define ext2_set_bit_atomic(lock, nr, addr)             \
>       ({                                              \
>               int ret;                                \
>               EXT2_SPIN_LOCK(lock);                   \
>               ret = __test_and_set_bit_le(nr, addr);  \
>               EXT2_SPIN_UNLOCK(lock);                 \
>               ret;                                    \
>       })

This is not equivalent change if ARCH_NO_EXT2_ATOMIC_SPINLOCK is defined
because ext2_set_bit_atomic for the majority of architectures is

#define ext2_set_bit_atomic(lock, nr, addr) \
        test_and_set_bit_le((nr), (unsigned long*)addr)

So ext2-atomic.h could be:

#ifdef ARCH_NO_EXT2_ATOMIC_SPINLOCK

#define ext2_set_bit_atomic(l, nr, addr)	test_and_set_bit_le(nr, addr)
#define ext2_clear_bit_atomic(l, nr, addr)	test_and_clear_bit_le(nr, addr)

#else

#define ext2_set_bit_atomic(lock, nr, addr)		\
	({						\
		int ret;				\
		spin_lock(lock);			\
		ret = __test_and_set_bit_le(nr, addr);	\
		spin_unlock(lock);			\
		ret;					\
	})

#define ext2_clear_bit_atomic(lock, nr, addr)		\
	({						\
		int ret;				\
		spin_lock(lock);			\
		ret = __test_and_clear_bit_le(nr, addr);	\
		spin_unlock(lock);			\
		ret;					\
	})

#endif
