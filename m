Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0FRHcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 03:32:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754214Ab0FRHcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 03:32:35 -0400
Date: Fri, 18 Jun 2010 00:31:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
       Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
Message-Id: <20100618003127.10d9e6c8.akpm@linux-foundation.org>
In-Reply-To: <4C1B1D3F.8030509@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	<4C17C598.7070303@kernel.org>
	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	<4C18BF40.40607@kernel.org>
	<1276694825.9309.12.camel@m0nster>
	<4C18D1FD.9060804@kernel.org>
	<1276695665.9309.17.camel@m0nster>
	<4C18D574.1040903@kernel.org>
	<1276697146.9309.27.camel@m0nster>
	<1276776066.2461.15.camel@localhost>
	<20100617161619.d3ebd73d.akpm@linux-foundation.org>
	<4C1B1D3F.8030509@kernel.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010 09:16:15 +0200 Tejun Heo <tj@kernel.org> wrote:

> On 06/18/2010 01:16 AM, Andrew Morton wrote:
> > On Thu, 17 Jun 2010 08:01:06 -0400
> > Andy Walls <awalls@md.metrocast.net> wrote:
> > 
> >> I'm going to agree with Tejun, that tweaking worker thread priorities
> >> seems like an odd thing, since they are meant to handle deferable
> >> actions - things that can be put off until later.
> > 
> > Disagree.  If you're in an interrupt handler and have some work which
> > you want done in process context and you want it done RIGHT NOW then
> > handing that work off to a realtime-policy worker thread is a fine way of
> > doing that.
> 
> In that case, the right thing to do would be using threaded interrupt
> handler.  It's not only easier but also provide enough context such
> that RT kernel can do the right thing.

Nope.  Consider a simple byte-at-a-time rx handler.  The ISR grabs the
byte, stashes it away, bangs on the hardware a bit then signals
userspace to promptly start processing that byte.  Very simple,
legitimate and a valid thing to do.

Also the "interrupt" code might be running from a timer handler.  Or it
might just be in process context, buried in a forest of locks and wants
to punt further processing into a separate process.

