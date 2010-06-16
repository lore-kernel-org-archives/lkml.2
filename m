Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0FPIyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:54:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab0FPIyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:54:08 -0400
Message-ID: <4C18912A.8040802@redhat.com>
Date: Wed, 16 Jun 2010 11:54:02 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC][PATCH 8/9] reduce kvm_lock hold times in mmu_skrink()
References: <20100615135518.BC244431@kernel.beaverton.ibm.com> <20100615135528.01AC8966@kernel.beaverton.ibm.com>
In-Reply-To: <20100615135528.01AC8966@kernel.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 04:55 PM, Dave Hansen wrote:
> mmu_shrink() is effectively single-threaded since the global
> kvm_lock is held over the entire function.
>
> I beleive its only use here is for synchronization of the
> vm_list.  Instead of using the kvm_lock to ensure
> consistency of the list, we instead obtain a kvm_get_kvm()
> reference.  This keeps the kvm object on the vm_list while
> we shrink it.
>
> Since we don't need the lock to maintain the list any more,
> we can drop it.  We'll reacquire it if we need to get another
> object off.
>
> This leads to a larger number of atomic ops, but reduces
> lock hold times: the typical latency vs. throughput debate.
>
>    

<snip content>

> diff -puN kernel/profile.c~optimize_shrinker-3 kernel/profile.c
> --- linux-2.6.git/kernel/profile.c~optimize_shrinker-3	2010-06-11 09:09:43.000000000 -0700
> +++ linux-2.6.git-dave/kernel/profile.c	2010-06-11 09:12:24.000000000 -0700
> @@ -314,6 +314,8 @@ void profile_hits(int type, void *__pc,
>   	if (prof_on != type || !prof_buffer)
>   		return;
>   	pc = min((pc - (unsigned long)_stext)>>  prof_shift, prof_len - 1);
> +	if ((pc == prof_len - 1)&&  printk_ratelimit())
> +		printk("profile_hits(%d, %p, %d)\n", type, __pc, nr_hits);
>   	i = primary = (pc&  (NR_PROFILE_GRP - 1))<<  PROFILE_GRPSHIFT;
>   	secondary = (~(pc<<  1)&  (NR_PROFILE_GRP - 1))<<  PROFILE_GRPSHIFT;
>   	cpu = get_cpu();
> _
>    

Unrelated gunk...

-- 
error compiling committee.c: too many arguments to function

