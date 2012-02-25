Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2BYVon (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 16:44:43 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34803 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab2BYVol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 16:44:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.132.74 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Sun, 26 Feb 2012 06:44:21 +0900
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120225214421.GA3401@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
 <20120223144336.58742e1b.akpm@linux-foundation.org>
 <20120223230123.GL22536@google.com>
 <20120223231204.GM22536@google.com>
 <20120224142033.GA5095@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224142033.GA5095@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Fri, Feb 24, 2012 at 09:20:33AM -0500, Vivek Goyal wrote:
> Ok. I will write a patch. Things have changed a lot since last time.
> I think there is only one tricky part and that is waiting for any
> scheduled work to finish during blkg destruction.  Because group destruction
> happens under both queue and blkcg spin locks, I think I will have to take
> the group off list, drop locks, wait for worker thread to finish and then
> take locks again and walk through list again to kill remaining groups.

Rather than embedding work_struct into blkg and tying work and blkg
destruction, why not just create a spinlock protected alloc-pending
list?  On blkg creation, link blkg onto that list and kick shared work
item and on destruction, just unlink it.  Worker function can walk the
list and try to alloc for all and reschedule if alloc fails.

Thanks.

-- 
tejun
