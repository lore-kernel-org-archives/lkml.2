Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab1FOTZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:25:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58192 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab1FOTZM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:25:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=j0hwReNxzgGULcPOIoEAedwlTD2+YgJ4WExbxkiK3GXhkgiMkYy2dy6IA4N+K6cbV/
         yJEnse8cUcKdsZmSQ3bJiJNKH9i+sPZ7a1yzbZ0LD2C8lRy6duYhy0HxXuHHH4zLkfIT
         P47YUZq/oUNK1FC3tbEBMJa6JYiENTZ/PwfZk=
MIME-Version: 1.0
In-Reply-To: <BANLkTinSac=XHNk7jnsYGDo06B=ChXsnAQ@mail.gmail.com>
References: <BANLkTikbnsu05+Nae8isATuZ8Fucj14+LQ@mail.gmail.com>
 <BANLkTi=nsCK2bFf2v+PkKj=Opsxseqe9pQ@mail.gmail.com> <BANLkTi=ZETGToRcOHXg5gxAQO3EKN+YyLg@mail.gmail.com>
 <BANLkTi=-xJizWP5H9vNvaJhRN-Vm-ubraA@mail.gmail.com> <4DF7A264.3030901@mit.edu>
 <20110614211613.GB12249@elte.hu> <BANLkTi=W1xFdoSFxnNBGX9gt_pYOH4oF=A@mail.gmail.com>
 <20110614213109.GA9725@elte.hu> <BANLkTimXYaf_14VbB6ex0kG6sPnTUfzu6g@mail.gmail.com>
 <BANLkTi=mwowbSy0M=rjdQW_cKDVf1tBBpA@mail.gmail.com> <20110615072553.GA26003@elte.hu>
 <BANLkTinSac=XHNk7jnsYGDo06B=ChXsnAQ@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 15 Jun 2011 15:24:49 -0400
X-Google-Sender-Auth: 2w_qmMlZDmIXUV9s3o0iGJP-VTY
Message-ID: <BANLkTinxKV-Kprm+ezfbt2a=C1fz+-7wrg@mail.gmail.com>
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Rakib Mullick <rakib.mullick@gmail.com>,
        hpa@zytor.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 2:49 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Jun 15, 2011 at 12:25 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> No, that BUG() is a "cannot happen on a correct kernel" so it has no
>> ABI impact - but it might trigger if the execution environment is
>> violated:
>
> Well, in genreal, I would seriously suggest that people not use
> BUG_ON() as liberally as they tend to be used.
>
> There are *very* few reasons to have a BUG_ON(), and they are all "I
> cannot possibly continue from this state".
>
> Anything else should have a WARN_ON() or just return an error, or (if
> it's a security issue) just kill the process.
>
> Some kernel developers seem to use BUG_ON() as a "I can't see how this
> could ever trigger, so let's kill the machine if it does", and that
> really is very wrong.
>
> If you are aware that something should never trigger, I'd suggest you
> either say "ok, I'm _sure_ that this cannot trigger" and just remove
> the BUG_ON(), or you should ask yourself "are we better off killing
> the machine than just returning an error".
>
> In this case, for example, if
>
>>  - leave the warning as-is. Whoever builds with CONFIG_BUG=n will
>>   have to live with the consequences of the 'impossible' happening
>>   and will have to accept the more unpredictable kernel behavior
>>   that *will* trigger in various parts of the kernel if BUG() is
>>   turned into a NOP. If any of the above 'impossible' failure modes
>>   triggers then having more undefined behavior in form of an
>>   uninitialized variable will be the least of their worry.
>
> If it's that impossible, I don't see why you have the BUG_ON() in the
> first place.
>
> I also don't see why the code isn't just written to be so strict that
> the lack of BUG_ON just wouldn't matter. I think that code that
> "depends" on a BUG_ON() for correctness (ie assuming that the whole
> thing never returns) is buggy by definition. Please just don't write
> code like that.
>
> So what's the reason for just not initializing that 'ret' variable to
> -EFAULT, and leaving it at that? And/or just removing all the BUG_ON's
> entirely? Do they actually _help_ anything?

Well, let's say that my logic is wrong and this particular BUG can be
hit because some kernel bug allows some user program to trigger it.
Then we can do one of four things:

1. Return some value back to userspace (i.e. not EFAULT).  (This value
could be hardcoded or left as uninitialized.)  I don't like this: if
this happens, I want to see a bug report so I can fix the root cause.
Also, for so long as the kernel bug exists, then userspace exploits
could try to take advantage of the incorrect kernel behavior to take
over buggy programs.

2. Set ret = -EFAULT.  That will hit the EFAULT path which will print
"vsyscall fault (exploit attempt?)" to the kernel log and kill the
process.  I have no problem killing the process, but the message is
misleading.  We don't have an "exploit attempt?"; we have a kernel bug
that should be fixed.  This will confuse people and could result in me
not getting a bug report.

3. Add code to print a more informative message and kill the process.
This seems like needless bloat.

4. BUG().  This will kill the process, print a nice loud message that
will get reported, and should leave the system pretty much usable
because no locks are held and no resources are in a funny state.

So, given the context, I stand by my BUG.


*However*, in this particular case, there is a different fix.  I can
rearrange the code to send vsyscall_nr == 3 through the bad RIP (i.e.
"illegal int 0xcc") path.  It even removes eight lines of code, and
I'll submit a patch as part of v2 of "remove all remaining code from
the vsyscall page".


--Andy

P.S.  I would like to congratulate myself for my
nitpicking-received-per-unit-patch score. :)

P.P.S. Maybe I'm off the hook until you notice the
BUG_ON(!user_mode(regs)) a few lines up.  That one I think should stay
since we're pretty much screwed if kernel code hits the int 0xcc
handler.  Trying to emulate a ret instruction will throw the caller
into some random address and OOPS just as hard a few nanoseconds
later.  Anyway, if int 0xcb will OOPS, then I think int 0xcc should
also.
