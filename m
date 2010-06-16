Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab0FPIjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:39:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab0FPIjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:39:45 -0400
Message-ID: <4C188D8B.40508@redhat.com>
Date: Wed, 16 Jun 2010 11:38:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC][PATCH 0/9] rework KVM mmu_shrink() code
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>
In-Reply-To: <20100615135518.BC244431@kernel.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 04:55 PM, Dave Hansen wrote:
> This is a big RFC for the moment.  These need a bunch more
> runtime testing.
>
> --
>
> We've seen contention in the mmu_shrink() function.

First of all, that's surprising.  I tried to configure the shrinker so 
it would stay away from kvm unless memory was really tight.  The reason 
is that kvm mmu pages can cost as much as 1-2 ms of cpu time to build, 
perhaps even more, so we shouldn't drop them lightly.

It's certainly a neglected area that needs attention, though.

> This patch
> set reworks it to hopefully be more scalable to large numbers
> of CPUs, as well as large numbers of running VMs.
>
> The patches are ordered with increasing invasiveness.
>
> These seem to boot and run fine.  I'm running about 40 VMs at
> once, while doing "echo 3>  /proc/sys/vm/drop_caches", and
> killing/restarting VMs constantly.
>    

Will drop_caches actually shrink the kvm caches too?  If so we probably 
need to add that to autotest since it's a really good stress test for 
the mmu.

> Seems to be relatively stable, and seems to keep the numbers
> of kvm_mmu_page_header objects down.
>    

That's no necessarily a good thing, those things are expensive to 
recreate.  Of course, when we do need to reclaim them, that should be 
efficient.

We also do a very bad job of selecting which page to reclaim.  We need 
to start using the accessed bit on sptes that point to shadow page 
tables, and then look those up and reclaim unreferenced pages sooner.  
With shadow paging there can be tons of unsync pages that are basically 
unused and can be reclaimed at no cost to future runtime.

-- 
error compiling committee.c: too many arguments to function

