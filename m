Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2CED7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 22:59:15 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43517 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab2CED7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 22:59:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of darkshikari@gmail.com designates 10.236.154.232 as permitted sender) smtp.mail=darkshikari@gmail.com; dkim=pass header.i=darkshikari@gmail.com
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
From: Jason Garrett-Glaser <jason@x264.com>
Date: Sun, 4 Mar 2012 19:58:33 -0800
X-Google-Sender-Auth: xcBHXpB1ZLi0lajq72U6tqq9XX0
Message-ID: <CABS55+D97mKFdQhGdAXjMGfyRiWd4Os8wfRq9YNa-FQAEQSR7Q@mail.gmail.com>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know of
 any filesystems that depend on the exact VFS 'namehash' implementation?)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 3:46 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Here's a new version of that patch.
>
> It's based n the cleanups I committed and pushed out today, so the base
> may not look familiar, but the upside is that this does the configuration
> automatically (currently the patch enables the word accesses on x86 by
> default as long as DEBUG_PAGEALLOC isn't set).
>
> I worked around my problems with stupid branch prediction on the '/' test
> at the end by just reorganizing the code a bit, and it actually all just
> looks cleaner.
>
> This *does* assume that "bsf" is a reasonably fast instruction, which is
> not necessarily the case especially on 32-bit x86. So the config option
> choice for this might want some tuning even on x86, but it would be lovely
> to get comments and have people test it out on older hardware.

There is an improvement you can make to this.  "bsf" is microcoded in
many future CPUs (e.g. Piledriver) in favor of tzcnt, which has
slightly different flag behavior and no undefined behavior and is part
of BMI1.  This costs a few clocks in such chips -- not as bad as the
Really Slow bsf in chips like the Pentium 4 and Atom, but more than is
necessary (and stalls the instruction decoder, at least on AMD, while
the microcode unit runs).

However, "tzcnt" is opcode-equivalent to "rep bsf", for some odd sort
of backwards compatibility.  Therefore, if your code does the same
thing with both tzcnt and bsf, you can simply use rep bsf instead, and
it'll work without any CPU checks.  The manuals claim that this works
on legacy CPUs, i.e. won't SIGILL.

The only downside I've noticed to this is that valgrind incorrectly
SIGILLs on rep bsf.

Jason
