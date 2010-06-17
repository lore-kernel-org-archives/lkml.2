Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269Ab0FQW2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 18:28:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55037 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab0FQW2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 18:28:13 -0400
Message-ID: <4C1AA15E.3050205@zytor.com>
Date: Thu, 17 Jun 2010 15:27:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Tim Abbott <tabbott@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Jiri Kosina <jkosina@suse.cz>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] x86: clear XD_DISABLED flag on Intel to regain NX
References: <20100617221318.GC24749@outflux.net>
In-Reply-To: <20100617221318.GC24749@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 03:13 PM, Kees Cook wrote:
> This will clear the MSR_IA32_MISC_ENABLE_XD_DISABLE bit so that NX cannot
> be inappropriately controlled by the BIOS on Intel CPUs.  If NX actually
> needs to be disabled, "noexec=off" can be used.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
>  arch/x86/kernel/head_32.S |   19 +++++++++++++++++++
>  arch/x86/kernel/head_64.S |   18 ++++++++++++++++++
>  arch/x86/mm/setup_nx.c    |    2 +-
>  3 files changed, 38 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index 37c3d4b..111e434 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -309,6 +309,25 @@ ENTRY(startup_32_smp)
>  	subl $0x80000001, %eax
>  	cmpl $(0x8000ffff-0x80000001), %eax
>  	ja 6f
> +
> +	/* Is this "GenuineIntel"? */
> +	movl $0x0, %eax
> +	cpuid
> +	cmpl $0x756e6547, %ebx
> +	jnz 5f
> +	cmpl $0x49656e69, %edx
> +	jnz 5f
> +	cmpl $0x6c65746e, %ecx
> +	jnz 5f
> +
> +	/* Clear MSR_IA32_MISC_ENABLE_XD_DISABLE if set */
> +	movl $MSR_IA32_MISC_ENABLE, %ecx
> +	rdmsr
> +	btrl $2, %edx
> +	jnc 5f
> +	wrmsr
> +
> +5:
>  	mov $0x80000001, %eax
>  	cpuid
>  	/* Execute Disable bit supported? */

Multiple problems with this code.

a) Not all Intel CPUs with extended CPUID levels have
   MSR_IA32_MISC_ENABLE bit 34.  Since we can't take traps here we would
   have to know positively that we aren't going to trip on anything.
b) For 64 bits, this should go into verify_cpu_64.S, and since that is
   32-bit code anyway, it would be best if we could merge the 32- and
   64-bit code into that file; it already simply returns a value
   that could be ignored on 32 bits.

	-hpa
