Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab2IYUYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 16:24:33 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63194 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab2IYUYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 16:24:32 -0400
Date: Tue, 25 Sep 2012 13:24:27 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] workqueue: restructure flush_workqueue() and
 start all flusher at the same time
Message-ID: <20120925202427.GM16296@google.com>
References: <1348481238-6138-1-git-send-email-laijs@cn.fujitsu.com>
 <20120924203954.GD29689@google.com>
 <50617333.9020903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50617333.9020903@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Tue, Sep 25, 2012 at 05:02:43PM +0800, Lai Jiangshan wrote:
> It is not possible to remove cascading. If cascading code is
> not in flush_workqueue(), it must be in some where else.

Yeah, sure, I liked that it didn't have to be done explicitly as a
separate step.

> If you force overflow to wait for freed color before do flush(which also
> force only one flusher for one color), and force the sole flush_workqueue()
> to grab ->flush_mutex twice, we can simplify the flush_workqueue().
> (see the attached patch, it remove 100 LOC, and the cascading code becomes
> only 3 LOC). But these two forcing slow down the caller a little.

Hmmm... so, that's a lot simpler.  flush_workqueue() isn't a super-hot
code path and I don't think grabbing mutex twice is too big a deal.  I
haven't actually reviewed the code but if it can be much simpler and
thus easier to understand and verify, I might go for that.

> (And if you allow to use SRCU(which is only TWO colors), you can remove another
> 150 LOC. flush_workqueue() will become single line. But it will add some more overhead
> in flush_workqueue() because SRCU's readsite is lockless)

I'm not really following how SRCU would factor into this but
supporting multiple colors was something explicitly requested by
Linus.  The initial implementation was a lot simpler which supported
only two colors.  Linus was worried that the high possibility of
flusher clustering could lead to chaining of latencies.

Thanks.

-- 
tejun
