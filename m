Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab2CGLz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:55:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58689 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2CGLz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:55:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alex Shi <alex.shi@intel.com>
Subject: Re: [RFC patch] spindep: add cross cache lines checking
Date: Wed, 7 Mar 2012 11:54:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: gcc@gcc.gnu.org, Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
        "mingo@redhat.com" <mingo@redhat.com>, hpa@zytor.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, andi.kleen@intel.com, gcc-help@gcc.gnu.org
References: <1330917630.18835.44.camel@debian> <201203060932.45223.arnd@arndb.de> <1331108607.18835.343.camel@debian>
In-Reply-To: <1331108607.18835.343.camel@debian>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203071154.36059.arnd@arndb.de>
X-Provags-ID: V02:K0:p8483ffIImvh+93DEzGOChRs89MU4DQ5SU94P0QSaNz
 ZvWBLIgebjnGK0+MHh3p8/NleH0bD/imBp/stKX+yspLOhSYT3
 9tJpe45jJsdPYSPMw+QFfbkybIKgkD20L66ivQIviPqgUJl0x8
 YjvSVrp4gdL+08RBwszszaJyelEx/NYUxUqHnMH3x8EqW2Gmqt
 WcYjE9oPM9APuHk4l6RcIod0O7w0OOxYXMQhiZ+LtoNh3F8pP5
 UqzKPaHiMuC2nyauqd3zlXJ6Uf9gHQyFXeapetfuQfdWuBvNL0
 JBZSw80ttChEdkJtmNcIWHkaMEos6uUW3jEYHAvN5OqidJEJmd
 UqdaEndEdTkeZgbnM+Wo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 March 2012, Alex Shi wrote:

> Understand. thx. So is the following checking that your wanted?
> ===
> diff --git a/include/linux/rwlock.h b/include/linux/rwlock.h
> index bc2994e..64828a3 100644
> --- a/include/linux/rwlock.h
> +++ b/include/linux/rwlock.h
> @@ -21,10 +21,12 @@
>  do {								\
>  	static struct lock_class_key __key;			\
>  								\
> +	BUILD_BUG_ON(__alignof__(lock) == 1);			\
>  	__rwlock_init((lock), #lock, &__key);			\
>  } while (0)
>  #else
>  # define rwlock_init(lock)					\
> +	BUILD_BUG_ON(__alignof__(lock) == 1);			\
>  	do { *(lock) = __RW_LOCK_UNLOCKED(lock); } while (0)
>  #endif

I think the check should be (__alignof__(lock) < __alignof__(rwlock_t)),
otherwise it will still pass when you have structure with attribute((packed,aligned(2)))

> 1, it is alignof bug for default gcc on my fc15 and Ubuntu 11.10 etc?
> 
> struct sub {
>         int  raw_lock;
>         char a;
> };
> struct foo {
>         struct sub z;
>         int slk;
>         char y;
> }__attribute__((packed));
> 
> struct foo f1;
> 
> __alignof__(f1.z.raw_lock) is 4, but its address actually can align on
> one byte. 

That looks like correct behavior, because the alignment of raw_lock inside of
struct sub is still 4. But it does mean that there can be cases where the
compile-time check is not sufficient, so we might want the run-time check
as well, at least under some config option.

	Arnd
