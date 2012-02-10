Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172Ab2BJUq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:46:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50933 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760115Ab2BJUq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:46:57 -0500
Date: Fri, 10 Feb 2012 12:46:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bug in disk event polling
Message-ID: <20120210204652.GJ19392@google.com>
References: <Pine.LNX.4.44L0.1202101519020.1281-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1202101519020.1281-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Rafael)

Hello, Alan.

On Fri, Feb 10, 2012 at 03:31:20PM -0500, Alan Stern wrote:
> Don't ask me why this hasn't shown up earlier...  There's a big fat bug 
> in the implementation of disk event polling.
> 
> The polling is done using the system_nrt_wq work queue, which isn't
> freezable.  As a result, polling continues while the system is
> preparing for suspend or hibernation.
> 
> Obviously I/O to suspended devices doesn't work well.  Somewhat less 
> obviously, error recovery for the failed I/O attempts can interfere 
> with normal system resume.

Hmmm.... I see.  Yeah, that can be a problem.

> You can see this for yourself easily enough by suspending or
> hibernating while a USB flash drive is plugged in.  You don't even need
> to go through the full suspend procedure; the first two stages are
> enough (echo devices >/sys/power/pm_test).  Check the system log
> afterward; most likely you'll find the flash drive got errors and had
> to be unregistered and re-enumerated.

Do you happen to have log of such failure?  Polilng failure itself
shouldn't lead to such failure mode.

> I have verified that changing all occurrences of system_nrt_wq in 
> block/genhd.c to system_freezable_wq fixes the bug.  However this may 
> not be the way you want to solve it; you may prefer to have a freezable 
> non-reentrant work queue.

Please feel free to send out a patch to fix the issue. :)

Thanks.

-- 
tejun
