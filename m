Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab2CFFZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 00:25:08 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59249 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2CFFZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 00:25:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of arve@android.com designates 10.229.135.66 as permitted sender) smtp.mail=arve@android.com
MIME-Version: 1.0
In-Reply-To: <20120306041015.GP23916@ZenIV.linux.org.uk>
References: <20120305063707.GH23916@ZenIV.linux.org.uk>
	<CAMP5XgeWQpMP2Q_29aybHwfMJ1_k5GkGozqocSVVYDoRTpKD2w@mail.gmail.com>
	<20120306041015.GP23916@ZenIV.linux.org.uk>
Date: Mon, 5 Mar 2012 21:25:05 -0800
Message-ID: <CAMP5XgdmjL68qZJ8D0pNz-S5m-BauTzPyQ9Xv1SPgdZVMiZMpg@mail.gmail.com>
Subject: Re: [patches] VM-related fixes
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, airlied@linux.ie, carsteno@de.ibm.com,
        steiner@sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 8:10 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Mar 05, 2012 at 07:38:21PM -0800, Arve Hj?nnev?g wrote:
>> > [unsolved] binder is insane, even more than usual for drivers/staging.
>> > It stores a reference to mm at open() time,
>>
>> It stores a reference to the task struct, not the mm.
>
> Equivalent, for our purposes.  OK, almost - strictly speaking that avoids
> some extra nasty scenarios with open/exec/mmap, but the real PITA comes from
> much simpler open/fork/mmap in child anyway...
>
>> > then it stores a reference to
>> > vma at mmap() time, then it cheerfully works with that ->vma assuming that
>> > ->mmap_sem on stored reference to ->mm would suffice. ?Guess what happens
>> > if somebody opens it and then forks and does mmap in child?
>>
>> mmap succeeds, but binder_update_page_range will fail when trying to
>> create a transaction? (assuming you are talking about the current
>> version of the driver)
>
> Sorry, no.
>                down_write(&mm->mmap_sem);
>                vma = proc->vma;
>                if (vma && mm != vma->vm_mm) {
> does *not* do what you seem to describe; there's nothing to protect you
> from proc->vma getting freed under you right between load from proc->vma
> and check of vma->mm.  ->mmap_sem on the right mm would prevent that,
> but this one doesn't guarantee anything.  Get preempted after the second
> line quoted above and by the time you get the timeslice back, you might
> have had munmap() done by another thread, with vma freed, its memory
> recycled, etc.
>

OK, if the memory got freed and then re-used by someone who stored a
value that matched a pointer to the mm struct that was just locked,
this check will fail to catch it. I can check against a cached vm_mm
member from mmap instead, assuming this will not change before
->close() is called. Does that sound reasonable, or is there a better
way to check this?

>> > ?Moreover, if
>> > we fork() and have child exit(), we get ->close() called on each VMA we'd
>> > copied into child.
>>
>> The driver sets VM_DONTCOPY which should avoid this.
>
> Umm...  Point taken - missed that.
>
>> > ?Since they have stored reference to vma invalidated by
>> > ->close(), that has unpleasant side effects, to put it mildly.
>>
>> The side effect of ->close() should be the same as when the process
>> that opened the driver exits. In other words, the process that
>> misbehaved is considered dying. It does not however send death
>> notifications until the driver is closed, so other processes do not
>> notice until they try to talk to it.
>>
>> > ?And yes,
>> > I realize that android userland probably doesn't do anything of that kind;
>> > fat lot of good it does us...
>> >
>>
>> What usage case do you have in mind? The binder driver uses the file
>> pointer as the binder process identifier, so you need to open and mmap
>> the driver in every process that want to use the driver. While it is
>> not common to fork a process in android, the driver should work as
>> expected if you do (assuming each process opens and mmaps the driver
>> on its own and don't share the file).
>
> Except that we can't make that assumption...

I'm not sure what your point is. You cannot expect the driver to
behave as expected if you don't follow its api. However, the driver
should prevent misbehaving processes from affecting other processes or
crashing the kernel. Apart from the situation described above, do you
know of any situation where this is not the case?

-- 
Arve Hjønnevåg
