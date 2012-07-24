Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab2GXIPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 04:15:44 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:57590
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755488Ab2GXIPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 04:15:40 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202hzzz2dh668h839hd25he5bhf0ah107ah)
X-WSS-ID: 0M7NO9H-02-7KO-02
X-M-MSG: 
Message-ID: <500E5951.5020900@amd.com>
Date: Tue, 24 Jul 2012 10:14:09 +0200
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
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com> <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com> <20120721103715.GA3632@aftab.osrc.amd.com> <500E4960.8040307@parallels.com>
In-Reply-To: <500E4960.8040307@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 09:06 AM, Vladimir Davydov wrote:
> On 07/21/2012 02:37 PM, Borislav Petkov wrote:
>> (+ Andre who's been doing some cross vendor stuff)
>>
>> On Fri, Jul 20, 2012 at 08:37:33PM +0400, Vladimir Davydov wrote:
>>> If 'clearcpuid=N' is specified in boot options, CPU feature #N won't be
>>> reported in /proc/cpuinfo and used by the kernel. However, if a
>>> userpsace process checks CPU features directly using the cpuid
>>> instruction, it will be reported about all features supported by the CPU
>>> irrespective of what features are cleared.
>>>
>>> The patch makes the clearcpuid boot option not only clear CPU features
>>> in kernel but also mask them in hardware for Intel and AMD CPUs that
>>> support it so that the features cleared won't be reported even by the
>>> cpuid instruction.
>>>
>>> This can be useful for migration of virtual machines managed by
>>> hypervisors that do not support/use Intel VT/AMD-V hardware-assisted
>>> virtualization technology.

But for this case you want it more fine-grained, say on a pre-process or 
per-container level, right?
For hardware-assisted virtualization you simply don't need it, and for 
Xen PV guests for instance this can be more safely done by the 
hypervisor. I assume Parallels is similar in this respect, so you may 
want to switch the MSRs on the guest's entry and exit by the VMM.
Also if you want to restrict a guest's CPUID features, you don't want to 
do this at the guest's discretion, but better one level below where the 
guest cannot revert this, right?

In general I am not reluctant to have this feature with a sane 
interface, but I simply don't see the usefulness of having it per kernel.
Also note that AFAIK this masking only helps with the basic CPUID 
features, namely leaf 1 and 0x80000001 for ECX and EDX. This does not 
cover the more advanced features and not the new ones at leaf 7.

>> So opening the floodgates to people fiddling with this (not only
>> migrators) makes me feel pretty uneasy. And I won't wonder if all of
>> a sudden strange failures start to appear because code is querying
>> cpuid features but some funny distro has disabled it in its kernel boot
>> options.

Actually these "strange failures" would be a bug then. If CPUID is not 
there, the feature is not there. Full stop. In the past we had had 
already some trouble with people ignoring CPUID and stating some funny 
things like: "Every XYZ processor has this feature."
If someone disables MCE, then on purpose. Let the code cope with it.

And Boris: I don't like this "majority of users" argument. If there is 
some sense in this feature, why not have it (unless it significantly 
hurts the code base)? Remember, this is Linux: If you want to shoot 
yourself in the foot, we will not prevent you.

Regards,
Andre.

-- 
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany

