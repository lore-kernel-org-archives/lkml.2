Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab1E1Agg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 20:36:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42721 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757569Ab1E1Age (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 20:36:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=EHDYBR1whmW3Qbvg+KgW1QJq4ZrIEfRW0LIlEaqVK7ZhhM4hin0YT439lbMIhhZi9e
         bkcvUWe2OKrEdQaJc3Zw1+5l1pw0VKkFwl/VxQJmOWg6qjTsPXZj87u+6UaIyca9LqZg
         YModcyiMpHwLRTJBr8uOF7Ugz0ipDSr3FSw1s=
MIME-Version: 1.0
In-Reply-To: <20110523090918.GA5474@elte.hu>
References: <20110520161210.81bbef3a.sfr@canb.auug.org.au>
	<BANLkTi=Dn_jvJ8mLY0Bc6C1Ptoqa-kJrCg@mail.gmail.com>
	<20110523090918.GA5474@elte.hu>
Date: Fri, 27 May 2011 20:36:33 -0400
X-Google-Sender-Auth: EBSL44JzAYxi2eSepjFoAiweYmU
Message-ID: <BANLkTi=_=wmzWm79RTVzw09VX-Feb6zpwA@mail.gmail.com>
Subject: Re: [bloat] Measuring header file bloat effects on kernel build
 performance: a more than 2x slowdown ...
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 5:09 AM, Ingo Molnar <mingo@elte.hu> wrote:
>

[...]

>
> A surprisingly large chunk are all the module.h details which brings in details
> like large elf.h definitions - despite pid.c only relying on the module code
> for the spurious use of EXPORT_SYMBOL primitives. Fixing this would cause no
> runtime overhead AFAICS.

I started working on the above since it seemed like it would be an interesting
puzzle to untangle - that is before I realized how involved it would be.  :)

It is do-able, but not as simple as it 1st might seem.  At the moment, if you
touch linux/module.h and rebuild, the time is within one or two seconds of
a fresh build - some 1670 compiles (for a typical x86-64 defconfig).  So
module.h is pretty much 99% pervasive.  With my tree so far, the same
touch builds close to 500 less files, is done in ~20% less time, and I've
still many changes yet to make....

Things that become evident upon attacking this:

1) Separating out the EXPORT_SYMBOL stuff just alone by itself largely
does nothing, because there are ~35 files in include/* which will directly
include linux/module.h regardless of whether your file wanted it or not.

2) The biggest culprit is linux/device.h, since it finds its way into almost
everything it seems.  One has to clean everything else up, and then
rebase this type of change to last, so the tree remains bisectable.

3) Dealing with #2 reveals that *lots* of drivers/files never even had a line
for #include <linux/module.h> -- they were happy to have it implicitly
appear via some unknown include chain and simply ride the wave.

4) It isn't just the presence of module.h that people were implicitly taking
advantage of -- since module.h itself includes 95% of the known world, I
found files that were getting stat.h, sched.h, even asm/*.h etc. via the
implicit presence of module.h

5) The combination of #3 and #4 makes for a lot of commits, as  I'm trying
to keep them separated along subsystem/maintainer boundaries.

Anyways, I just wanted to mention this was underway, but I don't see it
being 100% done in the small amount of time left in this merge window.

The current tree is here if anyone wants to poke at it and comment on it
while I continue to plug away at the task.  x86, x86-64 and powerpc-64
defconfigs have been tested to build OK.

git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux-2.6.git
module.h-split-May27

http://git.kernel.org/?p=linux/kernel/git/paulg/linux-2.6.git;a=shortlog;h=refs/heads/module.h-split-May27

Paul.

>
> Another big chunk are the RCU definitions and APIs. These too are inlined for
> performance reasons - and that seems justified.
>
> Anway, what i tried to demonstrate with this mail how much *real* slowdown in
> the kernel build our current header file bloat is causing. We could literally
> halve our kernel build times if we fixed this!
>
> Thanks,
>
