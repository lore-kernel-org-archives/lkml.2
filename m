Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965Ab2CNAj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:39:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64333 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759637Ab2CNAjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:39:55 -0400
MIME-Version: 1.0
In-Reply-To: <4EF1CD49.9020800@linux.intel.com>
References: <1324426147-16735-1-git-send-email-ccross@android.com>
	<4EF1A0B4.5080307@linux.intel.com>
	<CAMbhsRRP7s9xsHqxhb=iMfHAJFcqAea-6CDORZS34RCPNo+UWw@mail.gmail.com>
	<4EF1AA8A.8060304@linux.intel.com>
	<CAMbhsRSNTUvou9Gf6T4Ggq=jfxsWUcn7M2yNsKQz6aNrt6gLDg@mail.gmail.com>
	<4EF1CD49.9020800@linux.intel.com>
Date: Tue, 13 Mar 2012 17:39:54 -0700
X-Google-Sender-Auth: MrveQY1hRvhvvIWbL7nZ1cwraUI
Message-ID: <CAMbhsRS00BFgun=vA21LnuCW9HEH-72uFnNoB6A3GbVqkJEuWQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] coupled cpuidle state support
From: Colin Cross <ccross@android.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 4:12 AM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> On 12/21/2011 10:55 AM, Colin Cross wrote:
>> On Wed, Dec 21, 2011 at 1:44 AM, Arjan van de Ven <arjan@linux.intel.com> wrote:
>>> On 12/21/2011 10:40 AM, Colin Cross wrote:
>>>
>>>>> this smells fundamentally racey to me; you can get an interrupt one
>>>>> cycle after you think you're done, but before the last guy enters WFI...
>>>>>
>>>>> how do you solve that issue ?
>>>>
>>>> All the cpus have interrupts off when they increment the counter, so
>>>> they cannot receive an interrupt.  If an interrupt is pending on one
>>>> of those cpus, it will be handled later when WFI aborts due to the
>>>> pending interrupt.
>>>
>>> ... but this leads to cases where you're aborting before other cpus are
>>> entering..... so your "last guy in" doesn't really work, since while cpu
>>> 0 thinks it's the last guy, cpu 1 is already on the way out/out
>>> already...  (heck it might already be going back to sleep if your idle
>>> code can run fast, like in the size of a cache miss)
>>
>> Once a cpu has incremented the counter, it has no way out unless either
>> 1: another cpu (that hasn't incremented the counter yet) receives an
>> interrupt, aborts idle, and clears its idle flag
>> or
>> 2: all cpus enter the ready counter, and call the cpuidle driver's
>> enter function.
>
> .. or it enters WFI, and a physical device sends it an interrupt,
> at which point it exits.

Rereading this, I think I understand what you meant.  I misunderstood
because of your reference to WFI, which is not entered at this point.
WFI generally refers to the shallowest idle state, which only affects
a single cpu.  For deeper states, the cpu may or may not execute the
WFI instruction to trigger the transition (depending on the platform),
but it's not really entering WFI, and the cpu will generally not ever
execute the next instruction (again, depending on the platform).

For coupled cpus, only one cpu is capable of booting first, so all
interrupts should be masked on cpu1 by the time it gets to its low
power state, so it should never abort.  If it does abort (like the
example Kevin Hillman just posted to the end of this thread), cpu1
needs to set a flag to say it is not going to get to idle, and cpu0
needs to wait for cpu1 to be in idle (by polling a power controller
register), or for the flag to be set.  Afterwards, the cpus need to
resynchronize and reset the flag, which will be easy with the parallel
barrier helper function that will be included in the next patch set.
