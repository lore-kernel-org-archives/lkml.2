Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab2GAQYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 12:24:19 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:50469 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751013Ab2GAQYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 12:24:17 -0400
Message-ID: <4FF0798D.60109@xenotime.net>
Date: Sun, 01 Jul 2012 09:23:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        mtosatti@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] apic: fix kvm build on UP without IOAPIC
References: <20120701150506.GA31304@redhat.com>
In-Reply-To: <20120701150506.GA31304@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2012 08:05 AM, Michael S. Tsirkin wrote:

> On UP i386, when APIC is disabled
> # CONFIG_X86_UP_APIC is not set
> # CONFIG_PCI_IOAPIC is not set
> 
> code looking at apicdrivers never has any effect but it
> still gets compiled in. In particular, this causes
> build failures with kvm, but it generally bloats the kernel
> unnecessarily.
> 
> Fix by defining both __apicdrivers and __apicdrivers_end
> to be NULL when CONFIG_X86_LOCAL_APIC is unset: I verified
> that as the result any loop scanning __apicdrivers gets optimized out by
> the compiler.
> 
> Warning: a .config with apic disabled doesn't seem to boot
> for me (even without this patch). Still verifying why,
> meanwhile this patch is compile-tested only.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>


Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
> 
> Note: if this patch makes sense, can x86 maintainers
> please ACK applying it through the kvm tree, since that is
> where we see the issue that it addresses?
> Avi, Marcelo, maybe you can carry this in kvm/linux-next as a temporary
> measure so that linux-next builds?
> 
>  arch/x86/include/asm/apic.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index eaff479..aa5b2ee 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -417,7 +417,12 @@ extern struct apic *apic;
>  	__aligned(sizeof(struct apic *))				\
>  	__section(.apicdrivers) = { &sym1, &sym2 }
>  
> +#ifdef CONFIG_X86_LOCAL_APIC
>  extern struct apic *__apicdrivers[], *__apicdrivers_end[];
> +#else
> +#define __apicdrivers ((struct apic **)NULL)
> +#define __apicdrivers_end ((struct apic **)NULL)
> +#endif
>  
>  /*
>   * APIC functionality to boot other CPUs - only used on SMP:



-- 
~Randy
