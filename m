Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab0HUIld (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 04:41:33 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:49600 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751477Ab0HUIla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 04:41:30 -0400
Date: Sat, 21 Aug 2010 18:41:26 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [2.6.36-rc1] unmount livelock due to racing with bdi-flusher
 threads
Message-ID: <20100821084126.GE31488@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

I just had an umount take a very long time burning a CPU the entire
time. It wasn't the unmount thread, either, it was the the bdi
flusher thread for the the filesystem being unmounted. It was
spinning with this perf top trace:

           553144.00 76.9% writeback_inodes_wb  [kernel.kallsyms]
           106434.00 14.8% __ticket_spin_lock   [kernel.kallsyms]
            25646.00  3.6% __ticket_spin_unlock [kernel.kallsyms]
            10512.00  1.5% _raw_spin_lock       [kernel.kallsyms]
             9606.00  1.3% put_super            [kernel.kallsyms]
             7920.00  1.1% __put_super          [kernel.kallsyms]
             5592.00  0.8% down_read_trylock    [kernel.kallsyms]
               46.00  0.0% kfree                [kernel.kallsyms]
               22.00  0.0% __do_softirq         [kernel.kallsyms]
               19.00  0.0% wb_writeback         [kernel.kallsyms]
               16.00  0.0% wb_do_writeback      [kernel.kallsyms]
                8.00  0.0% queue_io             [kernel.kallsyms]
                6.00  0.0% run_timer_softirq    [kernel.kallsyms]
                6.00  0.0% local_bh_enable_ip   [kernel.kallsyms]

This went on for ~7m25s (according to the pmchart trace I had on
screen) before something broke the livelock by writing the inodes to
disk (maybe the xfssyncd) and the unmount then completed a couple
of seconds later.

>From the above profile, I'm assuming that writeback_inodes_wb() was
seeing pin_sb_for_writeback(sb) failing and moving dirty inodes from
the the b_io to the b_more_io list, then being called again,
splicing the inodes on b_more_io back to b_io, and then failed again
to pin_sb_for_writeback() for each inode, moving them back to the
b_more_io list....

This is on 2.6.36-rc1 + the radix tree fixes for writeback.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
