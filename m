Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab2E0Sfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 14:35:45 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36308 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101Ab2E0Sfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 14:35:44 -0400
X-Sasl-enc: s64DdKb3YeChAYey2TpKJIqHk/v9Rcxy0xUIZZXgwnsK 1338143743
Message-ID: <4FC273FD.8050806@fastmail.fm>
Date: Sun, 27 May 2012 19:35:41 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        alan@linux.intel.com
Subject: TTY Locking bug
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This has cropped up a few times now. The kernel is based on 786f02b from Linus' tree with a couple of networking
patches from Eric Dumazet.

[   78.262987] =============================================
[   78.264262] [ INFO: possible recursive locking detected ]
[   78.265386] 3.4.0-07822-g786f02b-dirty #2 Tainted: G         C  
[   78.266257] ---------------------------------------------
[   78.267065] plymouthd/214 is trying to acquire lock:
[   78.268027]  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81743777>] tty_lock+0x37/0x80
[   78.268892] 
[   78.268892] but task is already holding lock:
[   78.270467]  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81743777>] tty_lock+0x37/0x80
[   78.271244] 
[   78.271244] other info that might help us debug this:
[   78.272837]  Possible unsafe locking scenario:
[   78.272837] 
[   78.274420]        CPU0
[   78.275254]        ----
[   78.276038]   lock(&tty->legacy_mutex);
[   78.276818]   lock(&tty->legacy_mutex);
[   78.277585] 
[   78.277585]  *** DEADLOCK ***
[   78.277585] 
[   78.279856]  May be due to missing lock nesting notation
[   78.279856] 
[   78.281407] 2 locks held by plymouthd/214:
[   78.282188]  #0:  (tty_mutex){+.+.+.}, at: [<ffffffff813e2761>] tty_release+0x151/0x4b0
[   78.282972]  #1:  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81743777>] tty_lock+0x37/0x80
[   78.283745] 
[   78.283745] stack backtrace:
[   78.285291] Pid: 214, comm: plymouthd Tainted: G         C   3.4.0-07822-g786f02b-dirty #2
[   78.286073] Call Trace:
[   78.286875]  [<ffffffff810c8ca4>] print_deadlock_bug+0xf4/0x100
[   78.287679]  [<ffffffff810ca6e4>] validate_chain+0x644/0x720
[   78.288465]  [<ffffffff810cafed>] __lock_acquire+0x3ad/0x9f0
[   78.289258]  [<ffffffff810cafed>] ? __lock_acquire+0x3ad/0x9f0
[   78.290039]  [<ffffffff81022183>] ? native_sched_clock+0x13/0x80
[   78.290818]  [<ffffffff810221f9>] ? sched_clock+0x9/0x10
[   78.291605]  [<ffffffff810cbced>] lock_acquire+0x9d/0x200
[   78.292378]  [<ffffffff81743777>] ? tty_lock+0x37/0x80
[   78.293159]  [<ffffffff81743777>] ? tty_lock+0x37/0x80
[   78.293916]  [<ffffffff8173f574>] mutex_lock_nested+0x74/0x380
[   78.294671]  [<ffffffff81743777>] ? tty_lock+0x37/0x80
[   78.295440]  [<ffffffff813e2761>] ? tty_release+0x151/0x4b0
[   78.296206]  [<ffffffff81743777>] tty_lock+0x37/0x80
[   78.296961]  [<ffffffff817437e3>] tty_lock_pair+0x23/0x5c
[   78.297727]  [<ffffffff813e276c>] tty_release+0x15c/0x4b0
[   78.298485]  [<ffffffff811be7ec>] __fput+0xcc/0x290
[   78.299250]  [<ffffffff811be9d5>] fput+0x25/0x30
[   78.299998]  [<ffffffff813df553>] tioccons+0xc3/0xd0
[   78.300741]  [<ffffffff813e36c0>] tty_ioctl+0x560/0x960
[   78.301491]  [<ffffffff811a3016>] ? kmem_cache_free+0x96/0x260
[   78.302211]  [<ffffffff812c2710>] ? inode_has_perm.constprop.34+0x30/0x40
[   78.302934]  [<ffffffff811d0c1a>] do_vfs_ioctl+0x8a/0x340
[   78.303667]  [<ffffffff812c3c41>] ? selinux_file_ioctl+0x71/0x150
[   78.304369]  [<ffffffff811d0f61>] sys_ioctl+0x91/0xa0
[   78.305057]  [<ffffffff8174cc69>] system_call_fastpath+0x16/0x1b

Thanks,

Jack
