Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143Ab1APFQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 00:16:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49238
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888Ab1APFQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 00:16:50 -0500
Date: Sat, 15 Jan 2011 21:17:22 -0800 (PST)
Message-Id: <20110115.211722.39173519.davem@davemloft.net>
To: richm@oldelvet.org.uk
Cc: 609371@bugs.debian.org, ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D3074FE.3030707@oldelvet.org.uk>
References: <20110113.155700.102679408.davem@davemloft.net>
	<4D302B2F.7030108@oldelvet.org.uk>
	<4D3074FE.3030707@oldelvet.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Mortimer <richm@oldelvet.org.uk>
Date: Fri, 14 Jan 2011 16:08:30 +0000

[ Frederic, Steven, Ingo, the short version of the story is that we
  need to make it such that the _ftrace_events section is aligned
  properly for 64-bit systems, and in particular that GCC can see this
  too.  Otherwise GCC thinks 64-bit words will be unaligned and we get
  all kinds of funky relocations being used in modules on sparc64 that
  really there is never any reason to see. ]

> They seem to come from scsi.o at
> 
> .LLC51:
>         .asciz  "scsi_eh_wakeup"
>         .section        _ftrace_events,"aw",@progbits
>         .align 4
>         .type   event_scsi_eh_wakeup, #object
>         .size   event_scsi_eh_wakeup, 136
> event_scsi_eh_wakeup:
>         .skip   16
>         .uaxword        event_class_scsi_eh_wakeup
>         .uaxword        .LLC51
>         .skip   8
>         .skip   40
>         .uaxword        ftrace_event_type_funcs_scsi_eh_wakeup
>         .uaxword        print_fmt_scsi_eh_wakeup
>         .skip   40

These ".uaxword" emissions are a bug, and if we let them stand then
ftrace events are going to load every long word object using a
sequence of byte-sized accesses.  This will absolutely kill
performance.

This is exactly why I wanted to find out why this started happening
out of nowhere, instead of blindly adding support for new relocation
types to the sparc module loader.

The set of relocations supported by the sparc module loading code is
not meant to be "all relocations which are legal" but rather it's
meant to support the most minimum set of relocations that the kernel
actually _needs_ and should be making use of.

I think the problem we have here is that the _ftrace_events section is
not aligned sufficiently.  That ".align 4" mnemonic is a good indication
of this.  It should at least "8" on sparc64.

So we need to figure out why that is happening, and fix that instead.

Thanks.
