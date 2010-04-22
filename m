Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0DVWps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 18:45:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab0DVWpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:45:46 -0400
Date: Thu, 22 Apr 2010 18:45:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Haren Myneni <hbabu@us.ibm.com>,
       Neil Horman <nhorman@tuxdriver.com>, Cong Wang <amwang@redhat.com>,
       kexec@lists.infradead.org
Subject: Re: [PATCH 0/5] Add second memory region for crash kernel
Message-ID: <20100422224525.GJ3228@redhat.com>
References: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com> <m1aasvkupc.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1aasvkupc.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 03:07:11PM -0700, Eric W. Biederman wrote:
> Vitaly Mayatskikh <v.mayatskih@gmail.com> writes:
> 
> > Patch applies to 2.6.34-rc5
> >
> > On x86 platform, even if hardware is 64-bit capable, kernel starts
> > execution in 32-bit mode. When system is kdump-enabled, crashed kernel
> > switches to 32 bit mode and jumps into new kernel. This automatically
> > limits location of dump-capture kernel image and it's initrd by first
> > 4Gb of memory. Switching to 32 bit mode is performed by purgatory
> > code, which has relocations of type R_X86_64_32S (32-bit signed), and
> > this cuts "good" address space for crash kernel down to 2 Gb. I/O
> > regions may cut down this space further.
> >
> > When system has a lot of memory (hundreds of gigabytes), dump-capture
> > kernel also needs relatively a lot of memory to account old kernel's
> > pages. It may be impossible to reserve enough memory below 2 or even 4
> > Gb. Simplest solution is it break dump-capture kernel's reserved
> > memory region into two pieces: first (small) region for kernel and
> > initrd images may be easily placed in "good" address space in the
> > beginning of physical memory, and second region may be located
> > anywhere.
> >
> > This serie of patches realizes this approach. It requires also changes
> > in kexec utility to make this feature work, but is
> > backward-compatible: old versions of kexec will work with new
> > kernel. I will post patch to kexec-tools upstream separately.
> 
> Have you tried loading a 64bit vmlinux directly into a higher address
> range?  There may be a bit or two missing but you should be able to
> load a linux kernel above 4GB.  I tested the basics of that mechanism
> when I made the 64bit relocatable kernel.

I guess even if it works, for distributions it will become additional
liability to carry vmlinux (instead of relocatable bzImage). So we shall
have to find a way to make bzImage work.

> 
> I don't buy the argument that there is a direct connection between
> the amount of memory you have and how much memory it takes to dump it.
> Even an indirect connections seems suspicious.

Memory requirement by user space might be of interest though like dump
filtering tools. I vaguely remember that it used to first traverse all
the memory pages, create some internal data structures and then start
dumping.

So memory required by filtering tool might be directly proportional to
amount of memory present in the system.

Vitaly, have you really run into cases where 2G upper limit is a concern.
What is the configuration you have, how much memory it has and how much
memory are you planning to reserve for kdump kernel?

Thanks
Vivek
