Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0HQCxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:53:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:8309 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab0HQCxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:53:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,379,1278313200"; 
   d="scan'208";a="828794936"
Date: Tue, 17 Aug 2010 10:53:31 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH] Per file dirty limit throttling
Message-ID: <20100817025331.GC13916@localhost>
References: <201008160949.51512.knikanth@suse.de>
 <4C696CFD.7070003@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C696CFD.7070003@tmr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill,

On Tue, Aug 17, 2010 at 12:53:17AM +0800, Bill Davidsen wrote:
> Nikanth Karthikesan wrote:
> > When the total dirty pages exceed vm_dirty_ratio, the dirtier is made to do
> > the writeback. But this dirtier may not be the one who took the system to this
> > state. Instead, if we can track the dirty count per-file, we could throttle
> > the dirtier of a file, when the file's dirty pages exceed a certain limit.
> > Even though this dirtier may not be the one who dirtied the other pages of
> > this file, it is fair to throttle this process, as it uses that file.
> > 
> I agree with your problem description, a single program which writes a single 
> large file can make an interactive system suck. Creating a 25+GB Blu-Ray image 
> will often saturate the buffer space. I played with per-fd limiting during 
> 2.5.xx development and I had an app writing 5-10GB files. While I wanted to get 
> something to submit while the kernel was changing, I kept hitting cornet cases.

The block layer in recent kernels are much better at preventing SYNC
read/write from being delayed by lots of ASYNC writeback requests.
And we are attacking the other responsiveness problems under light
memory pressure.

> > This patch
> > 1. Adds dirty page accounting per-file.
> > 2. Exports the number of pages of this file in cache and no of pages dirty via
> > proc-fdinfo.
> > 3. Adds a new tunable, /proc/sys/vm/file_dirty_bytes. When a files dirty data
> > exceeds this limit, the writeback of that inode is done by the current
> > dirtier.
> > 
> I think you have this in the wrong place, can't it go in balance_dirty_pages?
> 
> > This certainly will affect the throughput of certain heavy-dirtying workloads,
> > but should help for interactive systems.
> > 
> I found that the effect was about the same as forcing the application to use 
> O_DIRECT, and since it was our application I could do that. Not all 
> badly-behaved programs are open source, so that addressed my issue but not the 
> general case.
> 
> I think you really need to track by process, not file, as you said "Even though 
> this dirtier may not be the one who dirtied the other pages of this file..." 
> that doesn't work, you block a process which is contributing minimally to the 
> problem while letting the real problem process continue. Ex: a log file, with 
> one process spewing error messages while others write a few lines/min. You have 
> to get it right, I think.

Good point. Peter implemented that idea long ago in upstream kernel,
see the comment for task_dirty_limit() in commit 1babe1838.

Thanks,
Fengguang
