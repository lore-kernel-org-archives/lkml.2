Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab0JKSi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 14:38:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56300 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab0JKSi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 14:38:26 -0400
Message-ID: <4CB35973.3070100@zytor.com>
Date: Mon, 11 Oct 2010 11:37:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v4] x86: Setup early console as early as possible in
 x86_start_kernel()
References: <4CB35050.7060207@kernel.org>
In-Reply-To: <4CB35050.7060207@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2010 10:58 AM, Yinghai Lu wrote:
>  
>  #ifdef CONFIG_X86_TRAMPOLINE
> Index: linux-2.6/arch/x86/kernel/head64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/head64.c
> +++ linux-2.6/arch/x86/kernel/head64.c
> @@ -74,6 +74,10 @@ void __init x86_64_start_kernel(char * r
>  	/* clear bss before set_intr_gate with early_idt_handler */
>  	clear_bss();
>  
> +	/* boot_params is in bss */
> +	copy_bootdata(__va(real_mode_data));
> +	setup_early_console();
> +
>  	/* Make NULL pointers segfault */
>  	zap_identity_mappings();
>  
> @@ -97,7 +101,14 @@ void __init x86_64_start_kernel(char * r
>  
>  void __init x86_64_start_reservations(char *real_mode_data)
>  {
> -	copy_bootdata(__va(real_mode_data));
> +	/*
> +	 * hdr.version is always not 0, so check it to see
> +	 *  if boot_params is copied or not.
> +	 */
> +	if (!boot_params.hdr.version) {
> +		copy_bootdata(__va(real_mode_data));
> +		setup_early_console();
> +	}
>  
>  	memblock_init();
>  

Under what conditions would we *not* have gotten through
x86_64_start_kernel()?

	-hpa
