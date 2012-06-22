Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762209Ab2FVN5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:57:12 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59598 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762152Ab2FVN5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:57:10 -0400
Message-ID: <1340373489.27031.40.camel@lappy>
Subject: New tty ldisc lockup on 3.5-rc3
From: Sasha Levin <levinsasha928@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, gregkh <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Date: Fri, 22 Jun 2012 15:58:09 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm seeing the following when fuzzing using trinity inside a KVM tools guest on 3.5-rc3:

[   60.361427] tty_ldisc_hangup: waiting (trinity-child1) for ttyS0 took too long, but we keep waiting...
[  242.690529] INFO: task trinity-watchdo:5872 blocked for more than 120 seconds.
[  242.693495] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.696567] trinity-watchdo D 000000000000001a  6016  5872   5844 0x00000000
[  242.697640]  ffff88000a079df8 0000000000000046 ffffffff83698795 00007fad79ce7000
[  242.699148]  ffff88000a078000 ffff88000a078010 ffff88000a079fd8 ffff88000a078000
[  242.700128]  ffff88000a078010 ffff88000a079fd8 ffff88000d5c0000 ffff88000be33000
[  242.701082] Call Trace:
[  242.701403]  [<ffffffff83698795>] ? _raw_spin_unlock_irqrestore+0x65/0xc0
[  242.702289]  [<ffffffff83696d15>] schedule+0x55/0x60
[  242.702921]  [<ffffffff81b2a026>] tty_ldisc_ref_wait+0x76/0xa0
[  242.703685]  [<ffffffff81b22624>] ? redirected_tty_write+0x84/0xc0
[  242.704484]  [<ffffffff81107a50>] ? wake_up_bit+0x40/0x40
[  242.705202]  [<ffffffff81b22539>] tty_write+0x99/0x100
[  242.705867]  [<ffffffff8197fc10>] ? do_raw_spin_unlock+0xd0/0xe0
[  242.706654]  [<ffffffff81b22635>] redirected_tty_write+0x95/0xc0
[  242.707439]  [<ffffffff81235b1a>] vfs_write+0xca/0x190
[  242.708112]  [<ffffffff81235cbf>] sys_write+0x4f/0x90
[  242.708764]  [<ffffffff83699739>] system_call_fastpath+0x16/0x1b
[  242.709554] no locks held by trinity-watchdo/5872.
[  242.710200] INFO: task trinity-child1:5881 blocked for more than 120 seconds.
[  242.711877] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.714508] trinity-child1  D ffff88001949be58  5472  5881   5873 0x00000004
[  242.716891]  ffff88001949bce8 0000000000000046 0000000000000000 0000000000000001
[  242.719381]  ffff88001949a000 ffff88001949a010 ffff88001949bfd8 ffff88001949a000
[  242.721894]  ffff88001949a010 ffff88001949bfd8 ffff88000d5b8000 ffff88001b578000
[  242.724336] Call Trace:
[  242.725147]  [<ffffffff83696d15>] schedule+0x55/0x60
[  242.726861]  [<ffffffff8369462a>] schedule_timeout+0x3a/0x400
[  242.728772]  [<ffffffff83698795>] ? _raw_spin_unlock_irqrestore+0x65/0xc0
[  242.731031]  [<ffffffff8114d74d>] ? trace_hardirqs_on+0xd/0x10
[  242.732916]  [<ffffffff836987c4>] ? _raw_spin_unlock_irqrestore+0x94/0xc0
[  242.735143]  [<ffffffff81107d52>] ? prepare_to_wait+0x72/0x80
[  242.737060]  [<ffffffff81b29c50>] tty_ldisc_wait_idle+0x80/0xd0
[  242.738867]  [<ffffffff81107a50>] ? wake_up_bit+0x40/0x40
[  242.740654]  [<ffffffff81b29e63>] tty_ldisc_hangup+0x1c3/0x310
[  242.742486]  [<ffffffff8114f29a>] ? __lock_release+0x1ba/0x1d0
[  242.744336]  [<ffffffff81b22c82>] ? __tty_hangup+0x122/0x400
[  242.746091]  [<ffffffff81b22c8a>] __tty_hangup+0x12a/0x400
[  242.747883]  [<ffffffff836987c4>] ? _raw_spin_unlock_irqrestore+0x94/0xc0
[  242.750101]  [<ffffffff81b22fae>] tty_vhangup_self+0x1e/0x30
[  242.751992]  [<ffffffff81233390>] sys_vhangup+0x20/0x30
[  242.753757]  [<ffffffff83699739>] system_call_fastpath+0x16/0x1b
[  242.755777] 1 lock held by trinity-child1/5881:
[  242.757296]  #0:  (&tty->ldisc_mutex){+.+...}, at: [<ffffffff81b29dbf>] tty_ldisc_hangup+0x11f/0x310
[  242.760256] INFO: task trinity-child2:5882 blocked for more than 120 seconds.
[  242.762581] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.765060] trinity-child2  D 0000000000000029  5472  5882   5873 0x00000000
[  242.767294]  ffff8800283a1df8 0000000000000046 ffffffff83698795 00007fad79ce7000
[  242.769394]  ffff8800283a0000 ffff8800283a0010 ffff8800283a1fd8 ffff8800283a0000
[  242.771649]  ffff8800283a0010 ffff8800283a1fd8 ffff88000cf80000 ffff88002833b000
[  242.773901] Call Trace:
[  242.774668]  [<ffffffff83698795>] ? _raw_spin_unlock_irqrestore+0x65/0xc0
[  242.776815]  [<ffffffff83696d15>] schedule+0x55/0x60
[  242.779035]  [<ffffffff81b2a026>] tty_ldisc_ref_wait+0x76/0xa0
[  242.780900]  [<ffffffff81b22624>] ? redirected_tty_write+0x84/0xc0
[  242.782866]  [<ffffffff81107a50>] ? wake_up_bit+0x40/0x40
[  242.784512]  [<ffffffff81b22539>] tty_write+0x99/0x100
[  242.786098]  [<ffffffff8197fc10>] ? do_raw_spin_unlock+0xd0/0xe0
[  242.787971]  [<ffffffff81b22635>] redirected_tty_write+0x95/0xc0
[  242.789915]  [<ffffffff81235b1a>] vfs_write+0xca/0x190
[  242.791566]  [<ffffffff81235cbf>] sys_write+0x4f/0x90
[  242.793199]  [<ffffffff83699739>] system_call_fastpath+0x16/0x1b
[  242.795122] no locks held by trinity-child2/5882.
[  242.796617] INFO: task trinity-child3:5883 blocked for more than 120 seconds.
[  242.798844] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.801274] trinity-child3  D 0000000000000029  5472  5883   5873 0x00000000
[  242.803471]  ffff8800276dddf8 0000000000000046 ffffffff83698795 00007fad79ce7000
[  242.805797]  ffff8800276dc000 ffff8800276dc010 ffff8800276ddfd8 ffff8800276dc000
[  242.808065]  ffff8800276dc010 ffff8800276ddfd8 ffff88000cf68000 ffff8800283f8000
[  242.810339] Call Trace:
[  242.811131]  [<ffffffff83698795>] ? _raw_spin_unlock_irqrestore+0x65/0xc0
[  242.813291]  [<ffffffff83696d15>] schedule+0x55/0x60
[  242.814801]  [<ffffffff81b2a026>] tty_ldisc_ref_wait+0x76/0xa0
[  242.816636]  [<ffffffff81b22624>] ? redirected_tty_write+0x84/0xc0
[  242.818613]  [<ffffffff81107a50>] ? wake_up_bit+0x40/0x40
[  242.820370]  [<ffffffff81b22539>] tty_write+0x99/0x100
[  242.822033]  [<ffffffff8197fc10>] ? do_raw_spin_unlock+0xd0/0xe0
[  242.823885]  [<ffffffff81b22635>] redirected_tty_write+0x95/0xc0
[  242.825839]  [<ffffffff81235b1a>] vfs_write+0xca/0x190
[  242.827418]  [<ffffffff81235cbf>] sys_write+0x4f/0x90
[  242.829027]  [<ffffffff83699739>] system_call_fastpath+0x16/0x1b
[  242.830905] no locks held by trinity-child3/5883.
[  242.832385] INFO: task trinity-child0:5884 blocked for more than 120 seconds.
[  242.834995] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.837596] trinity-child0  D ffff8800283dd4c0  5472  5884   5873 0x00000000
[  242.839973]  ffff8800276fddf8 0000000000000046 ffffffff83698795 00007fad79ce7000
[  242.842401]  ffff8800276fc000 ffff8800276fc010 ffff8800276fdfd8 ffff8800276fc000
[  242.844698]  ffff8800276fc010 ffff8800276fdfd8 ffff88000be2b000 ffff880027700000
[  242.847072] Call Trace:
[  242.847897]  [<ffffffff83698795>] ? _raw_spin_unlock_irqrestore+0x65/0xc0
[  242.850167]  [<ffffffff83696d15>] schedule+0x55/0x60
[  242.851878]  [<ffffffff81b2a026>] tty_ldisc_ref_wait+0x76/0xa0
[  242.853664]  [<ffffffff81b22624>] ? redirected_tty_write+0x84/0xc0
[  242.855573]  [<ffffffff81107a50>] ? wake_up_bit+0x40/0x40
[  242.857390]  [<ffffffff81b22539>] tty_write+0x99/0x100
[  242.859135]  [<ffffffff8197fc10>] ? do_raw_spin_unlock+0xd0/0xe0
[  242.861128]  [<ffffffff81b22635>] redirected_tty_write+0x95/0xc0
[  242.863046]  [<ffffffff81235b1a>] vfs_write+0xca/0x190
[  242.863050]  [<ffffffff81235cbf>] sys_write+0x4f/0x90
[  242.863054]  [<ffffffff83699739>] system_call_fastpath+0x16/0x1b
[  242.875268] no locks held by trinity-child0/5884.
[  242.876897] INFO: task trinity:5885 blocked for more than 120 seconds.
[  242.879055] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.881625] trinity         D 0000000000000019  6272  5885   5870 0x00000000
[  242.884195]  ffff880027729df8 0000000000000046 ffffffff83698795 00007f408df16000
[  242.886714]  ffff880027728000 ffff880027728010 ffff880027729fd8 ffff880027728000
[  242.889129]  ffff880027728010 ffff880027729fd8 ffff88000d5c0000 ffff880027703000
[  242.891481] Call Trace:
[  242.892258]  [<ffffffff83698795>] ? _raw_spin_unlock_irqrestore+0x65/0xc0
[  242.894477]  [<ffffffff83696d15>] schedule+0x55/0x60
[  242.896084]  [<ffffffff81b2a026>] tty_ldisc_ref_wait+0x76/0xa0
[  242.897935]  [<ffffffff81b22624>] ? redirected_tty_write+0x84/0xc0
[  242.900250]  [<ffffffff81107a50>] ? wake_up_bit+0x40/0x40
[  242.902019]  [<ffffffff81b22539>] tty_write+0x99/0x100
[  242.903610]  [<ffffffff8197fc10>] ? do_raw_spin_unlock+0xd0/0xe0
[  242.905487]  [<ffffffff81b22635>] redirected_tty_write+0x95/0xc0
[  242.907485]  [<ffffffff81235b1a>] vfs_write+0xca/0x190
[  242.909209]  [<ffffffff81235cbf>] sys_write+0x4f/0x90
[  242.910894]  [<ffffffff83699739>] system_call_fastpath+0x16/0x1b
[  242.924276] no locks held by trinity/5885.
[  242.925716] INFO: task trinity-main:5886 blocked for more than 120 seconds.
[  242.927986] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.930560] trinity-main    D 0000000000000024  6176  5886   5870 0x00000000
[  242.932901]  ffff880027759df8 0000000000000046 ffffffff83698795 00007f408df16000
[  242.935298]  ffff880027758000 ffff880027758010 ffff880027759fd8 ffff880027758000
[  242.937726]  ffff880027758010 ffff880027759fd8 ffff88000d5bb000 ffff880027750000
[  242.939999] Call Trace:
[  242.940800]  [<ffffffff83698795>] ? _raw_spin_unlock_irqrestore+0x65/0xc0
[  242.942899]  [<ffffffff83696d15>] schedule+0x55/0x60
[  242.944442]  [<ffffffff81b2a026>] tty_ldisc_ref_wait+0x76/0xa0
[  242.946323]  [<ffffffff81b22624>] ? redirected_tty_write+0x84/0xc0
[  242.948378]  [<ffffffff81107a50>] ? wake_up_bit+0x40/0x40
[  242.950186]  [<ffffffff81b22539>] tty_write+0x99/0x100
[  242.951803]  [<ffffffff8197fc10>] ? do_raw_spin_unlock+0xd0/0xe0
[  242.953490]  [<ffffffff81b22635>] redirected_tty_write+0x95/0xc0
[  242.955215]  [<ffffffff81235b1a>] vfs_write+0xca/0x190
[  242.956636]  [<ffffffff81235cbf>] sys_write+0x4f/0x90
[  242.958094]  [<ffffffff83699739>] system_call_fastpath+0x16/0x1b
[  242.959763] no locks held by trinity-main/5886.
[  242.960978] INFO: task trinity:5887 blocked for more than 120 seconds.
[  242.962737] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.964793] trinity         D 0000000000000019  6176  5887   5862 0x00000000
[  242.966724]  ffff88000a13bdf8 0000000000000046 ffffffff83698795 00007f1eb1681000
[  242.968765]  ffff88000a13a000 ffff88000a13a010 ffff88000a13bfd8 ffff88000a13a000
[  242.970809]  ffff88000a13a010 ffff88000a13bfd8 ffff88000d5b8000 ffff88000be18000
[  242.972830] Call Trace:
[  242.973529]  [<ffffffff83698795>] ? _raw_spin_unlock_irqrestore+0x65/0xc0
[  242.975395]  [<ffffffff83696d15>] schedule+0x55/0x60
[  242.976799]  [<ffffffff81b2a026>] tty_ldisc_ref_wait+0x76/0xa0
[  242.978389]  [<ffffffff81b22624>] ? redirected_tty_write+0x84/0xc0
[  242.980083]  [<ffffffff81107a50>] ? wake_up_bit+0x40/0x40
[  242.981556]  [<ffffffff81b22539>] tty_write+0x99/0x100
[  242.982984]  [<ffffffff8197fc10>] ? do_raw_spin_unlock+0xd0/0xe0
[  242.984602]  [<ffffffff81b22635>] redirected_tty_write+0x95/0xc0
[  242.986262]  [<ffffffff81235b1a>] vfs_write+0xca/0x190
[  242.987649]  [<ffffffff81235cbf>] sys_write+0x4f/0x90
[  242.989059]  [<ffffffff83699739>] system_call_fastpath+0x16/0x1b
[  242.990694] no locks held by trinity/5887.
[  242.991849] INFO: task trinity-main:5888 blocked for more than 120 seconds.
[  242.993959] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.996099] trinity-main    D 0000000000000024  6224  5888   5862 0x00000000
[  242.997984]  ffff88000a155df8 0000000000000046 ffffffff83698795 00007f1eb1681000
[  242.999936]  ffff88000a154000 ffff88000a154010 ffff88000a155fd8 ffff88000a154000
[  243.001902]  ffff88000a154010 ffff88000a155fd8 ffff88000d5b8000 ffff88000a158000
[  243.004305] Call Trace:
[  243.005032]  [<ffffffff83698795>] ? _raw_spin_unlock_irqrestore+0x65/0xc0
[  243.006916]  [<ffffffff83696d15>] schedule+0x55/0x60
[  243.008298]  [<ffffffff81b2a026>] tty_ldisc_ref_wait+0x76/0xa0
[  243.009916]  [<ffffffff81b22624>] ? redirected_tty_write+0x84/0xc0
[  243.011581]  [<ffffffff81107a50>] ? wake_up_bit+0x40/0x40
[  243.013070]  [<ffffffff81b22539>] tty_write+0x99/0x100
[  243.014466]  [<ffffffff8197fc10>] ? do_raw_spin_unlock+0xd0/0xe0
[  243.016157]  [<ffffffff81b22635>] redirected_tty_write+0x95/0xc0
[  243.017808]  [<ffffffff81235b1a>] vfs_write+0xca/0x190
[  243.019212]  [<ffffffff81235cbf>] sys_write+0x4f/0x90
[  243.020590]  [<ffffffff83699739>] system_call_fastpath+0x16/0x1b
[  243.022231] no locks held by trinity-main/5888.
[  243.023472] INFO: task trinity:5889 blocked for more than 120 seconds.
[  243.025221] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  243.027293] trinity         D 0000000000000019  6272  5889   5859 0x00000000
[  243.029152]  ffff880027789df8 0000000000000046 ffffffff83698795 00007f9af2075000
[  243.031095]  ffff880027788000 ffff880027788010 ffff880027789fd8 ffff880027788000
[  243.033041]  ffff880027788010 ffff880027789fd8 ffffffff8482d400 ffff880027753000
[  243.035040] Call Trace:
[  243.035763]  [<ffffffff83698795>] ? _raw_spin_unlock_irqrestore+0x65/0xc0
[  243.037603]  [<ffffffff83696d15>] schedule+0x55/0x60
[  243.039248]  [<ffffffff81b2a026>] tty_ldisc_ref_wait+0x76/0xa0
[  243.040911]  [<ffffffff81b22624>] ? redirected_tty_write+0x84/0xc0
[  243.042603]  [<ffffffff81107a50>] ? wake_up_bit+0x40/0x40
[  243.044118]  [<ffffffff81b22539>] tty_write+0x99/0x100
[  243.045540]  [<ffffffff8197fc10>] ? do_raw_spin_unlock+0xd0/0xe0
[  243.047209]  [<ffffffff81b22635>] redirected_tty_write+0x95/0xc0
[  243.048830]  [<ffffffff81235b1a>] vfs_write+0xca/0x190
[  243.050258]  [<ffffffff81235cbf>] sys_write+0x4f/0x90
[  243.051653]  [<ffffffff83699739>] system_call_fastpath+0x16/0x1b
[  243.053318] no locks held by trinity/5889.

