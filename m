Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab0JZJZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 05:25:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:49001 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab0JZJZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 05:25:38 -0400
Message-ID: <4CC69E8F.20003@kernel.org>
Date: Tue, 26 Oct 2010 11:25:35 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Question about synchronize_sched_expedited()
References: <20101025154358.GA6919@linux.vnet.ibm.com> <4CC5AA5F.9060909@kernel.org> <20101025194140.GB6390@linux.vnet.ibm.com>
In-Reply-To: <20101025194140.GB6390@linux.vnet.ibm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 09:25:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paul.

On 10/25/2010 09:41 PM, Paul E. McKenney wrote:
>> I think your concern is valid and this can happen w/o preemption given
>> enough cpus and perfect timing.  Was the original code free from this
>> problem?
> 
> I believe so -- there was a mutex guarding the whole operation, including
> the increment.

I see.

>> IMHO the counter based mechanism is a bit too difficult to ponder and
>> verify.  Can we do more conventional double queueing (ie. flipping
>> pending and executing queues so that multiple sync calls can get
>> coalesced while another one is in progress)?  That's what the code is
>> trying to achieve anyway, right?
> 
> Hmmm...  But it would be necessary to flip the queues somewhere, and
> wouldn't determining where that somewhere was involve the same analysis
> and complexity as determining where to increment the counter?

I was thinking something like the following.

	lock;
	if (list_empty(running))
		add myself to running
		unlock;
	else
		remember list_empty(pending)
		append myself to pending queue;
		unlock and sleep;
		if (pending wasn't empty)
			return;

	do it;

	lock;
	wake up all on running and clear it;
	list_splice_init(pending, running);
	wake up the first of running;
	unlock;

Thanks.

-- 
tejun
