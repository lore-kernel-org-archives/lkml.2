Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab2IZQuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:50:07 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:46450 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374Ab2IZQuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:50:03 -0400
Date: Wed, 26 Sep 2012 09:49:58 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] workqueue: restructure flush_workqueue() and
 start all flusher at the same time
Message-ID: <20120926164958.GR16296@google.com>
References: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
 <20120924203954.GD29689@google.com>
 <50617333.9020903@cn.fujitsu.com>
 <20120925202427.GM16296@google.com>
 <5062893B.70908@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5062893B.70908@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Wed, Sep 26, 2012 at 12:48:59PM +0800, Lai Jiangshan wrote:
> > Hmmm... so, that's a lot simpler.  flush_workqueue() isn't a super-hot
> > code path and I don't think grabbing mutex twice is too big a deal.  I
> > haven't actually reviewed the code but if it can be much simpler and
> > thus easier to understand and verify, I might go for that.
> 
> I updated it. it is attached, it forces flush_workqueue() to grab
> mutex twice(no other forcing).  overflow queue is implemented in a
> different way. This new algorithm may become our choice likely,
> please review this one.

Will do shortly.

> I did not know this history, thank you.
> 
> But the number of colors is not essential.
> "Does the algorithm chain flushers" is essential.
> 
> If we can have multiple flushers for each color. It is not chained.
> If we have only one flusher for one color. It is chained. Even we
> have multiple color, it is still partially chained(image we have
> very high frequent flush_workqueue()).

If you have very few colors, you can end up merging flushes of a lot
of work items which in turn delays the next flush and thus merging
more of them.  This was what Linus was worried about.

> The initial implementation of flush_workqueue() is "chained" algorithm.

I don't know what you mean by "chained" here.  The current mainline
implementation has enough colors for most use cases and don't assign a
color to single work item.  It's specifically designed to avoid
chained latencies.

> The initial implementation of SRCU is also "chained" algorithm.
> but the current SRCU which was implemented by me is not "chained"
> (I don't propose to use SRCU for flush_workqueue(), I just discuss it)

So, you lost me.  The current implementation doesn't have a problem on
that front.

> The simple version of flush_workqueue() which I sent yesterday is "chained",
> because it forces overflow flushers wait for free color and forces only one
> flusher for one color.
>
> Since "not chaining" is important/essential. I sent a new draft implement today.
> it uses multiple queues, one for each color(like SRCU).
> this version is also simple, it remove 90 LOC.

I'll review your patch but the current implementation is enough on
that regard.  I was trying to advise against going for two-color
scheme.

Thanks.

-- 
tejun
