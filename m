Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab1LAUJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 15:09:43 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55868 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab1LAUJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 15:09:42 -0500
MIME-Version: 1.0
In-Reply-To: <40F38A2B-48A0-4A8C-B45D-579865F135CC@kernel.crashing.org>
References: <CAL8zT=juU_PC92R4za31R8Lmur0PrFwog1m1fk+PEarW_0C6ng@mail.gmail.com>
 <D70E8CC4-9FA3-4DC9-B623-02F32EFBFE0F@kernel.crashing.org>
 <CAL8zT=gGfBYsLcsKobJPhfhEhNeLcrYMoWh2kv0odT0n0wnZgQ@mail.gmail.com>
 <CAOZdJXVq_g=GAJLRsHZ+290cAJfpOx0LX3sBL3T5i0CaG+xh9Q@mail.gmail.com>
 <CAL8zT=hK2rDDC7s+SkvCA=C5LjVX+5oRQmP+KQet2mkFEnaKKw@mail.gmail.com>
 <CAL8zT=jgZS2=t0SadUXXshabKPsxHJe_frkfOw5XyF88k3jR=g@mail.gmail.com> <40F38A2B-48A0-4A8C-B45D-579865F135CC@kernel.crashing.org>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Thu, 1 Dec 2011 21:09:20 +0100
Message-ID: <CAL8zT=iqoE0UKnqqDoioq6b8Ld0qXQ1XtMbACXnXtiunzpJRAw@mail.gmail.com>
Subject: Re: Different behaviour when using "nosmp" parameter on SMP and UP
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Tabi Timur-B04825 <B04825@freescale.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/1 Kumar Gala <galak@kernel.crashing.org>:
>
> On Dec 1, 2011, at 11:52 AM, Jean-Michel Hautbois wrote:
>
>> 2011/12/1 Jean-Michel Hautbois <jhautbois@gmail.com>:
>>> 2011/12/1 Tabi Timur-B04825 <B04825@freescale.com>:
>>>> On Thu, Dec 1, 2011 at 9:04 AM, Jean-Michel Hautbois
>>>> <jhautbois@gmail.com> wrote:
>>>>>
>>>>> Any idea on how to debug this ? I am using a 2.6.35 kernel.
>>>>
>>>> There are a ton of Kconfig options for debugging various locking bugs.
>>>>  Try turning them on.
>>>>
>>
>> All Kconfig options do not help me with cache coherency problems, though.
>> Or, I didn't find any option related.
>> Any idea ?
>>
>> JM
>
> Nope, if you can't describe the code in any more detail we can't help.
>

Here is what I can tell, I hope this will help you.

I have a userland process, which reads and writes data to a character
device thanks to ioctl.
Reads and Writes are performed with this scheme :
Lock Access -> ioctl -> down_interruptible(semaphore)
Read (or Write) -> ioctl -> ioread32
Unlock Access -> ioctl -> up(semaphore)

It reads (or writes) 4 bytes by 4 bytes, in a loop in the process
which will eventually get several bytes from the PCIe device.
The read (write) ioctl is really simple (and in fact, may be rewritten) :
- kmalloc a structure, then copy_from_user
- ioread32 using adress and offset from the structure copied previously
- copy_to_user and free the structure.

The userland process is currently doing a loop in order to read or
writes with a 4bytes step.
I am neither the writer of the driver nor the userland process, this
is why I can't give you the code.

Here is what I would do, at least :
1/ rewrite the read/write part of the ioctl in order to user a per_cpu
structure and not a "dynamically allocated at each call" structure
2/ rewrite the userland part in order to ask the driver for n bytes,
leaving the loop on ioread32/iowrite32 inside the ioctl

Thanks for your help.
JM
