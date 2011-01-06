Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1AFLsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 06:48:47 -0500
Received: from copper.chdir.org ([88.191.97.87]:38296 "EHLO copper.chdir.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab1AFLsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 06:48:46 -0500
X-Greylist: delayed 629 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2011 06:48:46 EST
X-Hashcash: 1:20:110106:cl@linux.com::mXWfOZ69jF8dAkVt:00000D6X4
X-Hashcash: 1:20:110106:mel@csn.ul.ie::w5P7+Bb3PjcH1Oa5:00001Gis
X-Hashcash: 1:20:110106:akpm@linux-foundation.org::YUCKL3MGzYA58nEd:000000000000000000000000000000000000207V
X-Hashcash: 1:20:110106:torvalds@linux-foundation.org::EDeGYWcjJqc/sxVa:000000000000000000000000000000006UWD
X-Hashcash: 1:20:110106:linux-kernel@vger.kernel.org::nykAgJ2TmQ9Io6uW:0000000000000000000000000000000001SaF
From: Nicolas Bareil <nico@chdir.org>
To: cl@linux.com, mel@csn.ul.ie
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [BISECTED][REGRESSION] INFO: rcu_sched_state detected stall on CPU
Date: Thu, 06 Jan 2011 12:38:15 +0100
Message-ID: <87mxne6z4o.fsf@puppet.chdir.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello

On my two HP Proliant DL160 G6, the system locks up for tens of seconds
when I copy a regular file into a LVM volume with the following command
line:

$ sudo dd if=5gigabytesfile of=/dev/hosts/myvol bs=4096

Logs are filled with call traces and theses messages:

  kernel: INFO: rcu_sched_state detected stall on CPU 5 (t=6000 jiffies)
  kernel: Uhhuh. NMI received for unknown reason 00 on CPU 7.
  kernel: Do you have a strange power saving mode enabled?
  kernel: Dazed and confused, but trying to continue


 My .config is available here : http://chdir.org/~nbareil/aa45484031/config-2.6.37.gz
 The (big!) kern.log is here  : http://chdir.org/~nbareil/aa45484031/kern.log.gz
 My System.map                : http://chdir.org/~nbareil/aa45484031/System.map-2.6.37.gz

After bisection, the culprit is aa45484031, to be 100% sure, I compiled
a 2.6.37 with this commit reverted and it works.

As a reminder, here is the commit:

commit aa45484031ddee09b06350ab8528bfe5b2c76d1c
Author: Christoph Lameter <cl@linux.com>
Date:   Thu Sep 9 16:38:17 2010 -0700

    mm: page allocator: calculate a better estimate of NR_FREE_PAGES
    when memory is low and kswapd is awake
    
    Ordinarily watermark checks are based on the vmstat NR_FREE_PAGES as
    it is cheaper than scanning a number of lists.  To avoid
    synchronization overhead, counter deltas are maintained on a per-cpu
    basis and drained both periodically and when the delta is above a
    threshold.  On large CPU systems, the difference between the
    estimated and real value of NR_FREE_PAGES can be very high.  If
    NR_FREE_PAGES is much higher than number of real free page in buddy,
    the VM can allocate pages below min watermark, at worst reducing the
    real number of pages to zero.  Even if the OOM killer kills some
    victim for freeing memory, it may not free memory if the exit path
    requires a new page resulting in livelock.
    
    This patch introduces a zone_page_state_snapshot() function
    (courtesy of Christoph) that takes a slightly more accurate view of
    an arbitrary vmstat counter.  It is used to read NR_FREE_PAGES while
    kswapd is awake to avoid the watermark being accidentally broken.
    The estimate is not perfect and may result in cache line bounces but
    is expected to be lighter than the IPI calls necessary to
    continually drain the per-cpu counters while kswapd is awake.
    
    Signed-off-by: Christoph Lameter <cl@linux.com>
    Signed-off-by: Mel Gorman <mel@csn.ul.ie>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


Let me know if you need anything.
