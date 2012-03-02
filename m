Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab2CBKvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 05:51:46 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:51713 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705Ab2CBKvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 05:51:44 -0500
Message-ID: <4F50A620.1080808@stericsson.com>
Date: Fri, 2 Mar 2012 11:51:12 +0100
From: Jonas Aaberg <jonas.aberg@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFC [PATCH] SMP: Don't schedule tasks on inactive cpu(s)
References: <1330512150-20727-1-git-send-email-jonas.aberg@stericsson.com>  <1330513384.11248.129.camel@twins> <1330516117.11248.138.camel@twins>
In-Reply-To: <1330516117.11248.138.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks Peter for having a look. I will try to come up with a way to
trigger this issue more easily. 

If I find a way, I will test with your original patch, 
https://lkml.org/lkml/2011/12/15/255, and tell you the result.

Best regards,
 Jonas Aaberg

On 02/29/2012 12:48 PM, Peter Zijlstra wrote:
> On Wed, 2012-02-29 at 12:03 +0100, Peter Zijlstra wrote:
>> On Wed, 2012-02-29 at 11:42 +0100, Jonas Aaberg wrote:
>>> This patch removes the ability to schedule tasks on cpus that are online,
>>> but not active.  The reason for this patch is that during cpu hotplug
>>> on ARM (atleast) there is a short window where cpuX (X > 0) is online, but
>>> busy-waiting on cpu0 to put it active, meanwhile cpu0 can be interrupted
>>> and try to schedule something on the cpu that is busy checking its active bit.
>>
>> https://lkml.org/lkml/2011/12/15/255
>>
>> that one?
>>
>> I _think_ its correct, but it would be so good if someone else could
>> verify.
> 
> Relevant patches to consider are: e761b772 and 3a101d05.
> 
> Having looked at this again, I think we lost something in 3a101d05 since
> it moves cpuset_update_active_cpus() from CPU_DEAD to CPU_DOWN_PREPARE
> (and DOWN_FAILED) -- not that it matters that much. Also this patch does
> leaves me somewhat puzzled as to what cpu_active_mask is for now..
> 
> The suggested patch linked above moves setting active to CPU_STARTING
> which is _before_ online. It looks like some parts of the scheduler
> don't look at online at all anymore so that opens a 'window' where we
> could select a cpu that isn't part of the sched_domain nor online
> (select_fallback_rq and cpuset_cpus_allowed_fallback).
> 
> Now this isn't really a problem because of stop-machine, by the time
> anybody gets to run again both online and active are set and we should
> be good to go. The bad part is of course us relying on this silly
> stop-machine semantic.
> 
> Bah, hotplug is such a pain.. 

