Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474Ab2JKBf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:35:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42161 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933788Ab2JKBSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:18:50 -0400
Date: Thu, 11 Oct 2012 12:18:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stuart Yoder <stuart.yoder@freescale.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the kvm-ppc tree with the powerpc-merge
 tree
Message-Id: <20121011121841.1b946f996cba995d9a5a2be7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__11_Oct_2012_12_18_41_+1100_1kBjXJNoomByO9L/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Oct_2012_12_18_41_+1100_1kBjXJNoomByO9L/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

Today's linux-next merge of the kvm-ppc tree got a conflict in
arch/powerpc/include/asm/kvm_para.h between commit c3617f72036c ("UAPI:
(Scripted) Disintegrate arch/powerpc/include/asm") from the powerpc-merge
tree and commit 549d62d889b4 ("KVM: PPC: use definitions in epapr header
for hcalls") from the kvm-ppc tree.

I fixed it up (see at the end) and can carry the fix as necessary (no action
is required, though you need to remember to tell Linus about this).

I also added this merge fix patch:

=46rom 61d39136e4228e62e27c11ac8d27cd6664b39639 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 11 Oct 2012 12:13:51 +1100
Subject: [PATCH] KVM: PPC: fix fallout from UAPI changes

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/include/asm/epapr_hcalls.h      |  511 ----------------------=
----
 arch/powerpc/include/uapi/asm/Kbuild         |    1 +
 arch/powerpc/include/uapi/asm/epapr_hcalls.h |  511 ++++++++++++++++++++++=
++++
 arch/powerpc/include/uapi/asm/kvm_para.h     |    7 +-
 4 files changed, 516 insertions(+), 514 deletions(-)
 delete mode 100644 arch/powerpc/include/asm/epapr_hcalls.h
 create mode 100644 arch/powerpc/include/uapi/asm/epapr_hcalls.h

diff --git a/arch/powerpc/include/asm/epapr_hcalls.h b/arch/powerpc/include=
/asm/epapr_hcalls.h
deleted file mode 100644
index b8d9445..0000000
--- a/arch/powerpc/include/asm/epapr_hcalls.h
+++ /dev/null
@@ -1,511 +0,0 @@
-/*
- * ePAPR hcall interface
- *
- * Copyright 2008-2011 Freescale Semiconductor, Inc.
- *
- * Author: Timur Tabi <timur@freescale.com>
- *
- * This file is provided under a dual BSD/GPL license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are =
met:
- *     * Redistributions of source code must retain the above copyright
- *       notice, this list of conditions and the following disclaimer.
- *     * Redistributions in binary form must reproduce the above copyright
- *       notice, this list of conditions and the following disclaimer in t=
he
- *       documentation and/or other materials provided with the distributi=
on.
- *     * Neither the name of Freescale Semiconductor nor the
- *       names of its contributors may be used to endorse or promote produ=
cts
- *       derived from this software without specific prior written permiss=
ion.
- *
- *
- * ALTERNATIVELY, this software may be distributed under the terms of the
- * GNU General Public License ("GPL") as published by the Free Software
- * Foundation, either version 2 of that License or (at your option) any
- * later version.
- *
- * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
- * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLI=
ED
- * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
- * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMA=
GES
- * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERV=
ICES;
- * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED=
 AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR T=
ORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE O=
F THIS
- * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- */
-
-/* A "hypercall" is an "sc 1" instruction.  This header file file provides=
 C
- * wrapper functions for the ePAPR hypervisor interface.  It is inteded
- * for use by Linux device drivers and other operating systems.
- *
- * The hypercalls are implemented as inline assembly, rather than assembly
- * language functions in a .S file, for optimization.  It allows
- * the caller to issue the hypercall instruction directly, improving both
- * performance and memory footprint.
- */
-
-#ifndef _EPAPR_HCALLS_H
-#define _EPAPR_HCALLS_H
-
-#define EV_BYTE_CHANNEL_SEND		1
-#define EV_BYTE_CHANNEL_RECEIVE		2
-#define EV_BYTE_CHANNEL_POLL		3
-#define EV_INT_SET_CONFIG		4
-#define EV_INT_GET_CONFIG		5
-#define EV_INT_SET_MASK			6
-#define EV_INT_GET_MASK			7
-#define EV_INT_IACK			9
-#define EV_INT_EOI			10
-#define EV_INT_SEND_IPI			11
-#define EV_INT_SET_TASK_PRIORITY	12
-#define EV_INT_GET_TASK_PRIORITY	13
-#define EV_DOORBELL_SEND		14
-#define EV_MSGSND			15
-#define EV_IDLE				16
-
-/* vendor ID: epapr */
-#define EV_LOCAL_VENDOR_ID		0	/* for private use */
-#define EV_EPAPR_VENDOR_ID		1
-#define EV_FSL_VENDOR_ID		2	/* Freescale Semiconductor */
-#define EV_IBM_VENDOR_ID		3	/* IBM */
-#define EV_GHS_VENDOR_ID		4	/* Green Hills Software */
-#define EV_ENEA_VENDOR_ID		5	/* Enea */
-#define EV_WR_VENDOR_ID			6	/* Wind River Systems */
-#define EV_AMCC_VENDOR_ID		7	/* Applied Micro Circuits */
-#define EV_KVM_VENDOR_ID		42	/* KVM */
-
-/* The max number of bytes that a byte channel can send or receive per cal=
l */
-#define EV_BYTE_CHANNEL_MAX_BYTES	16
-
-
-#define _EV_HCALL_TOKEN(id, num) (((id) << 16) | (num))
-#define EV_HCALL_TOKEN(hcall_num) _EV_HCALL_TOKEN(EV_EPAPR_VENDOR_ID, hcal=
l_num)
-
-/* epapr return codes */
-#define EV_SUCCESS		0
-#define EV_EPERM		1	/* Operation not permitted */
-#define EV_ENOENT		2	/*  Entry Not Found */
-#define EV_EIO			3	/* I/O error occured */
-#define EV_EAGAIN		4	/* The operation had insufficient
-					 * resources to complete and should be
-					 * retried
-					 */
-#define EV_ENOMEM		5	/* There was insufficient memory to
-					 * complete the operation */
-#define EV_EFAULT		6	/* Bad guest address */
-#define EV_ENODEV		7	/* No such device */
-#define EV_EINVAL		8	/* An argument supplied to the hcall
-					   was out of range or invalid */
-#define EV_INTERNAL		9	/* An internal error occured */
-#define EV_CONFIG		10	/* A configuration error was detected */
-#define EV_INVALID_STATE	11	/* The object is in an invalid state */
-#define EV_UNIMPLEMENTED	12	/* Unimplemented hypercall */
-#define EV_BUFFER_OVERFLOW	13	/* Caller-supplied buffer too small */
-
-#ifndef __ASSEMBLY__
-#include <linux/types.h>
-#include <linux/errno.h>
-#include <asm/byteorder.h>
-
-/*
- * Hypercall register clobber list
- *
- * These macros are used to define the list of clobbered registers during a
- * hypercall.  Technically, registers r0 and r3-r12 are always clobbered,
- * but the gcc inline assembly syntax does not allow us to specify registe=
rs
- * on the clobber list that are also on the input/output list.  Therefore,
- * the lists of clobbered registers depends on the number of register
- * parmeters ("+r" and "=3Dr") passed to the hypercall.
- *
- * Each assembly block should use one of the HCALL_CLOBBERSx macros.  As a
- * general rule, 'x' is the number of parameters passed to the assembly
- * block *except* for r11.
- *
- * If you're not sure, just use the smallest value of 'x' that does not
- * generate a compilation error.  Because these are static inline function=
s,
- * the compiler will only check the clobber list for a function if you
- * compile code that calls that function.
- *
- * r3 and r11 are not included in any clobbers list because they are always
- * listed as output registers.
- *
- * XER, CTR, and LR are currently listed as clobbers because it's uncertain
- * whether they will be clobbered.
- *
- * Note that r11 can be used as an output parameter.
- *
- * The "memory" clobber is only necessary for hcalls where the Hypervisor
- * will read or write guest memory. However, we add it to all hcalls becau=
se
- * the impact is minimal, and we want to ensure that it's present for the
- * hcalls that need it.
-*/
-
-/* List of common clobbered registers.  Do not use this macro. */
-#define EV_HCALL_CLOBBERS "r0", "r12", "xer", "ctr", "lr", "cc", "memory"
-
-#define EV_HCALL_CLOBBERS8 EV_HCALL_CLOBBERS
-#define EV_HCALL_CLOBBERS7 EV_HCALL_CLOBBERS8, "r10"
-#define EV_HCALL_CLOBBERS6 EV_HCALL_CLOBBERS7, "r9"
-#define EV_HCALL_CLOBBERS5 EV_HCALL_CLOBBERS6, "r8"
-#define EV_HCALL_CLOBBERS4 EV_HCALL_CLOBBERS5, "r7"
-#define EV_HCALL_CLOBBERS3 EV_HCALL_CLOBBERS4, "r6"
-#define EV_HCALL_CLOBBERS2 EV_HCALL_CLOBBERS3, "r5"
-#define EV_HCALL_CLOBBERS1 EV_HCALL_CLOBBERS2, "r4"
-
-extern bool epapr_paravirt_enabled;
-extern u32 epapr_hypercall_start[];
-
-/*
- * We use "uintptr_t" to define a register because it's guaranteed to be a
- * 32-bit integer on a 32-bit platform, and a 64-bit integer on a 64-bit
- * platform.
- *
- * All registers are either input/output or output only.  Registers that a=
re
- * initialized before making the hypercall are input/output.  All
- * input/output registers are represented with "+r".  Output-only registers
- * are represented with "=3Dr".  Do not specify any unused registers.  The
- * clobber list will tell the compiler that the hypercall modifies those
- * registers, which is good enough.
- */
-
-/**
- * ev_int_set_config - configure the specified interrupt
- * @interrupt: the interrupt number
- * @config: configuration for this interrupt
- * @priority: interrupt priority
- * @destination: destination CPU number
- *
- * Returns 0 for success, or an error code.
- */
-static inline unsigned int ev_int_set_config(unsigned int interrupt,
-	uint32_t config, unsigned int priority, uint32_t destination)
-{
-	register uintptr_t r11 __asm__("r11");
-	register uintptr_t r3 __asm__("r3");
-	register uintptr_t r4 __asm__("r4");
-	register uintptr_t r5 __asm__("r5");
-	register uintptr_t r6 __asm__("r6");
-
-	r11 =3D EV_HCALL_TOKEN(EV_INT_SET_CONFIG);
-	r3  =3D interrupt;
-	r4  =3D config;
-	r5  =3D priority;
-	r6  =3D destination;
-
-	asm volatile("bl	epapr_hypercall_start"
-		: "+r" (r11), "+r" (r3), "+r" (r4), "+r" (r5), "+r" (r6)
-		: : EV_HCALL_CLOBBERS4
-	);
-
-	return r3;
-}
-
-/**
- * ev_int_get_config - return the config of the specified interrupt
- * @interrupt: the interrupt number
- * @config: returned configuration for this interrupt
- * @priority: returned interrupt priority
- * @destination: returned destination CPU number
- *
- * Returns 0 for success, or an error code.
- */
-static inline unsigned int ev_int_get_config(unsigned int interrupt,
-	uint32_t *config, unsigned int *priority, uint32_t *destination)
-{
-	register uintptr_t r11 __asm__("r11");
-	register uintptr_t r3 __asm__("r3");
-	register uintptr_t r4 __asm__("r4");
-	register uintptr_t r5 __asm__("r5");
-	register uintptr_t r6 __asm__("r6");
-
-	r11 =3D EV_HCALL_TOKEN(EV_INT_GET_CONFIG);
-	r3 =3D interrupt;
-
-	asm volatile("bl	epapr_hypercall_start"
-		: "+r" (r11), "+r" (r3), "=3Dr" (r4), "=3Dr" (r5), "=3Dr" (r6)
-		: : EV_HCALL_CLOBBERS4
-	);
-
-	*config =3D r4;
-	*priority =3D r5;
-	*destination =3D r6;
-
-	return r3;
-}
-
-/**
- * ev_int_set_mask - sets the mask for the specified interrupt source
- * @interrupt: the interrupt number
- * @mask: 0=3Denable interrupts, 1=3Ddisable interrupts
- *
- * Returns 0 for success, or an error code.
- */
-static inline unsigned int ev_int_set_mask(unsigned int interrupt,
-	unsigned int mask)
-{
-	register uintptr_t r11 __asm__("r11");
-	register uintptr_t r3 __asm__("r3");
-	register uintptr_t r4 __asm__("r4");
-
-	r11 =3D EV_HCALL_TOKEN(EV_INT_SET_MASK);
-	r3 =3D interrupt;
-	r4 =3D mask;
-
-	asm volatile("bl	epapr_hypercall_start"
-		: "+r" (r11), "+r" (r3), "+r" (r4)
-		: : EV_HCALL_CLOBBERS2
-	);
-
-	return r3;
-}
-
-/**
- * ev_int_get_mask - returns the mask for the specified interrupt source
- * @interrupt: the interrupt number
- * @mask: returned mask for this interrupt (0=3Denabled, 1=3Ddisabled)
- *
- * Returns 0 for success, or an error code.
- */
-static inline unsigned int ev_int_get_mask(unsigned int interrupt,
-	unsigned int *mask)
-{
-	register uintptr_t r11 __asm__("r11");
-	register uintptr_t r3 __asm__("r3");
-	register uintptr_t r4 __asm__("r4");
-
-	r11 =3D EV_HCALL_TOKEN(EV_INT_GET_MASK);
-	r3 =3D interrupt;
-
-	asm volatile("bl	epapr_hypercall_start"
-		: "+r" (r11), "+r" (r3), "=3Dr" (r4)
-		: : EV_HCALL_CLOBBERS2
-	);
-
-	*mask =3D r4;
-
-	return r3;
-}
-
-/**
- * ev_int_eoi - signal the end of interrupt processing
- * @interrupt: the interrupt number
- *
- * This function signals the end of processing for the the specified
- * interrupt, which must be the interrupt currently in service. By
- * definition, this is also the highest-priority interrupt.
- *
- * Returns 0 for success, or an error code.
- */
-static inline unsigned int ev_int_eoi(unsigned int interrupt)
-{
-	register uintptr_t r11 __asm__("r11");
-	register uintptr_t r3 __asm__("r3");
-
-	r11 =3D EV_HCALL_TOKEN(EV_INT_EOI);
-	r3 =3D interrupt;
-
-	asm volatile("bl	epapr_hypercall_start"
-		: "+r" (r11), "+r" (r3)
-		: : EV_HCALL_CLOBBERS1
-	);
-
-	return r3;
-}
-
-/**
- * ev_byte_channel_send - send characters to a byte stream
- * @handle: byte stream handle
- * @count: (input) num of chars to send, (output) num chars sent
- * @buffer: pointer to a 16-byte buffer
- *
- * @buffer must be at least 16 bytes long, because all 16 bytes will be
- * read from memory into registers, even if count < 16.
- *
- * Returns 0 for success, or an error code.
- */
-static inline unsigned int ev_byte_channel_send(unsigned int handle,
-	unsigned int *count, const char buffer[EV_BYTE_CHANNEL_MAX_BYTES])
-{
-	register uintptr_t r11 __asm__("r11");
-	register uintptr_t r3 __asm__("r3");
-	register uintptr_t r4 __asm__("r4");
-	register uintptr_t r5 __asm__("r5");
-	register uintptr_t r6 __asm__("r6");
-	register uintptr_t r7 __asm__("r7");
-	register uintptr_t r8 __asm__("r8");
-	const uint32_t *p =3D (const uint32_t *) buffer;
-
-	r11 =3D EV_HCALL_TOKEN(EV_BYTE_CHANNEL_SEND);
-	r3 =3D handle;
-	r4 =3D *count;
-	r5 =3D be32_to_cpu(p[0]);
-	r6 =3D be32_to_cpu(p[1]);
-	r7 =3D be32_to_cpu(p[2]);
-	r8 =3D be32_to_cpu(p[3]);
-
-	asm volatile("bl	epapr_hypercall_start"
-		: "+r" (r11), "+r" (r3),
-		  "+r" (r4), "+r" (r5), "+r" (r6), "+r" (r7), "+r" (r8)
-		: : EV_HCALL_CLOBBERS6
-	);
-
-	*count =3D r4;
-
-	return r3;
-}
-
-/**
- * ev_byte_channel_receive - fetch characters from a byte channel
- * @handle: byte channel handle
- * @count: (input) max num of chars to receive, (output) num chars received
- * @buffer: pointer to a 16-byte buffer
- *
- * The size of @buffer must be at least 16 bytes, even if you request fewer
- * than 16 characters, because we always write 16 bytes to @buffer.  This =
is
- * for performance reasons.
- *
- * Returns 0 for success, or an error code.
- */
-static inline unsigned int ev_byte_channel_receive(unsigned int handle,
-	unsigned int *count, char buffer[EV_BYTE_CHANNEL_MAX_BYTES])
-{
-	register uintptr_t r11 __asm__("r11");
-	register uintptr_t r3 __asm__("r3");
-	register uintptr_t r4 __asm__("r4");
-	register uintptr_t r5 __asm__("r5");
-	register uintptr_t r6 __asm__("r6");
-	register uintptr_t r7 __asm__("r7");
-	register uintptr_t r8 __asm__("r8");
-	uint32_t *p =3D (uint32_t *) buffer;
-
-	r11 =3D EV_HCALL_TOKEN(EV_BYTE_CHANNEL_RECEIVE);
-	r3 =3D handle;
-	r4 =3D *count;
-
-	asm volatile("bl	epapr_hypercall_start"
-		: "+r" (r11), "+r" (r3), "+r" (r4),
-		  "=3Dr" (r5), "=3Dr" (r6), "=3Dr" (r7), "=3Dr" (r8)
-		: : EV_HCALL_CLOBBERS6
-	);
-
-	*count =3D r4;
-	p[0] =3D cpu_to_be32(r5);
-	p[1] =3D cpu_to_be32(r6);
-	p[2] =3D cpu_to_be32(r7);
-	p[3] =3D cpu_to_be32(r8);
-
-	return r3;
-}
-
-/**
- * ev_byte_channel_poll - returns the status of the byte channel buffers
- * @handle: byte channel handle
- * @rx_count: returned count of bytes in receive queue
- * @tx_count: returned count of free space in transmit queue
- *
- * This function reports the amount of data in the receive queue (i.e. the
- * number of bytes you can read), and the amount of free space in the tran=
smit
- * queue (i.e. the number of bytes you can write).
- *
- * Returns 0 for success, or an error code.
- */
-static inline unsigned int ev_byte_channel_poll(unsigned int handle,
-	unsigned int *rx_count,	unsigned int *tx_count)
-{
-	register uintptr_t r11 __asm__("r11");
-	register uintptr_t r3 __asm__("r3");
-	register uintptr_t r4 __asm__("r4");
-	register uintptr_t r5 __asm__("r5");
-
-	r11 =3D EV_HCALL_TOKEN(EV_BYTE_CHANNEL_POLL);
-	r3 =3D handle;
-
-	asm volatile("bl	epapr_hypercall_start"
-		: "+r" (r11), "+r" (r3), "=3Dr" (r4), "=3Dr" (r5)
-		: : EV_HCALL_CLOBBERS3
-	);
-
-	*rx_count =3D r4;
-	*tx_count =3D r5;
-
-	return r3;
-}
-
-/**
- * ev_int_iack - acknowledge an interrupt
- * @handle: handle to the target interrupt controller
- * @vector: returned interrupt vector
- *
- * If handle is zero, the function returns the next interrupt source
- * number to be handled irrespective of the hierarchy or cascading
- * of interrupt controllers. If non-zero, specifies a handle to the
- * interrupt controller that is the target of the acknowledge.
- *
- * Returns 0 for success, or an error code.
- */
-static inline unsigned int ev_int_iack(unsigned int handle,
-	unsigned int *vector)
-{
-	register uintptr_t r11 __asm__("r11");
-	register uintptr_t r3 __asm__("r3");
-	register uintptr_t r4 __asm__("r4");
-
-	r11 =3D EV_HCALL_TOKEN(EV_INT_IACK);
-	r3 =3D handle;
-
-	asm volatile("bl	epapr_hypercall_start"
-		: "+r" (r11), "+r" (r3), "=3Dr" (r4)
-		: : EV_HCALL_CLOBBERS2
-	);
-
-	*vector =3D r4;
-
-	return r3;
-}
-
-/**
- * ev_doorbell_send - send a doorbell to another partition
- * @handle: doorbell send handle
- *
- * Returns 0 for success, or an error code.
- */
-static inline unsigned int ev_doorbell_send(unsigned int handle)
-{
-	register uintptr_t r11 __asm__("r11");
-	register uintptr_t r3 __asm__("r3");
-
-	r11 =3D EV_HCALL_TOKEN(EV_DOORBELL_SEND);
-	r3 =3D handle;
-
-	asm volatile("bl	epapr_hypercall_start"
-		: "+r" (r11), "+r" (r3)
-		: : EV_HCALL_CLOBBERS1
-	);
-
-	return r3;
-}
-
-/**
- * ev_idle -- wait for next interrupt on this core
- *
- * Returns 0 for success, or an error code.
- */
-static inline unsigned int ev_idle(void)
-{
-	register uintptr_t r11 __asm__("r11");
-	register uintptr_t r3 __asm__("r3");
-
-	r11 =3D EV_HCALL_TOKEN(EV_IDLE);
-
-	asm volatile("bl	epapr_hypercall_start"
-		: "+r" (r11), "=3Dr" (r3)
-		: : EV_HCALL_CLOBBERS1
-	);
-
-	return r3;
-}
-#endif /* !__ASSEMBLY__ */
-#endif
diff --git a/arch/powerpc/include/uapi/asm/Kbuild b/arch/powerpc/include/ua=
pi/asm/Kbuild
index a33c3c0..c62a732 100644
--- a/arch/powerpc/include/uapi/asm/Kbuild
+++ b/arch/powerpc/include/uapi/asm/Kbuild
@@ -8,6 +8,7 @@ header-y +=3D byteorder.h
 header-y +=3D cputable.h
 header-y +=3D elf.h
 header-y +=3D errno.h
+header-y +=3D epapr_hcalls.h
 header-y +=3D fcntl.h
 header-y +=3D ioctl.h
 header-y +=3D ioctls.h
diff --git a/arch/powerpc/include/uapi/asm/epapr_hcalls.h b/arch/powerpc/in=
clude/uapi/asm/epapr_hcalls.h
new file mode 100644
index 0000000..b8d9445
--- /dev/null
+++ b/arch/powerpc/include/uapi/asm/epapr_hcalls.h
@@ -0,0 +1,511 @@
+/*
+ * ePAPR hcall interface
+ *
+ * Copyright 2008-2011 Freescale Semiconductor, Inc.
+ *
+ * Author: Timur Tabi <timur@freescale.com>
+ *
+ * This file is provided under a dual BSD/GPL license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are =
met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in t=
he
+ *       documentation and/or other materials provided with the distributi=
on.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote produ=
cts
+ *       derived from this software without specific prior written permiss=
ion.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLI=
ED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMA=
GES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERV=
ICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED=
 AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR T=
ORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE O=
F THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/* A "hypercall" is an "sc 1" instruction.  This header file file provides=
 C
+ * wrapper functions for the ePAPR hypervisor interface.  It is inteded
+ * for use by Linux device drivers and other operating systems.
+ *
+ * The hypercalls are implemented as inline assembly, rather than assembly
+ * language functions in a .S file, for optimization.  It allows
+ * the caller to issue the hypercall instruction directly, improving both
+ * performance and memory footprint.
+ */
+
+#ifndef _EPAPR_HCALLS_H
+#define _EPAPR_HCALLS_H
+
+#define EV_BYTE_CHANNEL_SEND		1
+#define EV_BYTE_CHANNEL_RECEIVE		2
+#define EV_BYTE_CHANNEL_POLL		3
+#define EV_INT_SET_CONFIG		4
+#define EV_INT_GET_CONFIG		5
+#define EV_INT_SET_MASK			6
+#define EV_INT_GET_MASK			7
+#define EV_INT_IACK			9
+#define EV_INT_EOI			10
+#define EV_INT_SEND_IPI			11
+#define EV_INT_SET_TASK_PRIORITY	12
+#define EV_INT_GET_TASK_PRIORITY	13
+#define EV_DOORBELL_SEND		14
+#define EV_MSGSND			15
+#define EV_IDLE				16
+
+/* vendor ID: epapr */
+#define EV_LOCAL_VENDOR_ID		0	/* for private use */
+#define EV_EPAPR_VENDOR_ID		1
+#define EV_FSL_VENDOR_ID		2	/* Freescale Semiconductor */
+#define EV_IBM_VENDOR_ID		3	/* IBM */
+#define EV_GHS_VENDOR_ID		4	/* Green Hills Software */
+#define EV_ENEA_VENDOR_ID		5	/* Enea */
+#define EV_WR_VENDOR_ID			6	/* Wind River Systems */
+#define EV_AMCC_VENDOR_ID		7	/* Applied Micro Circuits */
+#define EV_KVM_VENDOR_ID		42	/* KVM */
+
+/* The max number of bytes that a byte channel can send or receive per cal=
l */
+#define EV_BYTE_CHANNEL_MAX_BYTES	16
+
+
+#define _EV_HCALL_TOKEN(id, num) (((id) << 16) | (num))
+#define EV_HCALL_TOKEN(hcall_num) _EV_HCALL_TOKEN(EV_EPAPR_VENDOR_ID, hcal=
l_num)
+
+/* epapr return codes */
+#define EV_SUCCESS		0
+#define EV_EPERM		1	/* Operation not permitted */
+#define EV_ENOENT		2	/*  Entry Not Found */
+#define EV_EIO			3	/* I/O error occured */
+#define EV_EAGAIN		4	/* The operation had insufficient
+					 * resources to complete and should be
+					 * retried
+					 */
+#define EV_ENOMEM		5	/* There was insufficient memory to
+					 * complete the operation */
+#define EV_EFAULT		6	/* Bad guest address */
+#define EV_ENODEV		7	/* No such device */
+#define EV_EINVAL		8	/* An argument supplied to the hcall
+					   was out of range or invalid */
+#define EV_INTERNAL		9	/* An internal error occured */
+#define EV_CONFIG		10	/* A configuration error was detected */
+#define EV_INVALID_STATE	11	/* The object is in an invalid state */
+#define EV_UNIMPLEMENTED	12	/* Unimplemented hypercall */
+#define EV_BUFFER_OVERFLOW	13	/* Caller-supplied buffer too small */
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <asm/byteorder.h>
+
+/*
+ * Hypercall register clobber list
+ *
+ * These macros are used to define the list of clobbered registers during a
+ * hypercall.  Technically, registers r0 and r3-r12 are always clobbered,
+ * but the gcc inline assembly syntax does not allow us to specify registe=
rs
+ * on the clobber list that are also on the input/output list.  Therefore,
+ * the lists of clobbered registers depends on the number of register
+ * parmeters ("+r" and "=3Dr") passed to the hypercall.
+ *
+ * Each assembly block should use one of the HCALL_CLOBBERSx macros.  As a
+ * general rule, 'x' is the number of parameters passed to the assembly
+ * block *except* for r11.
+ *
+ * If you're not sure, just use the smallest value of 'x' that does not
+ * generate a compilation error.  Because these are static inline function=
s,
+ * the compiler will only check the clobber list for a function if you
+ * compile code that calls that function.
+ *
+ * r3 and r11 are not included in any clobbers list because they are always
+ * listed as output registers.
+ *
+ * XER, CTR, and LR are currently listed as clobbers because it's uncertain
+ * whether they will be clobbered.
+ *
+ * Note that r11 can be used as an output parameter.
+ *
+ * The "memory" clobber is only necessary for hcalls where the Hypervisor
+ * will read or write guest memory. However, we add it to all hcalls becau=
se
+ * the impact is minimal, and we want to ensure that it's present for the
+ * hcalls that need it.
+*/
+
+/* List of common clobbered registers.  Do not use this macro. */
+#define EV_HCALL_CLOBBERS "r0", "r12", "xer", "ctr", "lr", "cc", "memory"
+
+#define EV_HCALL_CLOBBERS8 EV_HCALL_CLOBBERS
+#define EV_HCALL_CLOBBERS7 EV_HCALL_CLOBBERS8, "r10"
+#define EV_HCALL_CLOBBERS6 EV_HCALL_CLOBBERS7, "r9"
+#define EV_HCALL_CLOBBERS5 EV_HCALL_CLOBBERS6, "r8"
+#define EV_HCALL_CLOBBERS4 EV_HCALL_CLOBBERS5, "r7"
+#define EV_HCALL_CLOBBERS3 EV_HCALL_CLOBBERS4, "r6"
+#define EV_HCALL_CLOBBERS2 EV_HCALL_CLOBBERS3, "r5"
+#define EV_HCALL_CLOBBERS1 EV_HCALL_CLOBBERS2, "r4"
+
+extern bool epapr_paravirt_enabled;
+extern u32 epapr_hypercall_start[];
+
+/*
+ * We use "uintptr_t" to define a register because it's guaranteed to be a
+ * 32-bit integer on a 32-bit platform, and a 64-bit integer on a 64-bit
+ * platform.
+ *
+ * All registers are either input/output or output only.  Registers that a=
re
+ * initialized before making the hypercall are input/output.  All
+ * input/output registers are represented with "+r".  Output-only registers
+ * are represented with "=3Dr".  Do not specify any unused registers.  The
+ * clobber list will tell the compiler that the hypercall modifies those
+ * registers, which is good enough.
+ */
+
+/**
+ * ev_int_set_config - configure the specified interrupt
+ * @interrupt: the interrupt number
+ * @config: configuration for this interrupt
+ * @priority: interrupt priority
+ * @destination: destination CPU number
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int ev_int_set_config(unsigned int interrupt,
+	uint32_t config, unsigned int priority, uint32_t destination)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+	register uintptr_t r5 __asm__("r5");
+	register uintptr_t r6 __asm__("r6");
+
+	r11 =3D EV_HCALL_TOKEN(EV_INT_SET_CONFIG);
+	r3  =3D interrupt;
+	r4  =3D config;
+	r5  =3D priority;
+	r6  =3D destination;
+
+	asm volatile("bl	epapr_hypercall_start"
+		: "+r" (r11), "+r" (r3), "+r" (r4), "+r" (r5), "+r" (r6)
+		: : EV_HCALL_CLOBBERS4
+	);
+
+	return r3;
+}
+
+/**
+ * ev_int_get_config - return the config of the specified interrupt
+ * @interrupt: the interrupt number
+ * @config: returned configuration for this interrupt
+ * @priority: returned interrupt priority
+ * @destination: returned destination CPU number
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int ev_int_get_config(unsigned int interrupt,
+	uint32_t *config, unsigned int *priority, uint32_t *destination)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+	register uintptr_t r5 __asm__("r5");
+	register uintptr_t r6 __asm__("r6");
+
+	r11 =3D EV_HCALL_TOKEN(EV_INT_GET_CONFIG);
+	r3 =3D interrupt;
+
+	asm volatile("bl	epapr_hypercall_start"
+		: "+r" (r11), "+r" (r3), "=3Dr" (r4), "=3Dr" (r5), "=3Dr" (r6)
+		: : EV_HCALL_CLOBBERS4
+	);
+
+	*config =3D r4;
+	*priority =3D r5;
+	*destination =3D r6;
+
+	return r3;
+}
+
+/**
+ * ev_int_set_mask - sets the mask for the specified interrupt source
+ * @interrupt: the interrupt number
+ * @mask: 0=3Denable interrupts, 1=3Ddisable interrupts
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int ev_int_set_mask(unsigned int interrupt,
+	unsigned int mask)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+
+	r11 =3D EV_HCALL_TOKEN(EV_INT_SET_MASK);
+	r3 =3D interrupt;
+	r4 =3D mask;
+
+	asm volatile("bl	epapr_hypercall_start"
+		: "+r" (r11), "+r" (r3), "+r" (r4)
+		: : EV_HCALL_CLOBBERS2
+	);
+
+	return r3;
+}
+
+/**
+ * ev_int_get_mask - returns the mask for the specified interrupt source
+ * @interrupt: the interrupt number
+ * @mask: returned mask for this interrupt (0=3Denabled, 1=3Ddisabled)
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int ev_int_get_mask(unsigned int interrupt,
+	unsigned int *mask)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+
+	r11 =3D EV_HCALL_TOKEN(EV_INT_GET_MASK);
+	r3 =3D interrupt;
+
+	asm volatile("bl	epapr_hypercall_start"
+		: "+r" (r11), "+r" (r3), "=3Dr" (r4)
+		: : EV_HCALL_CLOBBERS2
+	);
+
+	*mask =3D r4;
+
+	return r3;
+}
+
+/**
+ * ev_int_eoi - signal the end of interrupt processing
+ * @interrupt: the interrupt number
+ *
+ * This function signals the end of processing for the the specified
+ * interrupt, which must be the interrupt currently in service. By
+ * definition, this is also the highest-priority interrupt.
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int ev_int_eoi(unsigned int interrupt)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+
+	r11 =3D EV_HCALL_TOKEN(EV_INT_EOI);
+	r3 =3D interrupt;
+
+	asm volatile("bl	epapr_hypercall_start"
+		: "+r" (r11), "+r" (r3)
+		: : EV_HCALL_CLOBBERS1
+	);
+
+	return r3;
+}
+
+/**
+ * ev_byte_channel_send - send characters to a byte stream
+ * @handle: byte stream handle
+ * @count: (input) num of chars to send, (output) num chars sent
+ * @buffer: pointer to a 16-byte buffer
+ *
+ * @buffer must be at least 16 bytes long, because all 16 bytes will be
+ * read from memory into registers, even if count < 16.
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int ev_byte_channel_send(unsigned int handle,
+	unsigned int *count, const char buffer[EV_BYTE_CHANNEL_MAX_BYTES])
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+	register uintptr_t r5 __asm__("r5");
+	register uintptr_t r6 __asm__("r6");
+	register uintptr_t r7 __asm__("r7");
+	register uintptr_t r8 __asm__("r8");
+	const uint32_t *p =3D (const uint32_t *) buffer;
+
+	r11 =3D EV_HCALL_TOKEN(EV_BYTE_CHANNEL_SEND);
+	r3 =3D handle;
+	r4 =3D *count;
+	r5 =3D be32_to_cpu(p[0]);
+	r6 =3D be32_to_cpu(p[1]);
+	r7 =3D be32_to_cpu(p[2]);
+	r8 =3D be32_to_cpu(p[3]);
+
+	asm volatile("bl	epapr_hypercall_start"
+		: "+r" (r11), "+r" (r3),
+		  "+r" (r4), "+r" (r5), "+r" (r6), "+r" (r7), "+r" (r8)
+		: : EV_HCALL_CLOBBERS6
+	);
+
+	*count =3D r4;
+
+	return r3;
+}
+
+/**
+ * ev_byte_channel_receive - fetch characters from a byte channel
+ * @handle: byte channel handle
+ * @count: (input) max num of chars to receive, (output) num chars received
+ * @buffer: pointer to a 16-byte buffer
+ *
+ * The size of @buffer must be at least 16 bytes, even if you request fewer
+ * than 16 characters, because we always write 16 bytes to @buffer.  This =
is
+ * for performance reasons.
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int ev_byte_channel_receive(unsigned int handle,
+	unsigned int *count, char buffer[EV_BYTE_CHANNEL_MAX_BYTES])
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+	register uintptr_t r5 __asm__("r5");
+	register uintptr_t r6 __asm__("r6");
+	register uintptr_t r7 __asm__("r7");
+	register uintptr_t r8 __asm__("r8");
+	uint32_t *p =3D (uint32_t *) buffer;
+
+	r11 =3D EV_HCALL_TOKEN(EV_BYTE_CHANNEL_RECEIVE);
+	r3 =3D handle;
+	r4 =3D *count;
+
+	asm volatile("bl	epapr_hypercall_start"
+		: "+r" (r11), "+r" (r3), "+r" (r4),
+		  "=3Dr" (r5), "=3Dr" (r6), "=3Dr" (r7), "=3Dr" (r8)
+		: : EV_HCALL_CLOBBERS6
+	);
+
+	*count =3D r4;
+	p[0] =3D cpu_to_be32(r5);
+	p[1] =3D cpu_to_be32(r6);
+	p[2] =3D cpu_to_be32(r7);
+	p[3] =3D cpu_to_be32(r8);
+
+	return r3;
+}
+
+/**
+ * ev_byte_channel_poll - returns the status of the byte channel buffers
+ * @handle: byte channel handle
+ * @rx_count: returned count of bytes in receive queue
+ * @tx_count: returned count of free space in transmit queue
+ *
+ * This function reports the amount of data in the receive queue (i.e. the
+ * number of bytes you can read), and the amount of free space in the tran=
smit
+ * queue (i.e. the number of bytes you can write).
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int ev_byte_channel_poll(unsigned int handle,
+	unsigned int *rx_count,	unsigned int *tx_count)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+	register uintptr_t r5 __asm__("r5");
+
+	r11 =3D EV_HCALL_TOKEN(EV_BYTE_CHANNEL_POLL);
+	r3 =3D handle;
+
+	asm volatile("bl	epapr_hypercall_start"
+		: "+r" (r11), "+r" (r3), "=3Dr" (r4), "=3Dr" (r5)
+		: : EV_HCALL_CLOBBERS3
+	);
+
+	*rx_count =3D r4;
+	*tx_count =3D r5;
+
+	return r3;
+}
+
+/**
+ * ev_int_iack - acknowledge an interrupt
+ * @handle: handle to the target interrupt controller
+ * @vector: returned interrupt vector
+ *
+ * If handle is zero, the function returns the next interrupt source
+ * number to be handled irrespective of the hierarchy or cascading
+ * of interrupt controllers. If non-zero, specifies a handle to the
+ * interrupt controller that is the target of the acknowledge.
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int ev_int_iack(unsigned int handle,
+	unsigned int *vector)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+
+	r11 =3D EV_HCALL_TOKEN(EV_INT_IACK);
+	r3 =3D handle;
+
+	asm volatile("bl	epapr_hypercall_start"
+		: "+r" (r11), "+r" (r3), "=3Dr" (r4)
+		: : EV_HCALL_CLOBBERS2
+	);
+
+	*vector =3D r4;
+
+	return r3;
+}
+
+/**
+ * ev_doorbell_send - send a doorbell to another partition
+ * @handle: doorbell send handle
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int ev_doorbell_send(unsigned int handle)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+
+	r11 =3D EV_HCALL_TOKEN(EV_DOORBELL_SEND);
+	r3 =3D handle;
+
+	asm volatile("bl	epapr_hypercall_start"
+		: "+r" (r11), "+r" (r3)
+		: : EV_HCALL_CLOBBERS1
+	);
+
+	return r3;
+}
+
+/**
+ * ev_idle -- wait for next interrupt on this core
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int ev_idle(void)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+
+	r11 =3D EV_HCALL_TOKEN(EV_IDLE);
+
+	asm volatile("bl	epapr_hypercall_start"
+		: "+r" (r11), "=3Dr" (r3)
+		: : EV_HCALL_CLOBBERS1
+	);
+
+	return r3;
+}
+#endif /* !__ASSEMBLY__ */
+#endif
diff --git a/arch/powerpc/include/uapi/asm/kvm_para.h b/arch/powerpc/includ=
e/uapi/asm/kvm_para.h
index 5e04383..34d8b1c 100644
--- a/arch/powerpc/include/uapi/asm/kvm_para.h
+++ b/arch/powerpc/include/uapi/asm/kvm_para.h
@@ -75,9 +75,10 @@ struct kvm_vcpu_arch_shared {
 };
=20
 #define KVM_SC_MAGIC_R0		0x4b564d21 /* "KVM!" */
-#define HC_VENDOR_KVM		(42 << 16)
-#define HC_EV_SUCCESS		0
-#define HC_EV_UNIMPLEMENTED	12
+
+#define KVM_HCALL_TOKEN(num)	_EV_HCALL_TOKEN(EV_KVM_VENDOR_ID, num)
+
+#include <asm/epapr_hcalls.h>
=20
 #define KVM_FEATURE_MAGIC_PAGE	1
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/include/asm/kvm_para.h
index 9365860,a168ce3..0000000
--- a/arch/powerpc/include/asm/kvm_para.h
+++ b/arch/powerpc/include/asm/kvm_para.h
@@@ -19,9 -19,76 +19,8 @@@
  #ifndef __POWERPC_KVM_PARA_H__
  #define __POWERPC_KVM_PARA_H__
 =20
 -#include <linux/types.h>
 -
 -/*
 - * Additions to this struct must only occur at the end, and should be
 - * accompanied by a KVM_MAGIC_FEAT flag to advertise that they are present
 - * (albeit not necessarily relevant to the current target hardware platfo=
rm).
 - *
 - * Struct fields are always 32 or 64 bit aligned, depending on them being=
 32
 - * or 64 bit wide respectively.
 - *
 - * See Documentation/virtual/kvm/ppc-pv.txt
 - */
 -struct kvm_vcpu_arch_shared {
 -	__u64 scratch1;
 -	__u64 scratch2;
 -	__u64 scratch3;
 -	__u64 critical;		/* Guest may not get interrupts if =3D=3D r1 */
 -	__u64 sprg0;
 -	__u64 sprg1;
 -	__u64 sprg2;
 -	__u64 sprg3;
 -	__u64 srr0;
 -	__u64 srr1;
 -	__u64 dar;		/* dear on BookE */
 -	__u64 msr;
 -	__u32 dsisr;
 -	__u32 int_pending;	/* Tells the guest if we have an interrupt */
 -	__u32 sr[16];
 -	__u32 mas0;
 -	__u32 mas1;
 -	__u64 mas7_3;
 -	__u64 mas2;
 -	__u32 mas4;
 -	__u32 mas6;
 -	__u32 esr;
 -	__u32 pir;
 -
 -	/*
 -	 * SPRG4-7 are user-readable, so we can only keep these consistent
 -	 * between the shared area and the real registers when there's an
 -	 * intervening exit to KVM.  This also applies to SPRG3 on some
 -	 * chips.
 -	 *
 -	 * This suffices for access by guest userspace, since in PR-mode
 -	 * KVM, an exit must occur when changing the guest's MSR[PR].
 -	 * If the guest kernel writes to SPRG3-7 via the shared area, it
 -	 * must also use the shared area for reading while in kernel space.
 -	 */
 -	__u64 sprg4;
 -	__u64 sprg5;
 -	__u64 sprg6;
 -	__u64 sprg7;
 -};
 -
 -#define KVM_SC_MAGIC_R0		0x4b564d21 /* "KVM!" */
 -
 -#define KVM_HCALL_TOKEN(num)     _EV_HCALL_TOKEN(EV_KVM_VENDOR_ID, num)
 -
 -#include <asm/epapr_hcalls.h>
 -
 -#define KVM_FEATURE_MAGIC_PAGE	1
 -
 -#define KVM_MAGIC_FEAT_SR		(1 << 0)
 -
 -/* MASn, ESR, PIR, and high SPRGs */
 -#define KVM_MAGIC_FEAT_MAS0_TO_SPRG7	(1 << 1)
 -
 -#ifdef __KERNEL__
 +#include <uapi/asm/kvm_para.h>
 =20
-=20
  #ifdef CONFIG_KVM_GUEST
 =20
  #include <linux/of.h>

--Signature=_Thu__11_Oct_2012_12_18_41_+1100_1kBjXJNoomByO9L/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQdh5xAAoJEECxmPOUX5FEyiMP/jKR5UVXCXvzfq0hd/3sLuvN
xVO3Xsg9qzMFn2sffW5qFYUbPm+S2JEW/gV59su4IfxjBneo0M7e3yDirkglj/8H
r3YesltCOGr1p/BK/QzNNykjk+iH0HeSo71WObdV9ii22rhXjsNl22KUKVzunlV5
JMBNZQ1L7op5LQwZZEqJsVgKbVm342RTKTJFRdjdXwTkPaQqDxScMNtgy+yWbAa/
2UTpahcR/WYcS/MNdHz3sx2yAfq1sX6MmWkXd16Bg+aLQ+jsnghAot8xsGAHE1UO
nt8UzydCUQLqTYWuk+d6e6aeaCv4mSBLyfpEi2L7qVHYtZ5XDGF2d53bVDbp1kmv
RLSLLGkec6IeTWockDQoI8Gp9MG2ybMMtwzJegfTZAzz98qHEOgJHQhSy5m6R3hI
m4FfrwzAshpJ3wJseg1MRLLE/XO8sqr/vq91Da3QtripDg0VvckzruEpmKo5bvf4
4iza1LBOwMFo4nalkJEhHAS4f2luSHqwRf/1XySUmFfYgiejRmXQ7s0w9fpyCnYj
VVOkM6iNfj9IY7QcXL2sJ77ptSmK1iafR7jplTPJtXgLwPeLtou8LhuyLKL7fyV+
DM44sGkpJBV4ZZa11JiNDV6U97ooOabuBbgnxjMUQHLZ5hlvWCsoLwQIUEwIWspv
20AulnPNRoXqLMt9gUzb
=TsQd
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Oct_2012_12_18_41_+1100_1kBjXJNoomByO9L/--
