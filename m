Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab0GJVHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:07:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40095 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab0GJVHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HUKKTjVqApv0jhBfjHB0Vr1CUUkEMlbDrQ4ghC80n3X84QR6PD5agj0YVBiDCm1nZU
         xk3UJzOLSpB1jdgZlMM8SD6e3+vGUqTiMlmRUa5oe0LncAaQ/44hagWWjZBgWkh2N6A1
         tGSgtUV/wXyP7NX4+abJIfj82QbeeqJKwCSkQ=
Date: Sun, 11 Jul 2010 01:07:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2] x86: Early-boot serial I/O support
Message-ID: <20100710210750.GC6615@lenovo>
References: <1278790820-1817-1-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278790820-1817-1-git-send-email-penberg@cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 10:40:20PM +0300, Pekka Enberg wrote:
> This patch adds serial I/O support to very early boot printf(). It's useful for
> debugging boot code when running Linux under KVM, for example. The actual code
> was lifted from early printk.
> 
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
> v1 -> v2:
> 
>   - Use 'earlyprintk' kernel parameter to determine whether to use
>     early serial or not as suggested by Yinghai and hpa.
> 
>  arch/x86/boot/boot.h   |   16 +++++++
>  arch/x86/boot/main.c   |    3 +
>  arch/x86/boot/string.c |   41 ++++++++++++++++++
>  arch/x86/boot/tty.c    |  111 +++++++++++++++++++++++++++++++++++++++++++++---
>  4 files changed, 165 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
> index 98239d2..f05b5ac 100644
> --- a/arch/x86/boot/boot.h
> +++ b/arch/x86/boot/boot.h
> @@ -37,6 +37,8 @@
>  extern struct setup_header hdr;
>  extern struct boot_params boot_params;
>  
> +#define cpu_relax()	asm volatile("rep; nop" ::: "memory")
> +
>  /* Basic port I/O */
>  static inline void outb(u8 v, u16 port)
>  {
> @@ -203,6 +205,17 @@ static inline int isdigit(int ch)
>  	return (ch >= '0') && (ch <= '9');
>  }
>  
> +static inline int isxdigit(int ch)
> +{
> +	if (isdigit(ch))
> +		return true;
> +
> +	if ((ch >= 'a') && (ch <= 'f'))
> +		return true;
> +
> +	return (ch >= 'A') && (ch <= 'F');
> +}
> +

I suspect it's supposed to be static inline *bool*, right?

	-- Cyrill
