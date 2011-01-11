Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab1AKTqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 14:46:23 -0500
Received: from homer.adialaska.com ([173.230.150.116]:59839 "EHLO
	homer.adialaska.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab1AKTqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 14:46:21 -0500
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2011 14:46:21 EST
Message-ID: <4D2CB1B1.10102@gmail.com>
Date: Tue, 11 Jan 2011 11:38:25 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9pre) Gecko/20100821 Lanikai/3.1.3pre
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Screwing with the concurrency limit
References: <4D287AED.9090304@gmail.com> <20110108161840.GC13269@mtj.dyndns.org> <20110108163733.GD13269@mtj.dyndns.org> <iga94g$hkf$1@dough.gmane.org> <20110109144154.GA22453@mtj.dyndns.org>
In-Reply-To: <20110109144154.GA22453@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2011 06:41 AM, Tejun Heo wrote:
> Hello,
>
> On Sat, Jan 08, 2011 at 10:06:04AM -0800, Kent Overstreet wrote:
>> Well, that doesn't quite do it, I'd need workqueue_inc_max_active()
>> and workqueue_dec_max_active()... set_max_active() would be racy.
>
> You'll of course need to grab an outer mutex around max_active
> updates.
>
>> But also there's no point in adjusting max_active on every cpu's
>> workqueue, adjusting just the one on the local cpu would do exactly
>> what I want and be more efficient too... Can you see any issues in
>> doing it that way?
>
> Can you please explain the use case a bit more?  Is something per-cpu?
> ie. Are your write locks per-cpu?  How frequent do you expect the
> write locking to be?  I think adjusting max_active per-cpu should be
> doable but I'd rather stay away from that.

Hm, I must not be explaining myself very well.

Forget about the write locks for the moment.

So, high rate of work items, latency sensitive and _usually_ execute 
without blocking.

We would like a concurrency limit of 1 when they don't block - otherwise 
we're just scheduling for no reason. But sometimes they do block, and 
it's impossible to know whether they will or won't ahead of time.

That's the catch, if we have to block and we have a concurrency limit of 
1, we've got latency sensitive jobs queued on this CPU that are waiting 
around for no reason.

The write locks are the reason the concurrency limit pretty much has to 
be 1, because if it's not we'll sometimes just be trying to execute 
everything pointlessly.

So I'm trying to have my cake and eat it to. If a work item is 
executing, right before it blocks on IO it would like to do something to 
say "hey, start running whatever is available for this cpu". And it's 
only blocking the other work items on the cpu it's on, that's why I 
suggested adjusting only the local max_active.

>
>> What I was really hoping for was something like... maybe
>> move_work_to_workqueue() - if you could do that on the work item
>> you're executing, move it from the workqueue that has max_active = 1
>> to a different one - it's stateless from the caller's perspective.
>
> I don't think that's gonna be a good idea.  It's too specialized
> soultion which is likely to bite our asses down the road.

Well, I'm hoping I figure out the right way to convey what I'm trying to 
do, because I don't _think_ it's actually as specialized as it sounds. 
But as far as keeping the code sane, I agree with you there.

>> But I suspect that'd be more complicated than your way of doing it,
>> and inc()/dec() is probably just as good...
>
> So, I think it would be better to make max_active manipulation work
> somehow but again I want to stay way from being too specialized.

Yeah, it'll work. Does what I'm trying to do make any sense now?
