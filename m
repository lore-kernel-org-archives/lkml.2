Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab0IYDvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 23:51:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43954 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab0IYDvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 23:51:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BzjJmjk6g62yois8NilxglHW8VlBjRoj43NfOt/l7jHCnGMdiDWH6YShz5CGbAw8Rc
         hhwruPgzQxZpiYXqSRnPf5ilnjGgoxLWmA5aIFx2/eA3vKTZdeCdB2Laa4YLvSvwUmE1
         aB29Wce/LeMJp7F9txCH45zqmCbLDha6MMLsw=
MIME-Version: 1.0
In-Reply-To: <20100925024804.GS19804@ZenIV.linux.org.uk>
References: <20100924155231.GQ19804@ZenIV.linux.org.uk>
	<AANLkTik+1k76vGccjwQWeEWZFng61ZoodDyWbN8wvPgE@mail.gmail.com>
	<20100924165716.GR19804@ZenIV.linux.org.uk>
	<AANLkTikV5O1QxYEHRzZzCrE=VSWj8aV6nA5Z3QOTxtL=@mail.gmail.com>
	<20100925024804.GS19804@ZenIV.linux.org.uk>
Date: Fri, 24 Sep 2010 23:51:11 -0400
Message-ID: <AANLkTikKtK1s8mGF4chhLtXRJW1G43BKAAY3wC-EVbQH@mail.gmail.com>
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

On Fri, Sep 24, 2010 at 10:48 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Sep 24, 2010 at 10:25:15PM -0400, Brian Gerst wrote:
>> > + ?? ?? ?? ?? ?? ?? ?? __asm__("mov %w0,%%fs ; mov %w0,%%gs":"=r" (seg) :"0" (seg));
>> > + ?? ?? ?? ?? ?? ?? ?? set_fs(seg);
>> > + ?? ?? ?? ?? ?? ?? ?? regs->xds = seg;
>> > + ?? ?? ?? ?? ?? ?? ?? regs->xes = seg;
>> > + ?? ?? ?? ?? ?? ?? ?? regs->xss = seg;
>> > + ?? ?? ?? ?? ?? ?? ?? regs->xcs = USER_CS;
>> > in 2.1.2. ??And that's when we had
>> > ?? ?? ?? ??* fs and gs evicted from pt_regs
>> > ?? ?? ?? ??* fs and gs not saved restored on kernel entry/exit
>> > ?? ?? ?? ??* just introduced set_fs() to start with (that went in 2.1.0)
>> >
>> > A bit before my time, so I'm not sure what's been going on there...
>>
>> I believe it can be safely removed.  Looking through the history, the
>> corresponding set_fs() calls were removed from 32-bit by commit
>> b93b6ca3.  This is just an artifact from ancient i386 code where
>> set_fs (which is grossly misnamed now) really did set the %fs
>> register.
>
> Not quite.  If you look at the tree where it has shown up (2.1.2), you'll see
> that
>        a) by that time it _wasn't_ an assignment to %fs
>        b) the same patch that has introduced that call there does direct
> assignment to %fs right next to that set_fs().  See that __asm__ above?
>
> Again, I agree that it almost certainly can be dropped.  I really wonder
> about the history, though.  It predates git and bk by far (late 1996).
> Linus, do you have any recollection regarding that stuff?
>

In the beginning, the i386 kernel used a non-flat segmented memory
layout.  USER_[CD]S were 3GB segments at base 0, and KERNEL_[CD]S were
1GB segments at base 3GB.  This meant that the kernel could not access
userspace addresses without using a fs segment override (%fs was saved
in pt_regs, reloaded with USER_DS on kernel entry, and restored on
kernel exit).  You had to reload %fs with KERNEL_DS for the *_user
functions to address the kernel segment.

v2.1.2 introduced the modern flat memory layout with 4GB segments at
base 0.  %fs no longer was used for userspace access, so it wasn't
saved in pt_regs or touched in any way until a task switch.  Instead
of the hardware enforcing the limit, the check was moved to software.

Originally the signal handler had to set regs->xfs = USER_DS so that
the signal handler had a known state when it ran.  That had nothing to
do with the kernel's userspace access mechanism.  It was converted to
do both the immediate reloading of the %fs register (since it was no
longer saved in pt_regs and wouldn't get restored on kernel exit), and
to a new set_fs(USER_DS) call which meant something completely
different.  That is the origin of the code we are trying to remove
now.

--
Brian Gerst
