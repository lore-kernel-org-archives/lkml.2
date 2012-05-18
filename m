Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965467Ab2ERQzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:55:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552Ab2ERQdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:33:00 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH EDAC v26 06/66] edac.h: Add generic layers for describing a memory location
Date: Fri, 18 May 2012 13:31:53 -0300
Message-Id: <1337358773-6919-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
References: <1337358773-6919-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The edac core were written with the idea that memory controllers
are able to directly access csrows, and that the channels are
used inside a csrows select.

This is not true for FB-DIMM and RAMBUS memory controllers.

Also, some recent advanced memory controllers don't present a per-csrows
view. Instead, they view memories as DIMMs, instead of ranks, accessed
via csrow/channel.

So, changes are needed in order to allow the EDAC core to
work with all types of architectures.

In preparation for handling non-csrows based memory controllers,
add some memory structs and a macro:

enum hw_event_mc_err_type: describes the type of error
			   (corrected, uncorrected, fatal)

To be used by the new edac_mc_handle_error function;

enum edac_mc_layer: describes the type of a given memory
architecture layer (branch, channel, slot, csrow).

struct edac_mc_layer: describes the properties of a memory
		      layer (type, size, and if the layer
		      will be used on a virtual csrow.

EDAC_DIMM_PTR() - as the number of layers can vary from 1 to 3,
this macro converts from an address with up to 3 layers into
a linear address.

Reviewed-by: Borislav Petkov <bp@amd64.org>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 include/linux/edac.h |  103 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 102 insertions(+), 1 deletions(-)

diff --git a/include/linux/edac.h b/include/linux/edac.h
index 67717ca..9e628434e 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -71,6 +71,25 @@ enum dev_type {
 #define DEV_FLAG_X64		BIT(DEV_X64)
 
 /**
+ * enum hw_event_mc_err_type - type of the detected error
+ *
+ * @HW_EVENT_ERR_CORRECTED:	Corrected Error - Indicates that an ECC
+ *				corrected error was detected
+ * @HW_EVENT_ERR_UNCORRECTED:	Uncorrected Error - Indicates an error that
+ *				can't be corrected by ECC, but it is not
+ *				fatal (maybe it is on an unused memory area,
+ *				or the memory controller could recover from
+ *				it for example, by re-trying the operation).
+ * @HW_EVENT_ERR_FATAL:		Fatal Error - Uncorrected error that could not
+ *				be recovered.
+ */
+enum hw_event_mc_err_type {
+	HW_EVENT_ERR_CORRECTED,
+	HW_EVENT_ERR_UNCORRECTED,
+	HW_EVENT_ERR_FATAL,
+};
+
+/**
  * enum mem_type - memory types. For a more detailed reference, please see
  *			http://en.wikipedia.org/wiki/DRAM
  *
@@ -312,7 +331,89 @@ enum scrub_type {
  * PS - I enjoyed writing all that about as much as you enjoyed reading it.
  */
 
-/* FIXME: add a per-dimm ce error count */
+/**
+ * enum edac_mc_layer - memory controller hierarchy layer
+ *
+ * @EDAC_MC_LAYER_BRANCH:	memory layer is named "branch"
+ * @EDAC_MC_LAYER_CHANNEL:	memory layer is named "channel"
+ * @EDAC_MC_LAYER_SLOT:		memory layer is named "slot"
+ * @EDAC_MC_LAYER_CHIP_SELECT:	memory layer is named "chip select"
+ *
+ * This enum is used by the drivers to tell edac_mc_sysfs what name should
+ * be used when describing a memory stick location.
+ */
+enum edac_mc_layer_type {
+	EDAC_MC_LAYER_BRANCH,
+	EDAC_MC_LAYER_CHANNEL,
+	EDAC_MC_LAYER_SLOT,
+	EDAC_MC_LAYER_CHIP_SELECT,
+};
+
+/**
+ * struct edac_mc_layer - describes the memory controller hierarchy
+ * @layer:		layer type
+ * @size:		number of components per layer. For example,
+ *			if the channel layer has two channels, size = 2
+ * @is_virt_csrow:	This layer is part of the "csrow" when old API
+ *			compatibility mode is enabled. Otherwise, it is
+ *			a channel
+ */
+struct edac_mc_layer {
+	enum edac_mc_layer_type	type;
+	unsigned		size;
+	bool			is_virt_csrow;
+};
+
+/*
+ * Maximum number of layers used by the memory controller to uniquely
+ * identify a single memory stick.
+ * NOTE: Changing this constant requires not only to change the constant
+ * below, but also to change the existing code at the core, as there are
+ * some code there that are optimized for 3 layers.
+ */
+#define EDAC_MAX_LAYERS		3
+
+/**
+ * EDAC_DIMM_PTR - Macro responsible to find a pointer inside a pointer array
+ *		   for the element given by [layer0,layer1,layer2] position
+ *
+ * @layers:	a struct edac_mc_layer array, describing how many elements
+ *		were allocated for each layer
+ * @var:	name of the var where we want to get the pointer
+ *		(like mci->dimms)
+ * @n_layers:	Number of layers at the @layers array
+ * @layer0:	layer0 position
+ * @layer1:	layer1 position. Unused if n_layers < 2
+ * @layer2:	layer2 position. Unused if n_layers < 3
+ *
+ * For 1 layer, this macro returns &var[layer0]
+ * For 2 layers, this macro is similar to allocate a bi-dimensional array
+ *		and to return "&var[layer0][layer1]"
+ * For 3 layers, this macro is similar to allocate a tri-dimensional array
+ *		and to return "&var[layer0][layer1][layer2]"
+ *
+ * A loop could be used here to make it more generic, but, as we only have
+ * 3 layers, this is a little faster.
+ * By design, layers can never be 0 or more than 3. If that ever happens,
+ * a NULL is returned, causing an OOPS during the memory allocation routine,
+ * with would point to the developer that he's doing something wrong.
+ */
+#define EDAC_DIMM_PTR(layers, var, nlayers, layer0, layer1, layer2) ({	\
+	typeof(var) __p;						\
+	if ((nlayers) == 1)						\
+		__p = &var[layer0];					\
+	else if ((nlayers) == 2)					\
+		__p = &var[(layer1) + ((layers[1]).size * (layer0))];	\
+	else if ((nlayers) == 3)					\
+		__p = &var[(layer2) + ((layers[2]).size * ((layer1) +	\
+			    ((layers[1]).size * (layer0))))];		\
+	else								\
+		__p = NULL;						\
+	__p;								\
+})
+
+
+/* FIXME: add the proper per-location error counts */
 struct dimm_info {
 	char label[EDAC_MC_LABEL_LEN + 1];	/* DIMM label on motherboard */
 	unsigned memory_controller;
-- 
1.7.8

