Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab2LKNk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:40:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44513 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab2LKNkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:40:23 -0500
From: Mehar Bajwa <mehar.bajwa@ti.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mehar Bajwa <mehar.bajwa@ti.com>,
        M R Swami Reddy <mr.swami.reddy@ti.com>,
        Rajeev Kumar <rajeev-dlh.kumar@st.com>,
        amoderator list <lsa-devel@alsa-project.org>,
        open list <linux-kernel@vger.kernel.org>,
        Moderator list <devicetree-discuss@lists.ozlabs.org>
CC: Mukund <navada@ti.com>, Hari <harik@ti.com>,
        Mehar Bajwa <mehar.bajwa@ti.com>
Subject: [PATCH 2/2] ASoC: aic: Support for AIC family DSPs
Date: Tue, 11 Dec 2012 19:09:19 +0530
Message-ID: <1355233159-14524-1-git-send-email-mehar.bajwa@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AIC family of audio CODECs from TI features a programmable miniDSP for
performing signal processing operations. Due to commonality of functions
across the CODECs a common library will be used to provide support for them.

Signed-off-by: Mehar Bajwa <mehar.bajwa@ti.com>
---
 sound/soc/codecs/Kconfig           |    5 +
 sound/soc/codecs/Makefile          |    2 +
 sound/soc/codecs/aic3xxx_cfw.h     |  529 +++++++++++++++++++
 sound/soc/codecs/aic3xxx_cfw_ops.c |  989 ++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/aic3xxx_cfw_ops.h |   98 ++++
 5 files changed, 1623 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/codecs/aic3xxx_cfw.h
 create mode 100644 sound/soc/codecs/aic3xxx_cfw_ops.c
 create mode 100644 sound/soc/codecs/aic3xxx_cfw_ops.h

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 73d8cea..52b3601 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -188,6 +188,11 @@ config SND_SOC_ADAV80X
 config SND_SOC_ADS117X
 	tristate
 
+config SND_SOC_AIC_CFW
+	tristate
+	default y if SND_SOC_TLV320AIC3262=y
+	default m if SND_SOC_TLV320AIC3262=m
+
 config SND_SOC_AK4104
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index a3f8f4f..ffda11b 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -9,6 +9,7 @@ snd-soc-adau1701-objs := adau1701.o
 snd-soc-adau1373-objs := adau1373.o
 snd-soc-adav80x-objs := adav80x.o
 snd-soc-ads117x-objs := ads117x.o
+snd-soc-aic3xxx-cfw-ops-objs := aic3xxx_cfw_ops.o
 snd-soc-ak4104-objs := ak4104.o
 snd-soc-ak4535-objs := ak4535.o
 snd-soc-ak4641-objs := ak4641.o
@@ -132,6 +133,7 @@ obj-$(CONFIG_SND_SOC_ADAU1373)	+= snd-soc-adau1373.o
 obj-$(CONFIG_SND_SOC_ADAU1701)  += snd-soc-adau1701.o
 obj-$(CONFIG_SND_SOC_ADAV80X)  += snd-soc-adav80x.o
 obj-$(CONFIG_SND_SOC_ADS117X)	+= snd-soc-ads117x.o
+obj-$(CONFIG_SND_SOC_AIC_CFW)	+= snd-soc-aic3xxx-cfw-ops.o
 obj-$(CONFIG_SND_SOC_AK4104)	+= snd-soc-ak4104.o
 obj-$(CONFIG_SND_SOC_AK4535)	+= snd-soc-ak4535.o
 obj-$(CONFIG_SND_SOC_AK4641)	+= snd-soc-ak4641.o
diff --git a/sound/soc/codecs/aic3xxx_cfw.h b/sound/soc/codecs/aic3xxx_cfw.h
new file mode 100644
index 0000000..b88485d
--- /dev/null
+++ b/sound/soc/codecs/aic3xxx_cfw.h
@@ -0,0 +1,529 @@
+/*
+ *  aic3xxx_cfw.h  --  SoC audio for TI OMAP44XX SDP
+ *                      Codec Firmware Declarations
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef AIC_FIRMWARE_H_
+#define AIC_FIRMWARE_H_
+
+
+#define AIC_FW_MAGIC 0xC0D1F1ED
+
+
+/** \defgroup pd Arbitrary Limitations */
+/* @{ */
+#ifndef AIC_MAX_ID
+#    define AIC_MAX_ID          (64)	/**<Max length of string identifies*/
+#    define AIC_MAX_VARS       (256)	/**<Number of "variables" alive at the*/
+					/**<same time in an acx file*/
+#endif
+
+/* @} */
+
+
+
+/** \defgroup st Enums, Flags, Macros and Supporting Types */
+/* @{ */
+
+
+/**
+ * Device Family Identifier
+ *
+ */
+enum __attribute__ ((__packed__)) aic_dfamily {
+	AIC_DFM_TYPE_A,
+	AIC_DFM_TYPE_B,
+	AIC_DFM_TYPE_C
+};
+
+/**
+ * Device Identifier
+ *
+ */
+enum __attribute__ ((__packed__)) aic_device {
+	AIC_DEV_DAC3120,
+	AIC_DEV_DAC3100,
+	AIC_DEV_AIC3120,
+	AIC_DEV_AIC3100,
+	AIC_DEV_AIC3110,
+	AIC_DEV_AIC3111,
+	AIC_DEV_AIC36,
+	AIC_DEV_AIC3206,
+	AIC_DEV_AIC3204,
+	AIC_DEV_AIC3254,
+	AIC_DEV_AIC3256,
+	AIC_DEV_AIC3253,
+	AIC_DEV_AIC3212,
+	AIC_DEV_AIC3262,
+	AIC_DEV_AIC3017,
+	AIC_DEV_AIC3008,
+
+	AIC_DEV_AIC3266,
+	AIC_DEV_AIC3285,
+};
+
+/**
+ * Transition Sequence Identifier
+ *
+ */
+enum aic_transition_t {
+	AIC_TRN_INIT,
+	AIC_TRN_RESUME,
+	AIC_TRN_NEUTRAL,
+	AIC_TRN_A_MUTE,
+	AIC_TRN_D_MUTE,
+	AIC_TRN_AD_MUTE,
+	AIC_TRN_A_UNMUTE,
+	AIC_TRN_D_UNMUTE,
+	AIC_TRN_AD_UNMUTE,
+	AIC_TRN_SUSPEND,
+	AIC_TRN_EXIT,
+	AIC_TRN_N
+};
+
+#ifndef __cplusplus
+static const char *const aic_transition_id[] = {
+	[AIC_TRN_INIT]     "INIT",
+	[AIC_TRN_RESUME]   "RESUME",
+	[AIC_TRN_NEUTRAL]  "NEUTRAL",
+	[AIC_TRN_A_MUTE]   "A_MUTE",
+	[AIC_TRN_D_MUTE]   "D_MUTE",
+	[AIC_TRN_AD_MUTE]  "AD_MUTE",
+	[AIC_TRN_A_UNMUTE] "A_UNMUTE",
+	[AIC_TRN_D_UNMUTE] "D_UNMUTE",
+	[AIC_TRN_AD_UNMUTE]"AD_UNMUTE",
+	[AIC_TRN_SUSPEND]  "SUSPEND",
+	[AIC_TRN_EXIT]     "EXIT",
+};
+#endif
+
+/* @} */
+
+/** \defgroup ds Data Structures */
+/* @{ */
+
+
+/**
+* AIC Command
+* These commands do not appear in the register
+* set of the device.
+*/
+enum __attribute__ ((__packed__)) aic_cmd_id {
+	AIC_CMD_NOP = 0x80,
+	AIC_CMD_DELAY,
+	AIC_CMD_UPDTBITS,
+	AIC_CMD_WAITBITS,
+	AIC_CMD_LOCK,
+	AIC_CMD_BURST,
+	AIC_CMD_RBURST,
+	AIC_CMD_LOAD_VAR_IM,
+	AIC_CMD_LOAD_VAR_ID,
+	AIC_CMD_STORE_VAR,
+	AIC_CMD_COND,
+	AIC_CMD_BRANCH,
+	AIC_CMD_BRANCH_IM,
+	AIC_CMD_BRANCH_ID,
+	AIC_CMD_PRINT,
+	AIC_CMD_OP_ADD = 0xC0,
+	AIC_CMD_OP_SUB,
+	AIC_CMD_OP_MUL,
+	AIC_CMD_OP_DIV,
+	AIC_CMD_OP_AND,
+	AIC_CMD_OP_OR,
+	AIC_CMD_OP_SHL,
+	AIC_CMD_OP_SHR,
+	AIC_CMD_OP_RR,
+	AIC_CMD_OP_XOR,
+	AIC_CMD_OP_NOT,
+	AIC_CMD_OP_LNOT,
+};
+
+/**
+* AIC Delay
+* Used for the cmd command delay
+* Has one parameter of delay time in ms
+*/
+struct aic_cmd_delay {
+	u16 delay;
+	enum aic_cmd_id cid;
+	u8 delay_fine;
+};
+
+/**
+* AIC Lock
+* Take codec mutex to avoid clashing with DAPM operations
+*/
+struct aic_cmd_lock {
+	u16 lock;
+	enum aic_cmd_id cid;
+	u8 unused;
+};
+
+
+/**
+ * AIC  UPDTBITS, WAITBITS, CHKBITS
+ * Both these cmd commands have same arguments
+ * cid will be used to specify which command it is
+ * has parameters of book, page, offset and mask
+ */
+struct aic_cmd_bitop {
+	u16 unused1;
+	enum aic_cmd_id cid;
+	u8 mask;
+};
+
+/**
+ * AIC  CMD Burst header
+ * Burst writes inside command array
+ * Followed by burst address, first byte
+ */
+struct aic_cmd_bhdr {
+	u16 len;
+	enum aic_cmd_id cid;
+	u8 unused;
+};
+
+/**
+ * AIC  CMD Burst
+ * Burst writes inside command array
+ * Followed by data to the extent indicated in previous len
+ * Can be safely cast to aic_burst
+ */
+struct aic_cmd_burst {
+	u8 book;
+	u8 page;
+	u8 offset;
+	u8 data[1];
+};
+#define AIC_CMD_BURST_LEN(n) (2 + ((n) - 1 + 3)/4)
+
+/**
+ * AIC  CMD Scratch register
+ * For load
+ *  if (svar != dvar)
+ *      dvar = setbits(svar, mask) // Ignore reg
+ *  else
+ *      dvar = setbits(reg, mask)
+ * For store
+ *  if (svar != dvar)
+ *      reg = setbits(svar,  dvar)
+ *  else
+ *      reg =  setbits(svar, mask)
+ *
+ */
+struct aic_cmd_ldst {
+	u8 dvar;
+	u8 svar;
+	enum aic_cmd_id cid;
+	u8 mask;
+};
+
+/**
+ * AIC  CMD Conditional
+ * May only precede branch. Followed by nmatch+1 jump
+ * instructions
+ *   cond = svar&mask
+ * At each of the following nmatch+1 branch command
+ *   if (cond == match)
+ *       take the branch
+ */
+struct aic_cmd_cond {
+	u8 svar;
+	u8 nmatch;
+	enum aic_cmd_id cid;
+	u8 mask;
+};
+#define AIC_CMD_COND_LEN(nm) (1 + ((nm)+1))
+
+/**
+ * AIC  CMD Goto
+ * For branch, break, continue and stop
+ */
+struct aic_cmd_branch {
+	u16 address;
+	enum aic_cmd_id cid;
+	u8 match;
+};
+
+/**
+ * AIC  Debug print
+ * For diagnostics
+ */
+struct aic_cmd_print {
+	u8 fmtlen;
+	u8 nargs;
+	enum aic_cmd_id cid;
+	char fmt[1];
+};
+
+#define AIC_CMD_PRINT_LEN(p) (1 + ((p).fmtlen/4) + (((p).nargs + 3)/4))
+#define AIC_CMD_PRINT_ARG(p) (1 + ((p).fmtlen/4))
+
+/**
+ * AIC  Arithmetic and logical operations
+ *  Bit 5 indicates if op1 is indirect
+ *  Bit 6 indicates if op2 is indirect
+ */
+struct aic_cmd_op {
+	u8 op1;
+	u8 op2;
+	enum aic_cmd_id cid;
+	u8 dst;
+};
+#define AIC_CMD_OP1_ID     (1u<<5)
+#define AIC_CMD_OP2_ID     (1u<<4)
+
+#define AIC_CMD_OP_START   AIC_CMD_OP_ADD
+#define AIC_CMD_OP_END     (AIC_CMD_OP_LNOT|AIC_CMD_OP1_ID|AIC_CMD_OP2_ID)
+#define AIC_CMD_OP_IS_UNARY(x) \
+			(((x) == AIC_CMD_OP_NOT) || ((x) == AIC_CMD_OP_LNOT))
+
+
+/**
+ * AIC Register
+ *
+ * A single reg write
+ *
+ */
+union aic_register {
+	struct {
+		u8 book;
+		u8 page;
+		u8 offset;
+		u8 data;
+	};
+	u32 bpod;
+};
+
+
+
+/**
+ * AIC Command
+ *
+ * Can be a either a
+ *      -# single register write, or
+ *      -# command
+ *
+ */
+union aic_cmd {
+	struct {
+		u16 unused1;
+		enum aic_cmd_id cid;
+		u8 unused2;
+	};
+	union aic_register reg;
+	struct aic_cmd_delay delay;
+	struct aic_cmd_lock lock;
+	struct aic_cmd_bitop bitop;
+	struct aic_cmd_bhdr bhdr;
+	struct aic_cmd_burst burst;
+	struct aic_cmd_ldst ldst;
+	struct aic_cmd_cond cond;
+	struct aic_cmd_branch branch;
+	struct aic_cmd_print print;
+	u8     print_arg[4];
+	struct aic_cmd_op op;
+};
+
+#define AIC_REG_IS_CMD(x) ((x).cid >= AIC_CMD_DELAY)
+
+/**
+ * AIC Block Type
+ *
+ * Block identifier
+ *
+ */
+enum __attribute__ ((__packed__)) aic_block_t {
+	AIC_BLOCK_SYSTEM_PRE,
+	AIC_BLOCK_A_INST,
+	AIC_BLOCK_A_A_COEF,
+	AIC_BLOCK_A_B_COEF,
+	AIC_BLOCK_A_F_COEF,
+	AIC_BLOCK_D_INST,
+	AIC_BLOCK_D_A1_COEF,
+	AIC_BLOCK_D_B1_COEF,
+	AIC_BLOCK_D_A2_COEF,
+	AIC_BLOCK_D_B2_COEF,
+	AIC_BLOCK_D_F_COEF,
+	AIC_BLOCK_SYSTEM_POST,
+	AIC_BLOCK_N,
+	AIC_BLOCK_INVALID,
+};
+#define AIC_BLOCK_D_A_COEF AIC_BLOCK_D_A1_COEF
+#define AIC_BLOCK_D_B_COEF AIC_BLOCK_D_B1_COEF
+
+/**
+ * AIC Block
+ *
+ * A block of logically grouped sequences/commands/cmd-commands
+ *
+ */
+struct aic_block {
+	enum aic_block_t type;
+	int ncmds;
+	union aic_cmd cmd[];
+};
+#define AIC_BLOCK_SIZE(ncmds) (sizeof(struct aic_block) + \
+				((ncmds)*sizeof(union aic_cmd)))
+
+/**
+ * AIC Image
+ *
+ * A downloadable image
+ */
+struct aic_image {
+	char name[AIC_MAX_ID];	/**< Name of the pfw/overlay/configuration*/
+	char *desc;		/**< User string*/
+	int mute_flags;
+	struct aic_block *block[AIC_BLOCK_N];
+};
+
+
+
+/**
+ * AIC PLL
+ *
+ * PLL configuration sequence and match critirea
+ */
+struct aic_pll {
+	char name[AIC_MAX_ID];	/**< Name of the PLL sequence*/
+	char *desc;		/**< User string*/
+	struct aic_block *seq;
+};
+
+/**
+ * AIC Control
+ *
+ * Run-time control for a process flow
+ */
+struct aic_control {
+	char name[AIC_MAX_ID];	/**< Control identifier*/
+	char *desc;		/**< User string*/
+	int mute_flags;
+
+	int min;		/**< Min value of control (*100)*/
+	int max;		/**< Max  value of control (*100)*/
+	int step;		/**< Control step size (*100)*/
+
+	int imax;		/**< Max index into controls array*/
+	int ireset;		/**< Reset control to defaults*/
+	int icur;		/**< Last value set*/
+	struct aic_block **output;	/**< Array of sequences to send*/
+};
+
+/**
+ * Process flow
+ *
+ * Complete description of a process flow
+ */
+struct aic_pfw {
+	char name[AIC_MAX_ID];	/**< Name of the process flow*/
+	char *desc;		/**< User string*/
+	u32 version;
+	u8 prb_a;
+	u8 prb_d;
+	int novly;		/**< Number of overlays (1 or more)*/
+	int ncfg;		/**< Number of configurations (0 or more)*/
+	int nctrl;		/**< Number of run-time controls*/
+	struct aic_image *base;	/**< Base sequence*/
+	struct aic_image **ovly_cfg;	/**< Overlay and cfg*/
+					/**< patches (if any)*/
+	struct aic_control **ctrl;	/**< Array of run-time controls*/
+};
+
+#define AIC_OCFG_NDX(p, o, c) (((o)*(p)->ncfg)+(c))
+/**
+ * Process transition
+ *
+ * Sequence for specific state transisitions within the driver
+ *
+ */
+struct aic_transition {
+	char name[AIC_MAX_ID];	/**< Name of the transition*/
+	char *desc;		/**< User string*/
+	struct aic_block *block;
+};
+
+/**
+ * Device audio mode
+ *
+ * Link operating modes to process flows,
+ * configurations and sequences
+ *
+ */
+struct aic_mode {
+	char name[AIC_MAX_ID];
+	char *desc;		/**< User string*/
+	u32 flags;
+	u8 pfw;
+	u8 ovly;
+	u8 cfg;
+	u8 pll;
+	struct aic_block *entry;
+	struct aic_block *exit;
+};
+
+struct aic_asoc_toc_entry {
+	char etext[AIC_MAX_ID];
+	int mode;
+	int cfg;
+};
+
+struct aic_asoc_toc {
+	int nentries;
+	struct aic_asoc_toc_entry entry[];
+};
+
+/**
+ * AIC Project
+ *
+ * Top level structure describing the AIC project
+ */
+struct aic_project {
+	u32 magic;		/**< magic number for identifying F/W file*/
+	u32 if_id;		/**< Interface match code */
+	u32 size;		/**< Total size of the firmware (including this header)*/
+	u32 cksum;		/**< CRC32 of the pickled firmware */
+	u32 version;		/**< Firmware version (from CFD file)*/
+	u32 tstamp;		/**< Time stamp of firmware build (epoch seconds)*/
+	char name[AIC_MAX_ID];	/**< Project name*/
+	char *desc;		/**< User string*/
+	enum aic_dfamily dfamily;	/**< Device family*/
+	enum aic_device device;	/**< Device identifier*/
+	u32 flags;		/**< AIC flags*/
+
+	struct aic_transition **transition;	/**< Transition sequences*/
+
+	u16 npll;		/**< Number of PLL settings*/
+	struct aic_pll **pll;	/**< PLL settings*/
+
+	u16 npfw;		/**< Number of process flows*/
+	struct aic_pfw **pfw;	/**< Process flows*/
+
+	u16 nmode;		/**< Number of operating modes*/
+	struct aic_mode **mode;	/**< Modes*/
+
+	struct aic_asoc_toc *asoc_toc;	/**< list of amixer controls*/
+};
+
+
+/* @} */
+
+/* **AIC_INTERFACE_ID=0x3FA6D547** */
+
+#endif				/* AIC_FIRMWARE_H_ */
diff --git a/sound/soc/codecs/aic3xxx_cfw_ops.c b/sound/soc/codecs/aic3xxx_cfw_ops.c
new file mode 100644
index 0000000..79b975b
--- /dev/null
+++ b/sound/soc/codecs/aic3xxx_cfw_ops.c
@@ -0,0 +1,989 @@
+/*
+ * linux/sound/soc/codecs/aic3xxx/aic3xxx_cfw_ops.c
+ *
+ * Copyright (C) 2011 Texas Instruments Inc.,
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <linux/slab.h>
+#include <sound/tlv.h>
+
+#include "aic3xxx_cfw.h"
+#include "aic3xxx_cfw_ops.h"
+
+#define aic_warn(_cfw, fmt, ...)\
+	dev_warn(_cfw->dev, "AIC: " fmt, ##__VA_ARGS__)
+#define aic_error(_cfw, fmt, ...)\
+	dev_err(_cfw->dev, "AIC: " fmt, ##__VA_ARGS__)
+#define aic_dbg(_cfw, fmt, ...)\
+	dev_dbg(_cfw->dev, "AIC: " fmt, ##__VA_ARGS__)
+
+#if defined(CONFIG_MFD_AIC3111) || defined(CONFIG_AIC3111_CORE)
+
+#	define AIC3XXX_AIC_DEVICE "aic3111_cfw"
+#elif defined(CONFIG_MFD_AIC3256) || defined(CONFIG_AIC3256_CORE)
+
+#	define AIC3XXX_AIC_DEVICE "aic3256_cfw"
+#elif defined(CONFIG_MFD_AIC262) || defined(CONFIG_AIC3262_CORE)
+#	define AIC3XXX_AIC_DEVICE "aic3262_cfw"
+#else
+#	define AIC3XXX_AIC_DEVICE "aic3xxx_cfw"
+#endif
+
+/* **Code beyond this point is compilable on host** */
+
+/*
+ * Firmware version numbers are used to make sure that the
+ * host and target code stay in sync.  It is _not_ recommended
+ * to provide this number from the outside (E.g., from a makefile)
+ * Instead, a set of automated tools are relied upon to keep the numbers
+ * in sync at the time of host testing.
+ */
+#undef AIC_FW_IF_ID
+#define AIC_FW_IF_ID 0x3FA6D547
+static int aic_dlimage(struct aic_state *ps, struct aic_image *pim);
+static int aic_dlcfg(struct aic_state *ps, struct aic_image *pim);
+static int aic_dlctl(struct aic_state *ps, struct aic_block *pb,
+			     u32 mute_flags);
+
+static void aic_dlcmds(struct aic_state *ps, struct aic_block *pb);
+static int aic_set_mode_id(struct aic_state *ps);
+static int aic_mute(struct aic_state *ps, int mute, u32 flags);
+static int aic_setmode_cfg_u(struct aic_state *ps, int mode, int cfg);
+static int aic_setcfg_u(struct aic_state *ps, int cfg);
+static int aic_transition_u(struct aic_state *ps, char *ttype);
+static int aic_set_pll_u(struct aic_state *ps, int asi);
+static int aic_control_u(struct aic_state *ps, char *cname, int param);
+static struct aic_project *aic_unpickle(void *pcfw, int n);
+
+static void aic_wait(struct aic_state *ps, unsigned int reg, u8 mask,
+			 u8 data);
+static void aic_set_bits(u8 *data, u8 mask, u8 val);
+
+int aic_init(struct aic_state *ps, const struct aic3xxx_codec_ops *ops,
+	struct snd_soc_codec *codec)
+{
+	ps->ops = ops;
+	ps->codec = codec;
+	ps->pjt = NULL;
+	mutex_init(&ps->mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(aic_init);
+
+int aic_lock(struct aic_state *ps, int lock)
+{
+	if (lock)
+		mutex_lock(&ps->mutex);
+	else
+		mutex_unlock(&ps->mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(aic_lock);
+
+int aic_reload(struct aic_state *ps, void *pcfw, int n)
+{
+	ps->pjt = aic_unpickle(pcfw, n);
+	ps->cur_mode_id =
+	    ps->cur_mode = ps->cur_pll = ps->cur_pfw =
+	    ps->cur_ovly = ps->cur_cfg = -1;
+	if (ps->pjt == NULL) {
+		aic_error(ps, "version mismatch\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(aic_reload);
+
+int aic_setmode(struct aic_state *ps, int mode)
+{
+	struct aic_project *pjt;
+	int ret;
+
+	aic_lock(ps, 1);
+	pjt = ps->pjt;
+	if (pjt == NULL) {
+		aic_lock(ps, 0);
+		return -EINVAL;
+	}
+	ret = aic_setmode_cfg_u(ps, mode, pjt->mode[mode]->cfg);
+	aic_lock(ps, 0);
+	return ret;
+}
+
+int aic_setcfg(struct aic_state *ps, int cfg)
+{
+	int ret;
+
+	aic_lock(ps, 1);
+	ret = aic_setcfg_u(ps, cfg);
+	aic_lock(ps, 0);
+	return ret;
+}
+
+static int aic_setcfg_u(struct aic_state *ps, int cfg)
+{
+	struct aic_project *pjt = ps->pjt;
+	struct aic_pfw *pfw;
+	struct aic_image *patch;
+
+	if (pjt == NULL)
+		return -EINVAL;
+	if (ps->cur_pfw < 0 || ps->cur_pfw >= pjt->npfw)
+		return -EINVAL;	/* Non miniDSP */
+	if (ps->cur_cfg == cfg)
+		return 0;
+	pfw = pjt->pfw[ps->cur_pfw];
+	if (pfw->ncfg == 0 && cfg != 0)
+		return -EINVAL;
+	if (cfg > 0 && cfg >= pfw->ncfg)
+		return -EINVAL;
+	ps->cur_cfg = cfg;
+	aic_set_mode_id(ps);
+	patch =
+	    pfw->ovly_cfg[AIC_OCFG_NDX(pfw, ps->cur_ovly, ps->cur_cfg)];
+	if (pfw->ncfg != 0)
+		return aic_dlcfg(ps, patch);
+	return 0;
+}
+
+int aic_setmode_cfg(struct aic_state *ps, int mode, int cfg)
+{
+	int ret;
+
+	aic_lock(ps, 1);
+	ret = aic_setmode_cfg_u(ps, mode, cfg);
+	aic_lock(ps, 0);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(aic_setmode_cfg);
+
+static int aic_setmode_cfg_u(struct aic_state *ps, int mode, int cfg)
+{
+	struct aic_project *pjt = ps->pjt;
+	struct aic_mode *pmode;
+	int which = 0, ocndx;
+
+	if (pjt == NULL)
+		goto err;
+	if ((mode < 0) || (mode >= pjt->nmode))
+		goto err;
+	if (cfg < 0)
+		goto err;
+	if (mode == ps->cur_mode)
+		return aic_setcfg_u(ps, cfg);
+
+	/* Apply exit sequence for previous mode if present */
+	if (ps->cur_mode >= 0)
+		aic_dlcmds(ps, pjt->mode[ps->cur_mode]->exit);
+	pmode = pjt->mode[mode];
+	if (pjt->mode[mode]->pfw < pjt->npfw) { /* New mode uses miniDSP */
+		struct aic_image *im;
+		struct aic_pfw *pfw = pjt->pfw[pmode->pfw];
+
+		/* Make sure cfg is valid and supported in this mode */
+		if (pfw->ncfg == 0 && cfg != 0)
+			goto err;
+		if (cfg > 0 && cfg >= pfw->ncfg)
+			goto err;
+
+		/*
+		 * Decisions about which miniDSP to stop/restart are taken
+		 * on the basis of sections present in the _base_ image
+		 * This allows for correct sync mode operation even in cases
+		 * where the base PFW uses both miniDSPs where a particular
+		 * overlay applies only to one
+		 */
+		im = pfw->base;
+		if (im->block[AIC_BLOCK_A_INST])
+			which |= AIC3XXX_COPS_MDSP_A;
+		if (im->block[AIC_BLOCK_D_INST])
+			which |= AIC3XXX_COPS_MDSP_D;
+
+		if (pmode->pfw != ps->cur_pfw) {
+
+			/* New mode requires different PFW */
+			ps->cur_pfw = pmode->pfw;
+			ps->cur_ovly = 0;
+			ps->cur_cfg = 0;
+
+			which = ps->ops->stop(ps->codec, which);
+			aic_dlimage(ps, im);
+			if (pmode->ovly && pmode->ovly < pfw->novly) {
+
+				/* New mode uses ovly */
+				ocndx = AIC_OCFG_NDX(pfw, pmode->ovly, cfg);
+				aic_dlimage(ps,
+						    pfw->ovly_cfg[ocndx]);
+			} else if (pfw->ncfg > 0) {
+
+				/* new mode needs only a cfg change */
+				ocndx = AIC_OCFG_NDX(pfw, 0, cfg);
+				aic_dlimage(ps,
+						    pfw->ovly_cfg[ocndx]);
+			}
+			ps->ops->restore(ps->codec, which);
+
+		} else if (pmode->ovly != ps->cur_ovly) {
+
+			/* New mode requires only an ovly change */
+			ocndx = AIC_OCFG_NDX(pfw, pmode->ovly, cfg);
+			which = ps->ops->stop(ps->codec, which);
+			aic_dlimage(ps, pfw->ovly_cfg[ocndx]);
+			ps->ops->restore(ps->codec, which);
+		} else if (pfw->ncfg > 0 && cfg != ps->cur_cfg) {
+
+			/* New mode requires only a cfg change */
+			ocndx = AIC_OCFG_NDX(pfw, pmode->ovly, cfg);
+			aic_dlcfg(ps, pfw->ovly_cfg[ocndx]);
+		}
+		ps->cur_ovly = pmode->ovly;
+		ps->cur_cfg = cfg;
+
+		ps->cur_mode = mode;
+		aic_set_pll_u(ps, 0);
+
+	} else if (pjt->mode[mode]->pfw != 0xFF) {
+
+		/* Not bypass mode */
+		aic_warn(ps, "Bad pfw setting detected (%d).  Max pfw=%d",
+		     pmode->pfw, pjt->npfw);
+	}
+	ps->cur_mode = mode;
+	aic_set_mode_id(ps);
+
+	/* Transition to netural mode */
+	aic_transition_u(ps, "NEUTRAL");
+
+	/* Apply entry sequence if present */
+	aic_dlcmds(ps, pmode->entry);
+
+	aic_dbg(ps, "setmode_cfg: DONE (mode=%d pfw=%d ovly=%d cfg=%d)",
+	    ps->cur_mode, ps->cur_pfw, ps->cur_ovly, ps->cur_cfg);
+	return 0;
+
+err:
+	aic_dbg(ps, "Failed to set firmware mode");
+	return -EINVAL;
+}
+
+int aic_transition(struct aic_state *ps, char *ttype)
+{
+	int ret;
+
+	aic_lock(ps, 1);
+	ret = aic_transition_u(ps, ttype);
+	aic_lock(ps, 0);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(aic_transition);
+
+static int aic_transition_u(struct aic_state *ps, char *ttype)
+{
+	int i;
+
+	if (ps->pjt == NULL)
+		return -EINVAL;
+	for (i = 0; i < AIC_TRN_N; ++i) {
+		if (!strcasecmp(ttype, aic_transition_id[i])) {
+			struct aic_transition *pt = ps->pjt->transition[i];
+			aic_dbg(ps, "Sending transition %s[%d]", ttype, i);
+			if (pt)
+				aic_dlcmds(ps, pt->block);
+			return 0;
+		}
+	}
+	aic_warn(ps, "Transition %s not present or invalid", ttype);
+	return 0;
+}
+
+int aic_set_pll(struct aic_state *ps, int asi)
+{
+	int ret;
+
+	aic_lock(ps, 1);
+	ret = aic_set_pll_u(ps, asi);
+	aic_lock(ps, 0);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(aic_set_pll);
+
+static int aic_set_pll_u(struct aic_state *ps, int asi)
+{
+	struct aic_project *pjt = ps->pjt;
+	int pll_id;
+
+	if (pjt == NULL)
+		return -EINVAL;
+	if (ps->cur_mode < 0)
+		return -EINVAL;
+	pll_id = pjt->mode[ps->cur_mode]->pll;
+	if (ps->cur_pll != pll_id) {
+		aic_dbg(ps, "Re-configuring PLL: %s==>%d",
+			pjt->pll[pll_id]->name,
+			pll_id);
+		aic_dlcmds(ps, pjt->pll[pll_id]->seq);
+		ps->cur_pll = pll_id;
+	}
+	return 0;
+}
+
+int aic_control(struct aic_state *ps, char *cname, int param)
+{
+	int ret;
+
+	aic_lock(ps, 1);
+	ret = aic_control_u(ps, cname, param);
+	aic_lock(ps, 0);
+	return ret;
+}
+
+static int aic_control_u(struct aic_state *ps, char *cname, int param)
+{
+	struct aic_pfw *pfw;
+	int i;
+
+	if (ps->cur_pfw < 0 || ps->cur_pfw >= ps->pjt->npfw) {
+		aic_warn(ps, "Not in MiniDSP mode");
+		return 0;
+	}
+	pfw = ps->pjt->pfw[ps->cur_pfw];
+	for (i = 0; i < pfw->nctrl; ++i) {
+		struct aic_control *pc = pfw->ctrl[i];
+		if (strcasecmp(cname, pfw->ctrl[i]->name))
+			continue;
+		if (param < 0 || param > pc->imax) {
+			aic_warn(ps, "Parameter out of range\n");
+			return -EINVAL;
+		}
+		aic_dbg(ps, "Sending control %s[%d]", cname, param);
+		pc->icur = param;
+		aic_dlctl(ps, pc->output[param], pc->mute_flags);
+		return 0;
+	}
+	aic_warn(ps, "Control named %s not found in pfw %s", cname, pfw->name);
+
+	return -EINVAL;
+}
+
+static void aic_op(struct aic_state *ps, unsigned char *var,
+			   struct aic_cmd_op cmd)
+{
+	u32 op1, op2;
+	u32 cid = cmd.cid;
+
+	op1 = cmd.op1;
+	op2 = cmd.op2;
+	if (cid & AIC_CMD_OP1_ID)
+		op1 = var[op1];
+	if (cid & AIC_CMD_OP2_ID)
+		op2 = var[op2];
+	cid &= ~(AIC_CMD_OP1_ID | AIC_CMD_OP2_ID);
+
+	switch (cid) {
+	case AIC_CMD_OP_ADD:
+		var[cmd.dst] = op1 + op2;
+		break;
+	case AIC_CMD_OP_SUB:
+		var[cmd.dst] = op1 - op2;
+		break;
+	case AIC_CMD_OP_MUL:
+		var[cmd.dst] = op1 * op2;
+		break;
+	case AIC_CMD_OP_DIV:
+		var[cmd.dst] = op1 / op2;
+		break;
+	case AIC_CMD_OP_AND:
+		var[cmd.dst] = op1 & op2;
+		break;
+	case AIC_CMD_OP_OR:
+		var[cmd.dst] = op1 | op2;
+		break;
+	case AIC_CMD_OP_SHL:
+		var[cmd.dst] = (op1 << op2);
+		break;
+	case AIC_CMD_OP_SHR:
+		var[cmd.dst] = (op1 >> op2);
+		break;
+	case AIC_CMD_OP_RR:
+		while (op2--)
+			var[cmd.dst] = (op1 >> 1) | ((op1 & 1) << 7);
+		break;
+	case AIC_CMD_OP_XOR:
+		var[cmd.dst] = op1 ^ op2;
+		break;
+	case AIC_CMD_OP_NOT:
+		var[cmd.dst] = ~op1;
+		break;
+	case AIC_CMD_OP_LNOT:
+		var[cmd.dst] = !op1;
+		break;
+	default:
+		break;
+	}
+}
+
+static void aic_dlcmds(struct aic_state *ps, struct aic_block *pb)
+{
+	int pc = 0, cond = 0;
+	unsigned char var[256];
+
+	if (!pb)
+		return;
+	while (pc < pb->ncmds) {
+		union aic_cmd *c = &(pb->cmd[pc]);
+		if (c->cid != AIC_CMD_BRANCH_IM &&
+		    c->cid != AIC_CMD_BRANCH_ID && c->cid != AIC_CMD_NOP)
+			cond = 0;
+		switch (c->cid) {
+		case 0 ... (AIC_CMD_NOP - 1):
+			ps->ops->reg_write(ps->codec, c->reg.bpod,
+					   c->reg.data);
+			pc += 1;
+			break;
+		case AIC_CMD_NOP:
+			pc += 1;
+			break;
+		case AIC_CMD_DELAY:
+			mdelay(c->delay.delay);
+			pc += 1;
+			break;
+		case AIC_CMD_UPDTBITS:
+			ps->ops->set_bits(ps->codec, c[1].reg.bpod,
+					  c->bitop.mask, c[1].reg.data);
+			pc += 2;
+			break;
+		case AIC_CMD_WAITBITS:
+			aic_wait(ps, c[1].reg.bpod, c->bitop.mask,
+				     c[1].reg.data);
+			pc += 2;
+			break;
+		case AIC_CMD_LOCK:
+			if (c->delay.delay)
+				ps->ops->lock(ps->codec);
+			else
+				ps->ops->unlock(ps->codec);
+			pc += 1;
+			break;
+		case AIC_CMD_BURST:
+			ps->ops->bulk_write(ps->codec, c[1].reg.bpod,
+					    c->bhdr.len, c[1].burst.data);
+			pc += AIC_CMD_BURST_LEN(c->bhdr.len);
+			break;
+		case AIC_CMD_RBURST:
+			ps->ops->bulk_read(ps->codec, c[1].reg.bpod,
+					    c->bhdr.len, c[1].burst.data);
+			pc += AIC_CMD_BURST_LEN(c->bhdr.len);
+			break;
+		case AIC_CMD_LOAD_VAR_IM:
+			aic_set_bits(&var[c->ldst.dvar],
+					 c->ldst.mask, c->ldst.svar);
+			pc += 1;
+			break;
+		case AIC_CMD_LOAD_VAR_ID:
+			if (c->ldst.svar != c->ldst.dvar) {
+				aic_set_bits(&var[c->ldst.dvar],
+						 c->ldst.mask,
+						 var[c->ldst.svar]);
+				pc += 1;
+			} else {
+				u8 data;
+				data = ps->ops->reg_read(ps->codec,
+							c[1].reg.bpod);
+				aic_set_bits(&var[c->ldst.dvar],
+						 c->ldst.mask, data);
+				pc += 2;
+			}
+			break;
+		case AIC_CMD_STORE_VAR:
+			if (c->ldst.svar != c->ldst.dvar)
+				ps->ops->set_bits(ps->codec,
+						  c[1].reg.bpod,
+						  var[c->ldst.dvar],
+						  var[c->ldst.svar]);
+			else
+				ps->ops->set_bits(ps->codec,
+						  c[1].reg.bpod,
+						  c->ldst.mask,
+						  var[c->ldst.svar]);
+			pc += 2;
+			break;
+		case AIC_CMD_COND:
+			cond = var[c->cond.svar] & c->cond.mask;
+			pc += 1;
+			break;
+		case AIC_CMD_BRANCH:
+			pc = c->branch.address;
+			break;
+		case AIC_CMD_BRANCH_IM:
+			if (c->branch.match == cond)
+				pc = c->branch.address;
+			else
+				pc += 1;
+			break;
+		case AIC_CMD_BRANCH_ID:
+			if (var[c->branch.match] == cond)
+				pc = c->branch.address;
+			else
+				pc += 1;
+			break;
+		case AIC_CMD_PRINT:
+			{
+				union aic_cmd *parglist =
+				    c + AIC_CMD_PRINT_ARG(c->print);
+				printk(c->print.fmt,
+				     var[parglist->print_arg[0]],
+				     var[parglist->print_arg[1]],
+				     var[parglist->print_arg[2]],
+				     var[parglist->print_arg[3]]);
+				pc += AIC_CMD_PRINT_LEN(c->print);
+			}
+			break;
+		case AIC_CMD_OP_START ... AIC_CMD_OP_END:
+			aic_op(ps, var, c->op);
+			pc += 1;
+			break;
+		default:
+			aic_warn(ps, "Unknown cmd command %x. Skipped", c->cid);
+			pc += 1;
+			break;
+		}
+	}
+}
+
+static void aic_wait(struct aic_state *ps, unsigned int reg, u8 mask,
+			 u8 data)
+{
+	while ((ps->ops->reg_read(ps->codec, reg) & mask) != data)
+		usleep_range(500, 1000);
+}
+
+static inline void aic_set_bits(u8 *data, u8 mask, u8 val)
+{
+	*data = (*data & (~mask)) | (val & mask);
+}
+
+static const struct {
+	u32 mdsp;
+	int buf_a, buf_b;
+	u32 swap;
+} csecs[] = {
+	{
+		.mdsp = AIC3XXX_COPS_MDSP_A,
+		.swap = AIC3XXX_ABUF_MDSP_A,
+		.buf_a = AIC_BLOCK_A_A_COEF,
+		.buf_b = AIC_BLOCK_A_B_COEF
+	},
+	{
+		.mdsp = AIC3XXX_COPS_MDSP_D,
+		.swap = AIC3XXX_ABUF_MDSP_D1,
+		.buf_a = AIC_BLOCK_D_A1_COEF,
+		.buf_b = AIC_BLOCK_D_B1_COEF
+	},
+	{
+		.mdsp = AIC3XXX_COPS_MDSP_D,
+		.swap = AIC3XXX_ABUF_MDSP_D2,
+		.buf_a = AIC_BLOCK_D_A2_COEF,
+		.buf_b = AIC_BLOCK_D_B2_COEF
+	},
+};
+static int aic_dlctl(struct aic_state *ps, struct aic_block *pb,
+			     u32 mute_flags)
+{
+	int i, btype = pb->type;
+	int run_state = ps->ops->lock(ps->codec);
+
+	aic_dbg(ps, "Download CTL");
+	for (i = 0; i < sizeof(csecs) / sizeof(csecs[0]); ++i) {
+		if (csecs[i].buf_a != btype && csecs[i].buf_b != btype)
+			continue;
+		aic_dbg(ps, "\tDownload once to %d\n", btype);
+		aic_dlcmds(ps, pb);
+		if (run_state & csecs[i].mdsp) {
+			aic_dbg(ps, "Download again to make sure it reaches B");
+			aic_mute(ps, 1, run_state & mute_flags);
+			ps->ops->bswap(ps->codec, csecs[i].swap);
+			aic_mute(ps, 0, run_state & mute_flags);
+			aic_dlcmds(ps, pb);
+		}
+		break;
+	}
+	ps->ops->unlock(ps->codec);
+	return 0;
+}
+
+static int aic_dlcfg(struct aic_state *ps, struct aic_image *pim)
+{
+	int i, run_state, swap;
+
+	aic_dbg(ps, "Download CFG %s", pim->name);
+	run_state = ps->ops->lock(ps->codec);
+	swap = 0;
+	for (i = 0; i < sizeof(csecs) / sizeof(csecs[0]); ++i) {
+		if (!pim->block[csecs[i].buf_a])
+			continue;
+		aic_dlcmds(ps, pim->block[csecs[i].buf_a]);
+		aic_dlcmds(ps, pim->block[csecs[i].buf_b]);
+		if (run_state & csecs[i].mdsp)
+			swap |= csecs[i].swap;
+	}
+	if (swap) {
+		aic_mute(ps, 1, run_state & pim->mute_flags);
+		ps->ops->bswap(ps->codec, swap);
+		aic_mute(ps, 0, run_state & pim->mute_flags);
+		for (i = 0; i < sizeof(csecs) / sizeof(csecs[0]); ++i) {
+			if (!pim->block[csecs[i].buf_a])
+				continue;
+			if (!(run_state & csecs[i].mdsp))
+				continue;
+			aic_dlcmds(ps, pim->block[csecs[i].buf_a]);
+			aic_dlcmds(ps, pim->block[csecs[i].buf_b]);
+		}
+	}
+	ps->ops->unlock(ps->codec);
+	return 0;
+}
+
+static int aic_dlimage(struct aic_state *ps, struct aic_image *pim)
+{
+	int i;
+
+	if (!pim)
+		return 0;
+	aic_dbg(ps, "Download IMAGE %s", pim->name);
+	for (i = 0; i < AIC_BLOCK_N; ++i)
+		aic_dlcmds(ps, pim->block[i]);
+	return 0;
+}
+
+static int aic_mute(struct aic_state *ps, int mute, u32 flags)
+{
+	if ((flags & AIC3XXX_COPS_MDSP_D) && (flags & AIC3XXX_COPS_MDSP_A))
+		aic_transition_u(ps,
+					 mute ? "AD_MUTE" : "AD_UNMUTE");
+	else if (flags & AIC3XXX_COPS_MDSP_D)
+		aic_transition_u(ps, mute ? "D_MUTE" : "D_UNMUTE");
+	else if (flags & AIC3XXX_COPS_MDSP_A)
+		aic_transition_u(ps, mute ? "A_MUTE" : "A_UNMUTE");
+	return 0;
+}
+
+static inline void *aic_ndx2ptr(void *p, u8 *base)
+{
+	return &base[(int)p];
+}
+static inline char *aic_desc(void *p, u8 *base)
+{
+	if (p)
+		return aic_ndx2ptr(p, base);
+	return NULL;
+}
+
+static void aic_unpickle_image(struct aic_image *im, void *p)
+{
+	int i;
+
+	im->desc = aic_desc(im->desc, p);
+	for (i = 0; i < AIC_BLOCK_N; ++i)
+		if (im->block[i])
+			im->block[i] = aic_ndx2ptr(im->block[i], p);
+}
+
+static void aic_unpickle_control(struct aic_control *ct, void *p)
+{
+	int i;
+
+	ct->output = aic_ndx2ptr(ct->output, p);
+	ct->desc = aic_desc(ct->desc, p);
+	for (i = 0; i <= ct->imax; ++i)
+		ct->output[i] = aic_ndx2ptr(ct->output[i], p);
+}
+
+static struct aic_project *aic_unpickle(void *p, int n)
+{
+	struct aic_project *pjt = p;
+	int i, j;
+
+	if (pjt->magic != AIC_FW_MAGIC || pjt->size != n ||
+	    pjt->if_id != AIC_FW_IF_ID) {
+		return NULL;
+	}
+
+	pjt->desc = aic_desc(pjt->desc, p);
+	pjt->transition = aic_ndx2ptr(pjt->transition, p);
+	for (i = 0; i < AIC_TRN_N; i++) {
+		if (!pjt->transition[i])
+			continue;
+		pjt->transition[i] = aic_ndx2ptr(pjt->transition[i], p);
+		pjt->transition[i]->desc = aic_desc(
+						pjt->transition[i]->desc, p);
+		pjt->transition[i]->block = aic_ndx2ptr(
+						pjt->transition[i]->block, p);
+	}
+	pjt->pll = aic_ndx2ptr(pjt->pll, p);
+	for (i = 0; i < pjt->npll; i++) {
+		pjt->pll[i] = aic_ndx2ptr(pjt->pll[i], p);
+		pjt->pll[i]->desc = aic_desc(pjt->pll[i]->desc, p);
+		pjt->pll[i]->seq = aic_ndx2ptr(pjt->pll[i]->seq, p);
+	}
+
+	pjt->pfw = aic_ndx2ptr(pjt->pfw, p);
+	for (i = 0; i < pjt->npfw; i++) {
+		pjt->pfw[i] = aic_ndx2ptr(pjt->pfw[i], p);
+		pjt->pfw[i]->desc = aic_desc(pjt->pfw[i]->desc, p);
+		if (pjt->pfw[i]->base) {
+			pjt->pfw[i]->base = aic_ndx2ptr(
+							pjt->pfw[i]->base, p);
+			aic_unpickle_image(pjt->pfw[i]->base, p);
+		}
+		pjt->pfw[i]->ovly_cfg = aic_ndx2ptr(
+						pjt->pfw[i]->ovly_cfg, p);
+		for (j = 0; j < pjt->pfw[i]->novly * pjt->pfw[i]->ncfg; ++j) {
+			pjt->pfw[i]->ovly_cfg[j] = aic_ndx2ptr(
+						pjt->pfw[i]->ovly_cfg[j], p);
+			aic_unpickle_image(pjt->pfw[i]->ovly_cfg[j], p);
+		}
+		if (pjt->pfw[i]->nctrl)
+			pjt->pfw[i]->ctrl = aic_ndx2ptr(
+							pjt->pfw[i]->ctrl, p);
+		for (j = 0; j < pjt->pfw[i]->nctrl; ++j) {
+			pjt->pfw[i]->ctrl[j] = aic_ndx2ptr(
+						pjt->pfw[i]->ctrl[j], p);
+			aic_unpickle_control(pjt->pfw[i]->ctrl[j], p);
+		}
+	}
+
+	pjt->mode = aic_ndx2ptr(pjt->mode, p);
+	for (i = 0; i < pjt->nmode; i++) {
+		pjt->mode[i] = aic_ndx2ptr(pjt->mode[i], p);
+		pjt->mode[i]->desc = aic_desc(pjt->mode[i]->desc, p);
+		if (pjt->mode[i]->entry)
+			pjt->mode[i]->entry = aic_ndx2ptr(
+						pjt->mode[i]->entry, p);
+		if (pjt->mode[i]->exit)
+			pjt->mode[i]->exit = aic_ndx2ptr(
+						pjt->mode[i]->exit, p);
+	}
+	if (pjt->asoc_toc)
+		pjt->asoc_toc = aic_ndx2ptr(pjt->asoc_toc, p);
+	else
+		return NULL;
+
+	return pjt;
+}
+static int aic_set_mode_id(struct aic_state *ps)
+{
+	struct aic_asoc_toc *toc = ps->pjt->asoc_toc;
+	int i;
+
+	for (i = 0; i < toc->nentries; ++i) {
+		if (toc->entry[i].cfg == ps->cur_cfg &&
+		    toc->entry[i].mode == ps->cur_mode) {
+			ps->cur_mode_id = i;
+			return 0;
+		}
+	}
+	aic_dbg(ps, "Unknown mode,cfg combination [%d,%d]", ps->cur_mode,
+	    ps->cur_cfg);
+	return -EINVAL;
+}
+
+/* **Code beyond this point is not compilable on host** */
+
+static int aic3xxx_get_control(struct snd_kcontrol *kcontrol,
+			       struct snd_ctl_elem_value *ucontrol)
+{
+	struct aic_state *ps = (struct aic_state *)kcontrol->private_value;
+	struct aic_pfw *pfw;
+	int i;
+
+	if (ps->cur_pfw >= ps->pjt->npfw) {
+		aic_dbg(ps, "Not in MiniDSP mode");
+		return 0;
+	}
+	pfw = ps->pjt->pfw[ps->cur_pfw];
+	for (i = 0; i < pfw->nctrl; ++i) {
+		if (!strcasecmp(kcontrol->id.name, pfw->ctrl[i]->name)) {
+			struct aic_control *pc = pfw->ctrl[i];
+			ucontrol->value.integer.value[0] = pc->icur;
+			return 0;
+		}
+	}
+	return 0;
+}
+
+static int aic3xxx_put_control(struct snd_kcontrol *kcontrol,
+			       struct snd_ctl_elem_value *ucontrol)
+{
+	struct aic_state *ps = (struct aic_state *)kcontrol->private_value;
+
+	aic_control(ps, kcontrol->id.name,
+			    ucontrol->value.integer.value[0]);
+	return 0;
+}
+
+static int aic3xxx_info_control(struct snd_kcontrol *kcontrol,
+				struct snd_ctl_elem_info *ucontrol)
+{
+	struct aic_state *ps = (struct aic_state *)kcontrol->private_value;
+	struct aic_pfw *pfw;
+	int i;
+
+	if (ps->cur_pfw >= ps->pjt->npfw) {
+		aic_dbg(ps, "Not in MiniDSP mode");
+		return 0;
+	}
+	pfw = ps->pjt->pfw[ps->cur_pfw];
+	for (i = 0; i < pfw->nctrl; ++i) {
+		if (!strcasecmp(kcontrol->id.name, pfw->ctrl[i]->name)) {
+			struct aic_control *pc = pfw->ctrl[i];
+			ucontrol->value.integer.min = 0;
+			ucontrol->value.integer.max = pc->imax;
+			if (pc->imax == 1)
+				ucontrol->type = SNDRV_CTL_ELEM_TYPE_BOOLEAN;
+			else
+				ucontrol->type = SNDRV_CTL_ELEM_TYPE_INTEGER;
+		}
+	}
+
+	ucontrol->count = 1;
+	return 0;
+}
+int aic_add_controls(struct snd_soc_codec *codec, struct aic_state *ps)
+{
+	int i, j;
+	struct aic_pfw *pfw;
+
+	for (j = 0; j < ps->pjt->npfw; ++j) {
+		pfw = ps->pjt->pfw[j];
+
+		for (i = 0; i < pfw->nctrl; ++i) {
+			struct aic_control *pc = pfw->ctrl[i];
+			struct snd_kcontrol_new *generic_control =
+			    devm_kzalloc(codec->dev,
+					sizeof(struct snd_kcontrol_new),
+					GFP_KERNEL);
+			unsigned int *tlv_array =
+			    devm_kzalloc(codec->dev,
+					4 * sizeof(unsigned int), GFP_KERNEL);
+
+			if (generic_control == NULL)
+				return -ENOMEM;
+			generic_control->access =
+			    SNDRV_CTL_ELEM_ACCESS_TLV_READ |
+			    SNDRV_CTL_ELEM_ACCESS_READWRITE;
+			tlv_array[0] = SNDRV_CTL_TLVT_DB_SCALE;
+			tlv_array[1] = 2 * sizeof(unsigned int);
+			tlv_array[2] = pc->min;
+			tlv_array[3] = ((pc->step) & TLV_DB_SCALE_MASK);
+			if (pc->step > 0)
+				generic_control->tlv.p = tlv_array;
+			generic_control->name = pc->name;
+			generic_control->private_value = (unsigned long) ps;
+			generic_control->get = aic3xxx_get_control;
+			generic_control->put = aic3xxx_put_control;
+			generic_control->info = aic3xxx_info_control;
+			generic_control->iface = SNDRV_CTL_ELEM_IFACE_MIXER;
+			snd_soc_add_codec_controls(codec, generic_control, 1);
+			aic_dbg(ps, "Added control %s", pc->name);
+		}
+	}
+	return 0;
+
+}
+EXPORT_SYMBOL_GPL(aic_add_controls);
+
+static int aic3xxx_get_mode(struct snd_kcontrol *kcontrol,
+			    struct snd_ctl_elem_value *ucontrol)
+{
+	struct soc_enum *e = (struct soc_enum *) kcontrol->private_value;
+	struct aic_state *ps = (struct aic_state *) e->mask;
+
+	ucontrol->value.enumerated.item[0] = ps->cur_mode_id;
+
+	return 0;
+}
+
+static int aic3xxx_put_mode(struct snd_kcontrol *kcontrol,
+			    struct snd_ctl_elem_value *ucontrol)
+{
+	struct soc_enum *e = (struct soc_enum *) kcontrol->private_value;
+	struct aic_state *ps = (struct aic_state *) e->mask;
+	struct aic_asoc_toc *toc;
+	int index, ret;
+
+	aic_lock(ps, 1);
+	toc = ps->pjt->asoc_toc;
+
+	index = ucontrol->value.enumerated.item[0];
+	if (index < 0 || index >= toc->nentries) {
+		aic_lock(ps, 0);
+		return -EINVAL;
+	}
+	ret = aic_setmode_cfg_u(ps, toc->entry[index].mode,
+				      toc->entry[index].cfg);
+	aic_lock(ps, 0);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(aic3xxx_put_mode);
+
+int aic_add_modes(struct snd_soc_codec *codec, struct aic_state *ps)
+{
+	int j;
+	struct aic_asoc_toc *toc = ps->pjt->asoc_toc;
+	struct soc_enum *mode_cfg_enum =
+	    devm_kzalloc(codec->dev, sizeof(struct soc_enum), GFP_KERNEL);
+	struct snd_kcontrol_new *mode_cfg_control =
+	    devm_kzalloc(codec->dev, sizeof(struct snd_kcontrol_new),
+			GFP_KERNEL);
+
+	if (mode_cfg_enum == NULL)
+		goto mem_err;
+	if (mode_cfg_control == NULL)
+		goto mem_err;
+
+	mode_cfg_enum->dtexts = devm_kzalloc(codec->dev,
+					    toc->nentries * sizeof(char *),
+					    GFP_KERNEL);
+	if (mode_cfg_enum->dtexts == NULL)
+		goto mem_err;
+
+	for (j = 0; j < toc->nentries; j++)
+		mode_cfg_enum->dtexts[j] = toc->entry[j].etext;
+
+	mode_cfg_enum->reg = j;
+	mode_cfg_enum->max = toc->nentries;
+	mode_cfg_enum->mask = (unsigned int) ps;
+	mode_cfg_control->name = "Codec Firmware Setmode";
+	mode_cfg_control->get = aic3xxx_get_mode;
+	mode_cfg_control->put = aic3xxx_put_mode;
+	mode_cfg_control->info = snd_soc_info_enum_ext;
+	mode_cfg_control->private_value = (unsigned long) mode_cfg_enum;
+	mode_cfg_control->iface = SNDRV_CTL_ELEM_IFACE_MIXER;
+	snd_soc_add_codec_controls(codec, mode_cfg_control, 1);
+	return 0;
+mem_err:
+	kfree(mode_cfg_control);
+	kfree(mode_cfg_enum);
+	kfree(mode_cfg_enum->texts);
+	return -ENOMEM;
+
+}
+EXPORT_SYMBOL_GPL(aic_add_modes);
+
+MODULE_AUTHOR("Hari Rajagopala <harik@ti.com>");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/aic3xxx_cfw_ops.h b/sound/soc/codecs/aic3xxx_cfw_ops.h
new file mode 100644
index 0000000..6a600fb
--- /dev/null
+++ b/sound/soc/codecs/aic3xxx_cfw_ops.h
@@ -0,0 +1,98 @@
+/*
+ * aic3xxx_cfw_ops.h  --  SoC audio for TI OMAP44XX SDP
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef AIC3XXX_CFW_OPS_H_
+#define AIC3XXX_CFW_OPS_H_
+
+#include <linux/mutex.h>
+#include <sound/soc.h>
+#include <linux/cdev.h>
+
+struct aic_project;
+struct aic3xxx_codec_ops;
+
+struct aic_state {
+	const char *dev_name;
+	int version;
+	struct aic_project *pjt;
+	const struct aic3xxx_codec_ops  *ops;
+	struct snd_soc_codec *codec;
+	struct device *dev;
+	struct mutex mutex;
+	int cur_mode_id;
+	int cur_pll;
+	int cur_mode;
+	int cur_pfw;
+	int cur_ovly;
+	int cur_cfg;
+	struct cdev cdev;
+	int is_open;
+};
+
+int aic_init(struct aic_state *ps, const struct aic3xxx_codec_ops *ops,
+		     struct snd_soc_codec *codec);
+int aic_lock(struct aic_state *ps, int lock);
+int aic_reload(struct aic_state *ps, void *pcfw, int n);
+int aic_setmode(struct aic_state *ps, int mode);
+int aic_setmode_cfg(struct aic_state *ps, int mode, int cfg);
+int aic_setcfg(struct aic_state *ps, int cfg);
+int aic_transition(struct aic_state *ps, char *ttype);
+int aic_set_pll(struct aic_state *ps, int asi);
+int aic_control(struct aic_state *ps, char *cname, int param);
+int aic_add_controls(struct snd_soc_codec *codec, struct aic_state *ps);
+int aic_add_modes(struct snd_soc_codec *codec, struct aic_state *ps);
+
+
+#define AIC3XXX_COPS_MDSP_D_L    (0x00000002u)
+#define AIC3XXX_COPS_MDSP_D_R    (0x00000001u)
+#define AIC3XXX_COPS_MDSP_D      (AIC3XXX_COPS_MDSP_D_L|AIC3XXX_COPS_MDSP_D_R)
+
+#define AIC3XXX_COPS_MDSP_A_L    (0x00000020u)
+#define AIC3XXX_COPS_MDSP_A_R    (0x00000010u)
+#define AIC3XXX_COPS_MDSP_A      (AIC3XXX_COPS_MDSP_A_L|AIC3XXX_COPS_MDSP_A_R)
+
+#define AIC3XXX_COPS_MDSP_ALL    (AIC3XXX_COPS_MDSP_D|AIC3XXX_COPS_MDSP_A)
+
+#define AIC3XXX_ABUF_MDSP_D1 (0x00000001u)
+#define AIC3XXX_ABUF_MDSP_D2 (0x00000002u)
+#define AIC3XXX_ABUF_MDSP_A  (0x00000010u)
+#define AIC3XXX_ABUF_MDSP_ALL \
+		(AIC3XXX_ABUF_MDSP_D1|AIC3XXX_ABUF_MDSP_D2|AIC3XXX_ABUF_MDSP_A)
+
+
+struct aic3xxx_codec_ops {
+	int (*reg_read) (struct snd_soc_codec *codec, unsigned int reg);
+	int (*reg_write) (struct snd_soc_codec *codec, unsigned int reg,
+					unsigned char val);
+	int (*set_bits) (struct snd_soc_codec *codec, unsigned int reg,
+					unsigned char mask, unsigned char val);
+	int (*bulk_read) (struct snd_soc_codec *codec, unsigned int reg,
+					int count, u8 *buf);
+	int (*bulk_write) (struct snd_soc_codec *codec, unsigned int reg,
+					int count, const u8 *buf);
+	int (*lock) (struct snd_soc_codec *codec);
+	int (*unlock) (struct snd_soc_codec *codec);
+	int (*stop) (struct snd_soc_codec *codec, int mask);
+	int (*restore) (struct snd_soc_codec *codec, int runstate);
+	int (*bswap) (struct snd_soc_codec *codec, int mask);
+};
+
+MODULE_LICENSE("GPL");
+
+#endif
-- 
1.7.0.4

