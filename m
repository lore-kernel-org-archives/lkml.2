Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1HLO3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 10:29:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54450 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab1HLO3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 10:29:38 -0400
Subject: Re: [net-next RFC PATCH 4/7] tuntap: multiqueue support
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, davem@davemloft.net,
        krkumar2@in.ibm.com, rusty@rustcorp.com.au, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, mirq-linux@rere.qmqm.pl
In-Reply-To: <20110812015520.31613.99890.stgit@intel-e5620-16-2.englab.nay.redhat.com>
References: <20110812015221.31613.95001.stgit@intel-e5620-16-2.englab.nay.redhat.com>
	 <20110812015520.31613.99890.stgit@intel-e5620-16-2.englab.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 16:29:36 +0200
Message-ID: <1313159376.2354.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 12 août 2011 à 09:55 +0800, Jason Wang a écrit :

>+       rxq = skb_get_rxhash(skb);
>+       if (rxq) {
>+               tfile = rcu_dereference(tun->tfiles[rxq % numqueues]);
>+               if (tfile)
>+                       goto out;
>+       }

You can avoid an expensive divide with following trick :

u32 idx = ((u64)rxq * numqueues) >> 32;



> -static struct tun_struct *tun_get(struct file *file)
> +static void tun_detach_all(struct net_device *dev)
>  {
> -	return __tun_get(file->private_data);
> +	struct tun_struct *tun = netdev_priv(dev);
> +	struct tun_file *tfile, *tfile_list[MAX_TAP_QUEUES];
> +	int i, j = 0;
> +
> +	spin_lock(&tun_lock);
> +
> +	for (i = 0; i < MAX_TAP_QUEUES && tun->numqueues; i++) {
> +		tfile = rcu_dereference_protected(tun->tfiles[i],
> +						lockdep_is_held(&tun_lock));
> +		if (tfile) {
> +			wake_up_all(&tfile->wq.wait);
> +			tfile_list[i++] = tfile;

	typo here, you want tfile_list[j++] = tfile;

> +			rcu_assign_pointer(tun->tfiles[i], NULL);
> +			rcu_assign_pointer(tfile->tun, NULL);
> +			--tun->numqueues;
> +		}
> +	}
> +	BUG_ON(tun->numqueues != 0);
> +	spin_unlock(&tun_lock);
> +
> +	synchronize_rcu();
> +	for(--j; j >= 0; j--)
> +		sock_put(&tfile_list[j]->sk);
>  }
>  

Could you take a look at net/packet/af_packet.c, to check how David did
the whole fanout thing ?

__fanout_unlink() 

Trick is to not leave NULL entries in the tun->tfiles[] array.

It makes things easier in hot path.


