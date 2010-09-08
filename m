Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab0IHIq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:46:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:46566 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758373Ab0IHIqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:46:21 -0400
Message-ID: <4C874D55.6080402@kernel.org>
Date: Wed, 08 Sep 2010 10:46:13 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
References: <20100907072954.GM705@dastard> <4C86003B.6090706@kernel.org> <20100907100108.GN705@dastard> <4C861582.6080102@kernel.org> <20100907124850.GP705@dastard> <4C865CC4.9070701@kernel.org> <20100908073428.GR705@dastard> <4C87474B.3050405@kernel.org> <20100908082819.GV705@dastard>
In-Reply-To: <20100908082819.GV705@dastard>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 08:46:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/08/2010 10:28 AM, Dave Chinner wrote:
>> They may if necessary to keep the workqueue progressing.
> 
> Ok, so the normal case is that they will all be processed local to the
> CPU they were queued on, like the old workqueue code?

Bound workqueues always process works locally.  Please consider the
following scenario.

 w0, w1, w2 are queued to q0 on the same CPU.  w0 burns CPU for 5ms
 then sleeps for 10ms then burns CPU for 5ms again then finishes.  w1
 and w2 sleeps for 10ms.

The following is what happens with the original workqueue (ignoring
all other tasks and processing overhead).

 TIME IN MSECS	EVENT
 0		w0 burns CPU
 5		w0 sleeps
 15		w0 wakes and burns CPU
 20		w0 finishes, w1 starts and sleeps
 30		w1 finishes, w2 starts and sleeps
 40		w2 finishes

With cmwq if @max_active >= 3,

 TIME IN MSECS	EVENT
 0		w0 burns CPU
 5		w0 sleeps, w1 starts and sleeps, w2 starts and sleeps
 15		w0 wakes and burns CPU, w1 finishes, w2 finishes
 20		w0 finishes

IOW, cmwq assigns a new worker when there are more work items to
process but no work item is currently in progress on the CPU.  Please
note that this behavior is across *all* workqueues.  It doesn't matter
which work item belongs to which workqueue.

Thanks.

-- 
tejun
