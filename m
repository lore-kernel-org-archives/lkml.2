Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab0KCRqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:46:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:23100 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab0KCRqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:46:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,289,1286175600"; 
   d="scan'208";a="344208110"
Date: Thu, 4 Nov 2010 01:46:43 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "mrubin@google.com" <mrubin@google.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.37-rc1] /proc/vmstat failure.
Message-ID: <20101103174643.GA4985@localhost>
References: <201011010053.ADE86905.JMLFHVtSQOOFOF@I-love.SAKURA.ne.jp>
 <201011032011.BAB21899.OHVQtFLSFJMFOO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011032011.BAB21899.OHVQtFLSFJMFOO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 07:11:11PM +0800, Tetsuo Handa wrote:
> Hello.
> 
> "cat /proc/vmstat" triggered below failure.
> 
> BUG: unable to handle kernel paging request at 07c06d16
> IP: [<c050c336>] strnlen+0x6/0x20

It seems that m->private is of type (void *) while the original v is
(unsigned long *). Can be fixed by the following patch.

Thanks,
Fengguang
---
diff --git a/mm/vmstat.c b/mm/vmstat.c
index cd2e42b..42eac4d 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -949,7 +949,7 @@ static void *vmstat_start(struct seq_file *m, loff_t *pos)
 	v[PGPGIN] /= 2;		/* sectors -> kbytes */
 	v[PGPGOUT] /= 2;
 #endif
-	return m->private + *pos;
+	return (unsigned long *)m->private + *pos;
 }
 
 static void *vmstat_next(struct seq_file *m, void *arg, loff_t *pos)
