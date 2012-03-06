Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab2CFF5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 00:57:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35188 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab2CFF5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 00:57:10 -0500
Date: Tue, 6 Mar 2012 05:57:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, airlied@linux.ie, carsteno@de.ibm.com,
        steiner@sgi.com
Subject: Re: [patches] VM-related fixes
Message-ID: <20120306055706.GQ23916@ZenIV.linux.org.uk>
References: <20120305063707.GH23916@ZenIV.linux.org.uk>
 <CAMP5XgeWQpMP2Q_29aybHwfMJ1_k5GkGozqocSVVYDoRTpKD2w@mail.gmail.com>
 <20120306041015.GP23916@ZenIV.linux.org.uk>
 <CAMP5XgdmjL68qZJ8D0pNz-S5m-BauTzPyQ9Xv1SPgdZVMiZMpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP5XgdmjL68qZJ8D0pNz-S5m-BauTzPyQ9Xv1SPgdZVMiZMpg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 09:25:05PM -0800, Arve Hj?nnev?g wrote:
> > Sorry, no.
> > ? ? ? ? ? ? ? ?down_write(&mm->mmap_sem);
> > ? ? ? ? ? ? ? ?vma = proc->vma;
> > ? ? ? ? ? ? ? ?if (vma && mm != vma->vm_mm) {
> > does *not* do what you seem to describe; there's nothing to protect you
> > from proc->vma getting freed under you right between load from proc->vma
> > and check of vma->mm. ?->mmap_sem on the right mm would prevent that,
> > but this one doesn't guarantee anything. ?Get preempted after the second
> > line quoted above and by the time you get the timeslice back, you might
> > have had munmap() done by another thread, with vma freed, its memory
> > recycled, etc.
> >
> 
> OK, if the memory got freed and then re-used by someone who stored a
> value that matched a pointer to the mm struct that was just locked,
> this check will fail to catch it. I can check against a cached vm_mm
> member from mmap instead, assuming this will not change before
> ->close() is called. Does that sound reasonable, or is there a better
> way to check this?

Huh?  Sorry, I hadn't been able to parse that - what do you want to cache,
where and what do you want to check?  Again, at that point *(proc->vma)
may very well be random garbage, so looking at it would be pointless;
the value you had at ->mmap() time would be simply current->mm of mmap(2)
caller; if you want to check that it matches that of opener, fine,
but then why not do just that in ->mmap()?
