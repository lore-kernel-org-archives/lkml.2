Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0JAHGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:06:23 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:57785 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab0JAHGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:06:22 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org
Cc: paulus@samba.org
Subject: Introduce support for little endian PowerPC
Date: Fri,  1 Oct 2010 17:05:53 +1000
Message-Id: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some PowerPC processors can be run in either big or little endian modes, some
others can map selected pages of memory as little endian, which allows the same
thing. Until now we have only supported the default big endian mode in Linux.
This patch set introduces little endian support for the 44x family of PowerPC
processors.

This patch set in combination with a patched GCC, binutils, uClibc and
buildroot has allowed for a full proof of concept little endian environment on
a 440 Taishan board, which was able to successfully run busybox, OpenSSH and a
handful of other userspace programs without problems.

I am not currently in a position to release my patches for the toolchain, but
in the meantime I thought I would send my patches on the kernel side for review
and feedback.

While my toolchain patches are necessary to support the powerpcle-linux target,
the kernel can still be built with an unpatched toolchain using the
powerpcle-elf target instead. Userspace programs, however, do require the
patched toolchain to build.

Since the processor still starts as big endian, the boot wrapper must still be
compiled with a big endian 32bit toolchain. This can be passed into the build
as CROSSBE_COMPILE in the same manner as the CROSS_COMPILE variable. When the
boot wrapper is finished it runs some platform specific assembly to switch to
little endian and execute the kernel.

This is not yet complete support for little endian PowerPC, some outstanding
issues that I am aware of are:
 * We only support 32bit PowerPC for now (and indeed, only 44x)
 * The vdso has not been fixed to be endian agnostic - any userspace program
   accessing it will get an unexpected result.
 * I have not touched PCI at all
 * Remaining device tree accesses still need to be examined to ensure they are
   correctly handling the endianess of the device tree.
 * Any other driver that uses the device tree is likely be broken for the same reason.
 * I've included a patch for the alignment handler, however it is as yet
   completely untested due to a property of the hardware I've been using for
   testing.

