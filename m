Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2GIOj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:39:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab2GIOjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:39:23 -0400
Message-ID: <4FFAED16.7050204@redhat.com>
Date: Mon, 09 Jul 2012 17:39:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Gleb Natapov <gleb@redhat.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
References: <4FFAE6D8.5050609@gmail.com> <20120709141904.GC7298@redhat.com> <1341843844.3462.75.camel@twins>
In-Reply-To: <1341843844.3462.75.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 05:24 PM, Peter Zijlstra wrote:
> On Mon, 2012-07-09 at 17:19 +0300, Gleb Natapov wrote:
>> Yes, this is knows problem that I can't find time to fix. The crash is
>> cause by CPU using host PEBS virtual address while guest is running
>> which causes guest memory corruption. We should disable evens that use
>> PEBS at the guest entry. 
> 
> Whoops.. so the hardware is reading the DS address as programmed by the
> host (host linear address) and using it as a guest linear address?
> 
> Quality stuff..
> 
> Disabling PEBS events for guests isn't pretty though.. 

We already have atomic MSR switching at guest entry/exit time.  So it's
not pretty in terms of not getting full profiling, but the code won't be
too hard.  Basically we just have to exclude_guest any pebs event.

> but I guess the
> only alternative is mapping the DS into the guest and reprogramming
> MSR_IA32_DS_AREA which is all a little involved I suppose?

Way too involved, especially as it's virtual addresses and we don't
control the guest cr3.  Note that the hardware won't fail gracefully.

-- 
error compiling committee.c: too many arguments to function


