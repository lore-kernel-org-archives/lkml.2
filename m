Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab1LMTe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 14:34:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:39228 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab1LMTe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 14:34:27 -0500
Message-ID: <1323804803.9082.40.camel@twins>
Subject: printk() vs tty_io
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <greg@kroah.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 13 Dec 2011 20:33:23 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi tty folks,

I've been poking at reducing the constraints on printk(), like make it
work under rq->lock etc..

Aside from a fwd port of the patch that abuses the console_sem.lock:
https://lkml.org/lkml/2011/6/9/298 and a few other not so very pretty
patches, I ran into the following lockdep splat (using a not so very
pretty lockdep early_printk() patch):

watchdog/0/10 is trying to acquire lock:
 ((console_sem).lock){-.-...}, at: 
but task is already holding lock:
 (&rt_rq->rt_runtime_lock){-.-...}, at: 
which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #5 (&rt_rq->rt_runtime_lock){-.-...}:
-> #4 (&rq->lock){-.-.-.}:
-> #3 (&p->pi_lock){-.-.-.}:
-> #2 (&tty->write_wait){-.-...}:
-> #1 (&port_lock_key){-.-...}:
-> #0 ((console_sem).lock){-.-...}:

It turns out that writing to a console does wakeups due to tty_io.c.

My question is basically, is there a feasible way around doing these
wakeups from the console::write() path? Everything I thought of was
really quite horrible... and very likely would break stuff since I'm not
that well versed in the whole tty thing.


