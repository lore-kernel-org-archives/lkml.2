Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab1JQXw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 19:52:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37066 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1JQXw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 19:52:58 -0400
Date: Mon, 17 Oct 2011 16:47:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Don Zickus <dzickus@redhat.com>,
        Matthew Garrett <mjg@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Message-Id: <20111017164715.e42591d5.akpm@linux-foundation.org>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C5747DC7B@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5747DC7B@USINDEVS01.corp.hds.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011 16:53:05 -0400
Seiji Aguchi <seiji.aguchi@hds.com> wrote:

> Hi,
>  
>  As Don mentioned in following thread, it would be nice for pstore/kmsg_dump to serialize 
>  panic path and have one cpu running because they can log messages reliably. 
>  
>  https://lkml.org/lkml/2011/10/13/427
>  
>  For realizing this idea, we have to move kmsg_dump below smp_send_stop() and bust some locks 
>  of kmsg_dump/pstore in panic path.
> 
>  This patch does followings.
> 
>   - moving kmsg_dump(KMSG_DUMP_PANIC) below smp_send_stop.
>   - busting logbuf_lock of kmsg_dump() in panic path for avoiding deadlock.
>   - busting psinfo->buf_lock of pstore_dump() in panic path for avoiding deadlock.
> 
> Any comments are welcome.
>
> ...
>
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -90,19 +90,21 @@ static void pstore_dump(struct kmsg_dumper *dumper,
>  	int		hsize, ret;
>  	unsigned int	part = 1;
>  	unsigned long	flags = 0;
> -	int		is_locked = 0;
>  
>  	if (reason < ARRAY_SIZE(reason_str))
>  		why = reason_str[reason];
>  	else
>  		why = "Unknown";
>  
> -	if (in_nmi()) {
> -		is_locked = spin_trylock(&psinfo->buf_lock);
> -		if (!is_locked)
> -			pr_err("pstore dump routine blocked in NMI, may corrupt error record\n");
> -	} else
> -		spin_lock_irqsave(&psinfo->buf_lock, flags);
> +	/*
> +	 * pstore_dump() is called after smp_send_stop() in panic path.
> +	 * So, spin_lock should be bust for avoiding deadlock.
> +	 */
> +	if (reason == KMSG_DUMP_PANIC)
> +		spin_lock_init(&psinfo->buf_lock);
> +
> +	spin_lock_irqsave(&psinfo->buf_lock, flags);
> +
>  	oopscount++;
>  	while (total < kmsg_bytes) {
>  		dst = psinfo->buf;
> @@ -131,11 +133,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
>  		total += l1_cpy + l2_cpy;
>  		part++;
>  	}
> -	if (in_nmi()) {
> -		if (is_locked)
> -			spin_unlock(&psinfo->buf_lock);
> -	} else
> -		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
> +	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
>  }

afacit this assumes that (reason == KMSG_DUMP_PANIC) if in_nmi().  Is
that always the case, and will it always be the case in the future?

I felt that the spin_trylock() approach was less horrid than this.  I
assume that the new approach will cause lockdep to go berzerk?

> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1732,6 +1732,13 @@ void kmsg_dump(enum kmsg_dump_reason reason)
>  	unsigned long l1, l2;
>  	unsigned long flags;
>  
> +	/*
> +	 *  kmsg_dump() is called after smp_send_stop() in panic path.
> +	 *  So, spin_lock should be bust for avoiding deadlock.
> +	 */
> +	if (reason == KMSG_DUMP_PANIC)
> +		raw_spin_lock_init(&logbuf_lock);
> +
>  	/* Theoretically, the log could move on after we do this, but
>  	   there's not a lot we can do about that. The new messages
>  	   will overwrite the start of what we dump. */

I suggest you do some research into bust_spinlocks() and how it has
changed over time.  I think that code used to fiddle with log levels
and once upon a time it might have fiddled with logbuf_lock.
