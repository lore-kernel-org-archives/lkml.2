Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab0DILu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 07:50:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47412 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750856Ab0DILu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 07:50:26 -0400
Date: Fri, 9 Apr 2010 12:54:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Schnell <mschnell@lumino.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: atomic RAM ?
Message-ID: <20100409125426.5bc200da@lxorguk.ukuu.org.uk>
In-Reply-To: <4BBF0784.2060002@lumino.de>
References: <4BBD86A5.5030109@lumino.de>
	<20100408114542.47b6589a@lxorguk.ukuu.org.uk>
	<4BBDC7D4.6040301@lumino.de>
	<20100408143750.0acebaa1@lxorguk.ukuu.org.uk>
	<4BBF0784.2060002@lumino.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If "you" is You that might be true. But if "you" is me its utterly and
> totally wrong. For my heavily multithreaded application I need FUTEX but
> not SMP (yet). For me, SMP is no advantage if it does not support FUTEX
> and I suppose the SMP solution with a single hardware mutex can't do
> this (but maybe I'm wrong here and a software workaround is possible).

You are completing missing the point

Linux + glibc platforms don't "need" futex - you need fast user space
locks. Futex is an implementation of those locks really based around
platforms with atomic instructions. People were doing fast user space
locks before Linus was even born and on machines without atomic
operations.

Seperate out
- the purpose for which the system exists (fast user locking)
- the interfaces by which it must be presented (posix pthread mutex)
- the implementation of the system

> pthread_mutex..() uses FUTEX if available with the arch, so FUTEX is a
> way of complying to the POSIX standard. Of course there are other ways
> (that pthread_mutex_...() use if FUTEX is not available) but this asks
> for Kernel calls with any lock and any unlock and thus is a lot slower -
> maybe unusable with certain applications.

Nope. Glibc allows you to implement arch specific code for these locks
which may not be FUTEX but need not be kernel based. The user space
mechanics of the futex stuff include platform specific stuff for all
platforms. You might do the blocking kernel parts of it via the futex
syscall but what matters are the uncontended fast paths which are arch
specific C library code.

> IMHO, the only decent way to go is to provide FUTEX perfectly compatible
> to what other archs do, and thus have it be accessed via pthread_mutex()
> so that any "standard" POSIX compatible multithreaded application will
> take advantage of the speed gain.

You clearly need a pthread_mutex that is fast - but the idea that this
means FUTEX is misleading and futex on each platform in the user space
side is different per architecture anyway.

The idea that you need atomic operations to do fast user space locking is
also of course wrong - you only need store ordering.


Alan
