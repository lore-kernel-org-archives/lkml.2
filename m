Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab0FQAm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 20:42:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407Ab0FQAm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 20:42:28 -0400
Date: Wed, 16 Jun 2010 20:44:15 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Chris Vine <chris@cvine.freeserve.co.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nfsd hang and kernel bug in 2.6.35-rc3
Message-ID: <20100616204415.49285875@corrin.poochiereds.net>
In-Reply-To: <20100616220824.4e886552@boulder.homenet>
References: <20100615175034.1e015fbc@boulder.homenet>
	<20100616153603.GH10223@fieldses.org>
	<20100616123532.569efeb9@tlielax.poochiereds.net>
	<20100616220824.4e886552@boulder.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 22:08:24 +0100
Chris Vine <chris@cvine.freeserve.co.uk> wrote:

> On Wed, 16 Jun 2010 12:35:32 -0400
> Jeff Layton <jlayton@redhat.com> wrote:
> [snip]
> > No, I don't think we ever saw any oopses from this, but I think I can
> > see what happened here:
> > 
> > rpc.nfsd was unable to hand any socket fd's off to the kernel due to
> > being unable to start lockd. Regardless though, it tried to start
> > threads anyway, and called into nfsd_init_socks. It then started a udp
> > socket, and tried to call lockd_up again. That failed, and it
> > returned error. Now sv_permsocks is non-empty but the socket there
> > doesn't hold a lockd reference.
> > 
> > The right fix is probably to tear down the socket when lockd_up fails
> > in nfsd_init_socks.
> > 
> > I suspect that Chris may be using an older version of rpc.nfsd though
> > that might behave a little differently than the one I was using, and
> > that might account for why he hit this and we didn't.
> > 
> > Chris, what version of nfs-utils do you have installed on this box?
> [snip]
> 
> It's the stock nfs-utils-1.2.2 which comes with slackware 13.1, which
> seems to be the latest (stable) release.
> 
> Chris
> 
> 

I stand corrected then. That's pretty close to the nfsd that I've been
testing. I pulled down the nfsd init script and the only thing that
looks substantially different is that it sends signals to nfsd to shut
it down rather than just running "rpc.nfsd 0". That should work fine,
however.

Still I think the problem is basically something like what I've
described. You ended up somehow with sockets on the sv_permsocks list
that didn't hold lockd references. The way I described is one way that
could occur. Another seems to be __write_ports_addxprt (which I think
is clearly broken in light of this)...

The root cause of this however is likely to be related to this problem:

> Jun 15 16:07:18 laptop kernel: svc: failed to register lockdv3 RPC service (errno 110).
> Jun 15 16:07:18 laptop kernel: lockd_up: makesock failed, error=-110

...which means that the kernel couldn't talk to portmap or rpcbind.
Maybe it wasn't up at the time? Or a problem with firewalling?

It might be worthwhile to try out the patches I sent to Bruce last week:

    http://marc.info/?l=linux-nfs&m=127592501528302&w=2

I'm not certain they'll help this problem, but they may. If they do, it
would be an interesting datapoint.

Cheers,
-- 
Jeff Layton <jlayton@redhat.com>
