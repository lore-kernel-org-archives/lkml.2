Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab0ICPau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 11:30:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:55068 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab0ICPat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 11:30:49 -0400
Subject: Re: IPC between application and xserver is causing extra context
 switches
From: Peter Zijlstra <peterz@infradead.org>
To: Pauli Nieminen <ext-pauli.nieminen@nokia.com>
Cc: ext Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jhnikula@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pauli <suokkos@gmail.com>
In-Reply-To: <20100903142432.GG19353@squeeze>
References: <20100809150211.GA29771@burn-it> <20100901025817.GA6200@Krystal>
	 <20100903071738.GA19353@squeeze> <1283499074.1783.59.camel@laptop>
	 <20100903142432.GG19353@squeeze>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Sep 2010 17:30:43 +0200
Message-ID: <1283527843.2050.161.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-03 at 17:24 +0300, Pauli Nieminen wrote:
> On 03/09/10 09:31 +0200, ext Peter Zijlstra wrote:
> > On Fri, 2010-09-03 at 10:17 +0300, Pauli Nieminen wrote:
> > > Scheduling at write is wrong because xserver doesn't know about client
> > > priorities. 
> > 
> > Waking up the client at write is correct because you don't know if there
> > is more to be written.
> > 
> 
> IMO xserver is already signaling kernel when there is nothing more to write.
> There is nothing more to write when xserver calls select after processing
> request and writing responses.
> 
> O_NONBLOCK is set for file descriptors if it matters.
> 
> syscalls will be:
> 
> select(all_fds);
> 
> read(2, ...);
> read(5, ...);
> 
> writev(3, ...);
> writev(5, ...);
> writev(6, ...);
> 
> select(all_fds);
> 
> Of course this is a lot simplified what really happens.

I don't see how that is relevant to anything, POSIX certainly doesn't
mandate anything like that, hence we need to wake up the receiving side
as soon as data arrives.

Scheduling can happen at _any_ time, not only system calls. Waking a
task happens at the moment its blocking condition changes.

In particular, the other process' select()/read() blocks until there is
data available (or a signal arrives), the write() provides data,
therefore a wakeup happens.

The POSIX task model allows for full non-voluntary preemption and Linux
takes full advantage of that.

An application assuming anything else for correct execution is broken.
