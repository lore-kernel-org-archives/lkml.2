Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab1FEIj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 04:39:59 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:44751 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab1FEIj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 04:39:58 -0400
Subject: Re: Mysterious CFQ crash and RCU
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Date: Sun, 05 Jun 2011 10:39:55 +0200
In-Reply-To: <4DEB28A1.5090109@fusionio.com>
References: <20110519222404.GG12600@redhat.com>
		 <20110521210013.GJ2271@linux.vnet.ibm.com>
		 <20110523152141.GB4019@redhat.com>
		 <20110523153848.GC2310@linux.vnet.ibm.com>
		 <1306401337.27271.3.camel@t41.thuisdomein>
		 <20110603050724.GB2304@linux.vnet.ibm.com>
		 <1307191830.23387.24.camel@t41.thuisdomein>
		 <20110604160326.GA6093@linux.vnet.ibm.com>
	 <1307227686.28359.23.camel@t41.thuisdomein> <4DEB28A1.5090109@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307263197.28359.42.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-05 at 08:56 +0200, Jens Axboe wrote:
> Does this fix it? It will introduce a hierarchy that is queue -> ioc
> lock, but as far as I can remember (and tell from a quick look), we
> don't have any dependencies on that order of locking at this moment. So
> should be OK.
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 3c7b537..fa7ef54 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2772,8 +2772,11 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
>  	smp_wmb();
>  	cic->key = cfqd_dead_key(cfqd);
>  
> -	if (ioc->ioc_data == cic)
> +	if (ioc->ioc_data == cic) {
> +		spin_lock(&ioc->lock);
>  		rcu_assign_pointer(ioc->ioc_data, NULL);
> +		spin_unlock(&ioc->lock);
> +	}
>  
>  	if (cic->cfqq[BLK_RW_ASYNC]) {
>  		cfq_exit_cfqq(cfqd, cic->cfqq[BLK_RW_ASYNC]);
> 

0) I'd guess not, as the last thing I tried before simply ripping
io_context.ioc_data out, was:

        spin_lock_irqsave(&ioc->lock, flags);
        rcu_read_lock();
        ioc_data = rcu_dereference(ioc->ioc_data);
        rcu_read_unlock();
        if (ioc_data == cic)
                rcu_assign_pointer(ioc->ioc_data, NULL);
        spin_unlock_irqrestore(&ioc->lock, flags);

(By this time I had already wrapped all access to io_context.ioc_data in
rcu_read_lock(), rcu_dereference(), and rcu_read_unlock() voodoo. I also
wrapped all access of io_context members - other than refcount and
nr_tasks - in a spin_lock_irqsave()/spin_unlock_irqrestore() on
io_context.lock. This gave no warnings, nor lockups, but the code just
kept crashing in the exact same location it always did!)

1) Of course, by now I have forgotten what I had in mind when I stopped
working on this last night. My first bet currently is to change the core
of cic_free_func() into something like:

        spin_lock_irqsave(&ioc->lock, flags);
        radix_tree_delete(&ioc->radix_root, dead_key >>
CIC_DEAD_INDEX_SHIFT);

        rcu_read_lock();
        ioc_data = rcu_dereference(ioc->ioc_data);
        rcu_read_unlock();
        if (ioc_data == cic)
		rcu_assign_pointer(ioc->ioc_data, NULL);

        hlist_del_rcu(&cic->cic_list);
        spin_unlock_irqrestore(&ioc->lock, flags);

2) But, I must admit I'm not yet at full speed today.


Paul Bolle

