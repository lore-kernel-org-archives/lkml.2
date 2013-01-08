Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3AHVNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:13:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:63355 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab3AHVID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243604955"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 06/21] mei: rename interface to hw-me
Date: Tue,  8 Jan 2013 23:07:17 +0200
Message-Id: <1357679252-12958-7-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename hw-me.h to hw-me-regs.h as this file
contains only register definitions.
Files hw-me.[ch] now contains ME hw dependant
functionality

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/Makefile                 |    2 +-
 drivers/misc/mei/amthif.c                 |    2 +-
 drivers/misc/mei/client.c                 |    1 -
 drivers/misc/mei/hbm.c                    |    2 +-
 drivers/misc/mei/hw-me-regs.h             |  167 ++++++++++++++++++++++++++
 drivers/misc/mei/{interface.c => hw-me.c} |    2 +-
 drivers/misc/mei/hw-me.h                  |  181 +++++-----------------------
 drivers/misc/mei/init.c                   |    1 -
 drivers/misc/mei/interface.h              |   52 --------
 drivers/misc/mei/interrupt.c              |    2 +-
 drivers/misc/mei/main.c                   |    2 +-
 drivers/misc/mei/mei_dev.h                |    2 +-
 drivers/misc/mei/wd.c                     |    2 +-
 13 files changed, 208 insertions(+), 210 deletions(-)
 create mode 100644 drivers/misc/mei/hw-me-regs.h
 rename drivers/misc/mei/{interface.c => hw-me.c} (99%)
 delete mode 100644 drivers/misc/mei/interface.h

diff --git a/drivers/misc/mei/Makefile b/drivers/misc/mei/Makefile
index 67f543a..9f71933 100644
--- a/drivers/misc/mei/Makefile
+++ b/drivers/misc/mei/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_INTEL_MEI) += mei.o
 mei-objs := init.o
 mei-objs += hbm.o
 mei-objs += interrupt.o
-mei-objs += interface.o
+mei-objs += hw-me.o
 mei-objs += main.o
 mei-objs += amthif.o
 mei-objs += wd.o
diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index cbc9c4e..adc4120 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -35,7 +35,7 @@
 
 #include "mei_dev.h"
 #include "hbm.h"
-#include "interface.h"
+#include "hw-me.h"
 #include "client.h"
 
 const uuid_le mei_amthi_guid  = UUID_LE(0x12f80028, 0xb4b7, 0x4b2d, 0xac,
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index cc3e76c..e2e9cb7 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -23,7 +23,6 @@
 
 #include "mei_dev.h"
 #include "hbm.h"
-#include "interface.h"
 #include "client.h"
 
 /**
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 9956aaf..f0c3fc4 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -21,7 +21,7 @@
 
 #include "mei_dev.h"
 #include "hbm.h"
-#include "interface.h"
+#include "hw-me.h"
 
 /**
  * mei_hbm_cl_hdr - construct client hbm header
diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
new file mode 100644
index 0000000..6a203b6
--- /dev/null
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -0,0 +1,167 @@
+/******************************************************************************
+ * Intel Management Engine Interface (Intel MEI) Linux driver
+ * Intel MEI Interface Header
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *	Intel Corporation.
+ *	linux-mei@linux.intel.com
+ *	http://www.intel.com
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+#ifndef _MEI_HW_MEI_REGS_H_
+#define _MEI_HW_MEI_REGS_H_
+
+/*
+ * MEI device IDs
+ */
+#define MEI_DEV_ID_82946GZ    0x2974  /* 82946GZ/GL */
+#define MEI_DEV_ID_82G35      0x2984  /* 82G35 Express */
+#define MEI_DEV_ID_82Q965     0x2994  /* 82Q963/Q965 */
+#define MEI_DEV_ID_82G965     0x29A4  /* 82P965/G965 */
+
+#define MEI_DEV_ID_82GM965    0x2A04  /* Mobile PM965/GM965 */
+#define MEI_DEV_ID_82GME965   0x2A14  /* Mobile GME965/GLE960 */
+
+#define MEI_DEV_ID_ICH9_82Q35 0x29B4  /* 82Q35 Express */
+#define MEI_DEV_ID_ICH9_82G33 0x29C4  /* 82G33/G31/P35/P31 Express */
+#define MEI_DEV_ID_ICH9_82Q33 0x29D4  /* 82Q33 Express */
+#define MEI_DEV_ID_ICH9_82X38 0x29E4  /* 82X38/X48 Express */
+#define MEI_DEV_ID_ICH9_3200  0x29F4  /* 3200/3210 Server */
+
+#define MEI_DEV_ID_ICH9_6     0x28B4  /* Bearlake */
+#define MEI_DEV_ID_ICH9_7     0x28C4  /* Bearlake */
+#define MEI_DEV_ID_ICH9_8     0x28D4  /* Bearlake */
+#define MEI_DEV_ID_ICH9_9     0x28E4  /* Bearlake */
+#define MEI_DEV_ID_ICH9_10    0x28F4  /* Bearlake */
+
+#define MEI_DEV_ID_ICH9M_1    0x2A44  /* Cantiga */
+#define MEI_DEV_ID_ICH9M_2    0x2A54  /* Cantiga */
+#define MEI_DEV_ID_ICH9M_3    0x2A64  /* Cantiga */
+#define MEI_DEV_ID_ICH9M_4    0x2A74  /* Cantiga */
+
+#define MEI_DEV_ID_ICH10_1    0x2E04  /* Eaglelake */
+#define MEI_DEV_ID_ICH10_2    0x2E14  /* Eaglelake */
+#define MEI_DEV_ID_ICH10_3    0x2E24  /* Eaglelake */
+#define MEI_DEV_ID_ICH10_4    0x2E34  /* Eaglelake */
+
+#define MEI_DEV_ID_IBXPK_1    0x3B64  /* Calpella */
+#define MEI_DEV_ID_IBXPK_2    0x3B65  /* Calpella */
+
+#define MEI_DEV_ID_CPT_1      0x1C3A  /* Couger Point */
+#define MEI_DEV_ID_PBG_1      0x1D3A  /* C600/X79 Patsburg */
+
+#define MEI_DEV_ID_PPT_1      0x1E3A  /* Panther Point */
+#define MEI_DEV_ID_PPT_2      0x1CBA  /* Panther Point */
+#define MEI_DEV_ID_PPT_3      0x1DBA  /* Panther Point */
+
+#define MEI_DEV_ID_LPT        0x8C3A  /* Lynx Point */
+#define MEI_DEV_ID_LPT_LP     0x9C3A  /* Lynx Point LP */
+/*
+ * MEI HW Section
+ */
+
+/* MEI registers */
+/* H_CB_WW - Host Circular Buffer (CB) Write Window register */
+#define H_CB_WW    0
+/* H_CSR - Host Control Status register */
+#define H_CSR      4
+/* ME_CB_RW - ME Circular Buffer Read Window register (read only) */
+#define ME_CB_RW   8
+/* ME_CSR_HA - ME Control Status Host Access register (read only) */
+#define ME_CSR_HA  0xC
+
+
+/* register bits of H_CSR (Host Control Status register) */
+/* Host Circular Buffer Depth - maximum number of 32-bit entries in CB */
+#define H_CBD             0xFF000000
+/* Host Circular Buffer Write Pointer */
+#define H_CBWP            0x00FF0000
+/* Host Circular Buffer Read Pointer */
+#define H_CBRP            0x0000FF00
+/* Host Reset */
+#define H_RST             0x00000010
+/* Host Ready */
+#define H_RDY             0x00000008
+/* Host Interrupt Generate */
+#define H_IG              0x00000004
+/* Host Interrupt Status */
+#define H_IS              0x00000002
+/* Host Interrupt Enable */
+#define H_IE              0x00000001
+
+
+/* register bits of ME_CSR_HA (ME Control Status Host Access register) */
+/* ME CB (Circular Buffer) Depth HRA (Host Read Access) - host read only
+access to ME_CBD */
+#define ME_CBD_HRA        0xFF000000
+/* ME CB Write Pointer HRA - host read only access to ME_CBWP */
+#define ME_CBWP_HRA       0x00FF0000
+/* ME CB Read Pointer HRA - host read only access to ME_CBRP */
+#define ME_CBRP_HRA       0x0000FF00
+/* ME Reset HRA - host read only access to ME_RST */
+#define ME_RST_HRA        0x00000010
+/* ME Ready HRA - host read only access to ME_RDY */
+#define ME_RDY_HRA        0x00000008
+/* ME Interrupt Generate HRA - host read only access to ME_IG */
+#define ME_IG_HRA         0x00000004
+/* ME Interrupt Status HRA - host read only access to ME_IS */
+#define ME_IS_HRA         0x00000002
+/* ME Interrupt Enable HRA - host read only access to ME_IE */
+#define ME_IE_HRA         0x00000001
+
+#endif /* _MEI_HW_MEI_REGS_H_ */
diff --git a/drivers/misc/mei/interface.c b/drivers/misc/mei/hw-me.c
similarity index 99%
rename from drivers/misc/mei/interface.c
rename to drivers/misc/mei/hw-me.c
index 3cb0cff..4e6b657 100644
--- a/drivers/misc/mei/interface.c
+++ b/drivers/misc/mei/hw-me.c
@@ -18,7 +18,7 @@
 #include <linux/mei.h>
 
 #include "mei_dev.h"
-#include "interface.h"
+#include "hw-me.h"
 
 /**
  * mei_reg_read - Reads 32bit data from the mei device
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index a42b2a2..73bef54 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -1,167 +1,52 @@
-/******************************************************************************
- * Intel Management Engine Interface (Intel MEI) Linux driver
- * Intel MEI Interface Header
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * Contact Information:
- *	Intel Corporation.
- *	linux-mei@linux.intel.com
- *	http://www.intel.com
- *
- * BSD LICENSE
- *
- * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
- * All rights reserved.
+/*
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
+ * Intel Management Engine Interface (Intel MEI) Linux driver
+ * Copyright (c) 2003-2012, Intel Corporation.
  *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
  *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
  *
- *****************************************************************************/
-#ifndef _MEI_HW_MEI_H_
-#define _MEI_HW_MEI_H_
-
-/*
- * MEI device IDs
  */
-#define MEI_DEV_ID_82946GZ    0x2974  /* 82946GZ/GL */
-#define MEI_DEV_ID_82G35      0x2984  /* 82G35 Express */
-#define MEI_DEV_ID_82Q965     0x2994  /* 82Q963/Q965 */
-#define MEI_DEV_ID_82G965     0x29A4  /* 82P965/G965 */
-
-#define MEI_DEV_ID_82GM965    0x2A04  /* Mobile PM965/GM965 */
-#define MEI_DEV_ID_82GME965   0x2A14  /* Mobile GME965/GLE960 */
 
-#define MEI_DEV_ID_ICH9_82Q35 0x29B4  /* 82Q35 Express */
-#define MEI_DEV_ID_ICH9_82G33 0x29C4  /* 82G33/G31/P35/P31 Express */
-#define MEI_DEV_ID_ICH9_82Q33 0x29D4  /* 82Q33 Express */
-#define MEI_DEV_ID_ICH9_82X38 0x29E4  /* 82X38/X48 Express */
-#define MEI_DEV_ID_ICH9_3200  0x29F4  /* 3200/3210 Server */
 
-#define MEI_DEV_ID_ICH9_6     0x28B4  /* Bearlake */
-#define MEI_DEV_ID_ICH9_7     0x28C4  /* Bearlake */
-#define MEI_DEV_ID_ICH9_8     0x28D4  /* Bearlake */
-#define MEI_DEV_ID_ICH9_9     0x28E4  /* Bearlake */
-#define MEI_DEV_ID_ICH9_10    0x28F4  /* Bearlake */
 
-#define MEI_DEV_ID_ICH9M_1    0x2A44  /* Cantiga */
-#define MEI_DEV_ID_ICH9M_2    0x2A54  /* Cantiga */
-#define MEI_DEV_ID_ICH9M_3    0x2A64  /* Cantiga */
-#define MEI_DEV_ID_ICH9M_4    0x2A74  /* Cantiga */
+#ifndef _MEI_INTERFACE_H_
+#define _MEI_INTERFACE_H_
 
-#define MEI_DEV_ID_ICH10_1    0x2E04  /* Eaglelake */
-#define MEI_DEV_ID_ICH10_2    0x2E14  /* Eaglelake */
-#define MEI_DEV_ID_ICH10_3    0x2E24  /* Eaglelake */
-#define MEI_DEV_ID_ICH10_4    0x2E34  /* Eaglelake */
+#include <linux/mei.h>
+#include "mei_dev.h"
 
-#define MEI_DEV_ID_IBXPK_1    0x3B64  /* Calpella */
-#define MEI_DEV_ID_IBXPK_2    0x3B65  /* Calpella */
 
-#define MEI_DEV_ID_CPT_1      0x1C3A  /* Couger Point */
-#define MEI_DEV_ID_PBG_1      0x1D3A  /* C600/X79 Patsburg */
 
-#define MEI_DEV_ID_PPT_1      0x1E3A  /* Panther Point */
-#define MEI_DEV_ID_PPT_2      0x1CBA  /* Panther Point */
-#define MEI_DEV_ID_PPT_3      0x1DBA  /* Panther Point */
+void mei_read_slots(struct mei_device *dev,
+		     unsigned char *buffer,
+		     unsigned long buffer_length);
 
-#define MEI_DEV_ID_LPT        0x8C3A  /* Lynx Point */
-#define MEI_DEV_ID_LPT_LP     0x9C3A  /* Lynx Point LP */
-/*
- * MEI HW Section
- */
+int mei_write_message(struct mei_device *dev,
+			struct mei_msg_hdr *header,
+			unsigned char *buf);
 
-/* MEI registers */
-/* H_CB_WW - Host Circular Buffer (CB) Write Window register */
-#define H_CB_WW    0
-/* H_CSR - Host Control Status register */
-#define H_CSR      4
-/* ME_CB_RW - ME Circular Buffer Read Window register (read only) */
-#define ME_CB_RW   8
-/* ME_CSR_HA - ME Control Status Host Access register (read only) */
-#define ME_CSR_HA  0xC
+bool mei_hbuf_is_empty(struct mei_device *dev);
 
+int mei_hbuf_empty_slots(struct mei_device *dev);
 
-/* register bits of H_CSR (Host Control Status register) */
-/* Host Circular Buffer Depth - maximum number of 32-bit entries in CB */
-#define H_CBD             0xFF000000
-/* Host Circular Buffer Write Pointer */
-#define H_CBWP            0x00FF0000
-/* Host Circular Buffer Read Pointer */
-#define H_CBRP            0x0000FF00
-/* Host Reset */
-#define H_RST             0x00000010
-/* Host Ready */
-#define H_RDY             0x00000008
-/* Host Interrupt Generate */
-#define H_IG              0x00000004
-/* Host Interrupt Status */
-#define H_IS              0x00000002
-/* Host Interrupt Enable */
-#define H_IE              0x00000001
+static inline size_t mei_hbuf_max_data(const struct mei_device *dev)
+{
+	return dev->hbuf_depth * sizeof(u32) - sizeof(struct mei_msg_hdr);
+}
 
+/* get slots (dwords) from a message length + header (bytes) */
+static inline unsigned char mei_data2slots(size_t length)
+{
+	return DIV_ROUND_UP(sizeof(struct mei_msg_hdr) + length, 4);
+}
 
-/* register bits of ME_CSR_HA (ME Control Status Host Access register) */
-/* ME CB (Circular Buffer) Depth HRA (Host Read Access) - host read only
-access to ME_CBD */
-#define ME_CBD_HRA        0xFF000000
-/* ME CB Write Pointer HRA - host read only access to ME_CBWP */
-#define ME_CBWP_HRA       0x00FF0000
-/* ME CB Read Pointer HRA - host read only access to ME_CBRP */
-#define ME_CBRP_HRA       0x0000FF00
-/* ME Reset HRA - host read only access to ME_RST */
-#define ME_RST_HRA        0x00000010
-/* ME Ready HRA - host read only access to ME_RDY */
-#define ME_RDY_HRA        0x00000008
-/* ME Interrupt Generate HRA - host read only access to ME_IG */
-#define ME_IG_HRA         0x00000004
-/* ME Interrupt Status HRA - host read only access to ME_IS */
-#define ME_IS_HRA         0x00000002
-/* ME Interrupt Enable HRA - host read only access to ME_IE */
-#define ME_IE_HRA         0x00000001
+int mei_count_full_read_slots(struct mei_device *dev);
 
-#endif /* _MEI_HW_MEI_H_ */
+#endif /* _MEI_INTERFACE_H_ */
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 7028dbd..88407df 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -22,7 +22,6 @@
 #include <linux/mei.h>
 
 #include "mei_dev.h"
-#include "interface.h"
 #include "client.h"
 
 const char *mei_dev_state_str(int state)
diff --git a/drivers/misc/mei/interface.h b/drivers/misc/mei/interface.h
deleted file mode 100644
index 73bef54..0000000
--- a/drivers/misc/mei/interface.h
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- *
- * Intel Management Engine Interface (Intel MEI) Linux driver
- * Copyright (c) 2003-2012, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- */
-
-
-
-#ifndef _MEI_INTERFACE_H_
-#define _MEI_INTERFACE_H_
-
-#include <linux/mei.h>
-#include "mei_dev.h"
-
-
-
-void mei_read_slots(struct mei_device *dev,
-		     unsigned char *buffer,
-		     unsigned long buffer_length);
-
-int mei_write_message(struct mei_device *dev,
-			struct mei_msg_hdr *header,
-			unsigned char *buf);
-
-bool mei_hbuf_is_empty(struct mei_device *dev);
-
-int mei_hbuf_empty_slots(struct mei_device *dev);
-
-static inline size_t mei_hbuf_max_data(const struct mei_device *dev)
-{
-	return dev->hbuf_depth * sizeof(u32) - sizeof(struct mei_msg_hdr);
-}
-
-/* get slots (dwords) from a message length + header (bytes) */
-static inline unsigned char mei_data2slots(size_t length)
-{
-	return DIV_ROUND_UP(sizeof(struct mei_msg_hdr) + length, 4);
-}
-
-int mei_count_full_read_slots(struct mei_device *dev);
-
-#endif /* _MEI_INTERFACE_H_ */
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 0a141af..d1ef926 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -25,7 +25,7 @@
 
 #include "mei_dev.h"
 #include "hbm.h"
-#include "interface.h"
+#include "hw-me.h"
 #include "client.h"
 
 
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 8d3c134..e31ade3 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -40,7 +40,7 @@
 #include <linux/mei.h>
 
 #include "mei_dev.h"
-#include "interface.h"
+#include "hw-me.h"
 #include "client.h"
 
 /* AMT device is a singleton on the platform */
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index d41177b..87b1f6a 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -23,7 +23,7 @@
 #include <linux/mei.h>
 
 #include "hw.h"
-#include "hw-me.h"
+#include "hw-me-regs.h"
 
 /*
  * watch dog definition
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 5ad5225..bfcbcc8 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -25,7 +25,7 @@
 
 #include "mei_dev.h"
 #include "hbm.h"
-#include "interface.h"
+#include "hw-me.h"
 #include "client.h"
 
 static const u8 mei_start_wd_params[] = { 0x02, 0x12, 0x13, 0x10 };
-- 
1.7.4.4

