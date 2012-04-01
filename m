Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2DADDC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 23:03:02 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:50802 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab2DADC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 23:02:59 -0400
Date: Sat, 31 Mar 2012 20:02:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Rolland <rol@witbe.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Blocked in keyctl(...) ??? - RCU related ???
Message-ID: <20120401030246.GQ2450@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120312170301.5982e054@tux.DEF.witbe.net>
 <20120316094328.6b37a4d9@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120316094328.6b37a4d9@tux.DEF.witbe.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040103-7408-0000-0000-000003DFF59E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 09:43:28AM +0100, Paul Rolland wrote:
> Hello,
> 
> On Mon, 12 Mar 2012 17:03:01 +0100
> Paul Rolland (ポール・ロラン)  <rol@witbe.net> wrote:
> 
> > Sometimes, my applications start "locking": nothing happens anymore, can't
> > kill them... 
> > I manage to strace them, to find that they are executing the following
> > syscall:
> > 
> > 13686 keyctl(0x1, 0, 0xffffffffffffffff, 0x7fa90fd6a2c0, 0
> > 
> > and that syscall never returns.
> 
> OK, this happened again, while running 3.3-rc7... I've used sysrq to
> collect some informations and what I can see from that is the following :
> 
> Mar 16 08:40:02 tux kernel: Call Trace:
> Mar 16 08:40:02 tux kernel: [<ffffffff813b8771>] ? extract_buf+0x91/0x140
> Mar 16 08:40:02 tux kernel: [<ffffffff8166fd5a>] schedule+0x3a/0x50
> Mar 16 08:40:02 tux kernel: [<ffffffff8166e09d>] schedule_timeout+0x1ed/0x260
> Mar 16 08:40:02 tux kernel: [<ffffffff810636c1>] ? get_parent_ip+0x11/0x50
> Mar 16 08:40:02 tux kernel: [<ffffffff810636c1>] ? get_parent_ip+0x11/0x50
> Mar 16 08:40:02 tux kernel: [<ffffffff810636c1>] ? get_parent_ip+0x11/0x50
> Mar 16 08:40:02 tux kernel: [<ffffffff8166f100>] wait_for_common+0xc0/0x160
> Mar 16 08:40:02 tux kernel: [<ffffffff81062150>] ? try_to_wake_up+0x2e0/0x2e0
> Mar 16 08:40:02 tux kernel: [<ffffffff810ad020>] ? __call_rcu+0x150/0x150
> Mar 16 08:40:02 tux kernel: [<ffffffff8166f1b8>] wait_for_completion+0x18/0x20
> Mar 16 08:40:02 tux kernel: [<ffffffff81054628>] wait_rcu_gp+0x48/0x50
> Mar 16 08:40:02 tux kernel: [<ffffffff81054630>] ? wait_rcu_gp+0x50/0x50
> Mar 16 08:40:02 tux kernel: [<ffffffff810ac09c>] synchronize_rcu+0x1c/0x20
> Mar 16 08:40:02 tux kernel: [<ffffffff812ba6a9>] install_session_keyring_to_cred+0x59/0xc0
> Mar 16 08:40:02 tux kernel: [<ffffffff812bac3a>] join_session_keyring+0x12a/0x170
> Mar 16 08:40:02 tux kernel: [<ffffffff812b8cd2>] keyctl_join_session_keyring+0x32/0x60
> Mar 16 08:40:02 tux kernel: [<ffffffff812ba278>] sys_keyctl+0x168/0x180
> Mar 16 08:40:02 tux kernel: [<ffffffff81671b62>]
> system_call_fastpath+0x16/0x1b
> 
> The complete traces collected in /var/log/messages is attached to this email.
> 
> Is there anything I can do to investigate this ?

>From your message output, it looks like something is stalling RCU grace
periods, possibly due to a task being preempted in an RCU read-side
critical section (this assumes you are running CONFIG_PREEMPT=y).

Could you please try reproducing with CONFIG_RCU_CPU_STALL_VERBOSE=y?
This would identify tasks stalling the RCU grace period.

							Thanx, Paul

