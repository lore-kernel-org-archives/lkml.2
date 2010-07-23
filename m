Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab0GWBM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 21:12:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:32908 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab0GWBMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 21:12:50 -0400
From: Armando Uribe <x0095078@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Rene Sapiens <rene.sapiens@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Armando Uribe <x0095078@ti.com>
Subject: [PATCH 4/9] staging: tidspbridge: Change macros to static inline functions used in cload
Date: Thu, 22 Jul 2010 20:25:29 -0500
Message-Id: <1279848334-4043-5-git-send-email-x0095078@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1279848334-4043-4-git-send-email-x0095078@ti.com>
References: <1279848334-4043-1-git-send-email-x0095078@ti.com>
 <1279848334-4043-2-git-send-email-x0095078@ti.com>
 <1279848334-4043-3-git-send-email-x0095078@ti.com>
 <1279848334-4043-4-git-send-email-x0095078@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the macros to static inline function used
in cload as well adds two definition of const to avoid using magic
numbers

Signed-off-by: Armando Uribe <x0095078@ti.com>
---
 drivers/staging/tidspbridge/dynload/cload.c |   16 +++++++-------
 drivers/staging/tidspbridge/dynload/doff.h  |   31 +++++++++++++++++++-------
 drivers/staging/tidspbridge/dynload/tramp.c |    2 +-
 3 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/tidspbridge/dynload/cload.c b/drivers/staging/tidspbridge/dynload/cload.c
index e48e91b..32150f0 100644
--- a/drivers/staging/tidspbridge/dynload/cload.c
+++ b/drivers/staging/tidspbridge/dynload/cload.c
@@ -528,7 +528,7 @@ static void allocate_sections(struct dload_state *dlthis)
 		}
 #endif
 		/* allocate target storage for sections that require it */
-		if (DS_NEEDS_ALLOCATION(shp)) {
+		if (ds_needs_allocation(shp)) {
 			*asecs = *DOFFSEC_IS_LDRSEC(shp);
 			asecs->context = 0;	/* zero the context field */
 #if BITS_PER_AU > BITS_PER_BYTE
@@ -540,7 +540,7 @@ static void allocate_sections(struct dload_state *dlthis)
 			if (dlthis->myalloc != NULL) {
 				if (!dlthis->myalloc->
 				    dload_allocate(dlthis->myalloc, asecs,
-						   DS_ALIGNMENT(asecs->type))) {
+						   ds_alignment(asecs->type))) {
 					dload_error(dlthis, tgtalloc,
 						    asecs->name, asecs->size);
 					return;
@@ -1155,7 +1155,7 @@ static void dload_data(struct dload_state *dlthis)
 	 */
 	for (curr_sect = 0; curr_sect < dlthis->dfile_hdr.df_no_scns;
 	     curr_sect += 1) {
-		if (DS_NEEDS_DOWNLOAD(sptr)) {
+		if (ds_needs_download(sptr)) {
 			s32 nip;
 			ldr_addr image_offset = 0;
 			/* set relocation info for this section */
@@ -1201,7 +1201,7 @@ static void dload_data(struct dload_state *dlthis)
 				dest = ibuf.bufr;
 #ifdef OPT_ZERO_COPY_LOADER
 				zero_copy = false;
-				if (DLOAD_SECT_TYPE(sptr) != DLOAD_CINIT) {
+				if (!dload_check_type(sptr, DLOAD_CINIT) {
 					dlthis->myio->writemem(dlthis->myio,
 							       &dest,
 							       lptr->load_addr +
@@ -1267,8 +1267,8 @@ static void dload_data(struct dload_state *dlthis)
 
 					/* stuff the result into target
 					 * memory */
-					if (DLOAD_SECT_TYPE(sptr) ==
-					    DLOAD_CINIT) {
+					if (dload_check_type(sptr,
+						DLOAD_CINIT)) {
 						cload_cinit(dlthis,
 							    &ibuf.ipacket);
 						cinit_processed = true;
@@ -1306,7 +1306,7 @@ static void dload_data(struct dload_state *dlthis)
 				    BYTE_TO_TADDR(ibuf.ipacket.packet_size);
 			}	/* process packets */
 			/* if this is a BSS section, we may want to fill it */
-			if (DLOAD_SECT_TYPE(sptr) != DLOAD_BSS)
+			if (!dload_check_type(sptr, DLOAD_BSS))
 				goto loop_cont;
 
 			if (!(dlthis->myoptions & DLOAD_INITBSS))
@@ -1330,7 +1330,7 @@ static void dload_data(struct dload_state *dlthis)
 		}
 		/* if DS_DOWNLOAD_MASK */
 		/* If not loading, but BSS, zero initialize */
-		if (DLOAD_SECT_TYPE(sptr) != DLOAD_BSS)
+		if (!dload_check_type(sptr, DLOAD_BSS))
 			goto loop_cont;
 
 		if (!(dlthis->myoptions & DLOAD_INITBSS))
diff --git a/drivers/staging/tidspbridge/dynload/doff.h b/drivers/staging/tidspbridge/dynload/doff.h
index 5bf9924..c00d189 100644
--- a/drivers/staging/tidspbridge/dynload/doff.h
+++ b/drivers/staging/tidspbridge/dynload/doff.h
@@ -326,19 +326,32 @@ struct reloc_record_t {
 /**************************************************************************** */
 
 /* Enum for DOFF section types (bits 0-3 of flag): See dynamic_loader.h */
-
-/* Macros to help processing of sections */
-#define DLOAD_SECT_TYPE(s_hdr)      ((s_hdr)->ds_flags & 0xF)
-
+#define DS_SECTION_TYPE_MASK	0xF
 /* DS_ALLOCATE indicates whether a section needs space on the target */
 #define DS_ALLOCATE_MASK            0x10
-#define DS_NEEDS_ALLOCATION(s_hdr)  ((s_hdr)->ds_flags & DS_ALLOCATE_MASK)
-
 /* DS_DOWNLOAD indicates that the loader needs to copy bits */
 #define DS_DOWNLOAD_MASK            0x20
-#define DS_NEEDS_DOWNLOAD(s_hdr)    ((s_hdr)->ds_flags & DS_DOWNLOAD_MASK)
-
 /* Section alignment requirement in AUs */
-#define DS_ALIGNMENT(ds_flags) (1 << (((ds_flags) >> 8) & 0xF))
+#define DS_ALIGNMENT_SHIFT	8
+
+static inline bool dload_check_type(struct doff_scnhdr_t *sptr, u32 flag)
+{
+	return (sptr->ds_flags & DS_SECTION_TYPE_MASK) == flag;
+}
+static inline bool ds_needs_allocation(struct doff_scnhdr_t *sptr)
+{
+	return sptr->ds_flags & DS_ALLOCATE_MASK;
+}
+
+static inline bool ds_needs_download(struct doff_scnhdr_t *sptr)
+{
+	return sptr->ds_flags & DS_DOWNLOAD_MASK;
+}
+
+static inline int ds_alignment(u16 ds_flags)
+{
+	return 1 << ((ds_flags >> DS_ALIGNMENT_SHIFT) & DS_SECTION_TYPE_MASK);
+}
+
 
 #endif /* _DOFF_H */
diff --git a/drivers/staging/tidspbridge/dynload/tramp.c b/drivers/staging/tidspbridge/dynload/tramp.c
index 7b593fc..81314d2 100644
--- a/drivers/staging/tidspbridge/dynload/tramp.c
+++ b/drivers/staging/tidspbridge/dynload/tramp.c
@@ -48,7 +48,7 @@ static int priv_tramp_sect_tgt_alloc(struct dload_state *dlthis)
 	sect_info->load_addr = 0;
 	ret_val = dlthis->myalloc->dload_allocate(dlthis->myalloc,
 						  sect_info,
-						  DS_ALIGNMENT
+						  ds_alignment
 						  (sect_info->type));
 
 	if (ret_val == 0)
-- 
1.6.3.3

