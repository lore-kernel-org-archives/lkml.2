Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab2GXHGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 03:06:15 -0400
Received: from relay.parallels.com ([195.214.232.42]:45268 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab2GXHGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 03:06:14 -0400
Message-ID: <500E4960.8040307@parallels.com>
Date: Tue, 24 Jul 2012 11:06:08 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Andr=E9_Przywara?= <andre.przywara@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com> <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com> <20120721103715.GA3632@aftab.osrc.amd.com>
In-Reply-To: <20120721103715.GA3632@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2012 02:37 PM, Borislav Petkov wrote:
> (+ Andre who's been doing some cross vendor stuff)
>
> On Fri, Jul 20, 2012 at 08:37:33PM +0400, Vladimir Davydov wrote:
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
> As they say in Star Wars: "I have a bad feeling about this."
>
> So opening the floodgates to people fiddling with this (not only
> migrators) makes me feel pretty uneasy. And I won't wonder if all of
> a sudden strange failures start to appear because code is querying
> cpuid features but some funny distro has disabled it in its kernel boot
> options.
>
> Or some other obscure case where the culprit is hidden in kernel command
> line options.
>
> If it were only needed for migration, then I'd say you guys can use
> msr-tools and run a script as root on the target machine to which you
> want to migrate to and toggle the feature bits you want.

If msr-tools are used for cpuid masking, we will either get 
inconsistency between /proc/cpuinfo:flags and the output of the cpuid 
instruction or have to "synchronize" the clearcpuid boot option and the 
userspace app using msr-tools, which seems to be inconvenient. So, IMO, 
it would be better to have such functionality implemented in the kernel.

> I don't think cross vendor migration alone justifies having a generic
> kernel feature like that.
>
> Thanks.
>

