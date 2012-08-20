Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2HTJ4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:56:54 -0400
Received: from mga05.intel.com ([192.55.52.89]:43564 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751100Ab2HTJ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:56:51 -0400
Subject: Re: [PATCH] x86: efi: Turn off efi_enabled after setup on mixed
 fw/kernel
From: Matt Fleming <matt.fleming@intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mk@dee.su,
        Marko Kohtala <marko.kohtala@gmail.com>,
        Matthew Garrett <mjg@redhat.com>
In-Reply-To: <1345412920-10906-1-git-send-email-olof@lixom.net>
References: <1345412920-10906-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Mon, 20 Aug 2012 10:56:41 +0100
Message-ID: <1345456601.3088.40.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-08-19 at 14:48 -0700, Olof Johansson wrote:
> When 32-bit EFI is used with 64-bit kernel (or vice versa), turn off
> efi_enabled once setup is done. Beyond setup, it is normally used to
> determine if runtime services are available and we will have none.
> 
> This will resolve issues stemming from efivars modprobe panicking on a
> 32/64-bit setup, as well as some reboot issues on similar setups.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: stable@kernel.org # 3.4 and 3.5
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> ---
>  arch/x86/kernel/setup.c     | 11 +++++++++++
>  arch/x86/platform/efi/efi.c | 14 ++++++++------
>  2 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index f4b9b80..dad38ac 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1034,6 +1034,17 @@ void __init setup_arch(char **cmdline_p)
>  	mcheck_init();
>  
>  	arch_init_ideal_nops();
> +
> +#ifdef CONFIG_EFI
> +	/* Once setup is done above, disable efi_enabled on mismatched
> +	 * firmware/kernel archtectures since there is no support for
> +	 * runtime services.
> +	 */
> +	if (IS_ENABLED(CONFIG_X86_64) ^ efi_64bit) {
> +		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
> +		efi_enabled = 0;
> +	}
> +#endif
>  }

Is there a reason we can't just disable efi_enabled at the end of
efi_init() if we're non-native, rather than having this chunk of code
here?

