Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab2E1WSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 18:18:13 -0400
Received: from smp.if.uj.edu.pl ([149.156.82.206]:32791 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab2E1WSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 18:18:11 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 May 2012 18:18:10 EDT
Date: Tue, 29 May 2012 00:13:00 +0200
From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: tty locking problem (possible recursive locking detected)
Message-ID: <20120528221300.GD16584@smp.if.uj.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just compiled recent Linus tree and this is what I got after opening terminator terminal:

[ 7608.413277] 
[ 7608.413287] =============================================
[ 7608.413289] [ INFO: possible recursive locking detected ]
[ 7608.413293] 3.4.0-t43-devel-smp-08215-g1e2aec8-dirty #6 Not tainted
[ 7608.413296] ---------------------------------------------
[ 7608.413298] bash/13259 is trying to acquire lock:
[ 7608.413313]  (&tty->legacy_mutex){+.+.+.}, at: [<c17c3daf>] tty_lock+0x2f/0x70
[ 7608.413315] 
[ 7608.413315] but task is already holding lock:
[ 7608.413322]  (&tty->legacy_mutex){+.+.+.}, at: [<c17c3daf>] tty_lock+0x2f/0x70
[ 7608.413324] 
[ 7608.413324] other info that might help us debug this:
[ 7608.413327]  Possible unsafe locking scenario:
[ 7608.413327] 
[ 7608.413330]        CPU0
[ 7608.413331]        ----
[ 7608.413335]   lock(&tty->legacy_mutex);
[ 7608.413339]   lock(&tty->legacy_mutex);
[ 7608.413341] 
[ 7608.413341]  *** DEADLOCK ***
[ 7608.413341] 
[ 7608.413344]  May be due to missing lock nesting notation
[ 7608.413344] 
[ 7608.413347] 2 locks held by bash/13259:
[ 7608.413356]  #0:  (tty_mutex){+.+.+.}, at: [<c13d3405>] tty_release+0x145/0x4f0
[ 7608.413364]  #1:  (&tty->legacy_mutex){+.+.+.}, at: [<c17c3daf>] tty_lock+0x2f/0x70
[ 7608.413366] 
[ 7608.413366] stack backtrace:
[ 7608.413370] Pid: 13259, comm: bash Not tainted 3.4.0-t43-devel-smp-08215-g1e2aec8-dirty #6
[ 7608.413373] Call Trace:
[ 7608.413379]  [<c10b8945>] __lock_acquire+0x1535/0x1760
[ 7608.413386]  [<c10b0008>] ? clockevents_program_event+0xc8/0x160
[ 7608.413391]  [<c101d2d8>] ? sched_clock+0x8/0x10
[ 7608.413397]  [<c1080413>] ? set_groups+0xd3/0x170
[ 7608.413402]  [<c10b91a9>] lock_acquire+0x89/0x1b0
[ 7608.413406]  [<c17c3daf>] ? tty_lock+0x2f/0x70
[ 7608.413413]  [<c17c02d0>] mutex_lock_nested+0x70/0x300
[ 7608.413417]  [<c17c3daf>] ? tty_lock+0x2f/0x70
[ 7608.413421]  [<c17c3daf>] ? tty_lock+0x2f/0x70
[ 7608.413425]  [<c17c3daf>] tty_lock+0x2f/0x70
[ 7608.413429]  [<c17c3e0d>] tty_lock_pair+0x1d/0x56
[ 7608.413433]  [<c13d340e>] tty_release+0x14e/0x4f0
[ 7608.413440]  [<c118f5ec>] fput+0xfc/0x230
[ 7608.413444]  [<c10b413c>] ? lock_release_holdtime.part.20+0xcc/0xf0
[ 7608.413450]  [<c118a792>] filp_close+0x52/0x80
[ 7608.413454]  [<c118b0ea>] sys_close+0x8a/0x160
[ 7608.413460]  [<c17cb998>] sysenter_do_call+0x12/0x38



I belive this is releated to recent tty and tty lock changes:

commit 94b5aff4c6f72fee6b0f49d49e4fa8b204e8ded9
Merge: 5d4e2d0 59bd234
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 22 16:12:24 2012 -0700

    Merge tag 'tty-3.5-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty



This is 32-bit Intel system (i386), with gcc 4.7.0-9 from Debian sid.


Regards,
Witek

-- 
Witold Baryluk
