Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab2CFGgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 01:36:49 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57687 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2CFGgs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 01:36:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of arve@android.com designates 10.229.135.82 as permitted sender) smtp.mail=arve@android.com
MIME-Version: 1.0
In-Reply-To: <20120306055706.GQ23916@ZenIV.linux.org.uk>
References: <20120305063707.GH23916@ZenIV.linux.org.uk>
	<CAMP5XgeWQpMP2Q_29aybHwfMJ1_k5GkGozqocSVVYDoRTpKD2w@mail.gmail.com>
	<20120306041015.GP23916@ZenIV.linux.org.uk>
	<CAMP5XgdmjL68qZJ8D0pNz-S5m-BauTzPyQ9Xv1SPgdZVMiZMpg@mail.gmail.com>
	<20120306055706.GQ23916@ZenIV.linux.org.uk>
Date: Mon, 5 Mar 2012 22:36:47 -0800
Message-ID: <CAMP5XgeXvrQ4_cEWGiiHzbnYrzx6Nej_O4H_bA5JzLmUtvYALQ@mail.gmail.com>
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

On Mon, Mar 5, 2012 at 9:57 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Mar 05, 2012 at 09:25:05PM -0800, Arve Hj?nnev?g wrote:
>> > Sorry, no.
>> > ? ? ? ? ? ? ? ?down_write(&mm->mmap_sem);
>> > ? ? ? ? ? ? ? ?vma = proc->vma;
>> > ? ? ? ? ? ? ? ?if (vma && mm != vma->vm_mm) {
>> > does *not* do what you seem to describe; there's nothing to protect you
>> > from proc->vma getting freed under you right between load from proc->vma
>> > and check of vma->mm. ?->mmap_sem on the right mm would prevent that,
>> > but this one doesn't guarantee anything. ?Get preempted after the second
>> > line quoted above and by the time you get the timeslice back, you might
>> > have had munmap() done by another thread, with vma freed, its memory
>> > recycled, etc.
>> >
>>
>> OK, if the memory got freed and then re-used by someone who stored a
>> value that matched a pointer to the mm struct that was just locked,
>> this check will fail to catch it. I can check against a cached vm_mm
>> member from mmap instead, assuming this will not change before
>> ->close() is called. Does that sound reasonable, or is there a better
>> way to check this?
>
> Huh?  Sorry, I hadn't been able to parse that - what do you want to cache,

The vm_mm member of the vma.

> where and what do you want to check?  Again, at that point *(proc->vma)
> may very well be random garbage, so looking at it would be pointless;

Yes it may be random garbage, but we only have a problem if that
random garbage happens to match the mm pointer we just used.

> the value you had at ->mmap() time would be simply current->mm of mmap(2)
> caller; if you want to check that it matches that of opener, fine,
> but then why not do just that in ->mmap()?

If the opener calls exec does the mm returned by get_task_mm change?
If so, the mmap_sem I locked will not match the vma saved in mmap() so
I need the check above. If exec creates a new task struct then a check
in mmap would be sufficient, but I was not under the impression that
this happens.

-- 
Arve Hjønnevåg
