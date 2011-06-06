Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab1FFKAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:00:18 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:16075 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab1FFKAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:00:13 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/f7yb6+x1CF1B3oIP27v4=
X-RZG-CLASS-ID: mo00
Message-ID: <4DECA525.7030503@die-jansens.de>
Date: Mon, 06 Jun 2011 12:00:05 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
References: <20110605151323.GA30590@elte.hu>	 <20110605152641.GA31124@elte.hu> <20110605153218.GA31471@elte.hu>	 <4DEBA9CC.4090503@die-jansens.de> <4DEBB05C.8090506@die-jansens.de>	 <4DEBB3DA.8060001@die-jansens.de> <20110605172052.GA1036@elte.hu>	 <4DEBBFF9.2030101@die-jansens.de> <20110605185957.GA3452@elte.hu>	 <4DEBD95B.6030901@die-jansens.de> <20110605194419.GA12965@elte.hu>	 <4DEBE3DF.70104@die-jansens.de> <1307350909.2353.7408.camel@twins>
In-Reply-To: <1307350909.2353.7408.camel@twins>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.06.2011 11:01, Peter Zijlstra wrote:
> On Sun, 2011-06-05 at 22:15 +0200, Arne Jansen wrote:
>>
>> Can lockdep just get confused by the lockdep_off/on calls in printk
>> while scheduling is allowed? There aren't many users of lockdep_off().
> 
> Yes!, in that case lock_is_held() returns false, triggering the warning.
> I guess there's an argument to be made in favour of the below..

As expected this apparently fixes the problem. But are we confident
enough this is the true source? If it's really that simple, printk
calling into the scheduler, why am I the only one seeing this?

-Arne

> 
> ---
>  kernel/lockdep.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 53a6895..e4129cf 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -3242,7 +3242,7 @@ int lock_is_held(struct lockdep_map *lock)
>  	int ret = 0;
>  
>  	if (unlikely(current->lockdep_recursion))
> -		return ret;
> +		return 1; /* avoid false negative lockdep_assert_held */
>  
>  	raw_local_irq_save(flags);
>  	check_flags(flags);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

