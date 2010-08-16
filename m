Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab0HPVmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 17:42:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:43618 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab0HPVmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 17:42:50 -0400
Subject: Re: lockdep false positive? -- firewire-core transaction timer vs.
 scsi-core host lock
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de>
References: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 23:42:19 +0200
Message-ID: <1281994939.1926.2075.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 20:42 +0200, Stefan Richter wrote:
> What does this all mean?  How to act on it?
> 
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.35 #1
> ---------------------------------------------------------
> swapper/0 just changed the state of lock:
>  (&t->split_timeout_timer){+.-...}, at: [<c1032228>] run_timer_softirq+0x112/0x21c
> but this lock was taken by another, HARDIRQ-safe lock in the past:
>  (&(shost->host_lock)->rlock){-.-...}
> 
> and interrupts could create inverse lock ordering between them.


It says the locks nest like:

 (&(shost->host_lock)->rlock){-.-...}
   (&t->split_timeout_timer){+.-...}

But:


>  -> (&(shost->host_lock)->rlock){-.-...} ops: 123308 {
>     IN-HARDIRQ-W at:
>                           [<c104a080>] __lock_acquire+0x612/0x153e
>                           [<c104b008>] lock_acquire+0x5c/0x73
>                           [<c1268b57>] _raw_spin_lock_irqsave+0x2e/0x3e
>                           [<c11ad508>] scsi_eh_scmd_add+0x25/0x8a

...

vs

> -> (&t->split_timeout_timer){+.-...} ops: 14281 {
>    HARDIRQ-ON-W at:
>                         [<c104a100>] __lock_acquire+0x692/0x153e
>                         [<c104b008>] lock_acquire+0x5c/0x73
>                         [<c1032291>] run_timer_softirq+0x17b/0x21c
>                         [<c102defb>] __do_softirq+0x8b/0x10a
>                         [<c102dfa5>] do_softirq+0x2b/0x43

...


So shost->host_lock->rlock is a lock used in hardirq context but
split_timeout_timer is a !irq-safe lock.

Which means that it now worries the following can happen:

softirq:
  spin_lock(&t->split_timeout_timer);

IRQ:
  spin_lock(&(shost->host_lock)->rlock);
   spin_lock(&t->split_timeout_timer);

Now, the thing is that split_timeout_timer is a fake lock used to
annotate timers, its use is to connect lock chains from within the timer
callback to del_timer_sync() callers, to detect deadlocks.

Now, I can't seem to remember why del_timer_sync() explicitly disables
IRQs but call_timer_fn() does not, Johill, happen to remember?
