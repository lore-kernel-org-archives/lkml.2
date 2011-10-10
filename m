Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab1JJTAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:00:37 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:50910 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1JJTAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:00:35 -0400
Message-ID: <4E9340C2.4090901@linux.vnet.ibm.com>
Date: Tue, 11 Oct 2011 00:30:18 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "tj@kernel.org" <tj@kernel.org>
CC: Borislav Petkov <bp@amd64.org>, Alan Stern <stern@rowland.harvard.edu>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "vatsa@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
References: <Pine.LNX.4.44L0.1110101119550.18069-100000@netrider.rowland.org> <4E931018.8030904@linux.vnet.ibm.com> <20111010165343.GA29261@aftab> <4E932BBA.9090501@linux.vnet.ibm.com> <20111010175336.GA29415@aftab> <20111010180848.GI8100@google.com> <20111010183442.GC29415@aftab> <20111010185307.GK8100@google.com>
In-Reply-To: <20111010185307.GK8100@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11101009-3568-0000-0000-000000807008
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 12:23 AM, tj@kernel.org wrote:
> Hello,
> 
> On Mon, Oct 10, 2011 at 08:34:43PM +0200, Borislav Petkov wrote:
>> On Mon, Oct 10, 2011 at 02:08:48PM -0400, tj@kernel.org wrote:
>>> Maybe I'm confused but is that patch correct for actual CPU hotplug
>>> case?  If not, what's the point in doing that?  What are we gonna do
>>> after six month some people come up with "CPU hotplug fails to load
>>> new microcode for the new CPU"?
>>
>> Ok, first of all, we still will load ucode on the onlining path - we're
>> simply not going to reload it when the CPU has gone offline and onlined
>> again. For that case people should simply reload the module so that
>> ucode on _all_ CPUs is updated pretty much at same time.
> 
> I was thinking about hot-swap.  It might be pretty unlikely at this
> point but I don't think excluding that is a good idea.  x86 is used in
> pretty highend too these days.  Again, I don't know much about how
> ucodes are supposed to be managed and maybe it's true that we don't
> need new one at all even after hotswap.  If that's the case, state it
> clearly and it's all fine.
> 
>>> The invalidation code is there for a reason.
>>
>> ... and that reason being?
> 
> Again, the CPU for the microcode is going away?  It's something tied
> to a device and the device is going away.  It's a basic correctness
> issue.  It at least needs to be revalidated.
> 
>>> If somebody is sure that microcode don't need to be changed once
>>> loaded, then all's good and dandy but that's not the case here, right?
>>
>> Well, basically the current situation didn't change the ucode - it
>> simply reloaded the same image from before going offline.
>>
>> See, there's this another problem with what we have right now: imagine
>> you've just updated the ucode image on disk and offline only a subset of
>> the cores. Then you online them again and they now get the newer ucode
>> image while the others still run the old ucode. This could explode or
>> could not, one thing's for sure: all bets are off. If we don't reload it
>> on hotplug, we're fine - only module reload triggers the ucode update in
>> a fairly synchronized manner.
> 
> Yeah, loading different ucodes to different cores sounds pretty scary.
> I suppose we'll need to distinguish physical hotplugs from logical
> ones.
> 
> Hmm... is it possible to tell whether the core coming online is the
> same one as the last time?  If that's possible, the problem becomes
> pretty simple and we can simply tell people who are mixing
> suspend/hibernate with physical hotplug that they're crazy.
> 

I think that is pretty easy, atleast from a microcode revision standpoint:
the collect_cpu_info() function (defined in arch/x86/kernel/microcode_core.c
and arch/x86/kernel/microcode_intel.c or ..._amd.c) can be used for that
purpose. Am I right Boris?

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab

