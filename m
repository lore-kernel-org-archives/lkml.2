Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab0FCEv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:51:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40538 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0FCEv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:51:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=c6I/Svx/c8xKhvD0DlpIpilf/7gIDZTFWiS1R/Y5ZH52Cewx2cgwNMaKNCzqBxHXDt
         ygiOeDFESs2Oi2gIqDppeTTTTFrKa0KqzyXOF/g8V6C8RgVeSSXkl1tdHBZLCpCmYv2s
         0jC0crjFZ1A/1ZzRWTCWfeSkJUnN1i8n9YgCE=
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: vatsa@in.ibm.com
Cc: Avi Kivity <avi@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hpa@zytor.com, mingo@elte.hu, npiggin@suse.de,
       tglx@linutronix.de, mtosatti@redhat.com
In-Reply-To: <20100603042051.GA5953@linux.vnet.ibm.com>
References: <20100601093515.GH24302@redhat.com>
	 <87sk56ycka.fsf@basil.nowhere.org> <20100601162414.GA6191@redhat.com>
	 <20100601163807.GA11880@basil.fritz.box> <4C053ACC.5020708@redhat.com>
	 <20100601172730.GB11880@basil.fritz.box> <4C05C722.1010804@redhat.com>
	 <20100602085055.GA14221@basil.fritz.box> <4C061DAB.6000804@redhat.com>
	 <20100603042051.GA5953@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 06:51:51 +0200
Message-ID: <1275540711.29413.63.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 03 juin 2010 à 09:50 +0530, Srivatsa Vaddagiri a écrit :
> On Wed, Jun 02, 2010 at 12:00:27PM +0300, Avi Kivity wrote:
> > 
> > There are two separate problems: the more general problem is that
> > the hypervisor can put a vcpu to sleep while holding a lock, causing
> > other vcpus to spin until the end of their time slice.  This can
> > only be addressed with hypervisor help.
> 
> Fyi - I have a early patch ready to address this issue. Basically I am using
> host-kernel memory (mmap'ed into guest as io-memory via ivshmem driver) to hint 
> host whenever guest is in spin-lock'ed section, which is read by host scheduler 
> to defer preemption.
> 
> Guest side:
> 
> static inline void spin_lock(spinlock_t *lock)
> {
> 	raw_spin_lock(&lock->rlock);
> +       __get_cpu_var(gh_vcpu_ptr)->defer_preempt++;

1) __this_cpu_inc() should be faster

2) Isnt a bit late to do this increment _after_
raw_spin_lock(&lock->rlock);

> }
> 
> static inline void spin_unlock(spinlock_t *lock)
> {
> +	__get_cpu_var(gh_vcpu_ptr)->defer_preempt--;
>         raw_spin_unlock(&lock->rlock);
> }



