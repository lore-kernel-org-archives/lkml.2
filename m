Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab1AMEbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 23:31:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54542 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab1AMEa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 23:30:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k0fWi7i7GPpR+Iwoaf8/anD8XennQOSkkdACVX4e7luyMUJNl2M1BQU6fsF1ZRT51d
         bjO5ckrtmsbtqheeomcOtlZ9xU2Ej0ugH701Lo/DeKSj4JmUjyHj4BqcPQMVTqDM9R9r
         4Gpu9aPZ3zKhV+44nYIgnAxOpYs9aiLP0Jg0w=
Date: Thu, 13 Jan 2011 05:30:45 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH V8 08/13] posix clocks: cleanup the CLOCK_DISPTACH macro
Message-ID: <20110113043037.GA17726@riccoc20.at.omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at>
 <503cd1fa268867573001cfc9bb5681ee3b5b32fa.1293820862.git.richard.cochran@omicron.at>
 <alpine.LFD.2.00.1101111224280.12146@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101111224280.12146@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 01:57:23PM +0100, Thomas Gleixner wrote:
> 
> static clockid_t clock_get_array_id(const clockid_t id)
> {
> 	if (id >= 0)
> 	       return id < MAX_CLOCKS ? id : POSIX_INV_CLOCK_ID;
> 
>       	if (clock_is_posix_cpu(id))
> 		return POSIX_CPU_CLOCK_ID;
> 
> 	return POSIX_INV_CLOCK_ID;
> }
> 
> static inline int dispatch_clock_getres(const clockid_t id, struct timespec *ts)
> {
> 	struct k_clock *clk = &posix_clocks[clock_get_array_id(id)];
> 
> 	return clk->clock_getres ? clk->clock_getres(id, ts) : -EINVAL;
> }

I would like to take this idea one step further, like so:

static struct k_clock *clockid_to_kclock(const clockid_t id)
{
	if (id >= 0)
		return id < MAX_CLOCKS ?
			&posix_clocks[id] : &posix_clocks[POSIX_INV_CLOCK_ID];
	...
}

SYSCALL( ... , const clockid_t id, struct timespec *ts)
{
	struct k_clock *clk = clockid_to_kclock(id);

	return clk->clock_getres ? clk->clock_getres(id, ts) : -EINVAL;
}

What do you think?

Thanks,

Richard
