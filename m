Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab2AFJAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 04:00:16 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62548 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab2AFJAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 04:00:14 -0500
X-AuditID: 9c93016f-b7c8eae000000e9e-63-4f06b816dfa9
Message-ID: <4F06B814.2000006@lge.com>
Date: Fri, 06 Jan 2012 18:00:04 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dsharp@google.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET RESEND] ioblame: statistical IO analyzer
References: <1325806974-23486-1-git-send-email-tj@kernel.org>
In-Reply-To: <1325806974-23486-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tejun

2012-01-06 AM 8:42, Tejun Heo Wrote:
> This is re-post.  The original posting was on Dec 15th but it was
> missing cc to LKML.  I got some responses on that thread so didn't
> suspect LKML was missing.  If you're getting it the second time.  My
> apologies.
>
> Stuff pointed out in the original thread are...
>
> * Is the quick variant of backtrace gathering really necessary? -
>    Still need to get performance numbers.
>
> * TRACE_EVENT_CONDITION() can be used in some places. - Will be
>    updated.
>
> Original message follows.  Thanks.
>
> Hello, guys.
>
> Even with blktrace and tracepoints, getting insight into the IOs going
> on a system is very challenging.  A lot of IO operations happen long
> after the action which triggered the IO finished and the overall
> asynchronous nature of IO operations make it difficult to trace back
> the origin of a given IO.
>
> ioblame is an attempt at providing better visibility into overall IO
> behavior.  ioblame hooks into various tracepoints and tries to
> determine who caused any given IO how and charges the IO accordingly.
>
> On each IO completion, ioblame knows who to charge the IO (task), how
> the IO got triggered (stack trace at the point of triggering, be it
> page, inode dirtying or direct IO issue) and various information about
> the IO itself (offset, size, how long it took and so on).  ioblame
> collects this information into histograms which is configurable from
> userland using debugfs interface.
>
> For example, using ioblame, user can acquire information like "this
> task triggered IO with this stack trace on this file with the
> following offset distribution".
>
> For more details, please read Documentation/trace/ioblame.txt, which
> I'll append to this message too for discussion.
>
> This patchset contains the following 11 patches.
>
>    0001-trace_event_filter-factorize-filter-creation.patch
>    0002-trace_event_filter-add-trace_event_filter_-interface.patch
>    0003-block-block_bio_complete-tracepoint-was-missing.patch
>    0004-block-add-req-to-bio_-front-back-_merge-tracepoints.patch
>    0005-block-abstract-disk-iteration-into-disk_iter.patch
>    0006-writeback-move-struct-wb_writeback_work-to-writeback.patch
>    0007-writeback-add-more-tracepoints.patch
>    0008-block-add-block_touch_buffer-tracepoint.patch
>    0009-vfs-add-fcheck-tracepoint.patch
>    0010-stacktrace-implement-save_stack_trace_quick.patch
>    0011-block-trace-implement-ioblame-IO-statistical-analyze.patch
>
> 0001-0002 export trace_event_filter so that ioblame can use it too.
>
> 0003 adds back block_bio_complete TP invocation, which got lost
> somehow.  This probably makes sense as fix patch for 3.2.
>
> 0004-0006 update block layer in preparation.  0005 probably makes
> sense as a standalone patch too.
>
> 0007-0009 add more tracepoints along the IO stack.
>
> 0010 adds nimbler backtrace dump function as ioblame dumps stacktrace
> extremely frequently.
>
> 0011 implements ioblame.
>
> This is still in early stage and I haven't done much performance
> analysis yet.  Tentative testing shows it adds ~20% CPU overhead when
> used on memory backed loopback device.
>
> The patches are on top of mainline (42ebfc61cf "Merge branch
> 'stable...git/konrad/xen'") and perf/core (74eec26fac "perf tools: Add
> ability to synthesize event according to a sample").
>
> It's also available in the following git branch.
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-ioblame
>

Very interesting. It should help analyzing and improving IO performance 
a lot.

BTW, it seems the ioblame based on event tracing feature, so couldn't it 
be implemented in userspace with the help of the tracepoints and 
additional information (e.g. intent, ...) you add? The perf can deal 
with them and extend post-processing capability easily, and also might 
reduce some kernel jobs, I guess.

Thanks
Namhyung Kim
