Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2GIOry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:47:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65146 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab2GIOru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:47:50 -0400
Message-ID: <4FFAEF13.7010108@gmail.com>
Date: Mon, 09 Jul 2012 08:47:47 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
References: <4FFAE6D8.5050609@gmail.com> <20120709141904.GC7298@redhat.com> <1341843844.3462.75.camel@twins> <4FFAED16.7050204@redhat.com>
In-Reply-To: <4FFAED16.7050204@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/12 8:39 AM, Avi Kivity wrote:
> On 07/09/2012 05:24 PM, Peter Zijlstra wrote:
>> On Mon, 2012-07-09 at 17:19 +0300, Gleb Natapov wrote:
>>> Yes, this is knows problem that I can't find time to fix. The crash is
>>> cause by CPU using host PEBS virtual address while guest is running
>>> which causes guest memory corruption. We should disable evens that use
>>> PEBS at the guest entry.
>>
>> Whoops.. so the hardware is reading the DS address as programmed by the
>> host (host linear address) and using it as a guest linear address?
>>
>> Quality stuff..
>>
>> Disabling PEBS events for guests isn't pretty though..
>
> We already have atomic MSR switching at guest entry/exit time.  So it's
> not pretty in terms of not getting full profiling, but the code won't be
> too hard.  Basically we just have to exclude_guest any pebs event.

I found this testing changes to perf-kvm, but found the problem extends 
to just perf-record. With perf-record exclude_guest defaults to 1. See 
tools/perf/util/util.c, event_attr_init().

>
>> but I guess the
>> only alternative is mapping the DS into the guest and reprogramming
>> MSR_IA32_DS_AREA which is all a little involved I suppose?
>
> Way too involved, especially as it's virtual addresses and we don't
> control the guest cr3.  Note that the hardware won't fail gracefully.
>


