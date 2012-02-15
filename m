Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab2BORHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:07:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab2BORHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:07:36 -0500
Message-ID: <1329325622.2337.13.camel@localhost>
Subject: Re: [PATCH] ARM: ptrace: Include linux/audit.h to fix build errors
From: Eric Paris <eparis@redhat.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Nathaniel Husted <nhusted@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 15 Feb 2012 12:07:02 -0500
In-Reply-To: <20120215083609.GD13673@n2100.arm.linux.org.uk>
References: <1329284188.12708.1.camel@phoenix>
	 <20120215083609.GD13673@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 08:36 +0000, Russell King - ARM Linux wrote:
> On Wed, Feb 15, 2012 at 01:36:28PM +0800, Axel Lin wrote:
> > Include linux/audit.h to fix below build errors:
> > 
> >   CC      arch/arm/kernel/ptrace.o
> > arch/arm/kernel/ptrace.c: In function 'syscall_trace':
> > arch/arm/kernel/ptrace.c:919: error: implicit declaration of function 'audit_syscall_exit'
> > arch/arm/kernel/ptrace.c:921: error: implicit declaration of function 'audit_syscall_entry'
> > arch/arm/kernel/ptrace.c:921: error: 'AUDIT_ARCH_ARMEB' undeclared (first use in this function)
> 
> Err, can someone explain why we seem to tell the audit code that we're
> always big endian?

So we have 2 bugs obviously.  One is my fault.  One is Nathaniel's.
Both are easy to fix.

I'm pretty sure I introduced the build failure when I merged Nathaniel's
patch into my tree.  I completely rewrote audit_syscall_entry() and exit
and probably the include wasn't needed in his version.  So my fault.

The endian issue is something an ARM-er would have noticed I assume, and
again, it's my fault for not forwarding to the ARM list.  Let me explain
what happens.  The kernel audit system is going to dump the raw bits to
userspace.  Userspace is going to write them to a file exactly how it
got them.  One of the things we write is the arch (which includes
endianness)  This means we can send those bits to another machine and it
should be able to correctly interpret their meaning.  However if you are
just looking at the raw bits on your own box, endianness isn't an issue
and records will look ok.

Fixing the arch flag to be correct means we could do that translation
properly.  I haven't seen the patches to support translation of arm raw
bits to something higher level in audit userspace, but I assume it's
coming as soon as someone cares.

So if someone tells me how the code knows it's endianness I'll gladly
write the ifdef to switch from AUDIT_ARCH_ARMEB to AUDIT_ARCH_ARM when
appropriate....

