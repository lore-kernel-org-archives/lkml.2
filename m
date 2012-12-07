Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab2LGXQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 18:16:05 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42258 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111Ab2LGXQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 18:16:00 -0500
Message-ID: <50C278AC.5050205@gmail.com>
Date: Sat, 08 Dec 2012 00:15:56 +0100
From: Mircea Gherzan <mgherzan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Nicolas Schichan <nschichan@freebox.fr>
CC: rmk+kernel@arm.linux.org.uk, Russell King <linux@arm.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: net: bpf_jit_32: fix sp-relative load/stores
 offsets.
References: <1354804718-1662-1-git-send-email-nschichan@freebox.fr> <1354804718-1662-2-git-send-email-nschichan@freebox.fr>
In-Reply-To: <1354804718-1662-2-git-send-email-nschichan@freebox.fr>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.12.2012 15:38, schrieb Nicolas Schichan:
> The offset must be multiplied by 4 to be sure to access the correct
> 32bit word in the stack scratch space.
> 
> For instance, a store at scratch memory cell #1 was generating the
> following:
> 
> st	r4, [sp, #1]
> 
> While the correct code for this is:
> 
> st	r4, [sp, #4]
> 
> To reproduce the bug (assuming your system has a NIC with the mac
> address 52:54:00:12:34:56):
> 
> echo 0 > /proc/sys/net/core/bpf_jit_enable
> tcpdump -ni eth0 "ether[1] + ether[2] - ether[3] * ether[4] - ether[5] \
> 	== -0x3AA" # this will capture packets as expected
> 
> echo 1 > /proc/sys/net/core/bpf_jit_enable
> tcpdump -ni eth0 "ether[1] + ether[2] - ether[3] * ether[4] - ether[5] \
> 	== -0x3AA" # this will not.
> 
> This bug was present since the original inclusion of bpf_jit for ARM
> (ddecdfce: ARM: 7259/3: net: JIT compiler for packet filters).
> 
> Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
> ---
>  arch/arm/net/bpf_jit_32.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> index a64d349..b6f305e 100644
> --- a/arch/arm/net/bpf_jit_32.c
> +++ b/arch/arm/net/bpf_jit_32.c
> @@ -42,7 +42,7 @@
>  #define r_skb_hl	ARM_R8
>  
>  #define SCRATCH_SP_OFFSET	0
> -#define SCRATCH_OFF(k)		(SCRATCH_SP_OFFSET + (k))
> +#define SCRATCH_OFF(k)		(SCRATCH_SP_OFFSET + 4 * (k))
>  
>  #define SEEN_MEM		((1 << BPF_MEMWORDS) - 1)
>  #define SEEN_MEM_WORD(k)	(1 << (k))

Acked-by: Mircea Gherzan <mgherzan@gmail.com>
