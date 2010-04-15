Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0DOT3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 15:29:10 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:22798 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab0DOT3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 15:29:08 -0400
Date: Thu, 15 Apr 2010 12:28:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH 5/5] add documentation about kvmclock
Message-Id: <20100415122836.27f1e255.randy.dunlap@oracle.com>
In-Reply-To: <1271356648-5108-6-git-send-email-glommer@redhat.com>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
	<1271356648-5108-2-git-send-email-glommer@redhat.com>
	<1271356648-5108-3-git-send-email-glommer@redhat.com>
	<1271356648-5108-4-git-send-email-glommer@redhat.com>
	<1271356648-5108-5-git-send-email-glommer@redhat.com>
	<1271356648-5108-6-git-send-email-glommer@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4BC768F4.0222:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010 14:37:28 -0400 Glauber Costa wrote:

> This patch adds a new file, kvm/kvmclock.txt, describing
> the mechanism we use in kvmclock.
> 
> Signed-off-by: Glauber Costa <glommer@redhat.com>
> ---
>  Documentation/kvm/kvmclock.txt |  138 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 138 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/kvm/kvmclock.txt
> 
> diff --git a/Documentation/kvm/kvmclock.txt b/Documentation/kvm/kvmclock.txt
> new file mode 100644
> index 0000000..21008bb
> --- /dev/null
> +++ b/Documentation/kvm/kvmclock.txt
> @@ -0,0 +1,138 @@
> +KVM Paravirtual Clocksource driver
> +Glauber Costa, Red Hat Inc.
> +==================================
> +
> +1. General Description
> +=======================
> +
...
> +
> +2. kvmclock basics 
> +===========================
> +
> +When supported by the hypervisor, guests can register a memory page
> +to contain kvmclock data. This page has to be present in guest's address space
> +throughout its whole life. The hypervisor continues to write to it until it is
> +explicitly disabled or the guest is turned off.
> +
> +2.1 kvmclock availability
> +-------------------------
> +
> +Guests that want to take advantage of kvmclock should first check its
> +availability through cpuid.
> +
> +kvm features are presented to the guest in leaf 0x40000001. Bit 3 indicates
> +the present of kvmclock. Bit 0 indicates that kvmclock is present, but the

       presence
but it's confusing.  Is it bit 3 or bit 0?  They seem to indicate the same thing.

> +old MSR set must be used. See section 2.3 for details.

"old MSR set":  what does this mean?

> +
> +2.2 kvmclock functionality
> +--------------------------
> +
> +Two MSRs are provided by the hypervisor, controlling kvmclock operation:
> +
> + * MSR_KVM_WALL_CLOCK, value 0x4b564d00 and
> + * MSR_KVM_SYSTEM_TIME, value 0x4b564d01.
> +
> +The first one is only used in rare situations, like boot-time and a
> +suspend-resume cycle. Data is disposable, and after used, the guest
> +may use it for something else. This is hardly a hot path for anything.
> +The Hypervisor fills in the address provided through this MSR with the
> +following structure:
> +
> +struct pvclock_wall_clock {
> +        u32   version;
> +        u32   sec;
> +        u32   nsec;
> +} __attribute__((__packed__));
> +
> +Guest should only trust data to be valid when version haven't changed before

                                                         has not

> +and after reads of sec and nsec. Besides not changing, it has to be an even
> +number. Hypervisor may write an odd number to version field to indicate that
> +an update is in progress.
> +
> +MSR_KVM_SYSTEM_TIME, on the other hand, has persistent data, and is
> +constantly updated by the hypervisor with time information. The data
> +written in this MSR contains two pieces of information: the address in which
> +the guests expects time data to be present 4-byte aligned or'ed with an
> +enabled bit. If one wants to shutdown kvmclock, it just needs to write
> +anything that has 0 as its last bit.
> +
> +Time information presented by the hypervisor follows the structure:
> +
> +struct pvclock_vcpu_time_info {
> +        u32   version;
> +        u32   pad0;
> +        u64   tsc_timestamp;
> +        u64   system_time;
> +        u32   tsc_to_system_mul;
> +        s8    tsc_shift;
> +        u8    pad[3];
> +} __attribute__((__packed__)); 
> +
> +The version field plays the same role as with the one in struct
> +pvclock_wall_clock. The other fields, are:
> +
> + a. tsc_timestamp: the guest-visible tsc (result of rdtsc + tsc_offset) of
> +    this cpu at the moment we recorded system_time. Note that some time is

            CPU (please)

> +    inevitably spent between system_time and tsc_timestamp measurements.
> +    Guests can subtract this quantity from the current value of tsc to obtain
> +    a delta to be added to system_time

                           to system_time.

> +
> + b. system_time: this is the most recent host-time we could be provided with.
> +    host gets it through ktime_get_ts, using whichever clocksource is
> +    registered at the moment

                         moment.

> +
> + c. tsc_to_system_mul: this is the number that tsc delta has to be multiplied
> +    by in order to obtain time in nanoseconds. Hypervisor is free to change
> +    this value in face of events like cpu frequency change, pcpu migration,

                                         CPU

> +    etc.
> + 
> + d. tsc_shift: guests must shift 

missing text??

> +
> +With this information available, guest calculates current time as:
> +
> +  T = kt + to_nsec(tsc - tsc_0)
> +
> +2.3 Compatibility MSRs
> +----------------------
> +
> +Guests running on top of older hypervisors may have to use a different set of
> +MSRs. This is because originally, kvmclock MSRs were exported within a
> +reserved range by accident. Guests should check cpuid leaf 0x40000001 for the
> +presence of kvmclock. If bit 3 is disabled, but bit 0 is enabled, guests can
> +have access to kvmclock functionality through
> +
> + * MSR_KVM_WALL_CLOCK_OLD, value 0x11 and
> + * MSR_KVM_SYSTEM_TIME_OLD, value 0x12.
> +
> +Note, however, that this is deprecated.
> +
> +3. Migration
> +============
> +
> +Two ioctls are provided to aid the task of migration: 
> +
> + * KVM_GET_CLOCK and
> + * KVM_SET_CLOCK
> +
> +Their aim is to control an offset that can be summed to system_time, in order
> +to guarantee monotonicity on the time over guest migration. Source host
> +executes KVM_GET_CLOCK, obtaining the last valid timestamp in this host, while
> +destination sets it with KVM_SET_CLOCK. It's the destination responsibility to
> +never return time that is less than that.


---
~Randy
