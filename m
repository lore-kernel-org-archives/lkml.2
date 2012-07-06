Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab2GFIJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:09:48 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:52952 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2GFIJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:09:23 -0400
Message-ID: <1341562204.3377.5.camel@lappy>
Subject: Re: [net-next RFC V5 5/5] virtio_net: support negotiating the
 number of queues through ctrl vq
From: Sasha Levin <levinsasha928@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, mashirle@us.ibm.com, krkumar2@in.ibm.com,
        habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        akong@redhat.com, kvm@vger.kernel.org, sri@us.ibm.com
Date: Fri, 06 Jul 2012 10:10:04 +0200
In-Reply-To: <4FF65966.9040600@redhat.com>
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com>
	  <1341484194-8108-6-git-send-email-jasowang@redhat.com>
	 <1341492679.18786.18.camel@lappy> <4FF65966.9040600@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 11:20 +0800, Jason Wang wrote:
> On 07/05/2012 08:51 PM, Sasha Levin wrote:
> > On Thu, 2012-07-05 at 18:29 +0800, Jason Wang wrote:
> >> @@ -1387,6 +1404,10 @@ static int virtnet_probe(struct virtio_device *vdev)
> >>          if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
> >>                  vi->has_cvq = true;
> >>
> >> +       /* Use single tx/rx queue pair as default */
> >> +       vi->num_queue_pairs = 1;
> >> +       vi->total_queue_pairs = num_queue_pairs;
> > The code is using this "default" even if the amount of queue pairs it
> > wants was specified during initialization. This basically limits any
> > device to use 1 pair when starting up.
> >
> 
> Yes, currently the virtio-net driver would use 1 txq/txq by default 
> since multiqueue may not outperform in all kinds of workload. So it's 
> better to keep it as default and let user enable multiqueue by ethtool -L.

I think it makes sense to set it to 1 if the amount of initial queue
pairs wasn't specified.

On the other hand, if a virtio-net driver was probed to provide
VIRTIO_NET_F_MULTIQUEUE and has set something reasonable in
virtio_net_config.num_queues, then that setting shouldn't be quietly
ignored and reset back to 1.

What I'm basically saying is that I agree that the *default* should be 1
- but if the user has explicitly asked for something else during
initialization, then the default should be overridden.

