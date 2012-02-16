Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab2BPQpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:45:41 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58718 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2BPQpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:45:39 -0500
MIME-Version: 1.0
In-Reply-To: <4F3D2C09.1020803@redhat.com>
References: <20120203082748.GB782@amit.redhat.com> <20120214122205.GA29418@amit.redhat.com>
 <CALCETrVCzErebXrVk8Bi+k1TjigD3XvJsmZFVZb=ksmSCOTVLg@mail.gmail.com>
 <20120215110122.GA3136@amit.redhat.com> <CALCETrUmk+kpG9qLqSfrMP8Go9affMJCgybHFoK7Z2wm7ABXpA@mail.gmail.com>
 <4F3D2C09.1020803@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 16 Feb 2012 08:45:18 -0800
Message-ID: <CALCETrUhGY8C8JLz6DrbBxukV58K=2jrMSfDyAm=eF7OWbKx7g@mail.gmail.com>
Subject: Re: [KVM paravirt issue?] Re: vsyscall=emulate regression
To: Avi Kivity <avi@redhat.com>
Cc: Amit Shah <amit.shah@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 8:17 AM, Avi Kivity <avi@redhat.com> wrote:
> On 02/15/2012 09:36 PM, Andy Lutomirski wrote:
>> Hi, kvm people-
>>
>> Here's a strange failure.  It could be a bug in something
>> RHEL6-specific, but it could be a generic issue that only triggers
>> with a paravirt guest with old userspace on a non-ept host.  There was
>> a bug like this on Xen, and I'm wondering something's wrong on kvm as
>> well.
>>
>> For background, a change in 3.1 (IIRC) means that, when
>> vsyscall=emulate or vsyscall=none, the vsyscall page in the fixmap is
>> NX.  It seems like Amit's machine is marking the physical PTE present
>> but unreadable.
>
> No such thing as present and unreadable, without EPT.
>
>> So I could have messed up, or there could be a subtle
>> bug somewhere.  Any ideas?
>
> What's the code trying to do?  Execute an instruction from an
> non-executable page, trap the #PF, and emulate?  And what are the
> symptoms? wrong error code for the #PF?  That could easily be a kvm bug.
>

The symptom is that some kind of access to a page that's supposed to
be readable, NX is reporting error 5.  I'm not quite sure what kind of
access is causing that.

>>
>> I'll try to reproduce on a non-ept host later on, but that will
>> involve finding one.
>
> rmmod kvm-intel
> moprobe kvm-intel ept=0

I just tried that and still can't reproduce the problem.  FWIW, I also
failed to reproduce it on the one RHEL6 machine I have access to.

>
>> Hmm.  You don't have ept.  If your guest kernel supports paravirt,
>> then you might use the hypercall interface instead of programming the
>> fixmap directly.
>
> There is no hypercall interface for writing page tables in kvm.

Evidently I was looking at the removed kvm_set_pte stuff :)

>
>>
>> >
>> > This is what I get with vsyscall=none, where emulate and native work
>> > fine on the 3.2 kernel on different host hardware, the guest stays the
>> > same:
>> >
>> >
>> > [    2.874661] debug: unmapping init memory ffffffff8167f000..ffffffff818dc000
>> > [    2.876778] Write protecting the kernel read-only data: 6144k
>> > [    2.879111] debug: unmapping init memory ffff880001318000..ffff880001400000
>> > [    2.881242] debug: unmapping init memory ffff8800015a0000..ffff880001600000
>> > [    2.884637] init[1] vsyscall attempted with vsyscall=none ip:ffffffffff600400 cs:33 sp:7fff2f48fe18 ax:7fff2f48fe50 si:7fff2f48ff08 di:0
>>
>> This like (vsyscall attempted) means that the emulation worked
>> correctly.  Your other traces didn't have it or anything like it,
>> which mostly rules out do_emulate_vsyscall issues.
>>
>
> Can you point me at the code in question?

The setup code is in arch/x86/kernel/vsyscall_64.c in map_vsyscall.
The bad access is to the vsyscall page.

>
> Amit, a trace would be nice.

The full output from a test boot of my (updated this morning) initramfs here:
http://web.mit.edu/luto/www/linux/vsyscall_initramfs.img
may give a better hint.

The updated code is here:

#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

typedef time_t (*vsys_time_t)(time_t *);

int main()
{
  vsys_time_t vsys_time = (vsys_time_t)(0xffffffffff600400);
  unsigned char *p = (char*)0xffffffffff600400;
  int i;

  printf("Will try reading...\n");
  printf("The first few bytes are:\n");
  for (i = 0; i < 16; i++) {
    unsigned char c = p[i];
    printf("%02x ", (int)c);
  }
  printf("\n");

  printf("Will try executing...\n");
  printf("The time is %ld\n", (long)( vsys_time(0) ));

  printf("All done\n");
  while(1)
    pause();
}

--Andy
