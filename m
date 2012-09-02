Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab2IBH7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 03:59:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:39153 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab2IBH7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 03:59:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,355,1344236400"; 
   d="scan'208";a="217210166"
Date: Sun, 2 Sep 2012 15:59:46 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: linux-input@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, bjorn@mork.no,
        chunkeey@googlemail.com, linville@tuxdriver.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: input0: bad kobj_uevent_env content in show_uevent()
Message-ID: <20120902075946.GA21198@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After the __devinit* removal series, I can still get kernel panic in
show_uevent(). So there are more sources of bug..

Debug patch:

@@ -343,8 +343,11 @@ static ssize_t show_uevent(struct device
                goto out;

        /* copy keys to file */
-       for (i = 0; i < env->envp_idx; i++)
+       dev_err(dev, "uevent %d env[%d]: %s/.../%s\n", env->buflen, env->envp_idx, top_kobj->name, dev->kobj.name);
+       for (i = 0; i < env->envp_idx; i++) {
+               printk(KERN_ERR "uevent %d env[%d]: %s\n", (int)count, i, env->envp[i]);
                count += sprintf(&buf[count], "%s\n", env->envp[i]);
+       }

Oops message, the env[] is again not properly initilized:

[   44.068623] input input0: uevent 61 env[805306368]: input0/.../input0
[   44.069552] uevent 0 env[0]: (null)
[   44.070107] uevent 7 env[1]: (null)
[   44.070609] uevent 14 env[2]: (null)
[   44.071136] uevent 21 env[3]: (null)
[   44.071637] uevent 28 env[4]: (null)
[   44.072166] uevent 35 env[5]: (null)
[   44.072674] uevent 42 env[6]: (null)
[   44.073188] uevent 49 env[7]: (null)
[   44.073694] uevent 56 env[8]: (null)
[   44.074207] uevent 63 env[9]: (null)
[   44.074709] uevent 70 env[10]: (null)
[   44.075235] uevent 77 env[11]: (null)
[   44.075748] uevent 84 env[12]: (null)
[   44.076270] uevent 91 env[13]: (null)
[   44.076783] uevent 98 env[14]: (null)
[   44.077310] uevent 105 env[15]: (null)
[   44.077843] uevent 112 env[16]: (null)
[   44.078384] uevent 119 env[17]: (null)
[   44.078911] uevent 126 env[18]: (null)
[   44.079451] uevent 133 env[19]: (null)
[   44.079979] uevent 140 env[20]: (null)
[   44.080537] uevent 147 env[21]: (null)
[   44.081077] uevent 154 env[22]: (null)
[   44.081614] uevent 161 env[23]: (null)
[   44.082151] uevent 168 env[24]: (null)
[   44.082680] uevent 175 env[25]: (null)
[   44.083217] uevent 182 env[26]: (null)
[   44.083740] uevent 189 env[27]: (null)
[   44.084282] uevent 196 env[28]: (null)
[   44.084810] uevent 203 env[29]: (null)
[   44.085350] uevent 210 env[30]: (null)
[   44.085889] uevent 217 env[31]: (null)
[   44.086434] general protection fault: 0000 [#1] PREEMPT 
[   44.087232] CPU 0 
[   44.087505] Pid: 135, comm: trinity-child0 Not tainted 3.6.0-rc4-bisect2-00001-gb6d86d3-dirty #25 Bochs Bochs
[   44.088928] RIP: 0010:[<ffffffff81266ba3>]  [<ffffffff81266ba3>] strnlen+0x23/0x70
[   44.090037] RSP: 0018:ffff8800073dfc58  EFLAGS: 00010006
[   44.090522] RAX: ffff8800073dfe00 RBX: ffffffff8291f0f6 RCX: 000000000001c66a
[   44.090522] RDX: 3030313330000000 RSI: ffffffffffffffff RDI: 3030313330000000
[   44.090522] RBP: ffff8800073dfc58 R08: 000000000000ffff R09: 000000000000ffff
[   44.090522] R10: 0000000000000001 R11: 0000000000000001 R12: 3030313330000000
[   44.090522] R13: ffffffff8291f4c0 R14: 000000000000ffff R15: 0000000000000000
[   44.090522] FS:  00007ff846958700(0000) GS:ffffffff8222d000(0000) knlGS:0000000000000000
[   44.090522] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   44.090522] CR2: 00000000030e5000 CR3: 00000000073ee000 CR4: 00000000000006b0
[   44.090522] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   44.090522] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   44.090522] Process trinity-child0 (pid: 135, threadinfo ffff8800073de000, task ffff880006c0c000)
[   44.090522] Stack:
[   44.090522]  ffff8800073dfc98 ffffffff81268ccc ffffffff82252f18 ffffffff81faf19e
[   44.090522]  ffffffff8291f4c0 ffff8800073dfdd0 ffffffff81faf19e ffffffff8291f0f6
[   44.090522]  ffff8800073dfd18 ffffffff81269e89 ffffffff82250002 ffffffff82252ea0
[   44.090522] Call Trace:
[   44.090522]  [<ffffffff81268ccc>] string.isra.4+0x4c/0x120
[   44.090522]  [<ffffffff81269e89>] vsnprintf+0x2c9/0x900
[   44.090522]  [<ffffffff8126a939>] vscnprintf+0x19/0x50
[   44.090522]  [<ffffffff8105f8c7>] vprintk_emit+0xe7/0x750
[   44.090522]  [<ffffffff81a49b19>] printk+0x4f/0x58
[   44.090522]  [<ffffffff8150519b>] show_uevent+0x1cb/0x220
[   44.090522]  [<ffffffff81501d3b>] dev_attr_show+0x2b/0x90
[   44.090522]  [<ffffffff81174b72>] ? sysfs_read_file+0x112/0x290
[   44.090522]  [<ffffffff810f2974>] ? __get_free_pages+0x24/0xc0
[   44.090522]  [<ffffffff81174bae>] sysfs_read_file+0x14e/0x290
[   44.090522]  [<ffffffff81125b07>] vfs_read+0xc7/0x200
[   44.090522]  [<ffffffff81125fa0>] sys_read+0x60/0xd0
[   44.090522]  [<ffffffff81a5d737>] system_call_fastpath+0x16/0x1b

Thanks,
Fengguang
