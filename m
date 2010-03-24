Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0CXPx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:53:29 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:56452 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab0CXPx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:53:27 -0400
Message-ID: <4BAA3586.1020604@cs.columbia.edu>
Date: Wed, 24 Mar 2010 11:53:42 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       containers <containers@lists.linux-foundation.org>,
       Christoffer Dall <christofferdall@christofferdall.dk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [C/R ARM][PATCH 1/3] ARM: Rudimentary syscall interfaces
References: <1269219965-23923-1-git-send-email-christofferdall@christofferdall.dk> <1269219965-23923-2-git-send-email-christofferdall@christofferdall.dk> <20100323205342.GA19572@n2100.arm.linux.org.uk> <20100324020342.GB5704@count0.beaverton.ibm.com> <Pine.LNX.4.64.1003240055050.5867@takamine.ncl.cs.columbia.edu> <20100324140252.GC5704@count0.beaverton.ibm.com>
In-Reply-To: <20100324140252.GC5704@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Matt Helsley wrote:
> On Wed, Mar 24, 2010 at 12:57:46AM -0400, Oren Laadan wrote:
>> On Tue, 23 Mar 2010, Matt Helsley wrote:
>>
>>> On Tue, Mar 23, 2010 at 08:53:42PM +0000, Russell King - ARM Linux wrote:
>>>> On Sun, Mar 21, 2010 at 09:06:03PM -0400, Christoffer Dall wrote:
>>>>> This small commit introduces a global state of system calls for ARM
>>>>> making it possible for a debugger or checkpointing to gain information
>>>>> about another process' state with respect to system calls.
>>>> I don't particularly like the idea that we always store the syscall
>>>> number to memory for every system call, whether the stored version is
>>>> used or not.
>>>>
>>>> Since ARM caches are generally not write allocate, this means mostly
>>>> write-only variables can have a higher than expected expense.
>>>>
>>>> Is there not some thread flag which can be checked to see if we need to
>>>> store the syscall number?
>>> Perhaps before we freeze the task we can save the syscall number on ARM.
>>> The patches suggest that the signal delivery path -- which the freezer
>>> utilizes -- has the syscall number already.

Actually, the signal path doesn't have the syscall number, it has
a binary "in syscall" value.

>>>
>>> Should work since the threads must be frozen first anyway.
>> I like the idea.
>>
>> However, would it also work for those cases when the freezing does not 
>> occur from the signal delivery path - e.g. for vfork and ptraced tasks ?
> 
> We could just as easily set it before the vfork uninterruptible completion.
> ptracing I'd don't know about though.
> 

vfork() uses freezer_do_not_count() to tell the freezer that it's
effectively frozen. It's also used by drivers/char/apm-emulation.c

Looking at calls to ptrace_notify(), ptrace_stop() and ptace_event(),
there are several places where a ptraced task can stop with TASK_TRACED
(which is good enough for the freezer), outside the signal handling
path.

This means that recording the syscall number for all these cases is
going to be tedious and intrusive.

I prefer to somehow figure out the syscall from the task's state or
pt_regs, or by (re)using the same assembly code that already does that.

Oren.

