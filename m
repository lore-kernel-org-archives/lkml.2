Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1FAExN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 00:53:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:15371 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab1FAExK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 00:53:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=yuK75Od8vbrxR4ThU08xGbmAqY2gRF9yxw8zeqAHsjp6aUCQtAJFKQ5D1mL4rI2ns4
         4GG6GSEq51QCp0KxSKGg==
Date: Tue, 31 May 2011 21:52:56 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Brad Campbell <lists2009@fnarfbargle.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Subject: Re: KVM induced panic on 2.6.38[2367] & 2.6.39
In-Reply-To: <20110601011527.GN19505@random.random>
Message-ID: <alpine.LSU.2.00.1105312120530.22808@sister.anvils>
References: <4DE44333.9000903@fnarfbargle.com> <20110531054729.GA16852@liondog.tnic> <4DE4B432.1090203@fnarfbargle.com> <20110531103808.GA6915@eferding.osrc.amd.com> <4DE4FA2B.2050504@fnarfbargle.com> <alpine.LSU.2.00.1105311517480.21107@sister.anvils>
 <4DE589C5.8030600@fnarfbargle.com> <20110601011527.GN19505@random.random>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011, Andrea Arcangeli wrote:
> On Wed, Jun 01, 2011 at 08:37:25AM +0800, Brad Campbell wrote:
> > On 01/06/11 06:31, Hugh Dickins wrote:
> > > Brad, my suspicion is that in each case the top 16 bits of RDX have been
> > > mysteriously corrupted from ffff to 0000, causing the general protection
> > > faults.  I don't understand what that has to do with KSM.
> > >
> > > But it's only a suspicion, because I can't make sense of the "Code:"
> > > lines in your traces, they have more than the expected 64 bytes, and
> > > only one of them has a ">" (with no"<") to mark faulting instruction.
> > >
> > > I did try compiling the 2.6.39 kernel from your config, but of course
> > > we have different compilers, so although I got close, it wasn't exact.
> > >
> > > Would you mind mailing me privately (it's about 73MB) the "objdump -trd"
> > > output for your original vmlinux (with KSM on)?  (Those -trd options are
> > > the ones I'm used to typing, I bet not they're not all relevant.)
> > >
> > > Of course, it's only a tiny fraction of that output that I need,
> > > might be better to cut it down to remove_rmap_item_from_tree and
> > > dup_fd and ksm_scan_thread, if you have the time to do so.
> > 
> > Would you believe about 20 seconds after I pressed send the kernel oopsed.
> > 
> > http://www.fnarfbargle.com/private/003_kernel_oops/
> > 
> > oops reproduced here, but an un-munged version is in that directory 
> > alongside the kernel.
> > 
> > [36542.880228] general protection fault: 0000 [#1] SMP
> 
> Reminds me of another oops that was reported on the kvm list for
> 2.6.38.1 with message id 4D8C6110.6090204. There the top 16 bits of
> rsi were flipped and it was a general protection too because of
> hitting on the not mappable virtual range.
> 
> http://www.virtall.com/files/temp/kvm.txt
> http://www.virtall.com/files/temp/config-2.6.38.1
> http://virtall.com/files/temp/mmu-objdump.txt
> 
> That oops happened in kvm_unmap_rmapp though, but it looked memory
> corruption (Avi suggested use after free) but it was a production
> system so we couldn't debug it further.
> 
> I recommend next thing to reproduce again with 2.6.39 or
> 3.0.0-rc1. Let's fix your scsi trouble if needed but it's better you
> test with 2.6.39.

Brad, thanks for this and the other further crash, with vmlinux etc:
very helpful info.

Andrea, I'm pretty sure you're right to connect Brad's report with
the one above.

In four out of five of Brad's reports (cannot tell in the fifth),
the bad pointer (with top 16 bits 0000 instead of ffff) had been
loaded from SLUB memory at an address offset 0x7f8 (1 case) or
0xff8 (3 cases) i.e. it's the short at 0x7fe or 0xffe that has
been zeroed.

No reason to suspect KSM's rmap_item code, or file table handling:
they just seem to be the victims of corruption from elsewhere.

I notice %rax and %rsi, the corrupted pointer in your kvm.txt
case, is itself a ...7f8 address; and %r13 an ...ff8 address.
I've not even glanced at the code, but I wonder if that implies
that KVM is close to the origin of the corruption.

I doubt I'll be able to spend more time on this, hope you can
take over.

I guess Brad could try SLUB debugging, boot with slub_debug=P
for poisoning perhaps; though it might upset alignments and
drive the problem underground.  Or see if the same happens
with SLAB instead of SLUB.

But I rather hope that you or someone will understand the 7fe clue.

Thanks,
Hugh
