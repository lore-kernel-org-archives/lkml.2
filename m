Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab0DURby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 13:31:54 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39225 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab0DURbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 13:31:53 -0400
Date: Wed, 21 Apr 2010 10:31:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com,
       davem@davemloft.net
Subject: Re: [patch 0/5] rcu head debugobjects
Message-ID: <20100421173145.GA6966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100417124837.536020244@efficios.com>
 <20100418004849.GD2876@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100418004849.GD2876@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 17, 2010 at 05:48:49PM -0700, Paul E. McKenney wrote:
> On Sat, Apr 17, 2010 at 08:48:37AM -0400, Mathieu Desnoyers wrote:
> > Here is a repost of the rcu head debugobjects patchset, with updated changelogs.
> > 
> > Paul, this would be ready to be integrated with the RCU patches.
> 
> Thank you, Mathieu, queued up for 2.6.35!

And testing got me the following debugobjects splat, which baffles me.
My first thought was that one of the synchronize_rcu() variants was
missing the init_rcu_head_on_stack(), but not so.  Then I started
looking through the debugobjects code, and found the following:

	static void debug_object_is_on_stack(void *addr, int onstack)
	{
		int is_on_stack;
		static int limit;

		if (limit > 4)
			return;

This really confuses me.  We are using a static variable, but as
near as I can tell, it is being guarded by a per-bucket lock:

	raw_spin_lock_irqsave(&db->lock, flags);

If I understand correctly, this means that multiple CPUs might be
concurrently updating the static variable "limit", which might in
turn be causing the splat below.

Or am I missing something?

						Thanx, Paul

------------------------------------------------------------------------

ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
Badness at lib/debugobjects.c:294
NIP: c0000000002c76f0 LR: c0000000002c76ec CTR: c00000000041ecd8
REGS: c0000001de71b280 TRAP: 0700   Tainted: G        W   (2.6.34-rc3-autokern1)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 24000424  XER: 0000000f
TASK = c0000001de7dca00[3695] 'arping' THREAD: c0000001de718000 CPU: 1
GPR00: c0000000002c76ec c0000001de71b500 c00000000096c048 0000000000000034 
GPR04: 0000000000000001 c000000000063918 0000000000000000 0000000000000002 
GPR08: 0000000000000003 0000000000000000 c000000000086f68 c0000001de7dca00 
GPR12: 000000000000256d c0000000074e4200 0000000000000000 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000000000 00000000201b8f60 
GPR20: 00000000201b8f70 00000000201b8f48 0000000000000000 c0000000008766b8 
GPR24: c0000001de71b800 0000000000000001 c0000000008ad400 c000000001247478 
GPR28: c0000000e6abb8c0 c0000000e6abb8c0 c000000000904570 c000000001247470 
NIP [c0000000002c76f0] .__debug_object_init+0x314/0x40c
LR [c0000000002c76ec] .__debug_object_init+0x310/0x40c
Call Trace:
[c0000001de71b500] [c0000000002c76ec] .__debug_object_init+0x310/0x40c (unreliable)
[c0000001de71b5d0] [c00000000007d990] .rcuhead_fixup_activate+0x40/0xdc
[c0000001de71b660] [c0000000002c6a7c] .debug_object_fixup+0x4c/0x74
[c0000001de71b6f0] [c0000000000c5e54] .__call_rcu+0x3c/0x1d4
[c0000001de71b790] [c0000000000c6050] .synchronize_rcu+0x4c/0x6c
[c0000001de71b870] [c0000000004be218] .synchronize_net+0x10/0x24
[c0000001de71b8e0] [c0000000005498c8] .packet_release+0x1d4/0x274
[c0000001de71b990] [c0000000004ac1f0] .sock_release+0x54/0x124
[c0000001de71ba20] [c0000000004ac9e4] .sock_close+0x34/0x4c
[c0000001de71baa0] [c00000000012469c] .__fput+0x174/0x264
[c0000001de71bb40] [c000000000120c54] .filp_close+0xb0/0xd8
[c0000001de71bbd0] [c000000000065e70] .put_files_struct+0x1a8/0x314
[c0000001de71bc70] [c000000000067e04] .do_exit+0x234/0x6f0
[c0000001de71bd30] [c000000000068354] .do_group_exit+0x94/0xc8
[c0000001de71bdc0] [c00000000006839c] .SyS_exit_group+0x14/0x28
[c0000001de71be30] [c000000000008554] syscall_exit+0x0/0x40
Instruction dump:
7f80b000 419e0030 2fa00000 e93e8140 380b0001 90090000 419e000c e87e8148 
48000008 e87e8150 4bd9cb89 60000000 <0fe00000> 801c0010 2f800003 419e0024 

