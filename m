Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab1KKEXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 23:23:32 -0500
Received: from lo.gmane.org ([80.91.229.12]:46728 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158Ab1KKEXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 23:23:31 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Subject: Re: [patch 1/3] sched: use jump labels to reduce overhead when bandwidth
 control is inactive
Date: Thu, 10 Nov 2011 20:23:14 -0800
Message-ID: <j9i7vi$qis$1@dough.gmane.org>
References: <20111108042632.977080206@google.com>  <20111108042736.560831357@google.com> <1320744563.2244.8.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 216-239-45-4.google.com
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
In-Reply-To: <1320744563.2244.8.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 01:29 AM, Peter Zijlstra wrote:
> On Mon, 2011-11-07 at 20:26 -0800, Paul Turner wrote:
>> @@ -1788,6 +1791,9 @@ static void do_sched_cfs_slack_timer(str
>>    */
>>   static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
>>   {
>> +       if (!cfs_bandwidth_used())
>> +               return;
>> +
>>          /* an active group must be handled by the update_curr()->put() path */
>>          if (!cfs_rq->runtime_enabled || cfs_rq->curr)
>>                  return;
>> @@ -1805,6 +1811,9 @@ static void check_enqueue_throttle(struc
>>   /* conditionally throttle active cfs_rq's from put_prev_entity() */
>>   static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
>>   {
>> +       if (!cfs_bandwidth_used())
>> +               return;
>> +
>>          if (likely(!cfs_rq->runtime_enabled || cfs_rq->runtime_remaining>  0))
>>                  return;
>>
>
> does it matter if you pull this out into an inline function like:
>
> static __always_inline void check_enqueue_throttle(struct cfs_rq *cfs_rq)
> {
> 	if (cfs_bandwidth_used())
> 		__check_enqueue_throttle(cfs_rq);
> }
>
> That would avoid the superfluous function call as well.

This this is the only call-site it's being inlined already so there's no 
difference atm.  That said, check_enqueue_throttle is sufficiently small we 
could just add __always_inline to force this to be the default behavior and 
avoid any surprises from this in the future.

Let me know if you'd like me to re-post with this added.

- Paul

