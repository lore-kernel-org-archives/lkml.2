Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab2FERh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:37:27 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:56679 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab2FERhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:37:23 -0400
Message-ID: <4FCE438C.5080005@linux.vnet.ibm.com>
Date: Tue, 05 Jun 2012 23:06:12 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>, Russell King <linux@arm.linux.org.uk>,
        yong.zhang0@gmail.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        peterz@infradead.org, mingo@kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        nikunj@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com, Ingo Molnar <mingo@redhat.com>,
        rusty@rustcorp.com.au, rjw@sisk.pl, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Keir Fraser <keir@xen.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 05/27] xen, cpu hotplug: Don't call cpu_bringup()
 in xen_play_dead()
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091124.31979.91984.stgit@srivatsabhat.in.ibm.com> <4FC8D8E30200007800087D2B@nat28.tlf.novell.com> <4FC8DC19.4000007@linux.vnet.ibm.com> <4FC8FD9C0200007800087DF5@nat28.tlf.novell.com> <4FCA5608.2010404@linux.vnet.ibm.com> <20120605164957.GA1997@phenom.dumpdata.com>
In-Reply-To: <20120605164957.GA1997@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12060517-4790-0000-0000-000003186CE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 10:19 PM, Konrad Rzeszutek Wilk wrote:

> On Sat, Jun 02, 2012 at 11:36:00PM +0530, Srivatsa S. Bhat wrote:
>> On 06/01/2012 09:06 PM, Jan Beulich wrote:
>>
>>>>>> On 01.06.12 at 17:13, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
>>> wrote:
>>>> On 06/01/2012 06:29 PM, Jan Beulich wrote:
>>>>
>>>>>>>> On 01.06.12 at 11:11, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
>>>>> wrote:
>>>>>> xen_play_dead calls cpu_bringup() which looks weird, because xen_play_dead()
>>>>>> is invoked in the cpu down path, whereas cpu_bringup() (as the name 
>>>>>> suggests) is useful in the cpu bringup path.
>>>>>
>>>>> This might not be correct - the code as it is without this change is
>>>>> safe even when the vCPU gets onlined back later by an external
>>>>> entity (e.g. the Xen tool stack), and it would in that case resume
>>>>> at the return point of the VCPUOP_down hypercall. That might
>>>>> be a heritage from the original XenoLinux tree though, and be
>>>>> meaningless in pv-ops context - Jeremy, Konrad?
>>>>>
>>>>> Possibly it was bogus/unused even in that original tree - Keir?
>>>>>
>>>>
>>>>
>>>> Thanks for your comments Jan!
>>>>
>>>> In case this change is wrong, the other method I had in mind was to call
>>>> cpu_bringup_and_idle() in xen_play_dead(). (Even ARM does something similar,
>>>> in the sense that it runs the cpu bringup code including cpu_idle(), in the
>>>> cpu offline path, namely the cpu_die() function). Would that approach work
>>>> for xen as well? If yes, then we wouldn't have any issues to convert xen to
>>>> generic code.
>>>
>>> No, that wouldn't work either afaict - the function is expected
>>> to return.
>>>
>>
>>
>> Ok.. So, I would love to hear a confirmation about whether this patch (which
>> removes cpu_bringup() in xen_play_dead()) will break things or it is good as is.
> 
> I think it will break - are these patches available on some git tree to test them out?
> 


Oh, sorry I haven't hosted them on any git tree.. 

>>
>> If its not correct, then we can probably make __cpu_post_online() return an int,
>> with the meaning:
>>
>> 0 => success, go ahead and call cpu_idle()
>> non-zero => stop here, thanks for your services so far.. now leave the rest to me.
>>
>> So all other archs will return 0, Xen will return non-zero, and it will handle
>> when to call cpu_idle() and when not to do so.
> 
> The call-chain (this is taken from 41bd956de3dfdc3a43708fe2e0c8096c69064a1e):
> 
>     cpu_bringup_and_idle:
>      \- cpu_bringup
>       |   \-[preempt_disable]
>       |
>       |- cpu_idle
>            \- play_dead [assuming the user offlined the VCPU]
>            |     \
>            |     +- (xen_play_dead)
>            |          \- HYPERVISOR_VCPU_off [so VCPU is dead, once user
>            |          |                       onlines it starts from here]
>            |          \- cpu_bringup [preempt_disable]
>            |
>            +- preempt_enable_no_reschedule()
>            +- schedule()
>            \- preempt_enable()
> 
> Which I think is a bit different from your use-case?
> 


Yes, when this patch is applied, the call to cpu_bringup() after HYPERVISOR_VCPU_off
gets removed. So it will look like this:

    cpu_bringup_and_idle:
     \- cpu_bringup
      |   \-[preempt_disable]
      |
      |- cpu_idle
           \- play_dead [assuming the user offlined the VCPU]
           |     \
           |     +- (xen_play_dead)
           |          \- HYPERVISOR_VCPU_off [so VCPU is dead, once user
           |                                  onlines it starts from here]
           |
           |
           +- preempt_enable_no_reschedule()
           +- schedule()
           \- preempt_enable()


And hence we wouldn't have the preempt imbalance, hence no need for the
extra preempt_enable() in xen_play_dead().

So, basically our problem is this:
The generic smp booting code calls cpu_idle() after setting the cpu in
cpu_online_mask etc, because this call to cpu_idle() is used in every
architecture. But just for xen, that too only in the cpu down path, this
call is omitted - which makes it difficult to convert xen to the generic
smp booting framework.

So I proposed 3 solutions, of which we can choose whichever that doesn't
break stuff and whichever looks the least ugly:

1. Omit the call to cpu_bringup() after HYPERVISOR_VCPU_off (which this
patch does).

2. Or, invoke cpu_bringup_and_idle() after HYPERVISOR_VCPU_off (Jan said
this might not work since we are expected to return). ARM actually does
something like this (it does the complete bringup including idle in the
cpu down path).

3. Or, Just for the sake of Xen, convert the __cpu_post_online() function to
return an int - Xen will return non-zero and do the next steps itself,
also deciding between whether or not to call cpu_idle(). All other archs
will just return 0, and allow the generic smp booting code to continue
on to cpu_idle().

Please let me know your thoughts.

Regards,
Srivatsa S. Bhat

