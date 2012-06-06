Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab2FFFvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 01:51:53 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:39681 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab2FFFvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 01:51:52 -0400
Date: Wed, 6 Jun 2012 07:42:51 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Dave Jones <davej@redhat.com>
Cc: Marc Dionne <marc.c.dionne@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NOHZ: local_softirq_pending 08
Message-ID: <20120606054251.GA24467@electric-eye.fr.zoreil.com>
References: <20120530214809.GA19223@redhat.com> <alpine.LFD.2.02.1205310938080.3231@ionos> <20120601225754.GA25281@electric-eye.fr.zoreil.com> <CAB9dFdvWoc1onyWyy4BVmhpjeb5K2d10re0NcW-_NQCbfRC0hw@mail.gmail.com> <20120605231550.GA20981@electric-eye.fr.zoreil.com> <20120606014656.GA24870@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606014656.GA24870@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> :
[...]
> with these patches applied, I get a lot of spew in dmesg like ..

Yes, I only set up a single array for the irq instead of a real ring
and pipe in debugfs. You can change RTL_DEBUG_EVENT_RING_SIZE (4 bytes
per timestamp + event record). seq_file will grow its buffer when it
overflows.

[...]
> [   99.730789] r8169 0000:01:00.0: eth0: event ring full.
> [   99.887643] r8169 0000:01:00.0: eth0: event ring full.
> [  103.798861] net_ratelimit: 43 callbacks suppressed
> 
> over and over..

You can remove the message in 'rtl_trace_event'

[...]
>  > 'ip link set dev 8168b-lom up' + 'cat /sys/kernel/debug/tracing/trace':
> 
> What tracer do I need to configure to get make this work ? irqsoff ?

'function'

My sequence was:

echo 0 > tracing_on
echo nop > current_tracer
echo 10000 > buffer_size_kb
echo function > current_tracer
echo rtl* > set_ftrace_filter
echo r8169* >> set_ftrace_filter
echo tick_nohz_stop_sched_tick >> set_ftrace_filter

I only enabled tracing_on right before 'ip link ... up'.
tick_nohz_stop_sched_tick fills the log rather fast.

[...]
> finally, /sys/kernel/debug/r8169/ is empty.

I temporary saw it once too. Don't ask why.

Do things look like:

$ objdump --syms drivers/net/ethernet/realtek/r8169.ko | grep -E 'rtl_debug_(show|fops)_([rt]x|irq)' 
000000000000346d l     F .text	0000000000000087 rtl_debug_show_irq
0000000000009bdc l     F .text	00000000000000a0 rtl_debug_show_tx
000000000000355a l     F .text	0000000000000063 rtl_debug_show_rx
00000000000019e0 l     O .rodata	00000000000000d0 rtl_debug_fops_rx
0000000000001ab0 l     O .rodata	00000000000000d0 rtl_debug_fops_tx
0000000000001b80 l     O .rodata	00000000000000d0 rtl_debug_fops_irq

-- 
Ueimor

(off to work)
