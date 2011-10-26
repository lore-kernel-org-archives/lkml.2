Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab1JZTqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 15:46:19 -0400
Received: from claw.goop.org ([74.207.240.146]:48902 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab1JZTqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 15:46:17 -0400
Message-ID: <4EA86387.5040108@goop.org>
Date: Wed, 26 Oct 2011 12:46:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Raghavendra K T <raghukt@linux.vnet.ibm.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>, KVM <kvm@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Yinghai Lu <yinghai@kernel.org>, Sedat Dilek <sedat.dilek@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xen <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC V2 5/5] kvm guest : pv-ticketlocks support for linux
 guests running on KVM hypervisor
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com> <20111023190753.16364.31164.sendpatchset@oc5400248562.ibm.com> <4EA7012B.5040808@goop.org> <4EA85E32.3080107@linux.vnet.ibm.com>
In-Reply-To: <4EA85E32.3080107@linux.vnet.ibm.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2011 12:23 PM, Raghavendra K T wrote:
> On 10/26/2011 12:04 AM, Jeremy Fitzhardinge wrote:
>> On 10/23/2011 12:07 PM, Raghavendra K T wrote:
>>> This patch extends Linux guests running on KVM hypervisor to support
>>> +/*
>>> + * Setup pv_lock_ops to exploit KVM_FEATURE_WAIT_FOR_KICK if present.
>>> + * This needs to be setup really early in boot, before the first
>>> call to
>>> + * spinlock is issued!
>>
>> Actually, it doesn't matter that much.  The in-memory format is the same
>> for regular and PV spinlocks, and the PV paths only come into play if
>> the "slowpath" flag is set in the lock, which it never will be by the
>> non-PV code.
>>
>> In principle, you could defer initializing PV ticketlocks until some
>> arbitrarily late point if you notice that the system is oversubscribed
>> enough to require it.
>
> ok.. so this means it will not affect even if it is initialized in
> middle somewhere, but better to do it before we start seeing lock
> contention.

Right.  Or more specifically, lock contention while you have VCPU
overcommit.

> our current aim was to have before any printk happens.
> So I  'll trim the comment to somethings like :
>
> Setup pv_lock_ops to exploit KVM_FEATURE_WAIT_FOR_KICK if present.
> This needs to be setup early in boot. ?

You can hook the smp_ops.smp_prepare_cpus call and initialize it there. 
There's no need to add new hook code.

    J
