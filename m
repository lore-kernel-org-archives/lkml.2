Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab0KDDBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 23:01:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:13400 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab0KDDA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 23:00:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,293,1286175600"; 
   d="scan'208";a="623364987"
Date: Thu, 4 Nov 2010 11:00:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Shi, Alex" <alex.shi@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "pzijlstr@redhat.com" <pzijlstr@redhat.com>
Subject: Re: VM ops on 37-rc1
Message-ID: <20101104030054.GA18626@localhost>
References: <1288767341.15466.4624.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288767341.15466.4624.camel@debian>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is discuss and fixed in another LKML thread, thanks.

---
commit ff8b16d7e15a8ba2a6086645614a483e048e3fbf
Author: Wu Fengguang <fengguang.wu@intel.com>
Date:   Thu Nov 4 01:56:49 2010 +0800
                                     
    vmstat: fix offset calculation on void*
                                           
    Fix regression introduced by commit 79da826aee6 ("writeback: report
    dirty thresholds in /proc/vmstat").                                
                                       
    The incorrect pointer arithmetic can result in problems like this:
                                                                      
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
                                                
    Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Cc: Michael Rubin <mrubin@google.com>                         
    Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/vmstat.c b/mm/vmstat.c
index cd2e42b..42eac4d 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -949,7 +949,7 @@ static void *vmstat_start(struct seq_file *m, loff_t *pos)
        v[PGPGIN] /= 2;         /* sectors -> kbytes */
        v[PGPGOUT] /= 2;
 #endif
-       return m->private + *pos;
+       return (unsigned long *)m->private + *pos;
 }
 
 static void *vmstat_next(struct seq_file *m, void *arg, loff_t *pos)
