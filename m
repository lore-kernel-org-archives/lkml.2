Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab0IYJyK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 05:54:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64156 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab0IYJyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 05:54:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oVdGCLebVxazFQnW0EOHULRsgjw4pqrXe57wTn0pFs4RIF0EKCMWCSnlybfc6Ycw64
         1f9mEMS8rQnGAwZ6hdjlZdKvXUjo+7wzNgucHJEDdZjHsQCBILGVnveb72m34Yrr8YbK
         oVaCwQcBXFOAYYyX10dtCNBaoGlFXiroQ2bVk=
MIME-Version: 1.0
In-Reply-To: <20100925052054.GU19804@ZenIV.linux.org.uk>
References: <20100924155231.GQ19804@ZenIV.linux.org.uk>
	<AANLkTik+1k76vGccjwQWeEWZFng61ZoodDyWbN8wvPgE@mail.gmail.com>
	<20100924165716.GR19804@ZenIV.linux.org.uk>
	<AANLkTikV5O1QxYEHRzZzCrE=VSWj8aV6nA5Z3QOTxtL=@mail.gmail.com>
	<20100925024804.GS19804@ZenIV.linux.org.uk>
	<AANLkTikKtK1s8mGF4chhLtXRJW1G43BKAAY3wC-EVbQH@mail.gmail.com>
	<20100925052054.GU19804@ZenIV.linux.org.uk>
Date: Sat, 25 Sep 2010 05:54:06 -0400
Message-ID: <AANLkTindqGfToD=xjR_iQHMX+P0qz6bFttZ3RY4MvqOw@mail.gmail.com>
Subject: Re: what's papered over by set_fs(USER_DS) in amd64 signal delivery?
From: Brian Gerst <brgerst@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
        mingo@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 1:20 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Sep 24, 2010 at 11:51:11PM -0400, Brian Gerst wrote:
>> > Again, I agree that it almost certainly can be dropped. ??I really wonder
>> > about the history, though. ??It predates git and bk by far (late 1996).
>> > Linus, do you have any recollection regarding that stuff?
>> >
>>
>> In the beginning, the i386 kernel used a non-flat segmented memory
>> layout.  USER_[CD]S were 3GB segments at base 0, and KERNEL_[CD]S were
>> 1GB segments at base 3GB.  This meant that the kernel could not access
>> userspace addresses without using a fs segment override (%fs was saved
>> in pt_regs, reloaded with USER_DS on kernel entry, and restored on
>> kernel exit).  You had to reload %fs with KERNEL_DS for the *_user
>> functions to address the kernel segment.
>
> I know.
>
>> v2.1.2 introduced the modern flat memory layout with 4GB segments at
>> base 0.  %fs no longer was used for userspace access, so it wasn't
>> saved in pt_regs or touched in any way until a task switch.  Instead
>> of the hardware enforcing the limit, the check was moved to software.
>
> Yes.
>
>> Originally the signal handler had to set regs->xfs = USER_DS so that
>> the signal handler had a known state when it ran.  That had nothing to
>> do with the kernel's userspace access mechanism.  It was converted to
>> do both the immediate reloading of the %fs register (since it was no
>> longer saved in pt_regs and wouldn't get restored on kernel exit), and
>> to a new set_fs(USER_DS) call which meant something completely
>> different.  That is the origin of the code we are trying to remove
>> now.
>
> That still makes no sense.  2.0 mechanism guaranteed that even if you forgot
> to restore %fs to USER_DS, you wouldn't leak that to userland.  But this
> one didn't - each place like that became a roothole, no matter what you
> did on signal delivery.  Simply because there might have been no unblocked
> signals with userland handlers.  IOW, that set_fs() seems to have been
> useless from the day 1

That's what I was getting at.  The code it replaced did something
totally different (setting up user-mode register state).  The asm()
part of the replacement was the correct thing to do.  The set_fs()
call was unnecessary.

> unless I'm missing something really subtle, like
> e.g. some processes deliberately running (in 2.0) with %fs set to something
> with lower limit, with signal handlers allowed to switch back to normal
> for duration.  And even that would've been broken, since there wouldn't be
> a matching set_fs() in sigreturn()...

If the user process used a different %fs it didn't matter to the
kernel, because %fs was saved to pt_regs and reloaded with USER_DS on
kernel entry.

--
Brian Gerst
