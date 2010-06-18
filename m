Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849Ab0FRR33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:29:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:46936 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933834Ab0FRR32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:29:28 -0400
Message-ID: <4C1BACC6.5020602@kernel.org>
Date: Fri, 18 Jun 2010 19:28:38 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andy Walls <awalls@md.metrocast.net>,
       Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org>	<4C17C598.7070303@kernel.org>	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>	<4C18BF40.40607@kernel.org>	<1276694825.9309.12.camel@m0nster>	<4C18D1FD.9060804@kernel.org>	<1276695665.9309.17.camel@m0nster>	<4C18D574.1040903@kernel.org>	<1276697146.9309.27.camel@m0nster>	<1276776066.2461.15.camel@localhost>	<20100617161619.d3ebd73d.akpm@linux-foundation.org>	<4C1B1D3F.8030509@kernel.org>	<20100618003127.10d9e6c8.akpm@linux-foundation.org>	<4C1B29BF.7080404@kernel.org> <20100618100228.093ec17b.akpm@linux-foundation.org>
In-Reply-To: <20100618100228.093ec17b.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 17:28:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/18/2010 07:02 PM, Andrew Morton wrote:
> um.  We've *already* engineered a mechanism which serves the
> requirements which we've been discussing.  Then Tejun came along,
> called it "niche" and busted it!

Andrew, can we turn down dramatization a little bit?  I'll try to
explain my viewpoint again, hopefully in clearer manner.

Workqueue is primarily an async mechanism.  It's designed to be that
way and most of its current users don't care that much about execution
priority.  As everything else in the kernel, it started simple and
continued to evolve.  Up until now, workqueue - thread association has
been largely fixed and it naturally grew some number of users which
depended on that property.  Whether you like the term "niche" or not,
they are few by large proportion.

Please note that such association isn't something workqueue strives to
achieve.  For example, tryinig to exploit the association on MT
workqueue will be cumbersome over suspend/resume cycles and there's no
provision to manage such events.

Workqueues have become quite popular and grew a lot of users.
Compounded by the increasing number of CPU cores, it's also showing
various limitations, some of which affect ease of use while others
scalability or unexpectedly long latencies.  Many of these issues for
most workqueue users can be addressed by sharing workers and managing
work execution centrally, which is what cmwq does.

Sharing workers does cause problems for users which have assumed fixed
workqueue - thread association, but as mentioned earlier, they're few
and converting them to directly use kthread or a (yet non-existing)
facility which guarantees fixed thread association wouldn't be
difficult.

So, it seems logical to move those few cases over to kthread or a new
facility and improve workqueue for the majority of users.  I'm not
planning on "busting" anything.  All such users of course will be
converted so that they keep working properly.

> Oh well.  Kernel threads should not be running with RT policy anyway. 
> RT is a userspace feature, and whenever a kernel thread uses RT it
> degrades userspace RT qos.  But I expect that using RT in kernel
> threads is sometimes the best tradeoff, so let's not pretend that we're
> getting something for nothing here!

Such use is limited to ST workqueues and I can write up a simple
wrapper around kthread in a few hundred lines if necessary.  So, yes,
we're losing one way of using ST workqueues but it sure wasn't very
popular way to use it and it can easily be replaced.

Thanks.

-- 
tejun
