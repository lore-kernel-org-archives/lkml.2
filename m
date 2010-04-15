Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0DOSNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:13:14 -0400
Received: from mail-qy0-f189.google.com ([209.85.221.189]:50224 "EHLO
	mail-qy0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab0DOSNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:13:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=JsoB6haeYY5hpruQs+acLr4Oo3Yq5EDBTVuQqK965X8uj3hMZwMIyaC9P/dKJo4t9b
         DjXZu1cFvJMOgAqLjipO0coEj4lRbnfZDBxHJJ9W7aubh6mqgOnZ+YJyQ0Z6j35b/iJL
         +EVWNB0DZ5rkR4ogHoJc0J3S/vGeuTaDKXa34=
Subject: Re: sched_clock - microblaze
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: michal.simek@petalogix.com
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BC73FB9.9060303@petalogix.com>
References: <4BC728DD.5020404@petalogix.com>
	 <1271343888.1880.1.camel@localhost>  <4BC73FB9.9060303@petalogix.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Fri, 16 Apr 2010 02:12:59 +0800
Message-ID: <1271355179.20625.107.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-15 at 18:32 +0200, Michal Simek wrote:
> Steven Rostedt wrote:
> > On Thu, 2010-04-15 at 16:55 +0200, Michal Simek wrote:
> >> Hi Thomas and Steven,
> >>
> >> I would like to improve time measuring for ftrace (Log below)
> >>
> >> I looked at http://lkml.org/lkml/2009/11/16/181
> >> where Thomas suggested to create sched_clock() function.
> >> I used the same solution as Wu proposed but it is not nice.
> >>
> >> Is unimplemented sched_clock the reason why ftrace not show fine grain time?
> > 
> > Yeah, sched_clock is used by ftrace for timings, so if it only returns
> > jiffies, then that will, unfortunately, be the resolution of the tracer.
> > 
> > I've been told that if you make a higher resolution timer for sched
> > clock, it will improve the scheduling in CFS.
> 
> We have two timers (in one IP).
> timer0 - in IRQ mode - clock event
> timer1 - free running up counter without IRQ - clock source
> 
> I hope that I can use timer1 in sched_clock too.
> 
> Anyway. I played with it a little bit and I also implemented microblaze 
> specific sched_clock function (inspired by arch/arm/mach-ixp4xx/common.c)
> 
> unsigned long long notrace sched_clock(void)
> {
> 	printk("%s\n", __func__);
> 	cycle_t cyc = microblaze_read(NULL);
> 	struct clocksource *cs = &clocksource_microblaze;
> 	return clocksource_cyc2ns(cyc, cs->mult, cs->shift);
> }

Hey, I guess you got:

sched_clock() -> printk() -> sched_clock() ...

since printk() is not annotated with notrace, it will call mcount() and
then sched_clock() and ... so, you can not call printk() in
sched_clock().

but you may try this if you want to print something in sched_clock() for
debugging.

#include <>

sched_clock() {
	ftrace_stop();
	printk(...);
	ftrace_start();
	...
}

Regards,
	Wu Zhangjin

> 
> (And comment sched_clock in kernel/sched_clock.c because our toolchain 
> has the problem with weak symbols)
> 
> Recompile the kernel and then show the log_buf
> 
> <4>Ramdisk addr 0x00000003, Compiled-in FDT at 0xc0242a28
> <5>Linux version 2.6.34-rc4-00053-gbc6ce8a-dirty (monstr@monstr.eu) (gcc 
> version 4.1.2) #27 Thu Apr 15 16:38:16 CEST 2010
> <6>setup_cpuinfo: initialising
> <6>setup_cpuinfo: Using full CPU PVR support
> <6>cache: wb_msr
> <6>setup_memory: Main mem: 0x48000000-0x50000000, size 0x08000000, 
> klimit 0xc09c7000
> <6>setup_memory: max_mapnr: 0x8000
> <6>setup_memory: min_low_pfn: 0x48000
> <6>setup_memory: max_low_pfn: 0x50000
> <4>reserved 0 - 0x48000000-0x009c8000
> <4>reserved 1 - 0x48fe0000-0x00020000
> <4>reserved 2 - 0x4fffd8c8-0x00002738
> <7>On node 0 totalpages: 32768
> <7>free_area_init_node: node 0, pgdat c02bc70c, node_mem_map c09c8000
> <7>  Normal zone: 256 pages used for memmap
> <7>  Normal zone: 32512 pages, LIFO batch:7
> <4>Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 
> 32512
> <5>Kernel command line:  console=ttyS0,115200
> <6>PID hash table entries: 512 (order: -1, 2048 bytes)
> <6>Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
> <6>Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
> <6>Memory: 119796k/131072k available
> <4>sched_clock
> 
> The problem I see is that scheck_clock is used before our timer 
> subsystem is initialized.
> What am I missing?
> 
> Thanks,
> Michal
> 


