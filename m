Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab0HQDAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 23:00:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37511 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab0HQDAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 23:00:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qHvssriCyHSeHuiTBWQBY3HRs3WYrBXe2V7qLJdKfb3CpDnWk2GTEVMttoWaAZyBw5
         stCAfrI6sB0UgsVNBz/BzGl5XwROAWFtHJwbaXuoAOpoISUhkxHThXM4UBgYBQ7FDSDd
         s1b5Ggt4tQhquuFpi9lk1nscYyYF/vwJRdXpU=
Date: Tue, 17 Aug 2010 04:59:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
	and touch_softlockup_watchdog
Message-ID: <20100817025954.GA12366@nowhere>
References: <20100813102158.GA5434@swordfish.minsk.epam.com> <1281946970.1926.998.camel@laptop> <20100816133452.GS4879@redhat.com> <1281966418.1926.1421.camel@laptop> <20100816140829.GA5225@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100816140829.GA5225@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 05:08:29PM +0300, Sergey Senozhatsky wrote:
>  void touch_softlockup_watchdog(void)
>  {
> -	__get_cpu_var(watchdog_touch_ts) = 0;
> +	int this_cpu = get_cpu();
> +	per_cpu(watchdog_touch_ts, this_cpu) = 0;
> +	put_cpu();
>  }



If preemption is disabled and you deal with the current cpu,
then please use __get_cpu_var, it makes the code more
readable:


void touch_softlockup_watchdog(void)
{
	preempt_disable();
	__get_cpu_var(watchdog_touch_ts) = 0;
	preempt_enable();
}


Same below.

Thanks.


>  EXPORT_SYMBOL(touch_softlockup_watchdog);
>  
> @@ -142,7 +143,9 @@ void touch_all_softlockup_watchdogs(void)
>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>  void touch_nmi_watchdog(void)
>  {
> -	__get_cpu_var(watchdog_nmi_touch) = true;
> +	int this_cpu = get_cpu();
> +	per_cpu(watchdog_nmi_touch, this_cpu) = true;
> +	put_cpu();
>  	touch_softlockup_watchdog();
>  }
>  EXPORT_SYMBOL(touch_nmi_watchdog);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

