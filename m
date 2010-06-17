Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab0FQF3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 01:29:53 -0400
Received: from ist.d-labs.de ([213.239.218.44]:40512 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab0FQF3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 01:29:52 -0400
Date: Thu, 17 Jun 2010 07:29:20 +0200
From: Florian Mickler <florian@mickler.org>
To: Daniel Walker <dwalker@codeaurora.org>
Newsgroups: gmane.linux.kernel
Cc: Tejun Heo <tj@kernel.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
Message-ID: <20100617072920.2b09912d@schatten.dmk.lab>
In-Reply-To: <4C192404.7000004@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	<4C17C598.7070303@kernel.org>
	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	<4C18BF40.40607@kernel.org>
	<1276694825.9309.12.camel@m0nster>
	<4C18D1FD.9060804@kernel.org>
	<1276695665.9309.17.camel@m0nster>
	<4C18D574.1040903@kernel.org>
	<1276697146.9309.27.camel@m0nster>
	<4C18DC69.10704@kernel.org>
	<1276698880.9309.44.camel@m0nster>
	<4C18E4B7.5040702@kernel.org>
	<1276701074.9309.60.camel@m0nster>
	<4C18F2B8.9060805@kernel.org>
	<1276705838.9309.94.camel@m0nster>
	<4C1901E9.2080907@kernel.org>
	<1276712547.9309.172.camel@m0nster>
	<4C191BE9.1060400@kernel.org>
	<4C192404.7000004@kernel.org>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 21:20:36 +0200
Tejun Heo <tj@kernel.org> wrote:

> On 06/16/2010 08:46 PM, Tejun Heo wrote:
> > * I'm very sorry I'm breaking your hacky workaround but seriously
> >   that's another problem to solve.  Let's talk about the problem
> >   itself instead of your hacky workaround.  (I think for most cases
> >   not using workqueue in RT path would be the right thing to do.)
> 
> For example, for the actual case of amba-pl022.c you mentioned, where
> interrupt handler sometimes offloads to workqueue, convert
> amba-pl022.c to use threaded interrupt handler.  That's why it's
> there.
> 
> If you actually _solve_ the problem like this, other users wouldn't
> experience the problem at all once the update reaches them and you
> won't have to worry about your workaround breaking with the next
> kernel update or unexpected suspend/resume and we won't be having this
> discussion about adjusting workqueue priorities from userland.
> 
> There are many wrong things about working around RT latency problems
> by setting workqueue priorities from userland.  Please think about why
> the driver would have a separate workqueue for itself in the first
> place.  It was to work around the limitation of workqueue facility and
> you're arguing that, because that work around allows yet another very
> fragile workaround, the property which made the original work around
> necessary in the first place needs to stay.  That sounds really
> perverse to me.
> 

For what its worth, IMO the right thing to do would probably be to
propagate the priority through the subsystem into the driver. 

Not fumbling with thread priorities. As Tejun said, these are not
really userspace ABI ... (It's like hitting at the side of a vending
machine if the coin is stuck... may work, but definitely not
supported by the manufacturer) 

Once you have the priority in the driver you could pass it to the
workqueue subsystem (i.e. set the priority of the work) and the worker
could then assume the priority of its work.

The tricky part is probably to pass the priority from the userspace
thread to the kernel?

Cheers,
Flo
