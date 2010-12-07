Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab0LGGUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 01:20:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45210 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab0LGGUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 01:20:08 -0500
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: linux-omap <linux-omap@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Rene Sapiens <rene.sapiens@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Nishanth Menon <nm@ti.com>, Armando Uribe De Leon <x0095078@ti.com>,
        Ernesto Ramos Falcon <ernesto@ti.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: tidspbridge: remove file handling functions for loader
Date: Tue,  7 Dec 2010 00:09:06 -0600
Message-Id: <1291702146-17866-1-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead use request_firmware and friends to get a valid firmware
image.

Right now the image is supplied dynamically through udev and the
following rule:

KERNEL=="omap-dsp", SUBSYSTEM=="firmware", ACTION=="add",	\
	RUN+="/bin/sh -c 'echo 1 > /sys/$DEVPATH/loading;	\
		cat $FIRMWARE > /sys/$DEVPATH/data;		\
		echo 0 > /sys/$DEVPATH/loading'"

Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 .../tidspbridge/include/dspbridge/dbldefs.h        |   10 --
 .../staging/tidspbridge/include/dspbridge/dbll.h   |    7 ++
 .../tidspbridge/include/dspbridge/dblldefs.h       |   35 ------
 drivers/staging/tidspbridge/pmgr/cod.c             |  100 -----------------
 drivers/staging/tidspbridge/pmgr/dbll.c            |  114 +++++++++++--------
 5 files changed, 73 insertions(+), 193 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/dbldefs.h b/drivers/staging/tidspbridge/include/dspbridge/dbldefs.h
index bf4fb99..c74321b 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dbldefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dbldefs.h
@@ -126,16 +126,6 @@ struct dbl_attrs {
 	dbl_sym_lookup sym_lookup;
 	void *sym_handle;
 	void *sym_arg;
-
-	/*
-	 *  These file manipulation functions should be compatible with the
-	 *  "C" run time library functions of the same name.
-	 */
-	 s32(*fread) (void *, size_t, size_t, void *);
-	 s32(*fseek) (void *, long, int);
-	 s32(*ftell) (void *);
-	 s32(*fclose) (void *);
-	void *(*fopen) (const char *, const char *);
 };
 
 #endif /* DBLDEFS_ */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dbll.h b/drivers/staging/tidspbridge/include/dspbridge/dbll.h
index b018676..ad081e0 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dbll.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dbll.h
@@ -20,9 +20,16 @@
 #ifndef DBLL_
 #define DBLL_
 
+#include <linux/firmware.h>
 #include <dspbridge/dbdefs.h>
 #include <dspbridge/dblldefs.h>
 
+struct dsp_fw {
+	const struct firmware *img;
+	const char *name;
+	const u8 *pos;
+};
+
 extern bool symbols_reloaded;
 
 extern void dbll_close(struct dbll_library_obj *zl_lib);
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h b/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
index d2b4fda..f353a14 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
@@ -79,11 +79,6 @@ typedef s32(*dbll_alloc_fxn) (void *hdl, s32 space, u32 size, u32 align,
 			      bool reserved);
 
 /*
- *  ======== dbll_close_fxn ========
- */
-typedef s32(*dbll_f_close_fxn) (void *);
-
-/*
  *  ======== dbll_free_fxn ========
  *  Free memory function.  Free, or unreserve (if reserved == TRUE) "size"
  *  bytes of memory from segment "space"
@@ -92,11 +87,6 @@ typedef bool(*dbll_free_fxn) (void *hdl, u32 addr, s32 space, u32 size,
 			      bool reserved);
 
 /*
- *  ======== dbll_f_open_fxn ========
- */
-typedef void *(*dbll_f_open_fxn) (const char *, const char *);
-
-/*
  *  ======== dbll_log_write_fxn ========
  *  Function to call when writing data from a section, to log the info.
  *  Can be NULL if no logging is required.
@@ -106,16 +96,6 @@ typedef int(*dbll_log_write_fxn) (void *handle,
 					 u32 bytes);
 
 /*
- *  ======== dbll_read_fxn ========
- */
-typedef s32(*dbll_read_fxn) (void *, size_t, size_t, void *);
-
-/*
- *  ======== dbll_seek_fxn ========
- */
-typedef s32(*dbll_seek_fxn) (void *, long, int);
-
-/*
  *  ======== dbll_sym_lookup ========
  *  Symbol lookup function - Find the symbol name and return its value.
  *
@@ -133,11 +113,6 @@ typedef bool(*dbll_sym_lookup) (void *handle, void *parg, void *rmm_handle,
 				const char *name, struct dbll_sym_val ** sym);
 
 /*
- *  ======== dbll_tell_fxn ========
- */
-typedef s32(*dbll_tell_fxn) (void *);
-
-/*
  *  ======== dbll_write_fxn ========
  *  Write memory function.  Write "n" HOST bytes of memory to segment "mtype"
  *  starting at address "dsp_address" from the buffer "buf".  The buffer is
@@ -163,16 +138,6 @@ struct dbll_attrs {
 	dbll_sym_lookup sym_lookup;
 	void *sym_handle;
 	void *sym_arg;
-
-	/*
-	 *  These file manipulation functions should be compatible with the
-	 *  "C" run time library functions of the same name.
-	 */
-	 s32(*fread) (void *, size_t, size_t, void *);
-	 s32(*fseek) (void *, long, int);
-	 s32(*ftell) (void *);
-	 s32(*fclose) (void *);
-	void *(*fopen) (const char *, const char *);
 };
 
 /*
diff --git a/drivers/staging/tidspbridge/pmgr/cod.c b/drivers/staging/tidspbridge/pmgr/cod.c
index 52989ab..31cfa9b 100644
--- a/drivers/staging/tidspbridge/pmgr/cod.c
+++ b/drivers/staging/tidspbridge/pmgr/cod.c
@@ -89,101 +89,6 @@ static struct dbll_fxns ldr_fxns = {
 static bool no_op(void);
 
 /*
- * File operations (originally were under kfile.c)
- */
-static s32 cod_f_close(struct file *filp)
-{
-	/* Check for valid handle */
-	if (!filp)
-		return -EFAULT;
-
-	filp_close(filp, NULL);
-
-	/* we can't use 0 here */
-	return 0;
-}
-
-static struct file *cod_f_open(const char *psz_file_name, const char *sz_mode)
-{
-	mm_segment_t fs;
-	struct file *filp;
-
-	fs = get_fs();
-	set_fs(get_ds());
-
-	/* ignore given mode and open file as read-only */
-	filp = filp_open(psz_file_name, O_RDONLY, 0);
-
-	if (IS_ERR(filp))
-		filp = NULL;
-
-	set_fs(fs);
-
-	return filp;
-}
-
-static s32 cod_f_read(void __user *pbuffer, s32 size, s32 count,
-		      struct file *filp)
-{
-	/* check for valid file handle */
-	if (!filp)
-		return -EFAULT;
-
-	if ((size > 0) && (count > 0) && pbuffer) {
-		u32 dw_bytes_read;
-		mm_segment_t fs;
-
-		/* read from file */
-		fs = get_fs();
-		set_fs(get_ds());
-		dw_bytes_read = filp->f_op->read(filp, pbuffer, size * count,
-						 &(filp->f_pos));
-		set_fs(fs);
-
-		if (!dw_bytes_read)
-			return -EBADF;
-
-		return dw_bytes_read / size;
-	}
-
-	return -EINVAL;
-}
-
-static s32 cod_f_seek(struct file *filp, s32 offset, s32 origin)
-{
-	loff_t dw_cur_pos;
-
-	/* check for valid file handle */
-	if (!filp)
-		return -EFAULT;
-
-	/* based on the origin flag, move the internal pointer */
-	dw_cur_pos = filp->f_op->llseek(filp, offset, origin);
-
-	if ((s32) dw_cur_pos < 0)
-		return -EPERM;
-
-	/* we can't use 0 here */
-	return 0;
-}
-
-static s32 cod_f_tell(struct file *filp)
-{
-	loff_t dw_cur_pos;
-
-	if (!filp)
-		return -EFAULT;
-
-	/* Get current position */
-	dw_cur_pos = filp->f_op->llseek(filp, 0, SEEK_CUR);
-
-	if ((s32) dw_cur_pos < 0)
-		return -EPERM;
-
-	return dw_cur_pos;
-}
-
-/*
  *  ======== cod_close ========
  */
 void cod_close(struct cod_libraryobj *lib)
@@ -238,11 +143,6 @@ int cod_create(struct cod_manager **mgr, char *str_zl_file,
 
 	zl_attrs.alloc = (dbll_alloc_fxn) no_op;
 	zl_attrs.free = (dbll_free_fxn) no_op;
-	zl_attrs.fread = (dbll_read_fxn) cod_f_read;
-	zl_attrs.fseek = (dbll_seek_fxn) cod_f_seek;
-	zl_attrs.ftell = (dbll_tell_fxn) cod_f_tell;
-	zl_attrs.fclose = (dbll_f_close_fxn) cod_f_close;
-	zl_attrs.fopen = (dbll_f_open_fxn) cod_f_open;
 	zl_attrs.sym_lookup = NULL;
 	zl_attrs.base_image = true;
 	zl_attrs.log_write = NULL;
diff --git a/drivers/staging/tidspbridge/pmgr/dbll.c b/drivers/staging/tidspbridge/pmgr/dbll.c
index 878aa50..174883f 100644
--- a/drivers/staging/tidspbridge/pmgr/dbll.c
+++ b/drivers/staging/tidspbridge/pmgr/dbll.c
@@ -117,7 +117,7 @@ struct dbll_library_obj {
 	void *dload_mod_obj;
 
 	char *file_name;	/* COFF file name */
-	void *fp;		/* Opaque file handle */
+	struct dsp_fw *fp;
 	u32 entry;		/* Entry point */
 	void *desc;	/* desc of DOFF file loaded */
 	u32 open_ref;		/* Number of times opened */
@@ -136,6 +136,8 @@ struct dbll_symbol {
 
 static void dof_close(struct dbll_library_obj *zl_lib);
 static int dof_open(struct dbll_library_obj *zl_lib);
+static u32 dof_get_posn(struct dsp_fw *fw);
+static int dof_set_posn(struct dsp_fw *fw, u32 pos);
 static s32 no_op(struct dynamic_loader_initialize *thisptr, void *bufr,
 		 ldr_addr locn, struct ldr_section_info *info,
 		 unsigned bytsize);
@@ -397,9 +399,7 @@ int dbll_get_sect(struct dbll_library_obj *lib, char *name, u32 *paddr,
 				opened_doff = true;
 
 		} else {
-			(*(zl_lib->target_obj->attrs.fseek)) (zl_lib->fp,
-							      zl_lib->ul_pos,
-							      SEEK_SET);
+			dof_set_posn(zl_lib->fp, zl_lib->ul_pos);
 		}
 	} else {
 		status = -EFAULT;
@@ -522,12 +522,9 @@ int dbll_load(struct dbll_library_obj *lib, dbll_flags flags,
 
 		}
 		if (!status) {
-			zl_lib->ul_pos = (*(zl_lib->target_obj->attrs.ftell))
-			    (zl_lib->fp);
-			/* Reset file cursor */
-			(*(zl_lib->target_obj->attrs.fseek)) (zl_lib->fp,
-							      (long)0,
-							      SEEK_SET);
+			zl_lib->ul_pos = dof_get_posn(zl_lib->fp);
+			/* Reset firmware position */
+			dof_set_posn(zl_lib->fp, 0);
 			symbols_reloaded = true;
 			/* The 5th argument, DLOAD_INITBSS, tells the DLL
 			 * module to zero-init all BSS sections.  In general,
@@ -592,7 +589,6 @@ int dbll_open(struct dbll_tar_obj *target, char *file, dbll_flags flags,
 
 	DBC_REQUIRE(refs > 0);
 	DBC_REQUIRE(zl_target);
-	DBC_REQUIRE(zl_target->attrs.fopen != NULL);
 	DBC_REQUIRE(file != NULL);
 	DBC_REQUIRE(lib_obj != NULL);
 
@@ -661,8 +657,8 @@ int dbll_open(struct dbll_tar_obj *target, char *file, dbll_flags flags,
 	if (!status && zl_lib->fp == NULL)
 		status = dof_open(zl_lib);
 
-	zl_lib->ul_pos = (*(zl_lib->target_obj->attrs.ftell)) (zl_lib->fp);
-	(*(zl_lib->target_obj->attrs.fseek)) (zl_lib->fp, (long)0, SEEK_SET);
+	zl_lib->ul_pos = dof_get_posn(zl_lib->fp);
+	dof_set_posn(zl_lib->fp, 0);
 	/* Create a hash table for symbols if flag is set */
 	if (zl_lib->sym_tab != NULL || !(flags & DBLL_SYMB))
 		goto func_cont;
@@ -749,9 +745,7 @@ int dbll_read_sect(struct dbll_library_obj *lib, char *name,
 				opened_doff = true;
 
 		} else {
-			(*(zl_lib->target_obj->attrs.fseek)) (zl_lib->fp,
-							      zl_lib->ul_pos,
-							      SEEK_SET);
+			dof_set_posn(zl_lib->fp, zl_lib->ul_pos);
 		}
 	} else {
 		status = -EFAULT;
@@ -869,9 +863,10 @@ static void dof_close(struct dbll_library_obj *zl_lib)
 		dload_module_close(zl_lib->desc);
 		zl_lib->desc = NULL;
 	}
-	/* close file */
+
 	if (zl_lib->fp) {
-		(zl_lib->target_obj->attrs.fclose) (zl_lib->fp);
+		release_firmware(zl_lib->fp->img);
+		kfree(zl_lib->fp);
 		zl_lib->fp = NULL;
 	}
 }
@@ -881,30 +876,52 @@ static void dof_close(struct dbll_library_obj *zl_lib)
  */
 static int dof_open(struct dbll_library_obj *zl_lib)
 {
-	void *open = *(zl_lib->target_obj->attrs.fopen);
-	int status = 0;
+	int err;
+
+	if (zl_lib->fp || zl_lib->desc)
+		return -EBADF;
+
+	zl_lib->fp = kzalloc(sizeof(struct dsp_fw), GFP_KERNEL);
+	if (!zl_lib->fp)
+		return -ENOMEM;
 
-	/* First open the file for the dynamic loader, then open COF */
-	zl_lib->fp =
-	    (void *)((dbll_f_open_fxn) (open)) (zl_lib->file_name, "rb");
+	err = request_firmware(&zl_lib->fp->img, zl_lib->file_name, bridge);
+	if (IS_ERR_VALUE(err)) {
+		kfree(zl_lib->fp);
+		return err;
+	}
+
+	zl_lib->fp->pos = zl_lib->fp->img->data;
 
 	/* Open DOFF module */
-	if (zl_lib->fp && zl_lib->desc == NULL) {
-		(*(zl_lib->target_obj->attrs.fseek)) (zl_lib->fp, (long)0,
-						      SEEK_SET);
-		zl_lib->desc =
-		    dload_module_open(&zl_lib->stream.dl_stream,
-				      &zl_lib->symbol.dl_symbol);
-		if (zl_lib->desc == NULL) {
-			(zl_lib->target_obj->attrs.fclose) (zl_lib->fp);
-			zl_lib->fp = NULL;
-			status = -EBADF;
-		}
-	} else {
-		status = -EBADF;
+	zl_lib->desc = dload_module_open(&zl_lib->stream.dl_stream,
+					&zl_lib->symbol.dl_symbol);
+	if (!zl_lib->desc) {
+		dof_close(zl_lib);
+		return -EBADF;
 	}
 
-	return status;
+	return 0;
+}
+
+static u32 dof_get_posn(struct dsp_fw *fw)
+{
+	/* check for valid file handle */
+	if (!fw || !fw->img)
+		return -EFAULT;
+
+	return fw->pos - fw->img->data;
+}
+
+static int dof_set_posn(struct dsp_fw *fw, u32 pos)
+{
+	/* check for valid file handle */
+	if (!fw || !fw->img)
+		return -EFAULT;
+
+	fw->pos = fw->img->data + pos;
+
+	return 0;
 }
 
 /*
@@ -978,18 +995,21 @@ static int dbll_read_buffer(struct dynamic_loader_stream *this, void *buffer,
 {
 	struct dbll_stream *pstream = (struct dbll_stream *)this;
 	struct dbll_library_obj *lib;
-	int bytes_read = 0;
 
 	DBC_REQUIRE(this != NULL);
 	lib = pstream->lib;
 	DBC_REQUIRE(lib);
 
-	if (lib != NULL) {
-		bytes_read =
-		    (*(lib->target_obj->attrs.fread)) (buffer, 1, bufsize,
-						       lib->fp);
-	}
-	return bytes_read;
+	if (!lib || !lib->fp)
+		return -EFAULT;
+
+	if (!buffer || bufsize <= 0)
+		return -EINVAL;
+
+	memcpy(buffer, lib->fp->pos, bufsize);
+	lib->fp->pos += bufsize;
+
+	return bufsize;
 }
 
 /*
@@ -1006,10 +1026,8 @@ static int dbll_set_file_posn(struct dynamic_loader_stream *this,
 	lib = pstream->lib;
 	DBC_REQUIRE(lib);
 
-	if (lib != NULL) {
-		status = (*(lib->target_obj->attrs.fseek)) (lib->fp, (long)pos,
-							    SEEK_SET);
-	}
+	if (lib)
+		status = dof_set_posn(lib->fp, pos);
 
 	return status;
 }
-- 
1.7.1

