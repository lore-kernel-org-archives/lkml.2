Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab2EWS4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:56:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37724 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933818Ab2EWS4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:56:21 -0400
Date: Wed, 23 May 2012 19:56:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Drewry <wad@chromium.org>
Cc: wade_farnsworth@mentor.com, stevenrwalter@gmail.com, will.deacon@arm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: New ARM asm/syscall.h incompatible? (commit
	bf2c9f9866928df60157bc4f1ab39f93a32c754e)
Message-ID: <20120523185610.GB6908@n2100.arm.linux.org.uk>
References: <CABqD9hao8sYHimbs1SjT3uRiht2ACnS8TMPyUnPt7AMrM3kVGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABqD9hao8sYHimbs1SjT3uRiht2ACnS8TMPyUnPt7AMrM3kVGA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 11:01:50AM -0500, Will Drewry wrote:
> Hi Wade and Steven,
> 
> I don't believe the syscall_get_arguments/syscall_set_arguments
> implementation that landed in 3.4 is correct or safe.  I didn't see it
> get pulled in - sorry for not mailing sooner! :(
> 
> The current implementation allows for _7_ arguments and allows the 0th
> index to be the ARM_ORIG_r0 instead of starting with ARM_r0 == 0.  In
> the global description of syscall_*_arguments it says:
> 
>  * It's only valid to call this when @task is stopped for tracing on
>  * entry to a system call, due to %TIF_SYSCALL_TRACE or %TIF_SYSCALL_AUDIT.
>  * It's invalid to call this with @i + @n > 6; we only support system calls
>  * taking up to 6 arguments.
> 
> This means that the current implementation is broken when matching
> system call arguments for ftrace (unless there is an arch specific
> hack in there) and it breaks internal kernel API for any other
> consumers without arch knowledge (like seccomp mode=2).  Is there a
> reason to expose ARM_ORIG_r0 this way?  Am I misreading?
> 
> My understanding of the arch register usage at syscall time is something like:
> - ORIG_r0 gets the syscall number
> - r0 becomes the first system call argument
> - system call proceeds
> - on return, r0 is the return value

Wrong.  You're far too used to the x86 way of doing things.

For ARM, on entry to a system call, r0 _and_ orig_r0 are the first
syscall argument.  For other exceptions, orig_r0 will be -1 (but you
can't rely upon that meaning anything, because a syscall can take -1
as the first argument.)

On exit from a system call, r0 will be the return value, and orig_r0
will _still_ be the first system call argument.
