Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2KURRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:17:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52701 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab2KURRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:17:50 -0500
Message-ID: <50AD0CA1.8000904@zytor.com>
Date: Wed, 21 Nov 2012 09:17:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 11/12] x86, boot: add fields to support load bzImage
 and ramdisk high
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org> <1353482170-10160-12-git-send-email-yinghai@kernel.org>
In-Reply-To: <1353482170-10160-12-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 11:16 PM, Yinghai Lu wrote:
>
> diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
> index 9efceff..a8263f7 100644
> --- a/Documentation/x86/boot.txt
> +++ b/Documentation/x86/boot.txt
> @@ -57,6 +57,9 @@ Protocol 2.10:	(Kernel 2.6.31) Added a protocol for relaxed alignment
>   Protocol 2.11:	(Kernel 3.6) Added a field for offset of EFI handover
>   		protocol entry point.
>
> +Protocol 2.12:	(Kernel 3.9) Added three fields for loading bzImage and
> +		 ramdisk above 4G with 64bit.
> +
>   **** MEMORY LAYOUT
>
>   The traditional memory map for the kernel loader, used for Image or
> @@ -182,7 +185,7 @@ Offset	Proto	Name		Meaning
>   0230/4	2.05+	kernel_alignment Physical addr alignment required for kernel
>   0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
>   0235/1	2.10+	min_alignment	Minimum alignment, as a power of two
> -0236/2	N/A	pad3		Unused
> +0236/2	2.12+	xloadflags	Boot protocal option flags
                                              ^^^^^^^^
>   0238/4	2.06+	cmdline_size	Maximum size of the kernel command line
>   023C/4	2.07+	hardware_subarch Hardware subarchitecture
>   0240/8	2.07+	hardware_subarch_data Subarchitecture-specific data
> @@ -193,6 +196,9 @@ Offset	Proto	Name		Meaning
>   0258/8	2.10+	pref_address	Preferred loading address
>   0260/4	2.10+	init_size	Linear memory required during initialization
>   0264/4	2.11+	handover_offset	Offset of handover entry point
> +0268/4	2.12+	ext_ramdisk_image ramdisk_image 32 bits

"high 32 bits" presumably...

> +026C/4	2.12+	ext_ramdisk_size ramdisk_size high 32 bits
> +0270/4	2.12+   ext_cmd_line_ptr cmd_line_ptr high 32 bits

I'm looking at these three fields and I'm getting worried about space -- 
there are only two more word-sized fields possible in this structure. 
Since these fields are not initialized (default to zero) and almost 
certainly aren't useful for people entering via the 16-bit entry point I 
think we should move them out of struct setup_header and into the 
remainder of struct boot_param.
> diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
> index b4c913c..00678d3 100644
> --- a/arch/x86/boot/compressed/cmdline.c
> +++ b/arch/x86/boot/compressed/cmdline.c
> @@ -17,6 +17,9 @@ static unsigned long get_cmd_line_ptr(void)
>   {
>   	unsigned long cmd_line_ptr = real_mode->hdr.cmd_line_ptr;
>
> +	if (real_mode->hdr.version >= 0x020c)
> +		cmd_line_ptr |= (u64)real_mode->hdr.ext_cmd_line_ptr << 32;
> +
>   	return cmd_line_ptr;
>   }

No.  hdr.version is information from the kernel to the bootloader; it is 
meaningless to look at it inside the kernel.

Same in a bunch of other places.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

