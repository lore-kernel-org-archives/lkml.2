Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab2IXSta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:49:30 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:42654 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757648Ab2IXSt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:49:27 -0400
Message-ID: <5060AB0E.3070809@linux.vnet.ibm.com>
Date: Tue, 25 Sep 2012 00:18:46 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Conny Seidel <conny.seidel@amd.com>, Jan Kara <jack@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: divide error: bdi_dirty_limit+0x5a/0x9e
References: <20120924102324.GA22303@aftab.osrc.amd.com> <20120924142305.GD12264@quack.suse.cz> <20120924143609.GH22303@aftab.osrc.amd.com> <20120924201650.6574af64.conny.seidel@amd.com> <20120924181927.GA25762@aftab.osrc.amd.com>
In-Reply-To: <20120924181927.GA25762@aftab.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12092418-9574-0000-0000-0000049117C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 11:49 PM, Borislav Petkov wrote:
> On Mon, Sep 24, 2012 at 08:16:50PM +0200, Conny Seidel wrote:
>> Hi,
>>
>> On Mon, 24 Sep 2012 16:36:09 +0200
>> Borislav Petkov <bp@amd64.org> wrote:
>>> [ … ]
>>>
>>> Conny, would you test pls?
>>
>> Sure thing.
>> Out of ~25 runs I only triggered it once, without the patch the
>> trigger-rate is higher.
>>
>> [   55.098249] Broke affinity for irq 81
>> [   55.105108] smpboot: CPU 1 is now offline
>> [   55.311216] smpboot: Booting Node 0 Processor 1 APIC 0x11
>> [   55.333022] LVT offset 0 assigned for vector 0x400
>> [   55.545877] smpboot: CPU 2 is now offline
>> [   55.753050] smpboot: Booting Node 0 Processor 2 APIC 0x12
>> [   55.775582] LVT offset 0 assigned for vector 0x400
>> [   55.986747] smpboot: CPU 3 is now offline
>> [   56.193839] smpboot: Booting Node 0 Processor 3 APIC 0x13
>> [   56.212643] LVT offset 0 assigned for vector 0x400
>> [   56.423201] Got negative events: -25
> 
> I see it:
> 
> __percpu_counter_sum does for_each_online_cpu without doing
> get/put_online_cpus().
> 

Maybe I'm missing something, but that doesn't immediately tell me
what's the exact source of the bug.. Note that there is a hotplug
callback percpu_counter_hotcpu_callback() that takes the same
fbc->lock before updating/resetting the percpu counters of offline
CPU. So, though the synchronization is a bit weird, I don't
immediately see a problematic race condition there.

And, speaking of hotplug callbacks, on a slightly different note,
I see one defined as ratelimit_handler(), which calls
writeback_set_ratelimit() for *every single* state change in the
hotplug sequence! Is that really intentional? num_online_cpus()
changes its value only -once- for every hotplug :-)

Regards,
Srivatsa S. Bhat

