Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1KGMzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:55:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:60424 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330Ab1KGMzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:55:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,470,1315206000"; 
   d="scan'208";a="34029311"
Date: Mon, 7 Nov 2011 13:06:43 +0000
From: Alan Cox <alan@linux.intel.com>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Race condition in tty buffer's function
 flush_to_ldisc().
Message-ID: <20111107130643.07e84fca@bob.linux.org.uk>
In-Reply-To: <4EB7CCFF.5090304@ilyx.ru>
References: <4EB7BD9A.7070600@ilyx.ru>
	<20111107115802.23201d45@bob.linux.org.uk>
	<4EB7CCFF.5090304@ilyx.ru>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> if (!test_and_set_bit(TTY_FLUSHING, &tty->flags)) {
> 	.....
> } else
> 	prink...
> In my syslog appear this prink on pty devices.

Then we need to understand the call paths that did this. I suspect it
may be a bug in the hacks Linus made to n_tty. They've always bothered
me as they never looked correct.

Can you get traces to see if it is actually calling flush_to_ldisc
multithreaded on a given tty

> Why we need: "if (!test_and_set_bit(TTY_FLUSHING, &tty->flags)) {"
> if flush_to_ldisc is single threaded?
> we can: set_bit(TTY_FLUSHING, &tty->flags)
> without if() at all.

It is single threaded with respect to itself (you can't have two
flush_to_ldisc on the same tty at once) but you can have a parallel
call to tty_buffer_flush. The tty_buffer_flush path needs to pick the
right approach reliably.

So the theory is

If TTY_FLUSHING is set then tty_buffer_flush lets the flush_to_ldisc do
the work. During this time we won't fluish a buffer under the ldisc.

If TTY_FLUSHING is not set then we will do the flush directly. As we
hold tty->buf.lock at that point the two cannot race as far as I can
see.

We are actually now probably at the point we could take a per tty mutex
on the flush_to_ldisc and use it to tidy up ldisc change, flush and
other things. So this code could welll be something worth simplifying
once the rest of the tty_lock() is cleaned out.

Alan
