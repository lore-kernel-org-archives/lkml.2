Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab0IYCZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 22:25:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36369 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab0IYCZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 22:25:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ie9+GE+0vb8nzuLIHaroCXvgxNMZhsXcJmciLkCN5/eswRgl4W4v48I7zU9dOBlPKk
         I8BSIDKsjFAgI8k8ApQ6rtXsmSZXvSXpgG3upSUVqwzr/i4CLjS+ft9xY9xhGadkijQX
         meN8u12myyoTzPDITrPN7cj4Cw4gLHoBnl+ck=
MIME-Version: 1.0
In-Reply-To: <20100924165716.GR19804@ZenIV.linux.org.uk>
References: <20100924155231.GQ19804@ZenIV.linux.org.uk>
	<AANLkTik+1k76vGccjwQWeEWZFng61ZoodDyWbN8wvPgE@mail.gmail.com>
	<20100924165716.GR19804@ZenIV.linux.org.uk>
Date: Fri, 24 Sep 2010 22:25:15 -0400
Message-ID: <AANLkTikV5O1QxYEHRzZzCrE=VSWj8aV6nA5Z3QOTxtL=@mail.gmail.com>
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

On Fri, Sep 24, 2010 at 12:57 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Sep 24, 2010 at 09:07:33AM -0700, Linus Torvalds wrote:
>
>> I _think_ it is historical, and probably relates to just restoring all
>> the user mode state at signal delivery to a known state. IOW, I think
>> it really does go hand-in-hand with  the whole "clear bits in the
>> eflags register" thing.
>>
>> x86-64 has historically had some left-over crap that we already
>> cleaned up in 32-bit mode, for the simple reason that the original
>> x86-64 code was forked from an earlier base, and then hacked up
>> somewhat. So I think this "#ifdef CONFIG_X86_64" is just a case of
>> that.
>
> Nope - look at the commit that merged them; i386 used to have it as well
> right until the merge.  And yes, I agree that it's most likely a leftover
> from ancient times.
>
>> But maybe we should have a WARN_ON_ONCE() to verify it, rather than
>> just kill it outright.
>
> Um...  If we do that, I'd suggest taking it in front of setup_...frame()
> and doing do_exit() with loud warning along the lines of "someone has
> come that -><- close to rooting the box".  Anybody who can trigger that
> (assuming it can be triggered at all) can overwrite arbitrary parts of
> kernel memory.
>
> I'd still like to hear from the x86 maintainers, just in case there's
> something more non-trivial to that than "it has always been that way"...
>
> FWIW, looking at the history it seems that the thing has happened almost
> by accident; the critical part is
> -       regs->cs = USER_CS; regs->ss = USER_DS;
> -       regs->ds = USER_DS; regs->es = USER_DS;
> -       regs->gs = USER_DS; regs->fs = USER_DS;
> +       {
> +               unsigned long seg = USER_DS;
> +               __asm__("mov %w0,%%fs ; mov %w0,%%gs":"=r" (seg) :"0" (seg));
> +               set_fs(seg);
> +               regs->xds = seg;
> +               regs->xes = seg;
> +               regs->xss = seg;
> +               regs->xcs = USER_CS;
> in 2.1.2.  And that's when we had
>        * fs and gs evicted from pt_regs
>        * fs and gs not saved restored on kernel entry/exit
>        * just introduced set_fs() to start with (that went in 2.1.0)
>
> A bit before my time, so I'm not sure what's been going on there...

I believe it can be safely removed.  Looking through the history, the
corresponding set_fs() calls were removed from 32-bit by commit
b93b6ca3.  This is just an artifact from ancient i386 code where
set_fs (which is grossly misnamed now) really did set the %fs
register.

--
Brian Gerst
