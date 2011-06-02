Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748Ab1FBIhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 04:37:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:39922 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759262Ab1FBIhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 04:37:31 -0400
Subject: tty breakage in X (Was: tty vs workqueue oddities)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, gregkh@suse.de
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1306999045.29297.55.camel@pasglop>
References: <1306999045.29297.55.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 18:37:01 +1000
Message-ID: <1307003821.29297.77.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 17:17 +1000, Benjamin Herrenschmidt wrote:
> Hi Alan !

Hrm... looks like Alan is innocent ... interesting tho, the culprit
patch looks like something he (or somebody known to understand the tty
code :-) should have reviewed.

So I bisected the problem down to

Commit: b1c43f82c5aa265442f82dba31ce985ebb7aa71c
Author: Felipe Balbi <balbi@ti.com>  2011-03-21 21:25:08
Committer: Greg Kroah-Hartman <gregkh@suse.de>  2011-04-23 10:31:53

    tty: make receive_buf() return the amout of bytes received
    
    it makes it simpler to keep track of the amount of
    bytes received and simplifies how flush_to_ldisc counts
    the remaining bytes. It also fixes a bug of lost bytes
    on n_tty when flushing too many bytes via the USB
    serial gadget driver.
    
    Tested-by: Stefan Bigler <stefan.bigler@keymile.com>
    Tested-by: Toby Gray <toby.gray@realvnc.com>
    Signed-off-by: Felipe Balbi <balbi@ti.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

It looks like the patch is causing some major malfunctions of the X
server for me, possibly related to PTYs. For example, cat'ing a large
file in a gnome terminal hangs the kernel for -minutes- in a loop of
what looks like flush_to_ldisc/workqueue code, (some ftrace data in the
quoted bits further down). 

It's pretty gross and it doesn't look powerpc related in any ways (tho I
haven't had a chance to test on an x86 box), on the other hand I'm
surprised nobody else complained :-)

Should it just be reverted ? Is there a fix ?

Hand-reverting it on top of upstream (with some bluetooth manual fixups)
fixes the problems for me, X is back to normal.

Cheers,
Ben.

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
>      kworker/0:1-258   [000]   412.105879: put_ldisc <-tty_ldisc_deref
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
> 
> Cheers,
> Ben.
> 


