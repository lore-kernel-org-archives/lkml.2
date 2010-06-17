Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774Ab0FQKir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 06:38:47 -0400
Received: from smtp6.freeserve.com ([193.252.22.190]:45047 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab0FQKiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 06:38:46 -0400
X-ME-UUID: 20100617103842347.54E75700415F@mwinf3604.me.freeserve.com
Date: Thu, 17 Jun 2010 11:38:15 +0100
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Jeff Layton <jlayton@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nfsd hang and kernel bug in 2.6.35-rc3
Message-ID: <20100617113815.7e15d070@boulder.homenet>
In-Reply-To: <20100616204415.49285875@corrin.poochiereds.net>
References: <20100615175034.1e015fbc@boulder.homenet>
	<20100616153603.GH10223@fieldses.org>
	<20100616123532.569efeb9@tlielax.poochiereds.net>
	<20100616220824.4e886552@boulder.homenet>
	<20100616204415.49285875@corrin.poochiereds.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 20:44:15 -0400
Jeff Layton <jlayton@redhat.com> wrote:
[snip]
> I stand corrected then. That's pretty close to the nfsd that I've been
> testing. I pulled down the nfsd init script and the only thing that
> looks substantially different is that it sends signals to nfsd to shut
> it down rather than just running "rpc.nfsd 0". That should work fine,
> however.
> 
> Still I think the problem is basically something like what I've
> described. You ended up somehow with sockets on the sv_permsocks list
> that didn't hold lockd references. The way I described is one way that
> could occur. Another seems to be __write_ports_addxprt (which I think
> is clearly broken in light of this)...
> 
> The root cause of this however is likely to be related to this
> problem:
> 
> > Jun 15 16:07:18 laptop kernel: svc: failed to register lockdv3 RPC
> > service (errno 110). Jun 15 16:07:18 laptop kernel: lockd_up:
> > makesock failed, error=-110
> 
> ...which means that the kernel couldn't talk to portmap or rpcbind.
> Maybe it wasn't up at the time? Or a problem with firewalling?

My initial reaction was "of course it is up" but your mention of
portmap sent me investigating with interesting results. I was going
to say "of course its is up" because the standard start-up script for
nfsd (rc.nfsd) checks whether rpc.portmap and rpc.statd are running, if
not starts them, and then starts exportfs, rpc.rquotad, rpc.nfsd and
rpc.mountd.

However, if I start portmap and statd early on so they do not rely on
the nfsd start-up script, then nfsd starts fine, so it seems to be a
timing thing notwithstanding that they are all started (at user level)
sequentially and in the same thread/process.

The timing problem does not arise on kernel-2.6.34 and earlier. Nor
does it arise on my pentium uniprocessor machine with kernel 2.6.35-rc3,
so it could well be core/thread related.  It looks as if something in
the kernel has changed on that in 2.6.35 which provokes the kernel bug
report if timing is wrong.  (If timing is wrong and if this is a user
tools rather than a kernel deficiency, and I express no view on that,
then I suppose it probably needs to be handled more gracefully in the
kernel.)

Chris


