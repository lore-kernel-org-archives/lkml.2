Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1K1HQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 02:16:04 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53790 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab1K1HQC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 02:16:02 -0500
MIME-Version: 1.0
In-Reply-To: <20111127105000.GL2557@redhat.com>
References: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
	<1322361735-21428-1-git-send-email-kernelfans@gmail.com>
	<4ED212C7.1080901@redhat.com>
	<20111127105000.GL2557@redhat.com>
Date: Mon, 28 Nov 2011 15:16:01 +0800
Message-ID: <CAFgQCTscektJsC-2ThQn7FhHA7=Qf4t3t0+X+i0zT_yZZjwL0g@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH 2/2] kvm: exit to userspace with reason KVM_EXIT_VCPU_DEAD
From: Liu ping fan <kernelfans@gmail.com>
To: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>
Cc: aliguori@us.ibm.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org, ryanh@us.ibm.com, jan.kiszka@web.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 6:50 PM, Gleb Natapov <gleb@redhat.com> wrote:
> On Sun, Nov 27, 2011 at 12:36:55PM +0200, Avi Kivity wrote:
>> On 11/27/2011 04:42 AM, Liu Ping Fan wrote:
>> > From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>> >
>> > The vcpu can be safely released when
>> > --1.guest tells us that the vcpu is not needed any longer.
>> > --2.vcpu hits the last instruction _halt_
>> >
>> > If both of the conditions are satisfied, kvm exits to userspace
>> > with the reason vcpu dead. So the user thread can exit safely.
>> >
>> >
>>
>> Seems to be completely unnecessary.  If you want to exit from the vcpu
>> thread, send it a signal.
>>
Hi Avi and Gleb,

First, I wanted to make sure my assumption is right, so I can grab
your meaning more clearly -:). Could you elaborate it for me, thanks.

I had thought that when a vcpu was being removed from guest, kvm must
satisfy the following conditions to safely remove the vcpu:
--1. The tasks on vcpu in GUEST  have already been migrated to other
vcpus and ONLY idle_task left ---- The CPU_DEAD is the checkpoint.
--2. We must wait the idle task to hit native_halt() in GUEST, till
that time, this vcpu is no needed even by idle_task. In KVM, the vcpu
thread will finally sit on "kvm_vcpu_block(vcpu);"
We CAN NOT suppose the sequence of the two condition because they come
from different threads.  Am I right?

And here comes my question,
--1. I think the signal will make vcpu_run exit to user, but is it
allow vcpu thread to finally call  "kernel/exit.c : void do_exit(long
code)" in current code in kvm or in qemu?
--2. If we got CPU_DEAD event, and then send a signal to vcpu thread,
could we ensure that we have already sit on "kvm_vcpu_block(vcpu);"

Thanks and regards,
ping fan

> Also if guest "tells us that the vcpu is not needed any longer" (via
> ACPI I presume) and vcpu actually doing something critical instead of
> sitting in 1:hlt; jmp 1b loop then it is guest's problem if it stops
> working after vcpu destruction.
>


> --
>                        Gleb.
>
