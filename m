Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab1HNGFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 02:05:38 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:47140 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab1HNGFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 02:05:36 -0400
Date: Sun, 14 Aug 2011 02:05:25 -0400 (EDT)
From: Jason Wang <jasowang@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, davem@davemloft.net,
        krkumar2@in.ibm.com, rusty@rustcorp.com.au, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, mirq-linux@rere.qmqm.pl
Message-ID: <1465655104.165911.1313301925197.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1313159376.2354.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [net-next RFC PATCH 4/7] tuntap: multiqueue support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> Le vendredi 12 août 2011 à 09:55 +0800, Jason Wang a écrit :
> 
> >+ rxq = skb_get_rxhash(skb);
> >+ if (rxq) {
> >+ tfile = rcu_dereference(tun->tfiles[rxq % numqueues]);
> >+ if (tfile)
> >+ goto out;
> >+ }
> 
> You can avoid an expensive divide with following trick :
> 
> u32 idx = ((u64)rxq * numqueues) >> 32;
> 

Sure.

> 
> 
> > -static struct tun_struct *tun_get(struct file *file)
> > +static void tun_detach_all(struct net_device *dev)
> >  {
> > - return __tun_get(file->private_data);
> > + struct tun_struct *tun = netdev_priv(dev);
> > + struct tun_file *tfile, *tfile_list[MAX_TAP_QUEUES];
> > + int i, j = 0;
> > +
> > + spin_lock(&tun_lock);
> > +
> > + for (i = 0; i < MAX_TAP_QUEUES && tun->numqueues; i++) {
> > + tfile = rcu_dereference_protected(tun->tfiles[i],
> > + lockdep_is_held(&tun_lock));
> > + if (tfile) {
> > + wake_up_all(&tfile->wq.wait);
> > + tfile_list[i++] = tfile;
> 
> typo here, you want tfile_list[j++] = tfile;
> 

Yes, thanks for catching this.

> > + rcu_assign_pointer(tun->tfiles[i], NULL);
> > + rcu_assign_pointer(tfile->tun, NULL);
> > + --tun->numqueues;
> > + }
> > + }
> > + BUG_ON(tun->numqueues != 0);
> > + spin_unlock(&tun_lock);
> > +
> > + synchronize_rcu();
> > + for(--j; j >= 0; j--)
> > + sock_put(&tfile_list[j]->sk);
> >  }
> >
> 
> Could you take a look at net/packet/af_packet.c, to check how David
> did
> the whole fanout thing ?
> 
> __fanout_unlink()
> 
> Trick is to not leave NULL entries in the tun->tfiles[] array.
> 
> It makes things easier in hot path.

Sure I would go to take a look at this.

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
