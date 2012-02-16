Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab2BPQR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:17:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab2BPQR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:17:26 -0500
Message-ID: <4F3D2C09.1020803@redhat.com>
Date: Thu, 16 Feb 2012 18:17:13 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Amit Shah <amit.shah@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [KVM paravirt issue?] Re: vsyscall=emulate regression
References: <20120203082748.GB782@amit.redhat.com> <20120214122205.GA29418@amit.redhat.com> <CALCETrVCzErebXrVk8Bi+k1TjigD3XvJsmZFVZb=ksmSCOTVLg@mail.gmail.com> <20120215110122.GA3136@amit.redhat.com> <CALCETrUmk+kpG9qLqSfrMP8Go9affMJCgybHFoK7Z2wm7ABXpA@mail.gmail.com>
In-Reply-To: <CALCETrUmk+kpG9qLqSfrMP8Go9affMJCgybHFoK7Z2wm7ABXpA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2012 09:36 PM, Andy Lutomirski wrote:
> Hi, kvm people-
>
> Here's a strange failure.  It could be a bug in something
> RHEL6-specific, but it could be a generic issue that only triggers
> with a paravirt guest with old userspace on a non-ept host.  There was
> a bug like this on Xen, and I'm wondering something's wrong on kvm as
> well.
>
> For background, a change in 3.1 (IIRC) means that, when
> vsyscall=emulate or vsyscall=none, the vsyscall page in the fixmap is
> NX.  It seems like Amit's machine is marking the physical PTE present
> but unreadable.  

No such thing as present and unreadable, without EPT.

> So I could have messed up, or there could be a subtle
> bug somewhere.  Any ideas?

What's the code trying to do?  Execute an instruction from an
non-executable page, trap the #PF, and emulate?  And what are the
symptoms? wrong error code for the #PF?  That could easily be a kvm bug.

>
> I'll try to reproduce on a non-ept host later on, but that will
> involve finding one.

rmmod kvm-intel
moprobe kvm-intel ept=0

> Hmm.  You don't have ept.  If your guest kernel supports paravirt,
> then you might use the hypercall interface instead of programming the
> fixmap directly.

There is no hypercall interface for writing page tables in kvm.

>
> >
> > This is what I get with vsyscall=none, where emulate and native work
> > fine on the 3.2 kernel on different host hardware, the guest stays the
> > same:
> >
> >
> > [    2.874661] debug: unmapping init memory ffffffff8167f000..ffffffff818dc000
> > [    2.876778] Write protecting the kernel read-only data: 6144k
> > [    2.879111] debug: unmapping init memory ffff880001318000..ffff880001400000
> > [    2.881242] debug: unmapping init memory ffff8800015a0000..ffff880001600000
> > [    2.884637] init[1] vsyscall attempted with vsyscall=none ip:ffffffffff600400 cs:33 sp:7fff2f48fe18 ax:7fff2f48fe50 si:7fff2f48ff08 di:0
>
> This like (vsyscall attempted) means that the emulation worked
> correctly.  Your other traces didn't have it or anything like it,
> which mostly rules out do_emulate_vsyscall issues.
>

Can you point me at the code in question?

Amit, a trace would be nice.

-- 
error compiling committee.c: too many arguments to function

