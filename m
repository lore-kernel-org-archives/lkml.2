Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1CVXlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:41:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21693 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab1CVXl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:41:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6293"; a="81477971"
Message-ID: <4D8933A8.8080607@codeaurora.org>
Date: Tue, 22 Mar 2011 16:41:28 -0700
From: David Collins <collinsd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Deadlock scenario in regulator core
References: <4D891C59.1030009@codeaurora.org>	 <20110322223702.GO14675@home.goodmis.org> <4D892C0A.1090606@codeaurora.org> <1300835998.14261.13.camel@gandalf.stny.rr.com>
In-Reply-To: <1300835998.14261.13.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 04:19 PM, Steven Rostedt wrote:
> 
> Looks to me that the mutex_lock() in _notifier_call_chain needs to be a
> mutex_lock_nested().
> 
> The "_nested()" versions are when you have the same type of mutex taken
> but belonging to two different instances. Like you have here:
> 
> 	blocking_notifier_call_chain(&rdev->notifier, event, NULL);
> 
> 	/* now notify regulator we supply */
> 	list_for_each_entry(_rdev, &rdev->supply_list, slist) {
> 		mutex_lock(&_rdev->mutex);
> 		_notifier_call_chain(_rdev, event, data);
> 		mutex_unlock(&_rdev->mutex);
> 	}
> 
> The rdev->mutex is already held, so we don't need to take it to call the
> blocking_notifier_call_chain() with the rdev->notifier. But then the
> list of rdev's in the rdev->supply_list are different instances but we
> are still taking the same type of lock. lockdep treats all instances of
> the same lock the same, so to lockdep this looks like a deadlock. To
> teach lockdep that this is a different instance, simply use
> mutex_lock_nested() instead.
> 
> -- Steve
> 
> 

There seem to be very few uses of mutex_lock_nested() in the kernel.  Most
of them use subclass = SINGLE_DEPTH_NESTING.  Would this be sufficient for
usage in the regulator core in _notifier_call_chain (and perhaps other
places) or should some other subclass be used?

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
