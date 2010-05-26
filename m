Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145Ab0EZSfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:35:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65097 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933117Ab0EZSfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:35:31 -0400
Date: Wed, 26 May 2010 11:35:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       zamsden@redhat.com
Subject: Re: [PATCH] Add Documentation/kvm/msr.txt
Message-Id: <20100526113503.e88f5751.randy.dunlap@oracle.com>
In-Reply-To: <1274897088-8587-1-git-send-email-glommer@redhat.com>
References: <1274897088-8587-1-git-send-email-glommer@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090202.4BFD69E7.013A:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 14:04:48 -0400 Glauber Costa wrote:

> This patch adds a file that documents the usage of KVM-specific
> MSRs.
> 
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> ---
>  Documentation/kvm/msr.txt |  115 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 115 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/kvm/msr.txt
> 
> diff --git a/Documentation/kvm/msr.txt b/Documentation/kvm/msr.txt
> new file mode 100644
> index 0000000..c5110a2
> --- /dev/null
> +++ b/Documentation/kvm/msr.txt
> @@ -0,0 +1,115 @@
> +KVM-specific MSRs.
> +Glauber Costa <glommer@redhat.com>, Red Hat Inc, 2010
> +=====================================================
> +
> +KVM makes use of some custom MSRs to service some requests.
> +At present, this facility is only used by kvmclock.
> +
> +Custom MSRs have a range reserved for them, that goes from
> +0x4b564d00 to 0x4b564dff. There are MSRs outside this area,
> +but they are deprecated and their use is discouraged.
> +
> +Custom MSR list
> +--------
> +
> +The current supported Custom MSR list is:
> +
> +MSR_KVM_WALL_CLOCK:  0x11
> +
> +	data: physical address of a memory area. This memory is expected to
> +	hold a copy of the following structure:
> +
> +	struct pvclock_wall_clock {
> +		u32   version;
> +		u32   sec;
> +		u32   nsec;
> +	} __attribute__((__packed__));
> +
> +	whose data will be filled in by the hypervisor. The hypervisor will only
> +	touch this data once, at the moment of MSR write. Users that want to

	                                                  Users who want to

I don't get the "only touch this data once" part.
It sounds like the hypervisor will touch <version> 2 times (the odd and the even
writes).  It also sounds like the comment should be more like:
	The hypervisor will only update this data at the time of each MSR write.


> +	query this information more than once, have to write more than once to

	                                     ^drop the comma

> +	this MSR. Fields has the following meaning:

	                 have              meanings:
> +
> +		version: guest has to check version before and after grabbing
> +		time information, and check that they are both equal, and even.
> +		An odd version indicates an in-progress update.
> +
> +		sec: number of seconds for wallclock.
> +
> +		nsec: number of nanoseconds for wallclock.
> +
> +	Note that, although MSRs are per-CPU entities, the effect of this

	         ^drop comma

> +	particular MSR is global.
> +
> +	Availability of this MSR must be checked via bit 0 in 0x4000001 cpuid
> +	leaf prior to usage. 
> +
> +	This MSR falls outside the reserved KVM range, and may be removed in the
> +	future. Its usage is deprecated.
> +
> +MSR_KVM_SYSTEM_TIME: 0x12
> +
> +	data: physical address of a memory area. This memory is expected to
> +	hold a copy of the following structure:
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
> +
> +		tsc_to_system_mul: a function of the tsc frequency. One has
> +		to multiply any tsc-related quantity by this value to get
> +		a value in nanoseconds, besides dividing by 2^tsc_shift
> +
> +		tsc_shift: cycle to nanosecond divider, as a power of two, to
> +		allow for shift rights. One has to shift right any tsc-related
> +		quantity by this value to get a value in nanoseconds, besides
> +		multiplying by tsc_to_system_mul.
> +
> +		flags: bits in this field indicate extended capabilities
> +		coordinated between the guest and the hypervisor. Availability
> +		of specific flags has to be checked in 0x40000001 cpuid leaf.
> +		Refer to cpuid.txt for details.
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

It would make more sense to me to document the "_NEW" MSRs fully and then
refer the old (deprecated) ones to the new ones.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
