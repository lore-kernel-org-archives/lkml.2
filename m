Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab2GTSWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:22:13 -0400
Received: from relay.parallels.com ([195.214.232.42]:56069 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab2GTSWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:22:12 -0400
From: Vladimir Davydov <VDavydov@parallels.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 20 Jul 2012 22:21:58 +0400
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
Thread-Topic: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
Thread-Index: Ac1mpIzwP9RID3hURvydbpWrrszNug==
Message-ID: <2764CF11-A5E5-4C8D-A2EE-69491D2864C3@parallels.com>
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com>
 <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com>
 <50099361.6050300@zytor.com>
In-Reply-To: <50099361.6050300@zytor.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, ru-RU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 20, 2012, at 9:20 PM, H. Peter Anvin wrote:

> On 07/20/2012 09:37 AM, Vladimir Davydov wrote:
>> If 'clearcpuid=N' is specified in boot options, CPU feature #N won't be
>> reported in /proc/cpuinfo and used by the kernel. However, if a
>> userpsace process checks CPU features directly using the cpuid
>> instruction, it will be reported about all features supported by the CPU
>> irrespective of what features are cleared.
>> 
>> The patch makes the clearcpuid boot option not only clear CPU features
>> in kernel but also mask them in hardware for Intel and AMD CPUs that
>> support it so that the features cleared won't be reported even by the
>> cpuid instruction.
>> 
>> This can be useful for migration of virtual machines managed by
>> hypervisors that do not support/use Intel VT/AMD-V hardware-assisted
>> virtualization technology.
>> 
>> If CPUID masking is supported, this will be reported in
>> /proc/cpuinfo:flags as 'cpuidmask'.
> 
> I am a bit concerned about this patch:
> 
> 1. it silently changes existing behavior.

Yes, but who needs the current implementation of 'clearcpuid' which, in fact, just hides flags in /proc/cpuinfo while userspace apps will see and consequently use all CPU features?

So, I think it logically extends the existing behavior.

> 2. even on enabled hardware, only some of the bits are maskable.

The patch makes only words 0, 1, 4, 6 maskable, but words 3, 7, 8 are Linux-defined, words 2 and 5 are Transmeta-, Centaur-, etc- defined, and word 9 contains some bizarre Intel CPU features. Thus, it is words 0, 1, 4, 6 that contain useful information for most hardware models.

If you ask about some Intel CPUs that can't mask CPUID function 0x80000001, this function describes AMD-specific features, and I bet those Intel CPUs just don't have them at all and thus have nothing to mask.

> 
> 	-hpa
> 
> 

