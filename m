Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2K1Uzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:55:47 -0500
Received: from mx2.parallels.com ([64.131.90.16]:36083 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab2K1Uzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:55:46 -0500
Message-ID: <50B67A4B.8060800@parallels.com>
Date: Thu, 29 Nov 2012 00:55:39 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Michael Wolf <mjw@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, <linux-kernel@vger.kernel.org>,
        <riel@redhat.com>, <kvm@vger.kernel.org>, <peterz@infradead.org>,
        <mingo@redhat.com>
Subject: Re: [PATCH 0/5] Alter steal time reporting in KVM
References: <20121126203603.28840.38736.stgit@lambeau> <20121127232442.GA8295@amt.cnet> <50B65B4A.50508@linux.vnet.ibm.com>
In-Reply-To: <50B65B4A.50508@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.244.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 10:43 PM, Michael Wolf wrote:
> On 11/27/2012 05:24 PM, Marcelo Tosatti wrote:
>> On Mon, Nov 26, 2012 at 02:36:24PM -0600, Michael Wolf wrote:
>>> In the case of where you have a system that is running in a
>>> capped or overcommitted environment the user may see steal time
>>> being reported in accounting tools such as top or vmstat.
>> The definition of stolen time is 'time during which the virtual CPU is
>> runnable to not running'. Overcommit is the main scenario which steal
>> time helps to detect.
>>
>> Can you describe the 'capped' case?
> In the capped case, the time that the guest spends waiting due to it
> having used its full allottment of time shows up as steal time.  The way
> my patchset currently stands is that you would set up the
> bandwidth control and you would have to pass it a  matching value from
> qemu.  In the future, it would
> be possible to have something parse the bandwidth setting and
> automatically adjust the setting in the
> host used for steal time reporting.

Ok, so correct me if I am wrong, but I believe you would be using
something like the bandwidth capper in the cpu cgroup to set those
entitlements, right?

Some time has passed since I last looked into it, but IIRC, after you
get are out of your quota, you should be out of the runqueue. In the
lovely world of KVM, we approximate steal time as runqueue time:

arch/x86/kvm/x86.c:
delta = current->sched_info.run_delay - vcpu->arch.st.last_steal;
vcpu->arch.st.last_steal = current->sched_info.run_delay;
vcpu->arch.st.accum_steal = delta;

include/linux/sched.h:
unsigned long long run_delay; /* time spent waiting on a runqueue */

So if you are out of the runqueue, you won't get steal time accounted,
and then I truly fail to understand what you are doing.

In case I am wrong, and run_delay also includes the time you can't run
because you are out of capacity, then maybe what we should do, is to
just subtract it from run_delay in kvm/x86.c before we pass it on. In
summary:


>>>        Alter the amount of steal time reported by the guest.
Maybe this should go away.

>>>        Expand the steal time msr to also contain the consigned time.
Maybe this should go away

>>>        Add the code to send the consigned time from the host to the
>>> guest
This definitely should be heavily modified

>>>        Add a timer to allow the separation of consigned from steal time.
Maybe this should go away

>>>        Add an ioctl to communicate the consign limit to the host.
This definitely should go away.

More specifically, *whatever* way we use to cap the processor, the host
system will have all the information at all times.



