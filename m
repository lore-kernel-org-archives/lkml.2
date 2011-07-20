Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab1GTNXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:23:22 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39278 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab1GTNXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:23:21 -0400
Date: Wed, 20 Jul 2011 06:23:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org,
        greearb@candelatech.com, edward.tomlinson@aero.bombardier.com
Subject: Re: [PATCH tip/core/urgent 1/7] rcu: decrease rcu_report_exp_rnp
 coupling with scheduler
Message-ID: <20110720132311.GE2400@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110720001738.GA16369@linux.vnet.ibm.com>
 <1311129618.5345.2.camel@twins>
 <20110720045414.GC2400@linux.vnet.ibm.com>
 <201107200723.33819.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107200723.33819.edt@aei.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 07:23:32AM -0400, Ed Tomlinson wrote:
> On Wednesday 20 July 2011 00:54:15 Paul E. McKenney wrote:
> > On Wed, Jul 20, 2011 at 04:40:18AM +0200, Peter Zijlstra wrote:
> > > On Tue, 2011-07-19 at 17:18 -0700, Paul E. McKenney wrote:

[ . . . ]

> Paul/Peter,
> 
> With all 7 fixes applied with the above version of patch 1, I get a warning during boot:
> 
> [    3.443140] EXT4-fs (sdc3): mounted filesystem with ordered data mode. Opts: (null)
> [    3.456097] VFS: Mounted root (ext4 filesystem) readonly on device 8:35.
> [    3.469734] devtmpfs: mounted
> [    3.478488] Freeing unused kernel memory: 628k freed
> [    3.488590] Write protecting the kernel read-only data: 10240k
> [    3.500809] Freeing unused kernel memory: 468k freed
> [    3.514158] Freeing unused kernel memory: 1240k freed
> [    3.552337] ------------[ cut here ]------------
> [    3.553004] ------------[ cut here ]------------
> [    3.553004] WARNING: at kernel/rcutree_plugin.h:414 __rcu_read_unlock+0xc9/0x120()
> [    3.553004] Hardware name: System Product Name
> [    3.553004] Modules linked in:
> [    3.553004] Pid: 1, comm: init Not tainted 3.0.0-rcr-crc+ #342
> [    3.553004] Call Trace:
> [    3.553004]  [<ffffffff8104b00f>] warn_slowpath_common+0x7f/0xc0
> [    3.553004]  [<ffffffff8104b06a>] warn_slowpath_null+0x1a/0x20
> [    3.553004]  [<ffffffff810bb479>] __rcu_read_unlock+0xc9/0x120
> [    3.553004]  [<ffffffff8157d6b1>] __atomic_notifier_call_chain+0x91/0xb0
> [    3.553004]  [<ffffffff8157d620>] ? notifier_call_chain+0x80/0x80
> [    3.553004]  [<ffffffff812c5860>] ? bit_putcs+0x5b0/0x5b0
> [    3.553004]  [<ffffffff8157d6e6>] atomic_notifier_call_chain+0x16/0x20
> [    3.553004]  [<ffffffff813203c9>] notify_write+0x29/0x30
> [    3.553004]  [<ffffffff81322024>] vt_console_print+0x164/0x3b0
> [    3.553004]  [<ffffffff8104b29e>] __call_console_drivers+0x8e/0xb0
> [    3.553004]  [<ffffffff8104b30a>] _call_console_drivers+0x4a/0x80
> [    3.553004]  [<ffffffff8104b9ed>] console_unlock+0xfd/0x210
> [    3.553004]  [<ffffffff8104c246>] vprintk+0x3f6/0x530
> [    3.553004]  [<ffffffff810bb479>] ? __rcu_read_unlock+0xc9/0x120
> [    3.553004]  [<ffffffff8157585c>] printk+0x41/0x45
> [    3.553004]  [<ffffffff810bb479>] ? __rcu_read_unlock+0xc9/0x120
> [    3.553004]  [<ffffffff8104afcd>] warn_slowpath_common+0x3d/0xc0
> [    3.553004]  [<ffffffff8104b06a>] warn_slowpath_null+0x1a/0x20
> [    3.553004]  [<ffffffff810bb479>] __rcu_read_unlock+0xc9/0x120
> [    3.553004]  [<ffffffff8103fed8>] cpuacct_charge+0xc8/0xe0
> [    3.553004]  [<ffffffff8103fe58>] ? cpuacct_charge+0x48/0xe0
> [    3.553004]  [<ffffffff810326b7>] ? task_of+0x97/0xd0

The WARN_ON_ONCE() is no longer correct.  Here is a patch that goes
on top of #4 that fixes it.  The bug is in the warning, so if you are
running stably with all seven fixes and only get this warning, then that
is a -very- good sign!

							Thanx, Paul

------------------------------------------------------------------------

Fix warning to allow for negative values of ->rcu_read_lock_nesting.
    
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index cb33705..2b5f3e1 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -411,7 +411,11 @@ void __rcu_read_unlock(void)
 		t->rcu_read_lock_nesting = 0;
 	}
 #ifdef CONFIG_PROVE_LOCKING
-	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
+	{
+		int rrln = ACCESS_ONCE(t->rcu_read_lock_nesting);
+
+		WARN_ON_ONCE(rrln < 0 && rrln < INT_MIN / 2);
+	}
 #endif /* #ifdef CONFIG_PROVE_LOCKING */
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
