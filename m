Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab0HLGso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 02:48:44 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:62469 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0HLGsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 02:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=cnnObOT3XS4G0+McuQ5M+cqS2tNLNKRly2Aa3oE7vwnaB1hdG8BZWcBmqW8X/T4z1C
         B1vtKnz81s/VyDHOXZ+u6fWu3rQ7vdg49xd8QhzymTGBU0vLvHuqYu/aEy8GZaHzRUN3
         5PWRi73YsOrYTUhKcaSNGkMuka6qnq95bTylo=
Subject: Re: [PATCH V2] [X86] Fix potential issue on memmove
From: Namhyung Kim <namhyung@gmail.com>
To: Ma Ling <ling.ma@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        mingo@elte.hu
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 15:48:35 +0900
Message-ID: <1281595715.1631.5.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/arch/x86/lib/memcpy_32.c
> +++ b/arch/x86/lib/memcpy_32.c
> @@ -25,19 +25,35 @@ void *memmove(void *dest, const void *src, size_t n)
>	int d0, d1, d2;
> 
> 	if (dest < src) {
> -		memcpy(dest, src, n);
> +		if ((dest + n) < src)
> +			 return memcpy(dest, src, n);
> +		else
> +			__asm__ __volatile__(
> +				"rep\n\t"
> +				"movsb\n\t"
> +				: "=&c" (d0), "=&S" (d1), "=&D" (d2)
> +				:"0" (n),
> +				 "1" (src),
> +				 "2" (dest)
> +				:"memory");
> +
> 	} else {
> -		__asm__ __volatile__(
> -			"std\n\t"
> -			"rep\n\t"
> -			"movsb\n\t"
> -			"cld"
> -			: "=&c" (d0), "=&S" (d1), "=&D" (d2)
> -			:"0" (n),
> -			 "1" (n-1+src),
> -			 "2" (n-1+dest)
> -			:"memory");
> +		if((src + count) < dest)
> +			return memcpy(dest, src, count);

'count' should be 'n'.

-- 
Regards,
Namhyung Kim


