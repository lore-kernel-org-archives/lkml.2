Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab0EDGho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 02:37:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:43109 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472Ab0EDGhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 02:37:43 -0400
Message-ID: <4BDFC06B.4020805@kernel.org>
Date: Tue, 04 May 2010 08:36:27 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       oleg@redhat.com, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/4] cpu_stop: implement stop_cpu[s]()
References: <1271952554-22368-1-git-send-email-tj@kernel.org>	 <1271952554-22368-2-git-send-email-tj@kernel.org> <1272893189.5605.119.camel@twins>
In-Reply-To: <1272893189.5605.119.camel@twins>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 06:36:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/03/2010 03:26 PM, Peter Zijlstra wrote:
> On Thu, 2010-04-22 at 18:09 +0200, Tejun Heo wrote:
>> +static int cpu_stopper_thread(void *data)
>> +{
>> +       struct cpu_stopper *stopper = data; 
> 
> BUG_ON(stopper != __get_cpu_var(cpu_stopper)); ?

Added.

>> +       work = NULL;
>> +       spin_lock_irq(&stopper->lock);
>> +       if (!list_empty(&stopper->works)) {
>> +               work = list_first_entry(&stopper->works,
>> +                                       struct cpu_stop_work, list);
>> +               list_del_init(&work->list);
>> +       }
>> +       spin_unlock_irq(&stopper->lock);
> 
> Not sure if its worth the hassle, but you could list_splice_init() the
> complete pending list onto a local list, possible avoiding some locks.
> 
> But since this isn't supposed to be used much, I doubt we'll ever see
> the difference.

Yeah, I think it would be better to keep the code simple there.

>> +               /* restore preemption and check it's still balanced */
>> +               preempt_enable();
>> +               WARN_ON_ONCE(preempt_count());
> 
> You would use WARN_ONCE() and print the function that last ran and
> leaked the preempt count.

Updated to use WARN_ONCE() w/ print the function symbol and argument.

Thanks.

-- 
tejun
