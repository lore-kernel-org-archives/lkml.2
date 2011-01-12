Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1ALQY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:24:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60794 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab1ALQYz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:24:55 -0500
MIME-Version: 1.0
In-Reply-To: <20110112155215.GB11039@n2100.arm.linux.org.uk>
References: <20110111015409.18291.87166.stgit@localhost6.localdomain6>
 <20110111104051.GA11039@n2100.arm.linux.org.uk> <20110111153630.GB2707@angua.secretlab.ca>
 <20110111154833.GF11039@n2100.arm.linux.org.uk> <AANLkTi=29LB66j123ufMHQk=46hGYdmR4nZZQFnN=Tku@mail.gmail.com>
 <20110112155215.GB11039@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 12 Jan 2011 09:24:34 -0700
X-Google-Sender-Auth: NAAHCjWgjGjf44gsqg2aXEqKqKg
Message-ID: <AANLkTinwGd9pa7YQ=5hXfarw=MB=YdpBuN7xJAd+Ps4f@mail.gmail.com>
Subject: Re: [RFC] arm: Defer lookup of machine_type and vet of atags to setup.c
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Nicolas Pitre <nicolas.pitre@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 8:52 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Jan 12, 2011 at 08:46:44AM -0700, Grant Likely wrote:
>> Looks like I've hit a hiccup though.  When I remove the first call to
>> __lookup_machine_type, then it is only called after the MMU is turned
>> on and the kernel is no longer able to output the list of configured
>> machine ids when it doesn't recognize the value in r1 (tested with
>> qemu versatile emulation).  I'm still investigating, so I'll defer
>> reposting the patch until I've got this issue solved.
>
> It only does this when DEBUG_LL is enabled - at which point you have
> printascii, printhex8, etc available (although there's no prototype
> for them.)
>
> You could use snprintf() to format a message and then use printascii()
> (conditional on CONFIG_DEBUG_LL as the existing code does) as well as
> printk("%s", buffer).  That means if you have a debugger you can dump
> the kernel ring buffer and see the message, or see it via the serial
> port/debugging channel if DEBUG_LL is enabled.

Actually it looks like the real problem is that the mmu has been
turned on, but the virtual mappings for devices have not yet been
established, and so the debug macros aren't using a valid address.
I'm using printk to get output into the ring buffer in my patch to
rework lookup_machine_type() in C, and that does indeed output to the
ring buffer, but the kernel cannot spit stuff out the serial port.

It looks like I'd need to get past paging_init() in order to get
ll_debug working between turning on the mmu and paging_init(), but
paging_init() needs the mdesc pointer, and the whole point of the
error message is that the mdesc pointer is unknown!  I don't see any
code that sets up a debug mapping of the uart before paging_init time.
 I could try to implement something like that, but it is looking to be
more complicated than it is worth when the current code works just
fine.

Let me know if I've missed something, but I think I should drop the
removal of __lookup_machine_type from head.S from my patch.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
