Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab0DMRoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 13:44:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab0DMRoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 13:44:32 -0400
Date: Tue, 13 Apr 2010 20:39:19 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>,
       "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.hengli.com.au>,
       Paul Moore <paul.moore@hp.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] tun: orphan an skb on tx
Message-ID: <20100413173919.GC26011@redhat.com>
References: <20100413145944.GA7716@redhat.com> <4BC48F79.5090409@siemens.com> <1271176838.16881.537.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1271176838.16881.537.camel@edumazet-laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 06:40:38PM +0200, Eric Dumazet wrote:
> Le mardi 13 avril 2010 à 17:36 +0200, Jan Kiszka a écrit :
> > Michael S. Tsirkin wrote:
> > > The following situation was observed in the field:
> > > tap1 sends packets, tap2 does not consume them, as a result
> > > tap1 can not be closed.
> > 
> > And before that, tap1 may not be able to send further packets to anyone
> > else on the bridge as its TX resources were blocked by tap2 - that's
> > what we saw in the field.
> > 
> 
> After the patch, tap1 is able to flood tap2, and tap3/tap4 not able to
> send one single frame. Is it OK ?

Yes :) This was always possible. Number of senders needed to flood
a receiver might vary depending on send/recv queue size
that you set. External sources can also fill your RX queue
if you let them. In the end, we need to rely on the scheduler for fairness,
or apply packet shaping.

> Back to the problem : tap1 cannot be closed.
> 
> Why ? because of refcounts ?

Yes.

> When a socket with inflight tx packets is closed, we dont block the
> close, we only delay the socket freeing once all packets were delivered
> and freed.
> 

Which is wrong, since this is under userspace control, so you get
unkillable processes.

-- 
MST
