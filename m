Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab1FBHTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 03:19:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:49065 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757514Ab1FBHTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 03:19:01 -0400
Subject: tty vs workqueue oddities
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 17:17:25 +1000
Message-ID: <1306999045.29297.55.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan !

Current upstream (but that's been around for at least 2 or 3 days) seems
to have a strange behaviour on one of my powerbooks. Something like
"dmesg" or "cat" of a large file in an X terminal "hangs" the machine
litterally for minutes. It generally recovers, so not always.

Network is unresponsive as well.

My attempts at stopping it into xmon always landed in process_one_work()
or flush_to_ldisc() from what I can tell, and a simple ftrace run shows
something that looks like an -enormous- lot of:

     kworker/0:1-258   [000]   412.105871: flush_to_ldisc <-process_one_work
     kworker/0:1-258   [000]   412.105871: tty_ldisc_ref <-flush_to_ldisc
     kworker/0:1-258   [000]   412.105872: n_tty_receive_buf <-flush_to_ldisc
     kworker/0:1-258   [000]   412.105872: kill_fasync <-n_tty_receive_buf
     kworker/0:1-258   [000]   412.105873: __wake_up <-n_tty_receive_buf
     kworker/0:1-258   [000]   412.105873: __wake_up_common <-__wake_up
     kworker/0:1-258   [000]   412.105874: default_wake_function <-__wake_up_common
     kworker/0:1-258   [000]   412.105874: try_to_wake_up <-default_wake_function
     kworker/0:1-258   [000]   412.105874: tty_throttle <-n_tty_receive_buf
     kworker/0:1-258   [000]   412.105875: mutex_lock <-tty_throttle
     kworker/0:1-258   [000]   412.105875: mutex_unlock <-tty_throttle
     kworker/0:1-258   [000]   412.105876: schedule_work <-flush_to_ldisc
     kworker/0:1-258   [000]   412.105876: queue_work <-schedule_work
     kworker/0:1-258   [000]   412.105877: queue_work_on <-queue_work
     kworker/0:1-258   [000]   412.105877: __queue_work <-queue_work_on
     kworker/0:1-258   [000]   412.105878: insert_work <-__queue_work
     kworker/0:1-258   [000]   412.105878: tty_ldisc_deref <-flush_to_ldisc
     kworker/0:1-258   [000]   412.105879: put_ldisc <-tty_ldisc_deref
     kworker/0:1-258   [000]   412.105879: __wake_up <-put_ldisc
     kworker/0:1-258   [000]   412.105880: __wake_up_common <-__wake_up
     kworker/0:1-258   [000]   412.105880: cwq_dec_nr_in_flight <-process_one_work
     kworker/0:1-258   [000]   412.105880: process_one_work <-worker_thread

   and repeat that sequence more/less identical ad nauseum

Sometimes it breaks out and makes progress, usually after a few mn.

2.6.39 is fine. I'm going to attempt a bisection but it's a bit slow on
those machines and I'm running out of time today, so I wanted to shoot
that to you in case it rings a bell.

Cheers,
Ben.


