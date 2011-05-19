Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326Ab1ESNy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:54:57 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:37682
	"EHLO CH1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933258Ab1ESNyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:54:53 -0400
X-SpamScore: 0
X-BigFish: VS0(zz709fKc8kzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Timur Tabi <timur@freescale.com>
To: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: [PATCH 2/7] powerpc: introduce ePAPR embedded hypervisor hcall interface
Date: Thu, 19 May 2011 08:54:27 -0500
Message-ID: <1305813272-31826-3-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305813272-31826-1-git-send-email-timur@freescale.com>
References: <1305813272-31826-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ePAPR hypervisors provide operating system services via a "hypercall"
interface.  The following steps need to be performed to make an hcall:

1. Load r11 with the hcall number
2. Load specific other registers with parameters
3. Issue instrucion "sc 1"
4. The return code is in r3
5. Other returned parameters are in other registers.

To provide this service to the kernel, these steps are wrapped in inline
assembly functions.  Standard ePAPR hcalls are in epapr_hcalls.h, and Freescale
extensions are in fsl_hcalls.h.

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 arch/powerpc/include/asm/epapr_hcalls.h |  502 +++++++++++++++++++++++
 arch/powerpc/include/asm/fsl_hcalls.h   |  655 +++++++++++++++++++++++++++++++
 2 files changed, 1157 insertions(+), 0 deletions(-)
 create mode 100644 arch/powerpc/include/asm/epapr_hcalls.h
 create mode 100644 arch/powerpc/include/asm/fsl_hcalls.h

diff --git a/arch/powerpc/include/asm/epapr_hcalls.h b/arch/powerpc/include/asm/epapr_hcalls.h
new file mode 100644
index 0000000..f3b0c2c
--- /dev/null
+++ b/arch/powerpc/include/asm/epapr_hcalls.h
@@ -0,0 +1,502 @@
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
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/* A "hypercall" is an "sc 1" instruction.  This header file file provides C
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
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <asm/byteorder.h>
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
+/* The max number of bytes that a byte channel can send or receive per call */
+#define EV_BYTE_CHANNEL_MAX_BYTES	16
+
+
+#define _EV_HCALL_TOKEN(id, num) (((id) << 16) | (num))
+#define EV_HCALL_TOKEN(hcall_num) _EV_HCALL_TOKEN(EV_EPAPR_VENDOR_ID, hcall_num)
+
+/* epapr error codes */
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
+/*
+ * Hypercall register clobber list
+ *
+ * These macros are used to define the list of clobbered registers during a
+ * hypercall.  Technically, registers r0 and r3-r12 are always clobbered,
+ * but the gcc inline assembly syntax does not allow us to specify registers
+ * on the clobber list that are also on the input/output list.  Therefore,
+ * the lists of clobbered registers depends on the number of register
+ * parmeters ("+r" and "=r") passed to the hypercall.
+ *
+ * Each assembly block should use one of the HCALL_CLOBBERSx macros.  As a
+ * general rule, 'x' is the number of parameters passed to the assembly
+ * block *except* for r11.
+ *
+ * If you're not sure, just use the smallest value of 'x' that does not
+ * generate a compilation error.  Because these are static inline functions,
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
+*/
+
+/* List of common clobbered registers.  Do not use this macro. */
+#define EV_HCALL_CLOBBERS "r0", "r12", "xer", "ctr", "lr", "cc"
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
+
+/*
+ * We use "uintptr_t" to define a register because it's guaranteed to be a
+ * 32-bit integer on a 32-bit platform, and a 64-bit integer on a 64-bit
+ * platform.
+ *
+ * All registers are either input/output or output only.  Registers that are
+ * initialized before making the hypercall are input/output.  All
+ * input/output registers are represented with "+r".  Output-only registers
+ * are represented with "=r".  Do not specify any unused registers.  The
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
+	r11 = EV_HCALL_TOKEN(EV_INT_SET_CONFIG);
+	r3  = interrupt;
+	r4  = config;
+	r5  = priority;
+	r6  = destination;
+
+	__asm__ __volatile__ ("sc 1"
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
+	r11 = EV_HCALL_TOKEN(EV_INT_GET_CONFIG);
+	r3 = interrupt;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3), "=r" (r4), "=r" (r5), "=r" (r6)
+		: : EV_HCALL_CLOBBERS4
+	);
+
+	*config = r4;
+	*priority = r5;
+	*destination = r6;
+
+	return r3;
+}
+
+/**
+ * ev_int_set_mask - sets the mask for the specified interrupt source
+ * @interrupt: the interrupt number
+ * @mask: 0=enable interrupts, 1=disable interrupts
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
+	r11 = EV_HCALL_TOKEN(EV_INT_SET_MASK);
+	r3 = interrupt;
+	r4 = mask;
+
+	__asm__ __volatile__ ("sc 1"
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
+ * @mask: returned mask for this interrupt (0=enabled, 1=disabled)
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
+	r11 = EV_HCALL_TOKEN(EV_INT_GET_MASK);
+	r3 = interrupt;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3), "=r" (r4)
+		: : EV_HCALL_CLOBBERS2
+	);
+
+	*mask = r4;
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
+	r11 = EV_HCALL_TOKEN(EV_INT_EOI);
+	r3 = interrupt;
+
+	__asm__ __volatile__ ("sc 1"
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
+	const uint32_t *p = (const uint32_t *) buffer;
+
+	r11 = EV_HCALL_TOKEN(EV_BYTE_CHANNEL_SEND);
+	r3 = handle;
+	r4 = *count;
+	r5 = be32_to_cpu(p[0]);
+	r6 = be32_to_cpu(p[1]);
+	r7 = be32_to_cpu(p[2]);
+	r8 = be32_to_cpu(p[3]);
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3),
+		  "+r" (r4), "+r" (r5), "+r" (r6), "+r" (r7), "+r" (r8)
+		: : EV_HCALL_CLOBBERS6
+	);
+
+	*count = r4;
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
+ * than 16 characters, because we always write 16 bytes to @buffer.  This is
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
+	uint32_t *p = (uint32_t *) buffer;
+
+	r11 = EV_HCALL_TOKEN(EV_BYTE_CHANNEL_RECEIVE);
+	r3 = handle;
+	r4 = *count;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3), "+r" (r4),
+		  "=r" (r5), "=r" (r6), "=r" (r7), "=r" (r8)
+		: : EV_HCALL_CLOBBERS6
+	);
+
+	*count = r4;
+	p[0] = cpu_to_be32(r5);
+	p[1] = cpu_to_be32(r6);
+	p[2] = cpu_to_be32(r7);
+	p[3] = cpu_to_be32(r8);
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
+ * number of bytes you can read), and the amount of free space in the transmit
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
+	r11 = EV_HCALL_TOKEN(EV_BYTE_CHANNEL_POLL);
+	r3 = handle;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3), "=r" (r4), "=r" (r5)
+		: : EV_HCALL_CLOBBERS3
+	);
+
+	*rx_count = r4;
+	*tx_count = r5;
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
+	r11 = EV_HCALL_TOKEN(EV_INT_IACK);
+	r3 = handle;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3), "=r" (r4)
+		: : EV_HCALL_CLOBBERS2
+	);
+
+	*vector = r4;
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
+	r11 = EV_HCALL_TOKEN(EV_DOORBELL_SEND);
+	r3 = handle;
+
+	__asm__ __volatile__ ("sc 1"
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
+	r11 = EV_HCALL_TOKEN(EV_IDLE);
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "=r" (r3)
+		: : EV_HCALL_CLOBBERS1
+	);
+
+	return r3;
+}
+
+#endif
diff --git a/arch/powerpc/include/asm/fsl_hcalls.h b/arch/powerpc/include/asm/fsl_hcalls.h
new file mode 100644
index 0000000..922d9b5
--- /dev/null
+++ b/arch/powerpc/include/asm/fsl_hcalls.h
@@ -0,0 +1,655 @@
+/*
+ * Freescale hypervisor call interface
+ *
+ * Copyright 2008-2010 Freescale Semiconductor, Inc.
+ *
+ * Author: Timur Tabi <timur@freescale.com>
+ *
+ * This file is provided under a dual BSD/GPL license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _FSL_HCALLS_H
+#define _FSL_HCALLS_H
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <asm/byteorder.h>
+#include <asm/epapr_hcalls.h>
+
+#define FH_API_VERSION			1
+
+#define FH_ERR_GET_INFO			1
+#define FH_PARTITION_GET_DTPROP		2
+#define FH_PARTITION_SET_DTPROP		3
+#define FH_PARTITION_RESTART		4
+#define FH_PARTITION_GET_STATUS		5
+#define FH_PARTITION_START		6
+#define FH_PARTITION_STOP		7
+#define FH_PARTITION_MEMCPY		8
+#define FH_DMA_ENABLE			9
+#define FH_DMA_DISABLE			10
+#define FH_SEND_NMI			11
+#define FH_VMPIC_GET_MSIR		12
+#define FH_SYSTEM_RESET			13
+#define FH_GET_CORE_STATE		14
+#define FH_ENTER_NAP			15
+#define FH_EXIT_NAP			16
+#define FH_CLAIM_DEVICE			17
+#define FH_PARTITION_STOP_DMA		18
+
+/* vendor ID: Freescale Semiconductor */
+#define FH_HCALL_TOKEN(num)		_EV_HCALL_TOKEN(EV_FSL_VENDOR_ID, num)
+
+/*
+ * We use "uintptr_t" to define a register because it's guaranteed to be a
+ * 32-bit integer on a 32-bit platform, and a 64-bit integer on a 64-bit
+ * platform.
+ *
+ * All registers are either input/output or output only.  Registers that are
+ * initialized before making the hypercall are input/output.  All
+ * input/output registers are represented with "+r".  Output-only registers
+ * are represented with "=r".  Do not specify any unused registers.  The
+ * clobber list will tell the compiler that the hypercall modifies those
+ * registers, which is good enough.
+ */
+
+/**
+ * fh_send_nmi - send NMI to virtual cpu(s).
+ * @vcpu_mask: send NMI to virtual cpu(s) specified by this mask.
+ *
+ * Returns 0 for success, or EINVAL for invalid vcpu_mask.
+ */
+static inline unsigned int fh_send_nmi(unsigned int vcpu_mask)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+
+	r11 = FH_HCALL_TOKEN(FH_SEND_NMI);
+	r3 = vcpu_mask;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3)
+		: : EV_HCALL_CLOBBERS1
+	);
+
+	return r3;
+}
+
+/* Arbitrary limits to avoid excessive memory allocation in hypervisor */
+#define FH_DTPROP_MAX_PATHLEN 4096
+#define FH_DTPROP_MAX_PROPLEN 32768
+
+/**
+ * fh_partiton_get_dtprop - get a property from a guest device tree.
+ * @handle: handle of partition whose device tree is to be accessed
+ * @dtpath_addr: physical address of device tree path to access
+ * @propname_addr: physical address of name of property
+ * @propvalue_addr: physical address of property value buffer
+ * @propvalue_len: length of buffer on entry, length of property on return
+ *
+ * Returns zero on success, non-zero on error.
+ */
+static inline unsigned int fh_partition_get_dtprop(int handle,
+						   uint64_t dtpath_addr,
+						   uint64_t propname_addr,
+						   uint64_t propvalue_addr,
+						   uint32_t *propvalue_len)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+	register uintptr_t r5 __asm__("r5");
+	register uintptr_t r6 __asm__("r6");
+	register uintptr_t r7 __asm__("r7");
+	register uintptr_t r8 __asm__("r8");
+	register uintptr_t r9 __asm__("r9");
+	register uintptr_t r10 __asm__("r10");
+
+	r11 = FH_HCALL_TOKEN(FH_PARTITION_GET_DTPROP);
+	r3 = handle;
+
+#ifdef CONFIG_PHYS_64BIT
+	r4 = dtpath_addr >> 32;
+	r6 = propname_addr >> 32;
+	r8 = propvalue_addr >> 32;
+#else
+	r4 = 0;
+	r6 = 0;
+	r8 = 0;
+#endif
+	r5 = (uint32_t)dtpath_addr;
+	r7 = (uint32_t)propname_addr;
+	r9 = (uint32_t)propvalue_addr;
+	r10 = *propvalue_len;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11),
+		  "+r" (r3), "+r" (r4), "+r" (r5), "+r" (r6), "+r" (r7),
+		  "+r" (r8), "+r" (r9), "+r" (r10)
+		: : EV_HCALL_CLOBBERS8
+	);
+
+	*propvalue_len = r4;
+	return r3;
+}
+
+/**
+ * Set a property in a guest device tree.
+ * @handle: handle of partition whose device tree is to be accessed
+ * @dtpath_addr: physical address of device tree path to access
+ * @propname_addr: physical address of name of property
+ * @propvalue_addr: physical address of property value
+ * @propvalue_len: length of property
+ *
+ * Returns zero on success, non-zero on error.
+ */
+static inline unsigned int fh_partition_set_dtprop(int handle,
+						   uint64_t dtpath_addr,
+						   uint64_t propname_addr,
+						   uint64_t propvalue_addr,
+						   uint32_t propvalue_len)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+	register uintptr_t r6 __asm__("r6");
+	register uintptr_t r8 __asm__("r8");
+	register uintptr_t r5 __asm__("r5");
+	register uintptr_t r7 __asm__("r7");
+	register uintptr_t r9 __asm__("r9");
+	register uintptr_t r10 __asm__("r10");
+
+	r11 = FH_HCALL_TOKEN(FH_PARTITION_SET_DTPROP);
+	r3 = handle;
+
+#ifdef CONFIG_PHYS_64BIT
+	r4 = dtpath_addr >> 32;
+	r6 = propname_addr >> 32;
+	r8 = propvalue_addr >> 32;
+#else
+	r4 = 0;
+	r6 = 0;
+	r8 = 0;
+#endif
+	r5 = (uint32_t)dtpath_addr;
+	r7 = (uint32_t)propname_addr;
+	r9 = (uint32_t)propvalue_addr;
+	r10 = propvalue_len;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11),
+		  "+r" (r3), "+r" (r4), "+r" (r5), "+r" (r6), "+r" (r7),
+		  "+r" (r8), "+r" (r9), "+r" (r10)
+		: : EV_HCALL_CLOBBERS8
+	);
+
+	return r3;
+}
+
+/**
+ * fh_partition_restart - reboot the current partition
+ * @partition: partition ID
+ *
+ * Returns an error code if reboot failed.  Does not return if it succeeds.
+ */
+static inline unsigned int fh_partition_restart(unsigned int partition)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+
+	r11 = FH_HCALL_TOKEN(FH_PARTITION_RESTART);
+	r3 = partition;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3)
+		: : EV_HCALL_CLOBBERS1
+	);
+
+	return r3;
+}
+
+#define FH_PARTITION_STOPPED	0
+#define FH_PARTITION_RUNNING	1
+#define FH_PARTITION_STARTING	2
+#define FH_PARTITION_STOPPING	3
+#define FH_PARTITION_PAUSING	4
+#define FH_PARTITION_PAUSED	5
+#define FH_PARTITION_RESUMING	6
+
+/**
+ * fh_partition_get_status - gets the status of a partition
+ * @partition: partition ID
+ * @status: returned status code
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int fh_partition_get_status(unsigned int partition,
+	unsigned int *status)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+
+	r11 = FH_HCALL_TOKEN(FH_PARTITION_GET_STATUS);
+	r3 = partition;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3), "=r" (r4)
+		: : EV_HCALL_CLOBBERS2
+	);
+
+	*status = r4;
+
+	return r3;
+}
+
+/**
+ * fh_partition_start - boots and starts execution of the specified partition
+ * @partition: partition ID
+ * @entry_point: guest physical address to start execution
+ *
+ * The hypervisor creates a 1-to-1 virtual/physical IMA mapping, so at boot
+ * time, guest physical address are the same as guest virtual addresses.
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int fh_partition_start(unsigned int partition,
+	uint32_t entry_point, int load)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+	register uintptr_t r5 __asm__("r5");
+
+	r11 = FH_HCALL_TOKEN(FH_PARTITION_START);
+	r3 = partition;
+	r4 = entry_point;
+	r5 = load;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3), "+r" (r4), "+r" (r5)
+		: : EV_HCALL_CLOBBERS3
+	);
+
+	return r3;
+}
+
+/**
+ * fh_partition_stop - stops another partition
+ * @partition: partition ID
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int fh_partition_stop(unsigned int partition)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+
+	r11 = FH_HCALL_TOKEN(FH_PARTITION_STOP);
+	r3 = partition;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3)
+		: : EV_HCALL_CLOBBERS1
+	);
+
+	return r3;
+}
+
+/**
+ * struct fh_sg_list: definition of the fh_partition_memcpy S/G list
+ * @source: guest physical address to copy from
+ * @target: guest physical address to copy to
+ * @size: number of bytes to copy
+ * @reserved: reserved, must be zero
+ *
+ * The scatter/gather list for fh_partition_memcpy() is an array of these
+ * structures.  The array must be guest physically contiguous.
+ *
+ * This structure must be aligned on 32-byte boundary, so that no single
+ * strucuture can span two pages.
+ */
+struct fh_sg_list {
+	uint64_t source;   /**< guest physical address to copy from */
+	uint64_t target;   /**< guest physical address to copy to */
+	uint64_t size;     /**< number of bytes to copy */
+	uint64_t reserved; /**< reserved, must be zero */
+} __attribute__ ((aligned(32)));
+
+/**
+ * fh_partition_memcpy - copies data from one guest to another
+ * @source: the ID of the partition to copy from
+ * @target: the ID of the partition to copy to
+ * @sg_list: guest physical address of an array of &fh_sg_list structures
+ * @count: the number of entries in @sg_list
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int fh_partition_memcpy(unsigned int source,
+	unsigned int target, phys_addr_t sg_list, unsigned int count)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+	register uintptr_t r5 __asm__("r5");
+	register uintptr_t r6 __asm__("r6");
+	register uintptr_t r7 __asm__("r7");
+
+	r11 = FH_HCALL_TOKEN(FH_PARTITION_MEMCPY);
+	r3 = source;
+	r4 = target;
+	r5 = (uint32_t) sg_list;
+
+#ifdef CONFIG_PHYS_64BIT
+	r6 = sg_list >> 32;
+#else
+	r6 = 0;
+#endif
+	r7 = count;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11),
+		  "+r" (r3), "+r" (r4), "+r" (r5), "+r" (r6), "+r" (r7)
+		: : EV_HCALL_CLOBBERS5
+	);
+
+	return r3;
+}
+
+/**
+ * fh_dma_enable - enable DMA for the specified device
+ * @liodn: the LIODN of the I/O device for which to enable DMA
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int fh_dma_enable(unsigned int liodn)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+
+	r11 = FH_HCALL_TOKEN(FH_DMA_ENABLE);
+	r3 = liodn;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3)
+		: : EV_HCALL_CLOBBERS1
+	);
+
+	return r3;
+}
+
+/**
+ * fh_dma_disable - disable DMA for the specified device
+ * @liodn: the LIODN of the I/O device for which to disable DMA
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int fh_dma_disable(unsigned int liodn)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+
+	r11 = FH_HCALL_TOKEN(FH_DMA_DISABLE);
+	r3 = liodn;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3)
+		: : EV_HCALL_CLOBBERS1
+	);
+
+	return r3;
+}
+
+
+/**
+ * fh_vmpic_get_msir - returns the MPIC-MSI register value
+ * @interrupt: the interrupt number
+ * @msir_val: returned MPIC-MSI register value
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int fh_vmpic_get_msir(unsigned int interrupt,
+	unsigned int *msir_val)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+
+	r11 = FH_HCALL_TOKEN(FH_VMPIC_GET_MSIR);
+	r3 = interrupt;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3), "=r" (r4)
+		: : EV_HCALL_CLOBBERS2
+	);
+
+	*msir_val = r4;
+
+	return r3;
+}
+
+/**
+ * fh_system_reset - reset the system
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int fh_system_reset(void)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+
+	r11 = FH_HCALL_TOKEN(FH_SYSTEM_RESET);
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "=r" (r3)
+		: : EV_HCALL_CLOBBERS1
+	);
+
+	return r3;
+}
+
+
+/**
+ * fh_err_get_info - get platform error information
+ * @queue id:
+ * 0 for guest error event queue
+ * 1 for global error event queue
+ *
+ * @pointer to store the platform error data:
+ * platform error data is returned in registers r4 - r11
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int fh_err_get_info(int queue, uint32_t *bufsize,
+	uint32_t addr_hi, uint32_t addr_lo, int peek)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+	register uintptr_t r5 __asm__("r5");
+	register uintptr_t r6 __asm__("r6");
+	register uintptr_t r7 __asm__("r7");
+
+	r11 = FH_HCALL_TOKEN(FH_ERR_GET_INFO);
+	r3 = queue;
+	r4 = *bufsize;
+	r5 = addr_hi;
+	r6 = addr_lo;
+	r7 = peek;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3), "+r" (r4), "+r" (r5), "+r" (r6),
+		  "+r" (r7)
+		: : EV_HCALL_CLOBBERS5
+	);
+
+	*bufsize = r4;
+
+	return r3;
+}
+
+
+#define FH_VCPU_RUN	0
+#define FH_VCPU_IDLE	1
+#define FH_VCPU_NAP	2
+
+/**
+ * fh_get_core_state - get the state of a vcpu
+ *
+ * @handle: handle of partition containing the vcpu
+ * @vcpu: vcpu number within the partition
+ * @state:the current state of the vcpu, see FH_VCPU_*
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int fh_get_core_state(unsigned int handle,
+	unsigned int vcpu, unsigned int *state)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+
+	r11 = FH_HCALL_TOKEN(FH_GET_CORE_STATE);
+	r3 = handle;
+	r4 = vcpu;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3), "+r" (r4)
+		: : EV_HCALL_CLOBBERS2
+	);
+
+	*state = r4;
+	return r3;
+}
+
+/**
+ * fh_enter_nap - enter nap on a vcpu
+ *
+ * Note that though the API supports entering nap on a vcpu other
+ * than the caller, this may not be implmented and may return EINVAL.
+ *
+ * @handle: handle of partition containing the vcpu
+ * @vcpu: vcpu number within the partition
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int fh_enter_nap(unsigned int handle, unsigned int vcpu)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+
+	r11 = FH_HCALL_TOKEN(FH_ENTER_NAP);
+	r3 = handle;
+	r4 = vcpu;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3), "+r" (r4)
+		: : EV_HCALL_CLOBBERS2
+	);
+
+	return r3;
+}
+
+/**
+ * fh_exit_nap - exit nap on a vcpu
+ * @handle: handle of partition containing the vcpu
+ * @vcpu: vcpu number within the partition
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int fh_exit_nap(unsigned int handle, unsigned int vcpu)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+	register uintptr_t r4 __asm__("r4");
+
+	r11 = FH_HCALL_TOKEN(FH_EXIT_NAP);
+	r3 = handle;
+	r4 = vcpu;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3), "+r" (r4)
+		: : EV_HCALL_CLOBBERS2
+	);
+
+	return r3;
+}
+/**
+ * fh_claim_device - claim a "claimable" shared device
+ * @handle: fsl,hv-device-handle of node to claim
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int fh_claim_device(unsigned int handle)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+
+	r11 = FH_HCALL_TOKEN(FH_CLAIM_DEVICE);
+	r3 = handle;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3)
+		: : EV_HCALL_CLOBBERS1
+	);
+
+	return r3;
+}
+
+/**
+ * Run deferred DMA disabling on a partition's private devices
+ *
+ * This applies to devices which a partition owns either privately,
+ * or which are claimable and still actively owned by that partition,
+ * and which do not have the no-dma-disable property.
+ *
+ * @handle: partition (must be stopped) whose DMA is to be disabled
+ *
+ * Returns 0 for success, or an error code.
+ */
+static inline unsigned int fh_partition_stop_dma(unsigned int handle)
+{
+	register uintptr_t r11 __asm__("r11");
+	register uintptr_t r3 __asm__("r3");
+
+	r11 = FH_HCALL_TOKEN(FH_PARTITION_STOP_DMA);
+	r3 = handle;
+
+	__asm__ __volatile__ ("sc 1"
+		: "+r" (r11), "+r" (r3)
+		: : EV_HCALL_CLOBBERS1
+	);
+
+	return r3;
+}
+#endif
-- 
1.7.3.4


