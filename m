Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab2IXMQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:16:17 -0400
Received: from science.horizon.com ([71.41.210.146]:59044 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754551Ab2IXMQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:16:15 -0400
Date: 24 Sep 2012 08:16:14 -0400
Message-ID: <20120924121614.5422.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, mpn@google.com, vda.linux@googlemail.com
Subject: Re: [PATCH 2/4] lib: vsprintf: Optimize division by 10000
Cc: hughd@google.com, linux-kernel@vger.kernel.org
In-Reply-To: <xa1twqzk640j.fsf@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You are using a 64-bit multiply in a path that is designed for 32-bit
> processors, which makes me feel that it will be slower.

Slower than the divide it's replacing?

The following 32-bit processors have 32x32->64-bit multiply:

x86
ARM (as of ARMv4 = ARM7TDMI, the lowest version in common use)
SPARCv7, SPARCv8
MIPS32
MC68020
PA-RISC 1.1 (XMPYU)
avr32
PowerPC (MULHWU)
VAX (EMUL)

I could keep going through the full list of architectures in arch/,
but it's starting to get slow and I haven't hit one *without* a widening
multiply yet.  (And if it doesn't have hardware divide, I expect the
multiply is still faster.)

Ah!  Found one!  ColdFire MCF5272 has 32/32-bit divide, but only 32x32->32
multiply.  However, DIVU takes 20 or 35 cycles, which is pretty close to the
time to synthesize the multiply out of 4 16x16->32 pieces (4 cycles each).

I could do some Kconfig hacking and make the code path architecture-dependent.
Do you think it's worth it?
