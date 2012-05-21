Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2EUPnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:43:32 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54731 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2EUPn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:43:29 -0400
Subject: Re: [V2 PATCH 9/9] vhost: zerocopy: poll vq in zerocopy callback
From: Shirley Ma <mashirle@us.ibm.com>
To: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, davem@davemloft.net
In-Reply-To: <4FB9DB24.2040408@redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <20120502034254.11782.27314.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <1337100630.8220.4.camel@oc3660625478.ibm.com> <4FB317C8.90002@redhat.com>
	 <1337181027.10741.13.camel@oc3660625478.ibm.com>
	 <20120516151444.GC9934@redhat.com>
	 <1337189525.10741.24.camel@oc3660625478.ibm.com>
	 <4FB4677A.8020402@redhat.com>
	 <1337268862.10741.58.camel@oc3660625478.ibm.com>
	 <4FB61D57.4030103@redhat.com>
	 <1337354974.12999.12.camel@oc3660625478.ibm.com>
	 <4FB9DB24.2040408@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 May 2012 08:42:52 -0700
Message-ID: <1337614972.12999.56.camel@oc3660625478.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052115-1780-0000-0000-000005C21C60
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000276; HX=3.00000188; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00141129; UDB=6.00032620; UTC=2012-05-21
 15:43:26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 14:05 +0800, Jason Wang wrote:
> >> - tx polling depends on skb_orphan() which is often called by
> device
> >> driver when it place the packet into the queue of the devices
> instead
> >> of  when the packets were sent. So it was too early for vhost to be
> >> notified.
> > Then do you think it's better to replace with vhost_poll_queue here
> > instead?
> 
> Just like what does this patch do - calling vhost_poll_queue() in 
> vhost_zerocopy_callback().
> >> - it only works when the pending DMAs exceeds VHOST_MAX_PEND, it's
> >> highly possible that guest needs to be notified when the pending
> >> packets
> >> isn't so much.
> > In which situation the guest needs to be notified when there is no
> TX
> > besides buffers run out?
> 
> Consider guest call virtqueue_enable_cb_delayed() which means it only 
> need to be notified when 3/4 of pending buffers ( about 178 buffers 
> (256-MAX_SKB_FRAGS-2)*3/4 ) were sent by host. So vhost_net would
> notify 
> guest when about 60 buffers were pending. Since tx polling is only 
> enabled when pending packets exceeds VHOST_MAX_PEND 128, so tx work 
> would not be notified to run and guest would never get the interrupt
> it 
> expected to re-enable the queue.

So it seems we still need vhost_enable_notify() in handle_tx when there
is no tx in zerocopy case.

Do you know which one is more expensive: the cost of vhost_poll_queue()
in each zerocopy callback or calling vhost_enable_notify()?

Have you compared the results by removing below code in handle_tx()?

-                       if (unlikely(num_pends > VHOST_MAX_PEND)) {
-                                tx_poll_start(net, sock);
-                                set_bit(SOCK_ASYNC_NOSPACE, &sock->flags);
-                                break;
-                        }

> 
> And just like what we've discussed, tx polling based adding and 
> signaling is too early for vhost. 

Thanks
Shirley

