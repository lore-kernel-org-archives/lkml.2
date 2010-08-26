Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab0HZHKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 03:10:18 -0400
Received: from ozlabs.org ([203.10.76.45]:54373 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab0HZHKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 03:10:16 -0400
Message-ID: <4C761367.2000506@ozlabs.org>
Date: Thu, 26 Aug 2010 17:10:31 +1000
From: Matt Evans <matt@ozlabs.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: [49/59] powerpc: Initialise paca->kstack before early_setup_secondary
References: <20100824222526.676650737@clark.site>
In-Reply-To: <20100824222526.676650737@clark.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 25/08/10 08:25, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.

I have an objection!   We've found a problem, it breaks stuff fairly thoroughly.  >:(  Mikey has submitted http://patchwork.ozlabs.org/patch/62757/ to Ben's tree to fix it, but it might be easier all round to drop this and we can resubmit the indivisible pair of commits to -stable later?  (You'd selected this for {34,35}-stable also.)

Really for the inconvenience,


Matt



> 
> ------------------
> 
> From: Matt Evans <matt@ozlabs.org>
> 
> commit f761622e59433130bc33ad086ce219feee9eb961 upstream.
> 
> As early setup calls down to slb_initialize(), we must have kstack
> initialised before checking "should we add a bolted SLB entry for our kstack?"
> 
> Failing to do so means stack access requires an SLB miss exception to refill
> an entry dynamically, if the stack isn't accessible via SLB(0) (kernel text
> & static data).  It's not always allowable to take such a miss, and
> intermittent crashes will result.
> 
> Primary CPUs don't have this issue; an SLB entry is not bolted for their
> stack anyway (as that lives within SLB(0)).  This patch therefore only
> affects the init of secondaries.
> 
> Signed-off-by: Matt Evans <matt@ozlabs.org>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  arch/powerpc/kernel/head_64.S |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- a/arch/powerpc/kernel/head_64.S
> +++ b/arch/powerpc/kernel/head_64.S
> @@ -563,9 +563,6 @@ __secondary_start:
>  	/* Set thread priority to MEDIUM */
>  	HMT_MEDIUM
>  
> -	/* Do early setup for that CPU (stab, slb, hash table pointer) */
> -	bl	.early_setup_secondary
> -
>  	/* Initialize the kernel stack.  Just a repeat for iSeries.	 */
>  	LOAD_REG_ADDR(r3, current_set)
>  	sldi	r28,r24,3		/* get current_set[cpu#]	 */
> @@ -573,6 +570,9 @@ __secondary_start:
>  	addi	r1,r1,THREAD_SIZE-STACK_FRAME_OVERHEAD
>  	std	r1,PACAKSAVE(r13)
>  
> +	/* Do early setup for that CPU (stab, slb, hash table pointer) */
> +	bl	.early_setup_secondary
> +
>  	/* Clear backchain so we get nice backtraces */
>  	li	r7,0
>  	mtlr	r7
> 

