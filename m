Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0FQGjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 02:39:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:51077 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab0FQGjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 02:39:35 -0400
Subject: Re: Slow pty's (was Re: libdivecomputer interfaces?)
From: Mike Galbraith <mgalbraith@suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Brian Bloniarz <bmb@athenacr.com>, Chris Wedgwood <cw@f00f.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jef Driesen <jefdriesen@telenet.be>, linux-kernel@vger.kernel.org
In-Reply-To: <1276701411.30669.6.camel@marge.simson.net>
References: <AANLkTinLth4iKXAwszEEsPm_9ZDlj8HtqsiG5cdFE1cZ@mail.gmail.com>
	 <20100610181042.GA19210@puku.stupidest.org> <4C116652.8010408@athenacr.com>
	 <alpine.LRH.2.00.1006161702470.2497@twin.jikos.cz>
	 <1276701411.30669.6.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 17 Jun 2010 08:39:30 +0200
Message-Id: <1276756770.8248.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 17:16 +0200, Mike Galbraith wrote:
> On Wed, 2010-06-16 at 17:03 +0200, Jiri Kosina wrote:
> > On Thu, 10 Jun 2010, Brian Bloniarz wrote:
> > 
> > > On 06/10/2010 02:10 PM, Chris Wedgwood wrote:
> > > > (sorry if this reponse isn't on target, i was just pointed to this
> > > > thread a few minutes ago)
> > > > 
> > > > 
> > > > On Thu, Jun 10, 2010 at 10:25:36AM -0700, Linus Torvalds wrote:
> > > > 
> > > >>  I thought we long since (ie back last fall) fixed the latency
> > > >> problems with pty's, but there does seem to be something very fishy
> > > >> going on there still.
> > > > 
> > > > this might not be related, but i have slow serial ports with NOHZ that
> > > > goes away when i revert 39c0cbe2150cbd848a25ba6cdb271d1ad46818ad.
> > > 
> > > Unrelated or not, I think Chris is right about this. Somewhere before
> > > -rc1, the emulated serial console on my KVM instance became slow
> > > to echo input. I just tested with the commit reverted and it's
> > > back to normal.
> > 
> > So let's CC Mike then.
> 
> Chris already gave me a heads up, it's on my todo.  The old P4 box I use
> for a serial console box is exploding on boot, or I would have already
> had a look.

(Removing filth and re-seating ram seems to have revived poor old P4)

I'm not seeing any problem with serial console here, seems to work just
fine P4->Q6600, both running NOHZ kernels with nohz_ratelimit(), 33.5 on
the P4, and tip.today on the Q6600.

Eyeballing it, perhaps we need to proceed downward if any needs_cpu
condition is true, despite having just been here a wee bit ago.

Does this help anyone's woes?

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 5f171f0..ec72fad 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -262,7 +262,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	ktime_t last_update, expires, now;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	u64 time_delta;
-	int cpu;
+	int cpu, cpu_needed;
 
 	local_irq_save(flags);
 
@@ -315,7 +315,9 @@ void tick_nohz_stop_sched_tick(int inidle)
 		goto end;
 	}
 
-	if (nohz_ratelimit(cpu))
+	cpu_needed = rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) || arch_needs_cpu(cpu);
+
+	if (!cpu_needed && nohz_ratelimit(cpu))
 		goto end;
 
 	ts->idle_calls++;
@@ -327,8 +329,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 		time_delta = timekeeping_max_deferment();
 	} while (read_seqretry(&xtime_lock, seq));
 
-	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu)) {
+	if (cpu_needed) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {


