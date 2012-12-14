Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab2LNWZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:25:23 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59216 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab2LNWZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:25:21 -0500
Date: Sat, 15 Dec 2012 02:25:17 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, aarcange@redhat.com,
        ak@linux.intel.com, Pavel Emelyanov <xemul@parallels.com>,
        Stefani Seibold <stefani@seibold.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, criu@openvz.org, mingo@redhat.com,
        john.stultz@linaro.org, tglx@linutronix.de
Subject: Re: [CRIU] [PATCH] Add VDSO time function support for x86 32-bit
 kernel
Message-ID: <20121214222517.GG6582@moon>
References: <8c3585bc-fc7d-4826-913c-f4581494d91d@email.android.com>
 <CALCETrX5KUiQaV7dsAFa1SYyWPjUVwh43HvbPwqPStMxqE0ctQ@mail.gmail.com>
 <50CAE485.5020608@parallels.com>
 <50CB716D.6020501@zytor.com>
 <CALCETrWazriQVbQPc8u+KFyNUaa=kJUc=jdh9w7z6rS+kWEX1w@mail.gmail.com>
 <50CB7459.7010107@zytor.com>
 <20121214201217.GE6582@moon>
 <50CB9553.7050808@zytor.com>
 <CALCETrUS7JDtLd0jYy7cRNoBm1VHhMw3sTPRjhsm3uDwoPQrCA@mail.gmail.com>
 <50CBA171.4080403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CBA171.4080403@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 02:00:17PM -0800, H. Peter Anvin wrote:
> On 12/14/2012 01:27 PM, Andy Lutomirski wrote:
> > 
> > I don't know all that much about the linux vm.  Can we create a
> > special vdso address_space or struct inode or something so that a
> > single vma can contain pages with different flags?
> > 
> 
> No, that is still different vmas, but it probably isn't a big deal.
> 
> The advantage of having an inode/namespace is that it lets you use
> mmap() as opposed to mremap() with it, which might be useful, I don't know.
> 
> One option for the checkpoint people might actually be to not use the
> vdso for a process that needs to be checkpointed and restarted on a
> different machine or different kernel version.  Instead they can install
> a pseudo-vdso which just calls normal system calls, and is simply a
> static piece of code that makes normal system calls ... since the
> internals of the kernel are hidden from userspace it is "clean" that way.
> 
> With any actual vdso you risk something like:
> 

Is there a chance to make it something like that (assuming the
dumpee is ptraced)

> 	-> vdso entry

mark task as vdso-entered

> 	-> signal received, transfer to signal handler
> 	-> signal handler exit

before task leave vdso the task mark vdso-entered get cleaned
and if ptraced, the ptracing task is notified

> ... and now you return to the address in the old vdso, but the internals
> of the vdso may have changed.

this would allow us to defer checkpoint until task finish vdso code. Peter,
if I understand you correctly you propose we provide some own proxy-vdso
which would redirect calls to real ones, right? But the main problem
is that is exactly the idea to be able to c/r existing programs without
recompiling and such (or I miss something here?).

	Cyrill
