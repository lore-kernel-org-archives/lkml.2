Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab2ARNQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:16:13 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:44903 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab2ARNQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 08:16:10 -0500
Message-ID: <4F16C60B.4030903@linux.vnet.ibm.com>
Date: Wed, 18 Jan 2012 18:45:55 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com> <4F10929E.8070007@linux.vnet.ibm.com> <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com> <4F10BDF7.8030306@linux.vnet.ibm.com> <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com> <4F10EB5B.5060804@linux.vnet.ibm.com> <1326766892.16150.21.camel@sbsiddha-desk.sc.intel.com> <4F1544EA.5060907@linux.vnet.ibm.com> <1326856624.5291.20.camel@sbsiddha-mobl2>
In-Reply-To: <1326856624.5291.20.camel@sbsiddha-mobl2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011813-8256-0000-0000-000000EDF276
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 08:47 AM, Suresh Siddha wrote:

> On Tue, 2012-01-17 at 15:22 +0530, Srivatsa S. Bhat wrote:
>> Thanks for the patch, but unfortunately it doesn't fix the problem!
>> Exactly the same stack traces are seen during a CPU Hotplug stress test.
>> (I didn't even have to stress it - it is so fragile that just a script
>> to offline all cpus except the boot cpu was good enough to reproduce the
>> problem easily.)
> 
> hmm, that's weird. with the patch, sched_ilb_notifier() should have
> cleared the cpu going offline from the nohz.idle_cpus_mask. And this
> should have happened after that cpu is removed from active mask. So
> no-one else should add that cpu back to the nohz.idle_cpus_mask and this
> should prevent the issue from happening.
> 
> I could reproduce the problem easily with out the patch but when I
> applied the patch I couldn't recreate the issue. Srivatsa, can you
> please re-check the kernel you tested indeed has the fix?
> 
> re-Reviewing the code/patch also doesn't give me a hint.
> 
>> I have a few questions regarding the synchronization with CPU Hotplug.
>> What guarantees that the code which selects and IPIs the new ilb is totally
>> race-free with respect to CPU hotplug and we will never IPI an offline CPU?
> 
> So, nohz_balancer_kick() gets called only from interrupts disabled.
> During that time (from selecting the ilb_cpu to sending the IPI), no cpu
> can go offline. As the offline happens from the stop-machine process
> context with interrupts disabled.
> 
> Only thing we need to make sure is the offlined cpu shouldn't be part of
> the nohz.idle_cpus_mask and for post 3.2 code, posted patch ensures
> that.
> 
> For 3.2 and before, when a cpu exits tickless idle, it gets removed from
> the nohz.idle_cpus_mask (and also from the nohz.load_balancer). And if
> the cpu is not in the active mask (while going offline), subsequent
> calls to select_nohz_load_balancer() ensures that the cpu going down
> doesn't update the nohz structures. So I thought 3.2 shouldn't exhibit
> this problem.
> 
> 
>> (As demonstrated above, this issue is in 3.2-rc7
>> as well.)
> 
> hmm, don't think we ran into this before 3.2. So, what am I missing from
> the above? I will try to reproduce it on 3.2 too.
> 


I tested again on 3.2. I didn't hit those warnings (IPI to offline cpus).
It happens only in the post-3.2 kernel.

Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

