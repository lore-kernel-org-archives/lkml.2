Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab0CQJhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:37:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48974 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab0CQJhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:37:16 -0400
Date: Wed, 17 Mar 2010 10:37:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Ben Gamari <bgamari.foss@gmail.com>, tytso@mit.edu,
       linux-kernel@vger.kernel.org, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
Message-ID: <20100317093704.GA17146@elte.hu>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
 <20100317045350.GA2869@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100317045350.GA2869@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> Hi,
> 
> On Tue, Mar 16, 2010 at 08:31:12AM -0700, Ben Gamari wrote:
> > Hey all,
> > 
> > Recently I started using the Xapian-based notmuch mail client for everyday
> > use.  One of the things I was quite surprised by after the switch was the
> > incredible hit in interactive performance that is observed during database
> > updates. Things are particularly bad during runs of 'notmuch new,' which scans
> > the file system looking for new messages and adds them to the database.
> > Specifically, the worst of the performance hit appears to occur when the
> > database is being updated.
> > 
> > During these periods, even small chunks of I/O can become minute-long ordeals.
> > It is common for latencytop to show 30 second long latencies for page faults
> > and writing pages.  Interactive performance is absolutely abysmal, with other
> > unrelated processes feeling horrible latencies, causing media players,
> > editors, and even terminals to grind to a halt.
> > 
> > Despite the system being clearly I/O bound, iostat shows pitiful disk
> > throughput (700kByte/second read, 300 kByte/second write). Certainly this poor
> > performance can, at least to some degree, be attributable to the fact that
> > Xapian uses fdatasync() to ensure data consistency. That being said, it seems
> > like Xapian's page usage causes horrible thrashing, hence the performance hit
> > on unrelated processes.
> 
> Where are the unrelated processes waiting? Can you get a sample of several 
> backtraces?  (/proc/<pid>/stack should do it)

A call-graph profile will show the precise reason for IO latencies, and their 
relatively likelihood.

It's really simple to do it with a recent kernel. Firstly, enable 
CONFIG_BLK_DEV_IO_TRACE=y, CONFIG_EVENT_PROFILE=y:

  Kernel performance events and counters (PERF_EVENTS) [Y/?] y
    Tracepoint profiling sources (EVENT_PROFILE) [Y/n/?] y
    Support for tracing block IO actions (BLK_DEV_IO_TRACE) [N/y/?] y

(boot into this kernel)

Then build perf via:

  cd tools/perf/
  make -j install

and then capture 10 seconds of the DB workload:

  perf record -f -g -a -e block:block_rq_issue -c 1 sleep 10

  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.251 MB perf.data (~10977 samples) ]

and look at the call-graph output:

  perf report

# Samples: 5
#
# Overhead          Command      Shared Object  Symbol
# ........  ...............  .................  ......
#
    80.00%        kjournald  [kernel.kallsyms]  [k] perf_trace_block_rq_issue
                  |
                  --- perf_trace_block_rq_issue
                      scsi_request_fn
                     |          
                     |--50.00%-- __blk_run_queue
                     |          cfq_insert_request
                     |          elv_insert
                     |          __elv_add_request
                     |          __make_request
                     |          generic_make_request
                     |          submit_bio
                     |          submit_bh
                     |          sync_dirty_buffer
                     |          journal_commit_transaction
                     |          kjournald
                     |          kthread
                     |          kernel_thread_helper
                     |          
                      --50.00%-- __generic_unplug_device
                                generic_unplug_device
                                blk_unplug
                                blk_backing_dev_unplug
                                sync_buffer
                                __wait_on_bit
                                out_of_line_wait_on_bit
                                __wait_on_buffer
                                wait_on_buffer
                                journal_commit_transaction
                                kjournald
                                kthread
                                kernel_thread_helper

    20.00%               as  [kernel.kallsyms]  [k] perf_trace_block_rq_issue
                         |
                         --- perf_trace_block_rq_issue
                             scsi_request_fn
                             __generic_unplug_device
                             generic_unplug_device
                             blk_unplug
                             blk_backing_dev_unplug
                             page_cache_async_readahead
                             generic_file_aio_read
                             do_sync_read
                             vfs_read
                             sys_read
                             system_call_fastpath
                             0x39f8ad4930


This (very simple) example had 80% of the IO in kjournald and 20% of it in 
'as'. The precise call-paths of IO issues are visible.

For general scheduler context-switch events you can use:

  perf record -f -g -a -e context-switches -c 1 sleep 10

see 'perf list' for all events.

Thanks,

	Ingo
