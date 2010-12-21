Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab0LUFsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 00:48:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239Ab0LUFsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 00:48:14 -0500
Date: Mon, 20 Dec 2010 21:44:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Newton <will.newton@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] include/linux/unaligned: Pack the whole struct rather
 than just the field.
Message-Id: <20101220214445.85816469.akpm@linux-foundation.org>
In-Reply-To: <AANLkTi=kX8NraxuLn-f=s=nqja71Ayq2kYwgG6gq+7YF@mail.gmail.com>
References: <AANLkTi=kX8NraxuLn-f=s=nqja71Ayq2kYwgG6gq+7YF@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010 22:11:53 +0000 Will Newton <will.newton@gmail.com> wrote:

> The current packed struct implementation of unaligned access adds
> the packed attribute only to the field within the unaligned struct
> rather than to the struct as a whole. This is not sufficient to
> enforce proper behaviour on architectures with a default struct
> alignment of more than one byte.
> 
> For example, the current implementation of __get_unaligned_cpu16
> when compiled for arm with gcc -O1 -mstructure-size-boundary=32
> assumes the struct is on a 4 byte boundary so performs the load
> of the 16bit packed field as if it were on a 4 byte boundary:
> 
> __get_unaligned_cpu16:
>         ldrh    r0, [r0, #0]
>         bx      lr
> 
> Moving the packed attribute to the struct rather than the field
> causes the proper unaligned access code to be generated:
> 
> __get_unaligned_cpu16:
> 	ldrb	r3, [r0, #0]	@ zero_extendqisi2
> 	ldrb	r0, [r0, #1]	@ zero_extendqisi2
> 	orr	r0, r3, r0, asl #8
> 	bx	lr
> 
> Signed-off-by: Will Newton <will.newton@gmail.com>
> ---
>  include/linux/unaligned/packed_struct.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/unaligned/packed_struct.h
> b/include/linux/unaligned/packed_struct.h
> index 2498bb9..c9a6abd 100644
> --- a/include/linux/unaligned/packed_struct.h
> +++ b/include/linux/unaligned/packed_struct.h
> @@ -3,9 +3,9 @@
> 
>  #include <linux/kernel.h>
> 
> -struct __una_u16 { u16 x __attribute__((packed)); };
> -struct __una_u32 { u32 x __attribute__((packed)); };
> -struct __una_u64 { u64 x __attribute__((packed)); };
> +struct __una_u16 { u16 x; } __attribute__((packed));
> +struct __una_u32 { u32 x; } __attribute__((packed));
> +struct __una_u64 { u64 x; } __attribute__((packed));
> 

Yes, that was wrong.

Do you think this bug affects 2.6.36 or earlier?

Even if it doesn't, it looks like a bit of a hand-grenade to leave it
unfixed in earlier kernels.

