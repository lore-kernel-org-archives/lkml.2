Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0LGLMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:12:39 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64083 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab0LGLMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:12:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nBRgfeH1s4PnDU+55WB2ybvnea2i5BGGoaRmZhYOTG9orOGO9A3LpgJ3lFmPE/T1NX
         rJmS8qtmrr3jboO0S5lowiZK7w3e5OUZL4m/6BxLywj/MDFsGSacvO4CAtiDqPUKAHpK
         smL6CywWyle4EM4N+5zTPUEnffLOgOBPcEIq8=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=kX8NraxuLn-f=s=nqja71Ayq2kYwgG6gq+7YF@mail.gmail.com>
References: <AANLkTi=kX8NraxuLn-f=s=nqja71Ayq2kYwgG6gq+7YF@mail.gmail.com>
Date: Tue, 7 Dec 2010 11:12:37 +0000
Message-ID: <AANLkTinqgNKYLo2Ux_5Bsx=K=cgUB4gT7Djpnfbp6TGh@mail.gmail.com>
Subject: Re: [PATCH] include/linux/unaligned: Pack the whole struct rather
 than just the field.
From: Will Newton <will.newton@gmail.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 1, 2010 at 10:11 PM, Will Newton <will.newton@gmail.com> wrote:
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
>        ldrh    r0, [r0, #0]
>        bx      lr
>
> Moving the packed attribute to the struct rather than the field
> causes the proper unaligned access code to be generated:
>
> __get_unaligned_cpu16:
>        ldrb    r3, [r0, #0]    @ zero_extendqisi2
>        ldrb    r0, [r0, #1]    @ zero_extendqisi2
>        orr     r0, r3, r0, asl #8
>        bx      lr
>
> Signed-off-by: Will Newton <will.newton@gmail.com>

I don't know of any designated maintainer for this code, but add a
couple of ccs of people who might be interested.

This change doesn't change any behaviour on current architectures, but
is more correct and may enable other architectures to move to the
packed struct unaligned access implementation and so allow us to move
more architectures to the asm-generic implementation.

> ---
>  include/linux/unaligned/packed_struct.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/unaligned/packed_struct.h
> b/include/linux/unaligned/packed_struct.h
> index 2498bb9..c9a6abd 100644
> --- a/include/linux/unaligned/packed_struct.h
> +++ b/include/linux/unaligned/packed_struct.h
> @@ -3,9 +3,9 @@
>
>  #include <linux/kernel.h>
>
> -struct __una_u16 { u16 x __attribute__((packed)); };
> -struct __una_u32 { u32 x __attribute__((packed)); };
> -struct __una_u64 { u64 x __attribute__((packed)); };
> +struct __una_u16 { u16 x; } __attribute__((packed));
> +struct __una_u32 { u32 x; } __attribute__((packed));
> +struct __una_u64 { u64 x; } __attribute__((packed));
>
>  static inline u16 __get_unaligned_cpu16(const void *p)
>  {
> --
> 1.7.0.4
>
