Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2LZIAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 03:00:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43623 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab2LZIAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 03:00:23 -0500
Date: Wed, 26 Dec 2012 09:00:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stefan Hasko <hasko.stevo@gmail.com>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: x86: boot: compressed: eboot: fix cast warnings on
 32b platforms
Message-ID: <20121226080019.GB11555@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Stefan Hasko <hasko.stevo@gmail.com>,
	Matt Fleming <matt.fleming@intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1356171805-16930-1-git-send-email-hasko.stevo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1356171805-16930-1-git-send-email-hasko.stevo@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 11:23:25AM +0100, Stefan Hasko wrote:
> Fixed different size cast warnings in function setup_efi_pci
> 
> Signed-off-by: Stefan Hasko <hasko.stevo@gmail.com>

You might want to add the actual compiler warnings to the commit
message:

arch/x86/boot/compressed/eboot.c: In function ‘setup_efi_pci’:
arch/x86/boot/compressed/eboot.c:259:9: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
arch/x86/boot/compressed/eboot.c:262:10: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
arch/x86/boot/compressed/eboot.c:348:17: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
arch/x86/boot/compressed/eboot.c:350:29: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

And yes, I see them in all{mod,yes}config builds here too. The issue,
AFAICT, is that setup_data is __u64 to obviously accomodate 8-byte
pointers on x86-64 but on 32-bit they're half the size. And we obviously
cannot change struct setup_data since this is an ABI so I'd guess the
casts to native pointer sizes are ok. So

Acked-by: Borislav Petkov <bp@alien8.de>

> ---
>  arch/x86/boot/compressed/eboot.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index b1942e2..dd99fca 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -256,10 +256,10 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
>  	int i;
>  	struct setup_data *data;
>  
> -	data = (struct setup_data *)params->hdr.setup_data;
> +	data = (struct setup_data *)(uintptr_t)params->hdr.setup_data;
>  
>  	while (data && data->next)
> -		data = (struct setup_data *)data->next;
> +		data = (struct setup_data *)(uintptr_t)data->next;
>  
>  	status = efi_call_phys5(sys_table->boottime->locate_handle,
>  				EFI_LOCATE_BY_PROTOCOL, &pci_proto,
> @@ -345,9 +345,9 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
>  		memcpy(rom->romdata, pci->romimage, pci->romsize);
>  
>  		if (data)
> -			data->next = (uint64_t)rom;
> +			data->next = (uintptr_t)rom;
>  		else
> -			params->hdr.setup_data = (uint64_t)rom;
> +			params->hdr.setup_data = (uintptr_t)rom;
>  
>  		data = (struct setup_data *)rom;
>  
> -- 
> 1.7.10.4

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
