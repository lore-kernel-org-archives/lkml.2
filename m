Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab2JNVRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 17:17:39 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23780 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470Ab2JNVRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 17:17:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnQnAHAre1B5LH33/2dsb2JhbABEhSm0XIRnAoEDgQmCIAEBBTocIxAIAxguFCUDIROIA7wDFItFgWeEVgOVa5AxgwE
Date: Mon, 15 Oct 2012 08:17:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: Alex Bligh <alex@alex.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Local DoS through write heavy I/O on CFQ & Deadline
Message-ID: <20121014211735.GU2739@dastard>
References: <0B138F62-16BF-4295-9AD9-64C0BB39FCE2@alex.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0B138F62-16BF-4295-9AD9-64C0BB39FCE2@alex.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 01:23:32PM +0100, Alex Bligh wrote:
> We have noticed significant I/O scheduling issues on both the CFQ and the
> deadline scheduler where a non-root user can starve any other process of
> any I/O for minutes at a time. The problem is more serious using CFQ but is
> still an effective local DoS vector using Deadline.
> 
> A simple way to generate the problem is:
> 
>   dd if=/dev/zero of=- bs=1M count=50000 | dd if=- of=myfile bs=1M count=50000
> 
> (note use of 2 dd's is to avoid alleged optimisation of the writing dd
> from /dev/zero). zcat-ing a large file with stout redirected to a file
> produces a similar error. Using ionice to set idle priority makes no
> difference.
> 
> To instrument the problem we produced a python script which does a MySQL
> select and update every 10 seconds, and time the execution of the update.
> This is normally milliseconds, but under user generated load conditions, we
> can take this to indefinite (on CFQ) and over a minute (on deadline).
> Postgres is affected in a similar manner (i.e. it is not MySQL specific).
> Simultaneously we have captured the output of 'vmstat 1 2' and
> /proc/meminfo, with appropriate timestamps.

Well, mysql is stuck in fsync(), so of course it's going to have
problems with write latency:

[ 3840.268303] [<ffffffff812650d5>] jbd2_log_wait_commit+0xb5/0x130
[ 3840.268308] [<ffffffff8108aa50>] ? add_wait_queue+0x60/0x60
[ 3840.268313] [<ffffffff81211248>] ext4_sync_file+0x208/0x2d0

And postgres gets stuck there too. So what you are seeing is likely
an ext4 problem, not an IO scheduler problem.

Suggestion: try the same test with XFS. If the problem still exists,
then it *might* be an ioscheduler problem. If it goes away, then
it's an ext4 problem.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
