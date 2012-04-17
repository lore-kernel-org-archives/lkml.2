Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab2DQVsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 17:48:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43161 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2DQVsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 17:48:36 -0400
Date: Tue, 17 Apr 2012 14:48:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, sjayaraman@suse.com,
        andrea@betterlinux.com, jmoyer@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        ctalbott@google.com, rni@google.com, lsf@lists.linux-foundation.org
Subject: Re: [RFC] writeback and cgroup
Message-ID: <20120417214831.GE19975@google.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120404145134.GC12676@redhat.com>
 <20120407080027.GA2584@quack.suse.cz>
 <20120410180653.GJ21801@redhat.com>
 <20120410210505.GE4936@quack.suse.cz>
 <20120410212041.GP21801@redhat.com>
 <20120410222425.GF4936@quack.suse.cz>
 <20120411154005.GD16692@redhat.com>
 <20120411154531.GE16692@redhat.com>
 <20120411170542.GB16008@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411170542.GB16008@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 11, 2012 at 07:05:42PM +0200, Jan Kara wrote:
> > The additional feature for buffered throttle (which never went upstream),
> > was synchronous in nature. That is we were actively putting writer to
> > sleep on a per cgroup wait queue in the request queue and wake it up when
> > it can do further IO based on cgroup limits.
>
>   Hmm, but then there would be similar starvation issues as with my simple
> scheme because async IO could always use the whole available bandwidth.
> Mixing of sync & async throttling is really problematic... I'm wondering
> how useful the async throttling is. Because we will block on request
> allocation once there are more than nr_requests pending requests so at that
> point throttling becomes sync anyway.

I haven't thought about the interface too much yet but, with the
synchronous wait at transaction start, we have information both ways -
ie. lower layer also knows that there are synchrnous waiters.  At the
simplest, not allowing any more async IOs when sync writers exist
should solve the starvation issue.

As for priority inversion through shared request pool, it is a problem
which needs to be solved regardless of how async IOs are throttled.
I'm not determined to which extent yet tho.  Different cgroups
definitely need to be on separate pools but do we also want
distinguish sync and async and what about ioprio?  Maybe we need a
bybrid approach with larger common pool and reserved ones for each
class?

Thanks.

-- 
tejun
