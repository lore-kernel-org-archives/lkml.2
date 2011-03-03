Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397Ab1CCPaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 10:30:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab1CCPaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 10:30:23 -0500
Date: Thu, 3 Mar 2011 10:30:07 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Justin TerAvest <teravest@google.com>, Chad Talbott <ctalbott@google.com>,
        Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>
Subject: Per iocontext request descriptor limits (Was: Re: RFC: default
 group_isolation to 1, remove option)
Message-ID: <20110303153007.GF16720@redhat.com>
References: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com>
 <20110301142002.GB25699@redhat.com>
 <4D6F0ED0.80804@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6F0ED0.80804@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 10:45:20PM -0500, Jens Axboe wrote:
> On 2011-03-01 09:20, Vivek Goyal wrote:
> > I think creating per group request pool will complicate the
> > implementation further. (we have done that once in the past). Jens
> > once mentioned that he liked number of requests per iocontext limit
> > better than overall queue limit. So if we implement per iocontext
> > limit, it will get rid of need of doing anything extra for group
> > infrastructure.
> > 
> > Jens, do you think per iocontext per queue limit on request
> > descriptors make sense and we can get rid of per queue overall limit? 
> 
> Since we practically don't need a limit anymore to begin with (or so is
> the theory).

So what has changed that we don't need queue limits on nr_requests anymore?
If we get rid of queue limits then we need to get rid of bdi congestion
logic also and come up with some kind of ioc congestion logic so that
a thread which does not want to sleep while submitting the request needs to
checks it own ioc for being congested or not for a specific device/bdi. 

>then yes we can move to per-ioc limits instead and get rid
> of that queue state. We'd have to hold on to the ioc for the duration of
> the IO explicitly from the request then.

I think every request submitted on request queue already takes a reference
on ioc (set_request) and reference is not dropped till completion. So
ioc is anyway around till request completes.

> 
> I primarily like that implementation since it means we can make the IO
> completion lockless, at least on the block layer side. We still have
> state to complete in the schedulers that require that, but it's a good
> step at least.

Ok so in completion path the contention will move from queue_lock to
ioc lock or something like that. (We hope that there are no other
dependencies on queue here, devil lies in details :-))

The other potential issue with this approach is how will we handle the
case of flusher thread submitting IO. At some point of time we want to
account it to right cgroup.

Retrieving iocontext from bio will be hard as it will atleast require
on extra pointer in page_cgroup and I am not sure how feasible that is.

Or we could come up with the concept of group iocontext. With the help
of page cgroup we should be able to get to cgroup, retrieve the right
group iocontext and check the limit against that. But I guess this
get complicated. 

So if we move to ioc based limit, then for async IO, a reasonable way
would be to find the io context of submitting task and operate on that
even if that means increased page_cgroup size.

Thanks
Vivek 
