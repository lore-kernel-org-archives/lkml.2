Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab0IITsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:48:10 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:42473 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab0IITsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:48:07 -0400
Subject: Re: [patch -rc] oom: always return a badness score of non-zero for
 eligible tasks
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1009091152090.5556@chino.kir.corp.google.com>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	 <1284053081.7586.7910.camel@nimitz>
	 <alpine.DEB.2.00.1009091152090.5556@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 09 Sep 2010 12:48:03 -0700
Message-ID: <1284061683.7586.8100.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 12:07 -0700, David Rientjes wrote:
> On Thu, 9 Sep 2010, Dave Hansen wrote:
> 
> > Hi Nitin,
> > 
> > I've been playing with using zram (from -staging) to back some qemu
> > guest memory directly.  Basically mmap()'ing the device in instead of
> > using anonymous memory.  The old code with the backing swap devices
> > seemed to work pretty well, but I'm running into a problem with the new
> > code.
> > 
> > I have plenty of swap on the system, and I'd been running with compcache
> > nicely for a while.  But, I went to go tar up (and gzip) a pretty large
> > directory in my qemu guest.  It panic'd the qemu host system:
> > 
> > [703826.003126] Kernel panic - not syncing: Out of memory and no killable processes...
> > [703826.003127] 
> > [703826.012350] Pid: 25508, comm: cat Not tainted 2.6.36-rc3-00114-g9b9913d #29
> 
> I'm curious why there are no killable processes on the system; it seems 
> like the triggering task here, cat, would at least be killable itself.  
> Could you post the tasklist dump that preceeds this (or, if you've 
> disabled it try echo 1 > /proc/sys/vm/oom_dump_tasks first)?

That was one odd part here.  I didn't disable the tasklist dump, and
there was none in the dump.

> It's possible that if you have enough swap that none of the eligible tasks 
> actually have non-zero badness scores either because they are being run as 
> root or because the amount of RAM or swap is sufficiently high such that 
> (task's rss + swap) / (total rss + swap) is never non-zero.  And, since 
> root tasks have a 3% bonus, it's possible these are all root tasks and no 
> single task uses more than 3% of rss and swap.

It's a 64GB machine with ~30GB of swap and very little RSS.  Your
hypothesis seems correct.  Just grepping through /proc/[0-9]*/oom_score
shows nothing other than 0's.

Trying this again, I just hung the system instead of OOM'ing straight
away like last time.

Your patch makes a lot of sense to me in any case where there aren't
large-RSS tasks around using memory.  That definitely applies here
because of the amount in the compcache store and might also apply with
ramfs and hugetlbfs.

-- Dave

