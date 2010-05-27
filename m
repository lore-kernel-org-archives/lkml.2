Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab0E0IPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 04:15:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab0E0IPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 04:15:49 -0400
Message-ID: <4BFE2A2F.50209@redhat.com>
Date: Thu, 27 May 2010 11:15:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zamsden@redhat.com
Subject: Re: [PATCH] Add Documentation/kvm/msr.txt
References: <1274897088-8587-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1274897088-8587-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 09:04 PM, Glauber Costa wrote:
> This patch adds a file that documents the usage of KVM-specific
> MSRs.
>
>    

Looks good.  A few comments:

> +
> +Custom MSR list
> +--------
> +
> +The current supported Custom MSR list is:
> +
> +MSR_KVM_WALL_CLOCK:  0x11
> +
> +	data: physical address of a memory area.

Which must be in guest RAM (i.e., don't point it somewhere random and 
expect the hypervisor to allocate it for you).

Must be aligned to 4 bytes (we don't enforce it though).

> +
> +MSR_KVM_SYSTEM_TIME: 0x12
> +
> +	data: physical address of a memory area. This memory is expected to
> +	hold a copy of the following structure:
>    

In guest RAM.  What are the alignment restrictions?  I don't think we 
can restrict to less than 4 bytes without breaking guests retroactively.

> +
> +	struct pvclock_vcpu_time_info {
> +		u32   version;
> +		u32   pad0;
> +		u64   tsc_timestamp;
> +		u64   system_time;
> +		u32   tsc_to_system_mul;
> +		s8    tsc_shift;
> +		u8    flags;
> +		u8    pad[2];
> +	} __attribute__((__packed__)); /* 32 bytes */
> +
> +	whose data will be filled in by the hypervisor periodically. Only one
> +	write, or registration, is needed for each VCPU. The interval between
> +	updates of this structure is arbitrary, and implementation-dependent.
> +
> +		version: guest has to check version before and after grabbing
> +		time information, and check that they are both equal and even.
> +		An odd version indicates an in-progress update.
> +
> +		tsc_timestamp: the tsc value at the current VCPU, at the time
> +		of the update of this structure. Guests can subtract this value
> +		from current tsc to derive a notion of elapsed time since the
> +		structure update.
> +
> +		system_time: the current system time at the time this structure
> +		was last updated. Unit is nanoseconds.
>    

What is the baseline for system_time?  Guest boot?

> +
> +		tsc_to_system_mul: a function of the tsc frequency. One has
> +		to multiply any tsc-related quantity by this value to get
> +		a value in nanoseconds, besides dividing by 2^tsc_shift
> +
> +		tsc_shift: cycle to nanosecond divider, as a power of two, to
> +		allow for shift rights. One has to shift right any tsc-related
> +		quantity by this value to get a value in nanoseconds, besides
> +		multiplying by tsc_to_system_mul.
>    

Would be good to write down the formula for calculating time here.

> +
> +		flags: bits in this field indicate extended capabilities
> +		coordinated between the guest and the hypervisor. Availability
> +		of specific flags has to be checked in 0x40000001 cpuid leaf.
> +		Refer to cpuid.txt for details.
>    

Need to document bit 0 here for completeness.  cpuid.txt documents how 
to discover it, here we document how to use it.

> +
> +	Availability of this MSR must be checked via bit 0 in 0x4000001 cpuid
> +	leaf prior to usage.
> +
> +	This MSR falls outside the reserved KVM range, and may be removed in the
> +	future. Its usage is deprecated.
> +
> +MSR_KVM_WALL_CLOCK_NEW:   0x4b564d00
> +
> +	data and functioning: same as MSR_KVM_WALL_CLOCK. Use this instead.
> +
> +	Availability of this MSR must be checked via bit 3 in 0x4000001 cpuid
> +	leaf prior to usage.
> +
> +MSR_KVM_SYSTEM_TIME_NEW:  0x4b564d01
> +
> +	data and functioning: same as MSR_KVM_SYSTEM_TIME. Use this instead.
> +
> +	Availability of this MSR must be checked via bit 3 in 0x4000001 cpuid
> +	leaf prior to usage.
> +
>    

Please detail the suggested algorithm for using the msrs (new then old).



-- 
error compiling committee.c: too many arguments to function

