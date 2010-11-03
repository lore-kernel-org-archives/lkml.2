Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab0KCR4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:56:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:37250 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab0KCR4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:56:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,289,1286175600"; 
   d="scan'208";a="673957520"
Date: Thu, 4 Nov 2010 01:56:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "mrubin@google.com" <mrubin@google.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] vmstat: fix offset calculation on void*
Message-ID: <20101103175648.GA6398@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix regression introduced by commit 79da826aee6.

	BUG: unable to handle kernel paging request at 07c06d16
	IP: [<c050c336>] strnlen+0x6/0x20

	Call Trace:
	 [<c050a249>] ? string+0x39/0xe0
	 [<c042be6b>] ? __wake_up_common+0x4b/0x80
	 [<c050afcc>] ? vsnprintf+0x1ec/0x380
	 [<c04b380e>] ? seq_printf+0x2e/0x60
	 [<c04829a6>] ? vmstat_show+0x26/0x30
	 [<c04b3bb6>] ? seq_read+0xa6/0x380
	 [<c04b3b10>] ? seq_read+0x0/0x380
	 [<c04d5d2f>] ? proc_reg_read+0x5f/0x90
	 [<c049c4a1>] ? vfs_read+0xa1/0x140
	 [<c04d5cd0>] ? proc_reg_read+0x0/0x90
	 [<c049c981>] ? sys_read+0x41/0x70
	 [<c0402bd0>] ? sysenter_do_call+0x12/0x26


CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: Michael Rubin <mrubin@google.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---

Hopefully Tetsuo can test it soon, thanks!

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/mm/vmstat.c	2010-11-04 01:49:12.000000000 +0800
+++ linux-2.6/mm/vmstat.c	2010-11-04 01:49:23.000000000 +0800
@@ -949,7 +949,7 @@ static void *vmstat_start(struct seq_fil
 	v[PGPGIN] /= 2;		/* sectors -> kbytes */
 	v[PGPGOUT] /= 2;
 #endif
-	return m->private + *pos;
+	return (unsigned long *)m->private + *pos;
 }
 
 static void *vmstat_next(struct seq_file *m, void *arg, loff_t *pos)
