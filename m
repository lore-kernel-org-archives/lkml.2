Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1LLP7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:59:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab1LLP7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:59:00 -0500
Date: Mon, 12 Dec 2011 10:58:27 -0500
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v3 2/3] Skip spin_locks in panic case and add
 WARN_ON()
Message-ID: <20111212155827.GR1669@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C57DC0D10@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C57DC0D10@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 05:10:26PM -0500, Seiji Aguchi wrote:
> Patch Description:
>    - Skip spin_locks in panic case in both kmsg_dump() and pstore_dump() because they are 
>      serialized via smp_send_stop
> 
>    - Add WARN_ON() in "in_nmi() and !panic" case into kmsg_dump(). Currently, this case never 
>      happens because only kmsg_dump(KMSG_DUMP_PANIC) is called in NMI case.
>      But if someone adds new kmsg_dump() into NMI path in the future, kmsg_dump() may deadlock. 
>      We can trap it and complain with this WARN_ON().
>      
> 
>  With this patch, kmsg_dump()/pstore_dump() work as follows.
>    panic case (KMSG_DUMP_PANIC):
>      - don't take lock because they are serialized.
> 
>    not panic case (KMSG_DUMP_OOPS/KMSG_DUMP_EMERG/KMSG_DUMP_RESTART/KMSG_DUMP_HALT):
>      - take locks normally
>  
>  Regarding as NMI case,
>     - kmsg_dump()/pstore_dump() don't take locks, so deadlock issue will not happen
>       because kmsg_dump() is called in just panic case with current implementation.
>     - If someone adds new kmsg_dump() into NMI path, WARN_ON() is called.
>       So we can trap it and ask to fix it.
> 
>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> 
> ---
>  fs/pstore/platform.c |   16 ++++++----------
>  kernel/printk.c      |   13 +++++++++++--
>  2 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index 57bbf90..823669e 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -90,18 +90,17 @@ static void pstore_dump(struct kmsg_dumper *dumper,
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
> +	/*
> +	 * pstore_dump() is serialized in panic path.
> +	 * So, we don't need to take any locks.
> +	 */
> +	if (reason != KMSG_DUMP_PANIC)
>  		spin_lock_irqsave(&psinfo->buf_lock, flags);

This probably won't work because the original check wasn't necessarily for
locking purposes but to see if a lock was already taken in the serialized
path.  If buf_lock is already held, the code may have trouble executing
the backend, hence the pr_err.


>  	oopscount++;
>  	while (total < kmsg_bytes) {
> @@ -131,10 +130,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
>  		total += l1_cpy + l2_cpy;
>  		part++;
>  	}
> -	if (in_nmi()) {
> -		if (is_locked)
> -			spin_unlock(&psinfo->buf_lock);
> -	} else
> +	if (reason != KMSG_DUMP_PANIC)
>  		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
>  }
>  
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 1455a0d..bc5ac61 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1732,13 +1732,22 @@ void kmsg_dump(enum kmsg_dump_reason reason)
>  	unsigned long l1, l2;
>  	unsigned long flags;
>  
> +	WARN_ON(in_nmi() && reason != KMSG_DUMP_PANIC);
> +

You will need a comment to explain why the above is there.

>  	/* Theoretically, the log could move on after we do this, but
>  	   there's not a lot we can do about that. The new messages
>  	   will overwrite the start of what we dump. */
> -	raw_spin_lock_irqsave(&logbuf_lock, flags);
> +
> +	/*
> +	 * kmsg_dump(KMSG_DUMP_PANIC) is serialized.
> +	 * So, we don't need to take any locks.
> +	 */
> +	if (reason != KMSG_DUMP_PANIC)
> +		raw_spin_lock_irqsave(&logbuf_lock, flags);
>  	end = log_end & LOG_BUF_MASK;
>  	chars = logged_chars;
> -	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
> +	if (reason != KMSG_DUMP_PANIC)
> +		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
>  
>  	if (chars > end) {
>  		s1 = log_buf + log_buf_len - chars + end;

Cheers,
Don
