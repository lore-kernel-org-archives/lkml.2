Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2GXMgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 08:36:42 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:4142
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753526Ab2GXMgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 08:36:41 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202hzzz2dh668h839hd25he5bhf0ah107ah)
X-WSS-ID: 0M7O0CU-02-0JU-02
X-M-MSG: 
Message-ID: <500E9664.9030306@amd.com>
Date: Tue, 24 Jul 2012 14:34:44 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Vladimir Davydov <vdavydov@parallels.com>
CC: Borislav Petkov <bp@amd64.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com> <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com> <20120721103715.GA3632@aftab.osrc.amd.com> <500E4960.8040307@parallels.com> <500E5951.5020900@amd.com> <500E5CDF.5000504@parallels.com> <20120724101041.GA24739@aftab.osrc.amd.com> <500E8280.6050905@parallels.com>
In-Reply-To: <500E8280.6050905@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 01:09 PM, Vladimir Davydov wrote:
> On 07/24/2012 02:10 PM, Borislav Petkov wrote:
>> On Tue, Jul 24, 2012 at 12:29:19PM +0400, Vladimir Davydov wrote:
>>> I guess that when the more advanced features become widely-used,
>>> vendors will offer new MSRs and/or CPUID faulting.
>> And this right there is the dealbreaker:
>>
>> So what are you doing for cpus which have the advanced CPUID features
>> leafs but there are no MSRs to turn those bits off?
>
> We have not encountered this situation in our environments and I hope we
> won't :-)
>
> But look, these CPUID functions cover majority of CPU features, don't
> they? So, most of "normal" apps inside VM will survive migration.
> Perhaps, some low-level utils won't. I guess that's why there are no
> MSRs for other levels provided by vendors.

You have the new feature leaf at EAX=7. This contains things like BMI 
and AVX2 and probably more upcoming features.
So you may be safe for a while, but you need a solution in the long run.

>> You surely need some software-only solution for the migration to work,
>> no?
>
> Yes.
>
>> If so, why not apply that solution to your hypervisor without touching
>> the kernel at all?
>
> In most hypervisor-based virtualization products, this is already
> implemented using VMM-exits, so that each VM can have arbitrary CPUID
> mask set by the admin.
>
> The problem is that we have no hypervisor. "Virtualization" we want this
> feature for is based on cgroups and namespaces (examples are OpenVZ and
> mainstream LXC). Tasks are just grouped into virtual environments and
> share the same kernel, which is proved to be more memory usage efficient
> than traditional hypervisor-based approaches.

So for this single kernel approach I'd understand it that way:
1. You boot up the kernel on the host, it should detect and enable all 
the features, say MCA.
2. After boot, you use /src/msr-tools/wrmsr to mask CPUID bits, again 
MCA for instance or AVX/AES or the like.
Since the (host side of the) kernel already detected it, this does not 
hurt the kernel features like MCA. But AVX will not be available to 
applications running in the "host container", which is probably OK since 
these are mostly management applications, right?
3. Then you start guests. The guest's libc will not detect the features 
because of the MSR masking. All you need now is /proc/cpuinfo filtering 
to make this bullet-proof, preferably through the container 
functionality. I see that you do already massive sysfs filtering and 
also /proc/<pid> filtering, so this maybe an option?

This approach does not need any kernel support (except for the 
/proc/cpuinfo filtering). Does this address the issues you have?

Regards,
Andre.

-- 
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany

