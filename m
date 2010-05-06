Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0EFWSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 18:18:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085Ab0EFWSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 18:18:36 -0400
Date: Thu, 6 May 2010 15:18:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: linux-kernel@vger.kernel.org, Paul Clements <paul.clements@steeleye.com>
Subject: Re: [2.6.32] task hung
Message-Id: <20100506151828.de5cdbd1.akpm@linux-foundation.org>
In-Reply-To: <20100504124950.GK29057@vanheusden.com>
References: <20100504124950.GK29057@vanheusden.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 May 2010 14:49:50 +0200
Folkert van Heusden <folkert@vanheusden.com> wrote:

> Hi,
> 
> I'm copying 6GB of data onto an NBD device using a simple tool which
> differs from dd/cat in that it measures how long it takes to write each
> block and does a sync after each block.
> Now during that run I get:
> 
> [45480.665074] INFO: task measurecopy:13780 blocked for more than 120 seconds.
> [45480.665086] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [45480.665090] measurecopy   D 0000000000000000     0 13780  30341 0x00000000
> [45480.665102]  ffff8801bf06d4c0 0000000000000082 0000000000000000 ffff8801776d9d04
> [45480.665116]  0000000000000001 ffff88000000f640 000000000000f8a0 ffff8801776d9fd8
> [45480.665129]  00000000000155c0 00000000000155c0 ffff8801a867d4c0 ffff8801a867d7b8
> [45480.665143] Call Trace:
> [45480.665153]  [<ffffffff8106beb9>] ? ktime_get_ts+0x68/0xb2
> [45480.665159]  [<ffffffff81098f06>] ? delayacct_end+0x74/0x7f
> [45480.665168]  [<ffffffff810b3219>] ? sync_page+0x0/0x46
> [45480.665175]  [<ffffffff812edf36>] ? io_schedule+0x73/0xb7
> [45480.665181]  [<ffffffff810b325a>] ? sync_page+0x41/0x46
> [45480.665186]  [<ffffffff812ee436>] ? __wait_on_bit+0x41/0x70
> [45480.665192]  [<ffffffff810b33de>] ? wait_on_page_bit+0x6b/0x71
> [45480.665199]  [<ffffffff81064a84>] ? wake_bit_function+0x0/0x23
> [45480.665206]  [<ffffffff810baf36>] ? pagevec_lookup_tag+0x1a/0x21
> [45480.665212]  [<ffffffff810b3bb4>] ? wait_on_page_writeback_range+0x69/0x11b
> [45480.665218]  [<ffffffff810b3d26>] ? filemap_write_and_wait_range+0x43/0x52
> [45480.665225]  [<ffffffff8110a176>] ? vfs_fsync_range+0x55/0x9e
> [45480.665231]  [<ffffffff8110a23e>] ? do_fsync+0x28/0x39
> [45480.665236]  [<ffffffff8110a25d>] ? sys_fdatasync+0xe/0x13
> [45480.665243]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
> 
> command line:
> ./measurecopy -i /dev/VG01/LVHOME -o /dev/nbd0 -s -b 1048576
> 
> http://www.vanheusden.com/measurecopy/
> 
> 

end_page_writeback() never got run against a page.  My guess would be
that NBD got its knickers in a knot.
