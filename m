Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0HBIxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:53:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab0HBIxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:53:12 -0400
Message-ID: <4C56876F.5000804@redhat.com>
Date: Mon, 02 Aug 2010 11:53:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        linux-kernel@vger.kernel.org, npiggin@suse.de,
        Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
        bharata@in.ibm.com, Balbir Singh <balbir@in.ibm.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH RFC 3/4] Paravirtualized spinlock implementation for KVM
 guests
References: <20100726061150.GB21699@linux.vnet.ibm.com> <20100726061537.GC8402@linux.vnet.ibm.com>
In-Reply-To: <20100726061537.GC8402@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/26/2010 09:15 AM, Srivatsa Vaddagiri wrote:
> Paravirtual spinlock implementation for KVM guests, based heavily on Xen guest's
> spinlock implementation.
>
> +static void kvm_spin_unlock(struct arch_spinlock *lock)
> +{
> +	struct kvm_spinlock *sl = (struct kvm_spinlock *)lock;
> +
> +	ADD_STATS(released, 1);
> +
> +	smp_wmb();		/* make sure no writes get moved after unlock */
> +	sl->lock = 0;		/* release lock */
> +}

Wait, no wakeup?

So it is a yield, not a sleep.  I'm worried it could seriously impact 
fairness when one non-contending guest (or non-pv) is overcommitted 
together with a spin-yield guest.

-- 
error compiling committee.c: too many arguments to function

