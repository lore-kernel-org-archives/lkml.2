Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab1IYGC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 02:02:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41327 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab1IYGC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 02:02:26 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <20110924030718.GA29319@htj.dyndns.org>
References: <1314884193-20454-1-git-send-email-ripduman.sohan@cl.cam.ac.uk>
	<20110902002917.GD2752@htj.dyndns.org>
	<20110915161430.GE1548@tusker>
	<CAOtvUMf0Dx04Piw8bx2oD+F9ttiBP_xCpin7fTvoQqs_dn=ZRQ@mail.gmail.com>
	<20110924030718.GA29319@htj.dyndns.org>
Date: Sun, 25 Sep 2011 09:02:25 +0300
Message-ID: <CAOtvUMeGddgQK==K09uCVHOn8gbW2PaUaCiWhhOCNx8pvy8QiQ@mail.gmail.com>
Subject: Re: [PATCH] workqueue: Restore cpus_allowed mask for sleeping
 workqueue rescue threads
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ripduman Sohan <Ripduman.Sohan@cl.cam.ac.uk>, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Sep 24, 2011 at 6:07 AM, Tejun Heo <tj@kernel.org> wrote:
> On Sun, Sep 18, 2011 at 09:36:57AM +0300, Gilad Ben-Yossef wrote:
>> There is at least one use case where I think this can be a problem -
>> cpu isolation.
>>
>> If you decide to partition your CPU to give some group of processes a
>> set of CPUs all to their own (using cgroups/cpuset for example) having
>> non related bound processes really gets in the way. You would really
>> want to migrate away non related tasks from the isolated cpuset and
>> having a bound kernel thread prevents that.
>
> Hmm... I don't think this has much to do with CPU isolation.
> Workqueue rescuers are reactively invoked to resolve possible resource
> deadlock.  It doesn't initiate operations on itself while CPU
> isolation requires moving all sources of unwanted activites off the
> isolated CPUs.  Having idle rescuers not bound to any CPU might look
> prettier but wouldn't help anything - it's not an activity source and
> the 'wanted' activities on the isolated CPU also require rescuers for
> forward progress guarantee.
>

Thank you for taking the time to answer my query :-)

I agree there is no real problem with having an additional task bound
to an "isolated"
CPU so long that it does not run and of course that if a task on an
isolated CPU initiated
activity that resulted in requiring the services of a rescuer
workqueue thread it most certainly
needs to run there and that is fine.

I guess my question is - apart form running on the isolated CPU, does
the fact that the
rescuer thread is bound there can cause activity on that CPU
originating from a foreign CPU,
such as for example running an IPI handler in order to migrate it there?

If the answer is negative I agree there is no issue.

You do raise another valid point though - that having the rescuer
workqueue thread bound to an isolated
CPU is "less pretty". Right now it means that someone viewing the set
of tasks in a cpuset, for example,
need to figure out for each task "stuck" on the root set what is it,
why it is bound (and to which CPU) and
if that is a problem. I wonder what we can do to help with that.

Thanks,
Gilad



> Thanks.
>
> --
> tejun
>



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"I've seen things you people wouldn't believe. Goto statements used to
implement co-routines. I watched C structures being stored in
registers. All those moments will be lost in time... like tears in
rain... Time to die. "
