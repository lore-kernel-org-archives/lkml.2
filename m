Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab1HYOsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:48:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:60931 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1HYOsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:48:00 -0400
Subject: Re: perf: overflow signal survives an exec call starting in 3.0
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        acme@ghostprotocols.net, Stephane Eranian <eranian@gmail.com>,
        krentel@cs.rice.edu
Date: Thu, 25 Aug 2011 16:47:24 +0200
References: <alpine.DEB.2.00.1108231127380.30837@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314283644.27911.27.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 16:37 +0200, Peter Zijlstra wrote:
> On Tue, 2011-08-23 at 11:36 -0400, Vince Weaver wrote:
> > I'm guessing this was an unintended change, although what to do in
> > this situation is a bit vague.
> 
> > 
> > commit f506b3dc0ec454a16d40cab9ee5d75435b39dc50
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Thu May 26 17:02:53 2011 +0200
> > 
> >     perf: Fix SIGIO handling 
> 
> Ah, quite... its a combination of way too many weird things.
> 
> So that change made it possible (as requested) to receive a signal
> without having to mmap() the buffer, which seems like a perfectly sane
> thing.
> 
> Now, looking at fs/exec.c:setup_new_exec() we see that we only call
> perf_event_exit_task() when we cross a security domain. 
> 
> Previously the exec() would have wiped out the mmap, and hence the
> counter would have stopped sending signals (but not stopped counting).
> 
> Now exec() doesn't normally close fds, so the counter stays around and
> with the new scheme continues sending signals.
> 
> I think the message is, don't do that then.. and use fcntl(fd, F_SETFD,
> FD_CLOEXEC) or so.

That is, I suspect you can get into the same trouble by creating a pipe,
setting F_SETOWN on the read side and then calling exec() while ensuring
someone writes to the thing at the right moment.


