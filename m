Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab0LUH4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 02:56:23 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:56404 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab0LUH4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 02:56:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=vWi/ZVcbe/GhXdwML2iuhv/ppji7Vk+65gkxOEYUM9MOjtAw/rqz9xtF0FhYTrPM0/
         6n11SXimbvckRW7vQG62IgwvA2yOfuUJEg4oAJ6hV1ok7yjDLSkFTEgoZNqWk8sPUasN
         2FX6H9DiXtVbdI9gzG/lk5ubRHGvMR4TrK8ag=
MIME-Version: 1.0
In-Reply-To: <AANLkTinO9GSer2cjRL=dgwMzswsSas5j6i6z99NCvC65@mail.gmail.com>
References: <AANLkTimze4agnNRM_HVnQ1=B44pWy_D+OmeUYFvCSwMy@mail.gmail.com>
 <alpine.LSU.2.00.1012202037080.15253@tigran.mtv.corp.google.com> <AANLkTinO9GSer2cjRL=dgwMzswsSas5j6i6z99NCvC65@mail.gmail.com>
From: AJ ONeal <coolaj86@gmail.com>
Date: Tue, 21 Dec 2010 00:56:00 -0700
Message-ID: <AANLkTi=Gx3mFQPfrycmcU8e3oevo5E8bmw2FrrAe0qQB@mail.gmail.com>
Subject: Fwd: Memory Leak in /dev/shm on ARM 2.6.36
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

umount does fail, but umount -l succeeds.

Here's a snippet of the most relevant portion of the code:
https://gist.github.com/749619


The data size is always 512kb
The file write occurs every 128ms (with some hiccups now and then)
14 writes occur before the first file is overwritten.

It's not very likely, but possible that another process could have the
file open for reading when it is unlinked, but never written to.

Luckily I happen to have a 2.6.35 laying around for ARM.

Perhaps I can just get you a copy of the code to test on x86.
I don't have any handy that I'm okay to swap kernels on.

AJ ONeal

On Mon, Dec 20, 2010 at 9:46 PM, Hugh Dickins <hughd@google.com> wrote:
>
> On Mon, 20 Dec 2010, AJ ONeal wrote:
>
> > In my other message about SIGBUS I was mmap-ing a file in /dev/shm.
> >
> > I switched my implementation to use write() instead of mmap and now it
> > leaks memory very very quickly.
> >
> > `df -h` shows that 80mb of memory are in use
> > `du -ch /dev/shm` shows that 10mb of memory in use
> >
> > After just a few minutes of creating and removing 512kb files in
> > /dev/shm the program exits with a write failure.
> > Unmounting and remounting /dev/shm reclaims the memory.
>
> I'm interested, but won't have any time to investigate for several days.
>
> The usual reason (for such a large df/du discrepancy) would be something
> holding open the unlinked files; but if that were the case, then umount
> would fail, complaining that the mount is busy.
>
> Can you please try x86 and see if the same happens there with your
> program?  (I've got x86 but not arm: I see no problem on x86,
> but I'm probably not doing exactly what you're doing.)
>
> Can you please try 2.6.35 and see if that behaves in the same way?
> There were some shmem block accounting changes in 2.6.36, I wonder
> if they're misbehaving on arm.
>
> Thanks,
> Hugh
