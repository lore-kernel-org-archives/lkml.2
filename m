Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab1AQJ4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 04:56:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44416 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab1AQJ4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 04:56:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sz/P5PjglA6b0ex3DYVg0vP/nFPZ3QpVA/Hk+B7MLAW+Mdldzcrk/u5/BxCD71In0+
         /VVlX69kiLr7czk/Z4toXELfFSzgvrhtmRcc0h/CH7kuVcYL5QCWumJPrIcYUi4loRtu
         jaUczNcAf/llQwLL9UVw+BDK9j8AW571eJUSE=
MIME-Version: 1.0
In-Reply-To: <1295253729-23153-2-git-send-email-stanley.miao@windriver.com>
References: <1295253729-23153-1-git-send-email-stanley.miao@windriver.com>
	<1295253729-23153-2-git-send-email-stanley.miao@windriver.com>
Date: Mon, 17 Jan 2011 09:56:50 +0000
X-Google-Sender-Auth: SzPl-GsfxEeX9aS-PwmFhhT_zPg
Message-ID: <AANLkTi=RSpXHRpoZJsGLhVgQ=E=tcNGm8GXYC9UPaDrA@mail.gmail.com>
Subject: Re: [PATCH 1/3] Support BE8 mode kernel modules relocation
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Stanley.Miao" <stanley.miao@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 January 2011 08:42, Stanley.Miao <stanley.miao@windriver.com> wrote:
> The code section in BE8 kernel modules is in little-endian while data
> section is in big-endian. When reading code from memory in the relocation
> procedure, these instructions are read according to big-endian, so they
> need to be inverted before writing to memory and after reading from memory.
[...]
> --- a/arch/arm/include/asm/io.h
> +++ b/arch/arm/include/asm/io.h
> @@ -233,6 +233,18 @@ extern void _memset_io(volatile void __iomem *, int, size_t);
>
>  #endif /* __mem_pci */
>
> +#ifdef CONFIG_CPU_ENDIAN_BE8
> +#define read_instr32(c)                        __swab32(*(u32 *)c)
> +#define read_instr16(c)                        __swab16(*(u16 *)c)
> +#define write_instr32(v,a)             (*(u32 *)(a) = __swab32((__force __u32)(v)))
> +#define write_instr16(v,a)             (*(u16 *)(a) = __swab16((__force __u16)(v)))
> +#else
> +#define read_instr32(c)                        (*(u32 *)c)
> +#define read_instr16(c)                        (*(u16 *)c)
> +#define write_instr32(v,a)             (*(u32 *)(a) = (v))
> +#define write_instr16(v,a)             (*(u16 *)(a) = (v))
> +#endif

Can we not use cpu_to_le32 etc in here (and as Russell said, they are
not really IO)?

-- 
Catalin
