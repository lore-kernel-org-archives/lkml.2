Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924Ab2EWTE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:04:27 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55141 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933848Ab2EWTEZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:04:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120523185610.GB6908@n2100.arm.linux.org.uk>
References: <CABqD9hao8sYHimbs1SjT3uRiht2ACnS8TMPyUnPt7AMrM3kVGA@mail.gmail.com>
	<20120523185610.GB6908@n2100.arm.linux.org.uk>
Date: Wed, 23 May 2012 14:04:20 -0500
Message-ID: <CABqD9hah+26ZNJ8OsvSUFSx-dnxekTSLCkUf-8QXQqZ+mn6kmg@mail.gmail.com>
Subject: Re: New ARM asm/syscall.h incompatible? (commit bf2c9f9866928df60157bc4f1ab39f93a32c754e)
From: Will Drewry <wad@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: wade_farnsworth@mentor.com, stevenrwalter@gmail.com, will.deacon@arm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 1:56 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, May 23, 2012 at 11:01:50AM -0500, Will Drewry wrote:
>> Hi Wade and Steven,
>>
>> I don't believe the syscall_get_arguments/syscall_set_arguments
>> implementation that landed in 3.4 is correct or safe.  I didn't see it
>> get pulled in - sorry for not mailing sooner! :(
>>
>> The current implementation allows for _7_ arguments and allows the 0th
>> index to be the ARM_ORIG_r0 instead of starting with ARM_r0 == 0.  In
>> the global description of syscall_*_arguments it says:
>>
>>  * It's only valid to call this when @task is stopped for tracing on
>>  * entry to a system call, due to %TIF_SYSCALL_TRACE or %TIF_SYSCALL_AUDIT.
>>  * It's invalid to call this with @i + @n > 6; we only support system calls
>>  * taking up to 6 arguments.
>>
>> This means that the current implementation is broken when matching
>> system call arguments for ftrace (unless there is an arch specific
>> hack in there) and it breaks internal kernel API for any other
>> consumers without arch knowledge (like seccomp mode=2).  Is there a
>> reason to expose ARM_ORIG_r0 this way?  Am I misreading?
>>
>> My understanding of the arch register usage at syscall time is something like:
>> - ORIG_r0 gets the syscall number
>> - r0 becomes the first system call argument
>> - system call proceeds
>> - on return, r0 is the return value
>
> Wrong.  You're far too used to the x86 way of doing things.
>
> For ARM, on entry to a system call, r0 _and_ orig_r0 are the first
> syscall argument.  For other exceptions, orig_r0 will be -1 (but you
> can't rely upon that meaning anything, because a syscall can take -1
> as the first argument.)
>
> On exit from a system call, r0 will be the return value, and orig_r0
> will _still_ be the first system call argument.

Thanks - as usual, I can't keep them straight without the asm in front of me.

I'm still curious if it wouldn't make more sense to handle the
sys_syscall special case prior to any cross-arch (slowpath) code
involvement rather than truncating the 7th parameter making
sys_syscall a second class citizen for those cross-arch paths.
Perhaps that's not acceptable for ptrace/tracehook, but it seems like
it would make sense for ftrace and seccomp.

cheers!
will
