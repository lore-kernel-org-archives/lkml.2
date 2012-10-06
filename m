Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab2JFUNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:13:18 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35281 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2JFUNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:13:13 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 10/49] ACPICA: Add support for complex _PLD buffers.
Date: Sat,  6 Oct 2012 16:09:31 -0400
Message-Id: <be030a576854238250d70135644cde6a0ba34b0d.1349554106.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349554210-29978-1-git-send-email-lenb@kernel.org>
References: <1349554210-29978-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

_PLD (Physical Location of Device) returns a bit-packed buffer that
is difficult to parse. This change adds a new interface,
AcpiDecodePldBuffer that parses the buffer into a more usable
local struct. Also adds macros to both get and set individual
fields within the packed _PLD buffer. Adds a new include file,
acbuffer.h - which will be expanded to add structs for other
ACPI names that return buffers. ACPICA BZ 954.

Emit (in comments) the decoded contents of a static _PLD buffer
in order to improve comprehension of this bit-packed buffer.

Add multi-endian support to the _PLD decode routine. Deploy the
multi-endian macros to extract data from the _PLD buffer.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/aclocal.h  |  22 +++--
 drivers/acpi/acpica/acmacros.h |  29 ++++++-
 drivers/acpi/acpica/utxface.c  |  87 +++++++++++++++++++
 include/acpi/acbuffer.h        | 192 +++++++++++++++++++++++++++++++++++++++++
 include/acpi/acnames.h         |   1 +
 include/acpi/acpixf.h          |   5 ++
 include/acpi/actbl.h           |  12 ++-
 include/acpi/actbl1.h          |  12 ++-
 include/acpi/actbl2.h          |  12 ++-
 include/acpi/actbl3.h          |  12 ++-
 10 files changed, 360 insertions(+), 24 deletions(-)
 create mode 100644 include/acpi/acbuffer.h

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 493529a..c816ee6 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -707,15 +707,18 @@ union acpi_parse_value {
 	u8                              disasm_opcode;  /* Subtype used for disassembly */\
 	char                            aml_op_name[16])	/* Op name (debug only) */
 
-#define ACPI_DASM_BUFFER                0x00
-#define ACPI_DASM_RESOURCE              0x01
-#define ACPI_DASM_STRING                0x02
-#define ACPI_DASM_UNICODE               0x03
-#define ACPI_DASM_EISAID                0x04
-#define ACPI_DASM_MATCHOP               0x05
-#define ACPI_DASM_LNOT_PREFIX           0x06
-#define ACPI_DASM_LNOT_SUFFIX           0x07
-#define ACPI_DASM_IGNORE                0x08
+/* Flags for disasm_flags field above */
+
+#define ACPI_DASM_BUFFER                0x00	/* Buffer is a simple data buffer */
+#define ACPI_DASM_RESOURCE              0x01	/* Buffer is a Resource Descriptor */
+#define ACPI_DASM_STRING                0x02	/* Buffer is a ASCII string */
+#define ACPI_DASM_UNICODE               0x03	/* Buffer is a Unicode string */
+#define ACPI_DASM_PLD_METHOD            0x04	/* Buffer is a _PLD method bit-packed buffer */
+#define ACPI_DASM_EISAID                0x05	/* Integer is an EISAID */
+#define ACPI_DASM_MATCHOP               0x06	/* Parent opcode is a Match() operator */
+#define ACPI_DASM_LNOT_PREFIX           0x07	/* Start of a Lnot_equal (etc.) pair of opcodes */
+#define ACPI_DASM_LNOT_SUFFIX           0x08	/* End  of a Lnot_equal (etc.) pair of opcodes */
+#define ACPI_DASM_IGNORE                0x09	/* Not used at this time */
 
 /*
  * Generic operation (for example:  If, While, Store)
@@ -1025,6 +1028,7 @@ struct acpi_port_info {
  ****************************************************************************/
 
 struct acpi_db_method_info {
+	acpi_handle method;
 	acpi_handle main_thread_gate;
 	acpi_handle thread_complete_gate;
 	acpi_thread_id *threads;
diff --git a/drivers/acpi/acpica/acmacros.h b/drivers/acpi/acpica/acmacros.h
index 832b619..a7f68c4 100644
--- a/drivers/acpi/acpica/acmacros.h
+++ b/drivers/acpi/acpica/acmacros.h
@@ -277,10 +277,33 @@
 
 /* Bitfields within ACPI registers */
 
-#define ACPI_REGISTER_PREPARE_BITS(val, pos, mask)      ((val << pos) & mask)
-#define ACPI_REGISTER_INSERT_VALUE(reg, pos, mask, val)  reg = (reg & (~(mask))) | ACPI_REGISTER_PREPARE_BITS(val, pos, mask)
+#define ACPI_REGISTER_PREPARE_BITS(val, pos, mask) \
+	((val << pos) & mask)
 
-#define ACPI_INSERT_BITS(target, mask, source)          target = ((target & (~(mask))) | (source & mask))
+#define ACPI_REGISTER_INSERT_VALUE(reg, pos, mask, val) \
+	reg = (reg & (~(mask))) | ACPI_REGISTER_PREPARE_BITS(val, pos, mask)
+
+#define ACPI_INSERT_BITS(target, mask, source) \
+	target = ((target & (~(mask))) | (source & mask))
+
+/* Generic bitfield macros and masks */
+
+#define ACPI_GET_BITS(source_ptr, position, mask) \
+	((*source_ptr >> position) & mask)
+
+#define ACPI_SET_BITS(target_ptr, position, mask, value) \
+	(*target_ptr |= ((value & mask) << position))
+
+#define ACPI_1BIT_MASK      0x00000001
+#define ACPI_2BIT_MASK      0x00000003
+#define ACPI_3BIT_MASK      0x00000007
+#define ACPI_4BIT_MASK      0x0000000F
+#define ACPI_5BIT_MASK      0x0000001F
+#define ACPI_6BIT_MASK      0x0000003F
+#define ACPI_7BIT_MASK      0x0000007F
+#define ACPI_8BIT_MASK      0x000000FF
+#define ACPI_16BIT_MASK     0x0000FFFF
+#define ACPI_24BIT_MASK     0x00FFFFFF
 
 /*
  * An object of type struct acpi_namespace_node can appear in some contexts
diff --git a/drivers/acpi/acpica/utxface.c b/drivers/acpi/acpica/utxface.c
index 667229d..b09632b 100644
--- a/drivers/acpi/acpica/utxface.c
+++ b/drivers/acpi/acpica/utxface.c
@@ -418,3 +418,90 @@ acpi_check_address_range(acpi_adr_space_type space_id,
 
 ACPI_EXPORT_SYMBOL(acpi_check_address_range)
 #endif				/* !ACPI_ASL_COMPILER */
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_decode_pld_buffer
+ *
+ * PARAMETERS:  in_buffer           - Buffer returned by _PLD method
+ *              length              - Length of the in_buffer
+ *              return_buffer       - Where the decode buffer is returned
+ *
+ * RETURN:      Status and the decoded _PLD buffer. User must deallocate
+ *              the buffer via ACPI_FREE.
+ *
+ * DESCRIPTION: Decode the bit-packed buffer returned by the _PLD method into
+ *              a local struct that is much more useful to an ACPI driver.
+ *
+ ******************************************************************************/
+acpi_status
+acpi_decode_pld_buffer(u8 *in_buffer,
+		       acpi_size length, struct acpi_pld_info ** return_buffer)
+{
+	struct acpi_pld_info *pld_info;
+	u32 *buffer = ACPI_CAST_PTR(u32, in_buffer);
+	u32 dword;
+
+	/* Parameter validation */
+
+	if (!in_buffer || !return_buffer || (length < 16)) {
+		return (AE_BAD_PARAMETER);
+	}
+
+	pld_info = ACPI_ALLOCATE_ZEROED(sizeof(struct acpi_pld_info));
+	if (!pld_info) {
+		return (AE_NO_MEMORY);
+	}
+
+	/* First 32-bit DWord */
+
+	ACPI_MOVE_32_TO_32(&dword, &buffer[0]);
+	pld_info->revision = ACPI_PLD_GET_REVISION(&dword);
+	pld_info->ignore_color = ACPI_PLD_GET_IGNORE_COLOR(&dword);
+	pld_info->color = ACPI_PLD_GET_COLOR(&dword);
+
+	/* Second 32-bit DWord */
+
+	ACPI_MOVE_32_TO_32(&dword, &buffer[1]);
+	pld_info->width = ACPI_PLD_GET_WIDTH(&dword);
+	pld_info->height = ACPI_PLD_GET_HEIGHT(&dword);
+
+	/* Third 32-bit DWord */
+
+	ACPI_MOVE_32_TO_32(&dword, &buffer[2]);
+	pld_info->user_visible = ACPI_PLD_GET_USER_VISIBLE(&dword);
+	pld_info->dock = ACPI_PLD_GET_DOCK(&dword);
+	pld_info->lid = ACPI_PLD_GET_LID(&dword);
+	pld_info->panel = ACPI_PLD_GET_PANEL(&dword);
+	pld_info->vertical_position = ACPI_PLD_GET_VERTICAL(&dword);
+	pld_info->horizontal_position = ACPI_PLD_GET_HORIZONTAL(&dword);
+	pld_info->shape = ACPI_PLD_GET_SHAPE(&dword);
+	pld_info->group_orientation = ACPI_PLD_GET_ORIENTATION(&dword);
+	pld_info->group_token = ACPI_PLD_GET_TOKEN(&dword);
+	pld_info->group_position = ACPI_PLD_GET_POSITION(&dword);
+	pld_info->bay = ACPI_PLD_GET_BAY(&dword);
+
+	/* Fourth 32-bit DWord */
+
+	ACPI_MOVE_32_TO_32(&dword, &buffer[3]);
+	pld_info->ejectable = ACPI_PLD_GET_EJECTABLE(&dword);
+	pld_info->ospm_eject_required = ACPI_PLD_GET_OSPM_EJECT(&dword);
+	pld_info->cabinet_number = ACPI_PLD_GET_CABINET(&dword);
+	pld_info->card_cage_number = ACPI_PLD_GET_CARD_CAGE(&dword);
+	pld_info->reference = ACPI_PLD_GET_REFERENCE(&dword);
+	pld_info->rotation = ACPI_PLD_GET_ROTATION(&dword);
+	pld_info->order = ACPI_PLD_GET_ORDER(&dword);
+
+	if (length >= ACPI_PLD_BUFFER_SIZE) {
+
+		/* Fifth 32-bit DWord (Revision 2 of _PLD) */
+
+		ACPI_MOVE_32_TO_32(&dword, &buffer[4]);
+		pld_info->vertical_offset = ACPI_PLD_GET_VERT_OFFSET(&dword);
+		pld_info->horizontal_offset = ACPI_PLD_GET_HORIZ_OFFSET(&dword);
+	}
+
+	*return_buffer = pld_info;
+	return (AE_OK);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_decode_pld_buffer)
diff --git a/include/acpi/acbuffer.h b/include/acpi/acbuffer.h
new file mode 100644
index 0000000..2c3b447
--- /dev/null
+++ b/include/acpi/acbuffer.h
@@ -0,0 +1,192 @@
+/******************************************************************************
+ *
+ * Name: acbuffer.h - Support for buffers returned by ACPI predefined names
+ *
+ *****************************************************************************/
+
+/*
+ * Copyright (C) 2000 - 2012, Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ */
+
+#ifndef __ACBUFFER_H__
+#define __ACBUFFER_H__
+
+/*
+ * Note: C bitfields are not used for this reason:
+ *
+ * "Bitfields are great and easy to read, but unfortunately the C language
+ * does not specify the layout of bitfields in memory, which means they are
+ * essentially useless for dealing with packed data in on-disk formats or
+ * binary wire protocols." (Or ACPI tables and buffers.) "If you ask me,
+ * this decision was a design error in C. Ritchie could have picked an order
+ * and stuck with it." Norman Ramsey.
+ * See http://stackoverflow.com/a/1053662/41661
+ */
+
+/*
+ * Formatted _PLD return value. The minimum size is a package containing
+ * one buffer.
+ * Revision 1: Buffer is 16 bytes (128 bits)
+ * Revision 2: Buffer is 20 bytes (160 bits)
+ *
+ * Note: This structure is returned from the acpi_decode_pld_buffer
+ * interface.
+ */
+struct acpi_pld_info {
+	u8 revision;
+	u8 ignore_color;
+	u32 color;
+	u16 width;
+	u16 height;
+	u8 user_visible;
+	u8 dock;
+	u8 lid;
+	u8 panel;
+	u8 vertical_position;
+	u8 horizontal_position;
+	u8 shape;
+	u8 group_orientation;
+	u8 group_token;
+	u8 group_position;
+	u8 bay;
+	u8 ejectable;
+	u8 ospm_eject_required;
+	u8 cabinet_number;
+	u8 card_cage_number;
+	u8 reference;
+	u8 rotation;
+	u8 order;
+	u8 reserved;
+	u16 vertical_offset;
+	u16 horizontal_offset;
+};
+
+/*
+ * Macros to:
+ *     1) Convert a _PLD buffer to internal struct acpi_pld_info format - ACPI_PLD_GET*
+ *        (Used by acpi_decode_pld_buffer)
+ *     2) Construct a _PLD buffer - ACPI_PLD_SET*
+ *        (Intended for BIOS use only)
+ */
+#define ACPI_PLD_REV1_BUFFER_SIZE               16	/* For Revision 1 of the buffer (From ACPI spec) */
+#define ACPI_PLD_BUFFER_SIZE                    20	/* For Revision 2 of the buffer (From ACPI spec) */
+
+/* First 32-bit dword, bits 0:32 */
+
+#define ACPI_PLD_GET_REVISION(dword)            ACPI_GET_BITS (dword, 0, ACPI_7BIT_MASK)
+#define ACPI_PLD_SET_REVISION(dword,value)      ACPI_SET_BITS (dword, 0, ACPI_7BIT_MASK, value)	/* Offset 0, Len 7 */
+
+#define ACPI_PLD_GET_IGNORE_COLOR(dword)        ACPI_GET_BITS (dword, 7, ACPI_1BIT_MASK)
+#define ACPI_PLD_SET_IGNORE_COLOR(dword,value)  ACPI_SET_BITS (dword, 7, ACPI_1BIT_MASK, value)	/* Offset 7, Len 1 */
+
+#define ACPI_PLD_GET_COLOR(dword)               ACPI_GET_BITS (dword, 8, ACPI_24BIT_MASK)
+#define ACPI_PLD_SET_COLOR(dword,value)         ACPI_SET_BITS (dword, 8, ACPI_24BIT_MASK, value)	/* Offset 8, Len 24 */
+
+/* Second 32-bit dword, bits 33:63 */
+
+#define ACPI_PLD_GET_WIDTH(dword)               ACPI_GET_BITS (dword, 0, ACPI_16BIT_MASK)
+#define ACPI_PLD_SET_WIDTH(dword,value)         ACPI_SET_BITS (dword, 0, ACPI_16BIT_MASK, value)	/* Offset 32+0=32, Len 16 */
+
+#define ACPI_PLD_GET_HEIGHT(dword)              ACPI_GET_BITS (dword, 16, ACPI_16BIT_MASK)
+#define ACPI_PLD_SET_HEIGHT(dword,value)        ACPI_SET_BITS (dword, 16, ACPI_16BIT_MASK, value)	/* Offset 32+16=48, Len 16 */
+
+/* Third 32-bit dword, bits 64:95 */
+
+#define ACPI_PLD_GET_USER_VISIBLE(dword)        ACPI_GET_BITS (dword, 0, ACPI_1BIT_MASK)
+#define ACPI_PLD_SET_USER_VISIBLE(dword,value)  ACPI_SET_BITS (dword, 0, ACPI_1BIT_MASK, value)	/* Offset 64+0=64, Len 1 */
+
+#define ACPI_PLD_GET_DOCK(dword)                ACPI_GET_BITS (dword, 1, ACPI_1BIT_MASK)
+#define ACPI_PLD_SET_DOCK(dword,value)          ACPI_SET_BITS (dword, 1, ACPI_1BIT_MASK, value)	/* Offset 64+1=65, Len 1 */
+
+#define ACPI_PLD_GET_LID(dword)                 ACPI_GET_BITS (dword, 2, ACPI_1BIT_MASK)
+#define ACPI_PLD_SET_LID(dword,value)           ACPI_SET_BITS (dword, 2, ACPI_1BIT_MASK, value)	/* Offset 64+2=66, Len 1 */
+
+#define ACPI_PLD_GET_PANEL(dword)               ACPI_GET_BITS (dword, 3, ACPI_3BIT_MASK)
+#define ACPI_PLD_SET_PANEL(dword,value)         ACPI_SET_BITS (dword, 3, ACPI_3BIT_MASK, value)	/* Offset 64+3=67, Len 3 */
+
+#define ACPI_PLD_GET_VERTICAL(dword)            ACPI_GET_BITS (dword, 6, ACPI_2BIT_MASK)
+#define ACPI_PLD_SET_VERTICAL(dword,value)      ACPI_SET_BITS (dword, 6, ACPI_2BIT_MASK, value)	/* Offset 64+6=70, Len 2 */
+
+#define ACPI_PLD_GET_HORIZONTAL(dword)          ACPI_GET_BITS (dword, 8, ACPI_2BIT_MASK)
+#define ACPI_PLD_SET_HORIZONTAL(dword,value)    ACPI_SET_BITS (dword, 8, ACPI_2BIT_MASK, value)	/* Offset 64+8=72, Len 2 */
+
+#define ACPI_PLD_GET_SHAPE(dword)               ACPI_GET_BITS (dword, 10, ACPI_4BIT_MASK)
+#define ACPI_PLD_SET_SHAPE(dword,value)         ACPI_SET_BITS (dword, 10, ACPI_4BIT_MASK, value)	/* Offset 64+10=74, Len 4 */
+
+#define ACPI_PLD_GET_ORIENTATION(dword)         ACPI_GET_BITS (dword, 14, ACPI_1BIT_MASK)
+#define ACPI_PLD_SET_ORIENTATION(dword,value)   ACPI_SET_BITS (dword, 14, ACPI_1BIT_MASK, value)	/* Offset 64+14=78, Len 1 */
+
+#define ACPI_PLD_GET_TOKEN(dword)               ACPI_GET_BITS (dword, 15, ACPI_8BIT_MASK)
+#define ACPI_PLD_SET_TOKEN(dword,value)         ACPI_SET_BITS (dword, 15, ACPI_8BIT_MASK, value)	/* Offset 64+15=79, Len 8 */
+
+#define ACPI_PLD_GET_POSITION(dword)            ACPI_GET_BITS (dword, 23, ACPI_8BIT_MASK)
+#define ACPI_PLD_SET_POSITION(dword,value)      ACPI_SET_BITS (dword, 23, ACPI_8BIT_MASK, value)	/* Offset 64+23=87, Len 8 */
+
+#define ACPI_PLD_GET_BAY(dword)                 ACPI_GET_BITS (dword, 31, ACPI_1BIT_MASK)
+#define ACPI_PLD_SET_BAY(dword,value)           ACPI_SET_BITS (dword, 31, ACPI_1BIT_MASK, value)	/* Offset 64+31=95, Len 1 */
+
+/* Fourth 32-bit dword, bits 96:127 */
+
+#define ACPI_PLD_GET_EJECTABLE(dword)           ACPI_GET_BITS (dword, 0, ACPI_1BIT_MASK)
+#define ACPI_PLD_SET_EJECTABLE(dword,value)     ACPI_SET_BITS (dword, 0, ACPI_1BIT_MASK, value)	/* Offset 96+0=96, Len 1 */
+
+#define ACPI_PLD_GET_OSPM_EJECT(dword)          ACPI_GET_BITS (dword, 1, ACPI_1BIT_MASK)
+#define ACPI_PLD_SET_OSPM_EJECT(dword,value)    ACPI_SET_BITS (dword, 1, ACPI_1BIT_MASK, value)	/* Offset 96+1=97, Len 1 */
+
+#define ACPI_PLD_GET_CABINET(dword)             ACPI_GET_BITS (dword, 2, ACPI_8BIT_MASK)
+#define ACPI_PLD_SET_CABINET(dword,value)       ACPI_SET_BITS (dword, 2, ACPI_8BIT_MASK, value)	/* Offset 96+2=98, Len 8 */
+
+#define ACPI_PLD_GET_CARD_CAGE(dword)           ACPI_GET_BITS (dword, 10, ACPI_8BIT_MASK)
+#define ACPI_PLD_SET_CARD_CAGE(dword,value)     ACPI_SET_BITS (dword, 10, ACPI_8BIT_MASK, value)	/* Offset 96+10=106, Len 8 */
+
+#define ACPI_PLD_GET_REFERENCE(dword)           ACPI_GET_BITS (dword, 18, ACPI_1BIT_MASK)
+#define ACPI_PLD_SET_REFERENCE(dword,value)     ACPI_SET_BITS (dword, 18, ACPI_1BIT_MASK, value)	/* Offset 96+18=114, Len 1 */
+
+#define ACPI_PLD_GET_ROTATION(dword)            ACPI_GET_BITS (dword, 19, ACPI_4BIT_MASK)
+#define ACPI_PLD_SET_ROTATION(dword,value)      ACPI_SET_BITS (dword, 19, ACPI_4BIT_MASK, value)	/* Offset 96+19=115, Len 4 */
+
+#define ACPI_PLD_GET_ORDER(dword)               ACPI_GET_BITS (dword, 23, ACPI_5BIT_MASK)
+#define ACPI_PLD_SET_ORDER(dword,value)         ACPI_SET_BITS (dword, 23, ACPI_5BIT_MASK, value)	/* Offset 96+23=119, Len 5 */
+
+/* Fifth 32-bit dword, bits 128:159 (Revision 2 of _PLD only) */
+
+#define ACPI_PLD_GET_VERT_OFFSET(dword)         ACPI_GET_BITS (dword, 0, ACPI_16BIT_MASK)
+#define ACPI_PLD_SET_VERT_OFFSET(dword,value)   ACPI_SET_BITS (dword, 0, ACPI_16BIT_MASK, value)	/* Offset 128+0=128, Len 16 */
+
+#define ACPI_PLD_GET_HORIZ_OFFSET(dword)        ACPI_GET_BITS (dword, 16, ACPI_16BIT_MASK)
+#define ACPI_PLD_SET_HORIZ_OFFSET(dword,value)  ACPI_SET_BITS (dword, 16, ACPI_16BIT_MASK, value)	/* Offset 128+16=144, Len 16 */
+
+#endif				/* ACBUFFER_H */
diff --git a/include/acpi/acnames.h b/include/acpi/acnames.h
index d2f61dd..745dd24e 100644
--- a/include/acpi/acnames.h
+++ b/include/acpi/acnames.h
@@ -63,6 +63,7 @@
 #define METHOD_NAME__PRW        "_PRW"
 #define METHOD_NAME__SRS        "_SRS"
 #define METHOD_NAME__CBA        "_CBA"
+#define METHOD_NAME__PLD        "_PLD"
 
 /* Method names - these methods must appear at the namespace root */
 
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 26a92fc..270517d 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -52,6 +52,7 @@
 #include "acconfig.h"
 #include "actypes.h"
 #include "actbl.h"
+#include "acbuffer.h"
 
 extern u8 acpi_gbl_permanent_mmap;
 
@@ -144,6 +145,10 @@ acpi_check_address_range(acpi_adr_space_type space_id,
 			 acpi_physical_address address,
 			 acpi_size length, u8 warn);
 
+acpi_status
+acpi_decode_pld_buffer(u8 *in_buffer,
+		       acpi_size length, struct acpi_pld_info **return_buffer);
+
 /*
  * ACPI Memory management
  */
diff --git a/include/acpi/actbl.h b/include/acpi/actbl.h
index d54e358..4f94b1d 100644
--- a/include/acpi/actbl.h
+++ b/include/acpi/actbl.h
@@ -79,9 +79,15 @@
 #pragma pack(1)
 
 /*
- * Note about bitfields: The u8 type is used for bitfields in ACPI tables.
- * This is the only type that is even remotely portable. Anything else is not
- * portable, so do not use any other bitfield types.
+ * Note: C bitfields are not used for this reason:
+ *
+ * "Bitfields are great and easy to read, but unfortunately the C language
+ * does not specify the layout of bitfields in memory, which means they are
+ * essentially useless for dealing with packed data in on-disk formats or
+ * binary wire protocols." (Or ACPI tables and buffers.) "If you ask me,
+ * this decision was a design error in C. Ritchie could have picked an order
+ * and stuck with it." Norman Ramsey.
+ * See http://stackoverflow.com/a/1053662/41661
  */
 
 /*******************************************************************************
diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index 300d14e..c41d6f9 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -79,9 +79,15 @@
 #pragma pack(1)
 
 /*
- * Note about bitfields: The u8 type is used for bitfields in ACPI tables.
- * This is the only type that is even remotely portable. Anything else is not
- * portable, so do not use any other bitfield types.
+ * Note: C bitfields are not used for this reason:
+ *
+ * "Bitfields are great and easy to read, but unfortunately the C language
+ * does not specify the layout of bitfields in memory, which means they are
+ * essentially useless for dealing with packed data in on-disk formats or
+ * binary wire protocols." (Or ACPI tables and buffers.) "If you ask me,
+ * this decision was a design error in C. Ritchie could have picked an order
+ * and stuck with it." Norman Ramsey.
+ * See http://stackoverflow.com/a/1053662/41661
  */
 
 /*******************************************************************************
diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index b74476c..1b2b356 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -98,9 +98,15 @@
 #pragma pack(1)
 
 /*
- * Note about bitfields: The u8 type is used for bitfields in ACPI tables.
- * This is the only type that is even remotely portable. Anything else is not
- * portable, so do not use any other bitfield types.
+ * Note: C bitfields are not used for this reason:
+ *
+ * "Bitfields are great and easy to read, but unfortunately the C language
+ * does not specify the layout of bitfields in memory, which means they are
+ * essentially useless for dealing with packed data in on-disk formats or
+ * binary wire protocols." (Or ACPI tables and buffers.) "If you ask me,
+ * this decision was a design error in C. Ritchie could have picked an order
+ * and stuck with it." Norman Ramsey.
+ * See http://stackoverflow.com/a/1053662/41661
  */
 
 /*******************************************************************************
diff --git a/include/acpi/actbl3.h b/include/acpi/actbl3.h
index 37781ab..8c61b5f 100644
--- a/include/acpi/actbl3.h
+++ b/include/acpi/actbl3.h
@@ -86,9 +86,15 @@
 #pragma pack(1)
 
 /*
- * Note about bitfields: The u8 type is used for bitfields in ACPI tables.
- * This is the only type that is even remotely portable. Anything else is not
- * portable, so do not use any other bitfield types.
+ * Note: C bitfields are not used for this reason:
+ *
+ * "Bitfields are great and easy to read, but unfortunately the C language
+ * does not specify the layout of bitfields in memory, which means they are
+ * essentially useless for dealing with packed data in on-disk formats or
+ * binary wire protocols." (Or ACPI tables and buffers.) "If you ask me,
+ * this decision was a design error in C. Ritchie could have picked an order
+ * and stuck with it." Norman Ramsey.
+ * See http://stackoverflow.com/a/1053662/41661
  */
 
 /*******************************************************************************
-- 
1.8.0.rc0.18.gf84667d

