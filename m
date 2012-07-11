Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab2GKLwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 07:52:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab2GKLwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 07:52:38 -0400
Subject: Re: [PATCH RFC 0/2] kvm: Improving directed yield in PLE handler
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4FFD621D.5090607@redhat.com>
Date: Wed, 11 Jul 2012 13:52:26 +0200
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>, KVM <kvm@vger.kernel.org>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <794FFD35-579D-48CE-890F-8FCC785032F3@suse.de>
References: <20120709062012.24030.37154.sendpatchset@codeblue> <4FFA8E5E.3070108@de.ibm.com> <4FFD422B.9060008@redhat.com> <4FFD52CD.7040403@de.ibm.com> <4FFD5DA3.3010001@redhat.com> <39DA3B9A-87D6-4EA5-B1FF-B6E30733EF7B@suse.de> <4FFD621D.5090607@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11.07.2012, at 13:23, Avi Kivity wrote:

> On 07/11/2012 02:16 PM, Alexander Graf wrote:
>>> 
>>>> yes the data structure itself seems based on the algorithm
>>>> and not on arch specific things. That should work. If we move that to common 
>>>> code then s390 will use that scheme automatically for the cases were we call 
>>>> kvm_vcpu_on_spin(). All others archs as well.
>>> 
>>> ARM doesn't have an instruction for cpu_relax(), so it can't intercept
>>> it.  Given ppc's dislike of overcommit,
>> 
>> What dislike of overcommit?
> 
> I understood ppc virtualization is more of the partitioning sort.
> Perhaps I misunderstood it.  But the reliance on device assignment, the
> restrictions on scheduling, etc. all point to it.

Well, you need to distinguish the different PPC targets here. In the embedded world, partitioning is obviously the biggest use case, though overcommit is possible. For big servers however, we usually do want overcommit and we do support it within the constraints hardware gives us.

It's really no different from x86 when it comes to the use case wideness :).

> 
>> 
>>> and the way it implements cpu_relax() by adjusting hw thread priority,
>> 
>> Yeah, I don't think we can intercept relaxing.
> 
> ... and the lack of ability to intercept cpu_relax() ...
> 
>> It's basically a nop-like instruction that gives hardware hints on its current priorities.
> 
> That's what x88 PAUSE does.  But we can intercept it (and not just any
> execution - we can restrict intercept to tight loops executed more than
> a specific number of times).

Yeah, it's pretty hard to fetch that information from PPC, since unlike x86 we split the hint from the loop. But I'll let Ben speak to that, he certainly knows way better how the hardware works.

> 
>> That said, we can always add PV code.
> 
> Sure, but that's defeated by advancements like self-tuning PLE exits.
> It's hard to get this right.

Well, eventually everything we do in PV is going to be moot as soon as hardware catches up. In most cases from what I've seen it's only useful as an interim solution. But for that time it's good to have :).


Alex

