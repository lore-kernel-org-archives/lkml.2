Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab2JUS7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 14:59:21 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:39733 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474Ab2JUS7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 14:59:18 -0400
Date: Sun, 21 Oct 2012 20:59:08 +0200
From: Rabin Vincent <rabin@rab.in>
To: Dave Martin <dave.martin@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, oleg@redhat.com,
        Tixy <tixy@linaro.org>
Subject: Re: [PATCH 9/9] ARM: add uprobes support
Message-ID: <20121021185908.GD4840@ubuntu>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
 <1350242593-17761-9-git-send-email-rabin@rab.in>
 <20121015111443.GA2006@linaro.org>
 <CAH+eYFC1fr0vpK2T4hz9LK=Nz5bzQBQ4O-o0f9tsnj-_D9ZEJg@mail.gmail.com>
 <20121015174450.GB18614@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121015174450.GB18614@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 06:44:50PM +0100, Dave Martin wrote:
> On Mon, Oct 15, 2012 at 01:44:55PM +0200, Rabin Vincent wrote:
> > Why?  It currently works for ARM userspace even if the kernel is
> > Thumb-2.
> 
> My bad, I misread what was happening in the Makefile changes.
> 
> My concern is about whether we can build the ARM and Thumb-2 kprobes
> code into the same kernel.  If so, no problem, but I believe this is
> not a tested configuration for kprobes itself.
> 
> If you've not already done so, it should be possible to test this
> by adding CONFIG_THUMB2_KERNEL=y to your config, providing your
> hardware is Thumb-2 capable.

I've tested this before.  With a Thumb-2 kernel, both the kprobes test
(Thumb) and the uprobes test (ARM) run fine.

> General question which I'm not sure I understand yet: is is possible
> to combine uprobes/kprobes decode more completely?  It's not obvious
> to me whether the uprobes-specific decoding only relates to features
> which architecturally execute differently in user mode versus
> privileged mode.  Some explanation somewhere could be helpful.

What we change is not the decoding itself but the handling of the
instructions:

  (1) Load and stores are executed from the xol area by user space so
  the instructions need to be rewritten when they touch the PC.  Kprobes
  code rewrites the instructions directly and executes them or in some
  cases simulates them.

  (2) All other non-simulated instructions are also executed from the
  XOL area in userspace.  Because of this, the ALU instructions which
  use the PC also need to be rewritten to not use the PC.  Perhaps we
  can actually get rid of this and just execute these instruction from
  kernel space like it is done for uprobes.

  So the uprobes code is uses the decoding tables just to know if the
  instruction is using the PC or not, but if we make the ALU
  instructions execute from kernel space we could actually use the
  emulate_*() functions like kprobes does.
