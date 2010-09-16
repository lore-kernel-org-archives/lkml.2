Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab0IPAKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 20:10:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44967 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab0IPAKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 20:10:21 -0400
Date: Wed, 15 Sep 2010 21:10:12 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Mat Martineau <mathewm@codeaurora.org>
Cc: linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org, davem@davemloft.net
Subject: Re: Possible regression with skb_clone() in 2.6.36
Message-ID: <20100916001012.GA5656@vigoh>
References: <1283988727-1456-1-git-send-email-padovan@profusion.mobi>
 <alpine.DEB.2.00.1009100920270.14322@linux-sea-02>
 <20100910194509.GC19693@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910194509.GC19693@vigoh>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gustavo F. Padovan <padovan@profusion.mobi> [2010-09-10 16:45:09 -0300]:

> Hi Mat,
> 
> * Mat Martineau <mathewm@codeaurora.org> [2010-09-10 09:53:31 -0700]:
> 
> > 
> > Gustavo -
> > 
> > I'm not sure why the streaming code used to work, but this does not 
> > look like an skb_clone() problem.  Your patch to remove the 
> > skb_clone() call in l2cap_streaming_send() addresses the root cause of 
> > this crash.
> > 
> > On Wed, 8 Sep 2010, Gustavo F. Padovan wrote:
> > 
> > > I've been experiencing some problems when running the L2CAP Streaming mode in
> > > 2.6.36. The system quickly runs in an Out Of Memory condition and crash. That
> > > wasn't happening before, so I think we may have a regression here (I didn't
> > > find where yet). The crash log is below.
> > >
> > > The following patch does not fix the regression, but shows that removing the
> > > skb_clone() call from l2cap_streaming_send() we workaround the problem. The
> > > patch is good anyway because it saves memory and time.
> > >
> > > By now I have no idea on how to fix this.
> > >
> > > <snip>
> > 
> > This has to do with the sk->sk_wmem_alloc accounting that controls the 
> > amount of write buffer space used on the socket.
> > 
> > When the L2CAP streaming mode socket segments its data, it allocates 
> > memory using sock_alloc_send_skb() (via bt_skb_send_alloc()).  Before 
> > that allocation call returns, skb_set_owner_w() is called on the new 
> > skb.  This adds to sk->sk_wmem_alloc and sets skb->destructor so that 
> > sk->sk_wmem_alloc is correctly updated when the skb is freed.
> > 
> > When that skb is cloned, the clone is not "owned" by the write buffer. 
> > The clone's destructor is set to NULL in __skb_clone().  The version 
> > of l2cap_streaming_send() that runs out of memory is passing the 
> > non-owned skb clone down to the HCI layer.  The original skb (the one 
> > that's "owned by w") is immediately freed, which adjusts 
> > sk->sk_wmem_alloc back down - the socket thinks it has unlimited write 
> > buffer space.  As a result, bt_skb_send_alloc() never blocks waiting 
> > for buffer space (or returns EAGAIN for nonblocking writes) and the 
> > HCI send queue keeps growing.
> 
> If the problem is what you are saying, add a skb_set_owner_w(skb, sk) on
> the cloned skb should solve the problem, but it doesn't. That's exactly
> what tcp_transmit_skb() does. Also that just appeared in 2.6.36, is was
> working fine before, i.e, we have a regression here. 
> 
> > 
> > This isn't a problem for the ERTM sends, because the original skbs are 
> > kept in the ERTM tx queue until they are acked.  Once they're acked, 
> > the write buffer space is freed and additional skbs can be allocated.
> 
> It affects ERTM as well, but in that case the kernel doesn't crash
> because ERTM block on sending trying to allocate memory. Then we are not
> able to receive any ack (everything stays queued in sk_backlog_queue as
> the sk is owned by the user) and ERTM stalls.

By reverting 

commit 218bb9dfd21472128f86b38ad2eab123205c2991
Author: Gustavo F. Padovan <padovan@profusion.mobi>
Date:   Mon Jun 21 18:53:22 2010 -0300

    Bluetooth: Add backlog queue to ERTM code
    
    backlog queue is the canonical mechanism to avoid race conditions due
    interrupts in bottom half context. After the socket lock is released the
    net core take care of push all skb in its backlog queue.
    
    Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
    Signed-off-by: Marcel Holtmann <marcel@holtmann.org>


we can workaround the bug. It's not the real cause of the bug because the
backlog queue was working before 2.6.36, but removing the backlog queue scheme
make L2CAP works again and also give us more time to find the real cause of the
problem.
    
Before  implement the backlog queue L2CAP had his own lock scheme to avoid race
conditions. The point is that the backlog queue adds too much serialization to
L2CAP, that was the cause of the ERTM bug. The old scheme (the one we are going
to use after revert this commit) just serialize access to some places. 

By not using the backlog queue, we can receive the acknowledgement frames more
quickly and then free the acked frames quickly. In fact the old scheme is
looks better than backlog queue.

I think we should proceed with the revert with this commit in mainline, and at the
same time try to find the root cause of the problem.

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
