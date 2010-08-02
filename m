Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab0HBVmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 17:42:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44190 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab0HBVmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 17:42:35 -0400
Message-ID: <4C573BC5.70007@zytor.com>
Date: Mon, 02 Aug 2010 14:42:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: brgerst@gmail.com, Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 6175ddf06b6172046a329e3abfd9c901a43efd2e breaks matroxfb console
References: <201008022150.01037.linux@rainbow-software.org> <201008022314.26743.linux@rainbow-software.org> <4C573575.8040701@zytor.com> <201008022335.12191.linux@rainbow-software.org>
In-Reply-To: <201008022335.12191.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 02:35 PM, Ondrej Zary wrote:
> 
> The patch below fixes it for me. Is it correct on all architectures?
> 
> --- linux-2.6.35-rc2/drivers/video/matrox/matroxfb_base.h	2010-06-06 05:43:24.000000000 +0200
> +++ linux-2.6.35-rc3/drivers/video/matrox/matroxfb_base.h	2010-08-02 23:31:34.000000000 +0200
> @@ -157,7 +157,7 @@ static inline void mga_memcpy_toio(vaddr
>  	 *  (3) It copes with unaligned source (destination is guaranteed to be page
>  	 *      aligned and length is guaranteed to be multiple of 4).
>  	 */
> -	memcpy_toio(va.vaddr, src, len);
> +	iowrite32_rep(va.vaddr, src, len);
>  #else
>          u_int32_t __iomem* addr = va.vaddr;
>  

I don't think so; in particular I don't *think* non-x86 architectures
will deal with the requirement that it handles an unaligned source.  As
such, the #if would still be necessary; the #else clause could be
replaced with a get_unaligned() ... iowrite32() loop.

The other thing to watch out for is that "len" passed to iowrite32_rep()
is a count of 32-bit words, whereas memcpy_toio() takes a byte count...
you need to >> 2 there.

	-hpa

