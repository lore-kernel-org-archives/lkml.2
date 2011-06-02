Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277Ab1FBKCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 06:02:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52392 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932138Ab1FBKCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 06:02:05 -0400
Date: Thu, 2 Jun 2011 11:03:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: tty vs workqueue oddities
Message-ID: <20110602110356.5f821355@lxorguk.ukuu.org.uk>
In-Reply-To: <1306999045.29297.55.camel@pasglop>
References: <1306999045.29297.55.camel@pasglop>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Jun 2011 17:17:25 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> Hi Alan !
> 
> Current upstream (but that's been around for at least 2 or 3 days) seems
> to have a strange behaviour on one of my powerbooks. Something like
> "dmesg" or "cat" of a large file in an X terminal "hangs" the machine
> litterally for minutes. It generally recovers, so not always.
> 
> Network is unresponsive as well.
> 
> My attempts at stopping it into xmon always landed in process_one_work()
> or flush_to_ldisc() from what I can tell, and a simple ftrace run shows
> something that looks like an -enormous- lot of:
> 
>      kworker/0:1-258   [000]   412.105871: flush_to_ldisc <-process_one_work
>      kworker/0:1-258   [000]   412.105871: tty_ldisc_ref <-flush_to_ldisc
>      kworker/0:1-258   [000]   412.105872: n_tty_receive_buf <-flush_to_ldisc
>      kworker/0:1-258   [000]   412.105872: kill_fasync <-n_tty_receive_buf
>      kworker/0:1-258   [000]   412.105873: __wake_up <-n_tty_receive_buf
>      kworker/0:1-258   [000]   412.105873: __wake_up_common <-__wake_up
>      kworker/0:1-258   [000]   412.105874: default_wake_function <-__wake_up_common
>      kworker/0:1-258   [000]   412.105874: try_to_wake_up <-default_wake_function
>      kworker/0:1-258   [000]   412.105874: tty_throttle <-n_tty_receive_buf
>      kworker/0:1-258   [000]   412.105875: mutex_lock <-tty_throttle
>      kworker/0:1-258   [000]   412.105875: mutex_unlock <-tty_throttle
>      kworker/0:1-258   [000]   412.105876: schedule_work <-flush_to_ldisc
>      kworker/0:1-258   [000]   412.105876: queue_work <-schedule_work
>      kworker/0:1-258   [000]   412.105877: queue_work_on <-queue_work
>      kworker/0:1-258   [000]   412.105877: __queue_work <-queue_work_on
>      kworker/0:1-258   [000]   412.105878: insert_work <-__queue_work
>      kworker/0:1-258   [000]   412.105878: tty_ldisc_deref <-flush_to_ldisc
>      kworker/0:1-258   [000]   412.105879: put_ldisc <-tty_ldisc_"Yedvab, Nadav" <nadav.yedvab@intel.com>

deref
>      kworker/0:1-258   [000]   412.105879: __wake_up <-put_ldisc
>      kworker/0:1-258   [000]   412.105880: __wake_up_common <-__wake_up
>      kworker/0:1-258   [000]   412.105880: cwq_dec_nr_in_flight <-process_one_work
>      kworker/0:1-258   [000]   412.105880: process_one_work <-worker_thread
> 
>    and repeat that sequence more/less identical ad nauseum
> 
> Sometimes it breaks out and makes progress, usually after a few mn.
> 
> 2.6.39 is fine. I'm going to attempt a bisection but it's a bit slow on
> those machines and I'm running out of time today, so I wanted to shoot
> that to you in case it rings a bell.

Possibly

b1c43f82c5aa265442f82dba31ce985ebb7aa71c

other suspect would be

a5660b41af6a28f8004e70eb261e1202ad55c5e3

but 2.6.39 working suggests its not

