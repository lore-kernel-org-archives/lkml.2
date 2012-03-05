Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab2CERpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:45:15 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34895 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab2CERpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:45:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.224.9 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Mon, 5 Mar 2012 09:45:09 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120305174509.GR22536@google.com>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
 <20120223144336.58742e1b.akpm@linux-foundation.org>
 <20120223230123.GL22536@google.com>
 <20120223231204.GM22536@google.com>
 <20120225034432.GA18391@redhat.com>
 <20120225214641.GB3401@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120225222113.GE3401@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120227142529.GA27677@redhat.com>
 <20120227144045.GB27677@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120227144045.GB27677@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 27, 2012 at 09:40:45AM -0500, Vivek Goyal wrote:
> So we call following.
> 
> elevator_switch()
>   blkg_destroy_all()
>     update_root_blkg();
> 
> Here update_root_blkg() will free up the blkg->pd for cfq. 
> 
> And later we call.
> 
> elevator_exit()
>   cfq_exit_queue()
>     cfq_put_async_queues()
>       cfq_put_queue()
>         blkg_put(cfqg_to_blkg(cfqg)); <------ trying to reach blkg through
> already freed policy data.
> 
> So we should not free up root group policy data till old elevator has
> exited.

Yeah, this analysis seems correct.  For some reason, I still can't
reproduce it even with slab debugging turned on.  I modified the free
path to fill *pd with pattern w/o actually freeing it and now can see
similar crashes.  Will post fix soon.

Thanks a lot.

-- 
tejun
