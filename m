Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046Ab2JaUFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:05:19 -0400
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:59915 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957Ab2JaUFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:05:17 -0400
Date: Wed, 31 Oct 2012 16:03:52 -0400
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: davem@davemloft.net, dwmw2@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] pppoatm: fix race condition with destroying of
 vcc
Message-ID: <20121031160352.68353ecc@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <20121031094147.GA1004@shrek.podlesie.net>
References: <1350926091-12642-2-git-send-email-krzysiek@podlesie.net>
	<201210301426.q9UEQkI7007209@thirdoffive.cmf.nrl.navy.mil>
	<20121030182001.GA30373@shrek.podlesie.net>
	<20121031094147.GA1004@shrek.podlesie.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012 10:41:47 +0100
Krzysztof Mazur <krzysiek@podlesie.net> wrote:

> On Tue, Oct 30, 2012 at 07:20:01PM +0100, Krzysztof Mazur wrote:
> > Yes, this problem can be probably fixed by reversing close and push
> > and adding some synchronization to pppoatm_unassign_vcc(), but I think
> > we need that locking anyway, for instance for synchronization for
> > checking and incrementing sk->sk_wmem_alloc, between pppoatm_send()
> > and vcc_sendmsg().
> > 
> 
> I think that the same problem exists in other drivers (net/atm/br2684.c,
> net/atm/clip.c, maybe other).
>
> Reversing order of close() and push(vcc, NULL) operations seems to
> be a good idea, but synchronization with push(vcc, NULL)
> and function that calls vcc->send() must be added to all drivers.

this was the scheme that was (and is) currently in place.  detaching a
protocol from the atm layer never had a separate function, so it was
decided at some point to just push a NULL skb as a signal to the next
layer that i needed to cleanly shutdown and detach.  the push(vcc,
NULL) always happens in a sleepable context, so waiting for whatever
attached protocol scheduler to finish up is not a problem.  after the
pushing of the skb NULL, the attached protocol should not send or recv
any data on that vcc.

reversing the order of the push and close certainly seems like the right
thing to do. i would like to see if it would fix your problem.  making
the minimal change to get something working would be preferred before
adding additional complexity.  i am just surprised we havent seen this
bug before.

> I think it's better to just use ATM socket lock - lock_sock(sk_atm(vcc)),
> it will fix also problems with synchronization with vcc_sendmsg()
> and possibly other functions (ioctl?).
> 
> I think that we should add a wrapper to vcc->send(), based on
> fixed pppoatm_send(), that performs required checks and takes the ATM socket
> lock.
> 
> But I think we should reverse those operations anyway, because some
> drivers may use other locks, not ATM socket lock, for proper
> synchronization.

i dont think this is a bad idea.  vcc_release_async() could happen
(this would be a bit unusual for a pvc but removing the usbatm device
would do this) and there is no point in sending on a vcc that is
closing.
