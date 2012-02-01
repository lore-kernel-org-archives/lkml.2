Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2BAAES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 19:04:18 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63032 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2BAAER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 19:04:17 -0500
Message-ID: <4F288178.4040405@gmail.com>
Date: Wed, 01 Feb 2012 11:04:08 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] coda: Remove unnecessary OOM messages
References: <cover.1328049542.git.joe@perches.com> <db4ffce1e5a8a3a6e54e7a4f6487e822709dbdba.1328049542.git.joe@perches.com>
In-Reply-To: <db4ffce1e5a8a3a6e54e7a4f6487e822709dbdba.1328049542.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/12 09:42, Joe Perches wrote:
> Per call site OOM messages are unnecessary.
> k.alloc and v.alloc failures use dump_stack().
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/coda/coda_linux.h |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/fs/coda/coda_linux.h b/fs/coda/coda_linux.h
> index cc0ea9f..7b2c3a1 100644
> --- a/fs/coda/coda_linux.h
> +++ b/fs/coda/coda_linux.h
> @@ -57,13 +57,12 @@ unsigned short coda_flags_to_cflags(unsigned short);
>  void coda_sysctl_init(void);
>  void coda_sysctl_clean(void);
>  
> -#define CODA_ALLOC(ptr, cast, size) do { \
> -    if (size < PAGE_SIZE) \
> -        ptr = kzalloc((unsigned long) size, GFP_KERNEL); \
> -    else \
> -        ptr = (cast)vzalloc((unsigned long) size); \
> -    if (!ptr) \
> -        printk("kernel malloc returns 0 at %s:%d\n", __FILE__, __LINE__); \
> +#define CODA_ALLOC(ptr, cast, size)			\
> +do {							\
> +	if (size < PAGE_SIZE)				\
> +		ptr = kzalloc(size, GFP_KERNEL);	\
> +	else						\
> +		ptr = vzalloc(size);			\
>  } while (0)
>   

Hi Joe,

Since CODA_ALLOC no longer uses __FILE__ and __LINE__ and doesn't use
the cast argument any more, it can be replaced with a static inline
function. Something like this (untested, applies on top of your patch):
----

Since CODA_ALLOC no longer needs to be defined as a macro, replace it
with a static inline function and make it return the allocated pointer.
Rename it to coda_alloc to be more consistent with other function
naming. Similarly, replace CODA_FREE with a static inline function.

Also fix a bug in coda_psdev_write where the return value of CODA_ALLOC
was not being checked.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---

diff --git a/fs/coda/coda_linux.h b/fs/coda/coda_linux.h
index 7b2c3a1..f5da0a7 100644
--- a/fs/coda/coda_linux.h
+++ b/fs/coda/coda_linux.h
@@ -57,17 +57,20 @@ unsigned short coda_flags_to_cflags(unsigned short);
 void coda_sysctl_init(void);
 void coda_sysctl_clean(void);
 
-#define CODA_ALLOC(ptr, cast, size)			\
-do {							\
-	if (size < PAGE_SIZE)				\
-		ptr = kzalloc(size, GFP_KERNEL);	\
-	else						\
-		ptr = vzalloc(size);			\
-} while (0)
-
+static inline void *coda_alloc(size_t size)
+{
+	if (size < PAGE_SIZE)
+		return kzalloc(size, GFP_KERNEL);
+	return vzalloc(size);
+}
 
-#define CODA_FREE(ptr,size) \
-    do { if (size < PAGE_SIZE) kfree((ptr)); else vfree((ptr)); } while (0)
+static inline void coda_free(const void *ptr, size_t size)
+{
+	if (size < PAGE_SIZE)
+		kfree(ptr);
+	else
+		vfree(ptr);
+}
 
 /* inode to cnode access functions */
 
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index 8f616e0..4afcb81 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -124,9 +124,13 @@ static ssize_t coda_psdev_write(struct file *file, const char __user *buf,
 			       hdr.opcode, hdr.unique);
 		        nbytes = size;
 		}
-		CODA_ALLOC(dcbuf, union outputArgs *, nbytes);
+		dcbuf = coda_alloc(nbytes);
+		if (!dcbuf) {
+			retval = -ENOMEM;
+			goto out;
+		}
 		if (copy_from_user(dcbuf, buf, nbytes)) {
-			CODA_FREE(dcbuf, nbytes);
+			coda_free(dcbuf, nbytes);
 			retval = -EFAULT;
 			goto out;
 		}
@@ -134,7 +138,7 @@ static ssize_t coda_psdev_write(struct file *file, const char __user *buf,
 		/* what downcall errors does Venus handle ? */
 		error = coda_downcall(vcp, hdr.opcode, dcbuf);
 
-		CODA_FREE(dcbuf, nbytes);
+		coda_free(dcbuf, nbytes);
 		if (error) {
 		        printk("psdev_write: coda_downcall error: %d\n", error);
 			retval = error;
@@ -255,7 +259,7 @@ static ssize_t coda_psdev_read(struct file * file, char __user * buf,
 		goto out;
 	}
 
-	CODA_FREE(req->uc_data, sizeof(struct coda_in_hdr));
+	coda_free(req->uc_data, sizeof(struct coda_in_hdr));
 	kfree(req);
 out:
 	mutex_unlock(&vcp->vc_mutex);
@@ -311,7 +315,7 @@ static int coda_psdev_release(struct inode * inode, struct file * file)
 
 		/* Async requests need to be freed here */
 		if (req->uc_flags & CODA_REQ_ASYNC) {
-			CODA_FREE(req->uc_data, sizeof(struct coda_in_hdr));
+			coda_free(req->uc_data, sizeof(struct coda_in_hdr));
 			kfree(req);
 			continue;
 		}
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index 9727e0c..5c43991 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -46,7 +46,7 @@ static void *alloc_upcall(int opcode, int size)
 {
 	union inputArgs *inp;
 
-	CODA_ALLOC(inp, union inputArgs *, size);
+	inp = coda_alloc(size);
         if (!inp)
 		return ERR_PTR(-ENOMEM);
 
@@ -85,7 +85,7 @@ int venus_rootfid(struct super_block *sb, struct CodaFid *fidp)
 	if (!error)
 		*fidp = outp->coda_root.VFid;
 
-	CODA_FREE(inp, insize);
+	coda_free(inp, insize);
 	return error;
 }
 
@@ -104,7 +104,7 @@ int venus_getattr(struct super_block *sb, struct CodaFid *fid,
 	if (!error)
 		*attr = outp->coda_getattr.attr;
 
-	CODA_FREE(inp, insize);
+	coda_free(inp, insize);
         return error;
 }
 
@@ -123,7 +123,7 @@ int venus_setattr(struct super_block *sb, struct CodaFid *fid,
 
 	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
-        CODA_FREE(inp, insize);
+        coda_free(inp, insize);
         return error;
 }
 
@@ -153,7 +153,7 @@ int venus_lookup(struct super_block *sb, struct CodaFid *fid,
 		*type = outp->coda_lookup.vtype;
 	}
 
-	CODA_FREE(inp, insize);
+	coda_free(inp, insize);
 	return error;
 }
 
@@ -173,7 +173,7 @@ int venus_close(struct super_block *sb, struct CodaFid *fid, int flags,
 
 	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
-	CODA_FREE(inp, insize);
+	coda_free(inp, insize);
         return error;
 }
 
@@ -194,7 +194,7 @@ int venus_open(struct super_block *sb, struct CodaFid *fid,
 	if (!error)
 		*fh = outp->coda_open_by_fd.fh;
 
-	CODA_FREE(inp, insize);
+	coda_free(inp, insize);
 	return error;
 }	
 
@@ -224,7 +224,7 @@ int venus_mkdir(struct super_block *sb, struct CodaFid *dirfid,
 		*newfid = outp->coda_mkdir.VFid;
 	}
 
-	CODA_FREE(inp, insize);
+	coda_free(inp, insize);
 	return error;        
 }
 
@@ -262,7 +262,7 @@ int venus_rename(struct super_block *sb, struct CodaFid *old_fid,
 
 	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
-	CODA_FREE(inp, insize);
+	coda_free(inp, insize);
 	return error;
 }
 
@@ -295,7 +295,7 @@ int venus_create(struct super_block *sb, struct CodaFid *dirfid,
 		*newfid = outp->coda_create.VFid;
 	}
 
-	CODA_FREE(inp, insize);
+	coda_free(inp, insize);
 	return error;        
 }
 
@@ -318,7 +318,7 @@ int venus_rmdir(struct super_block *sb, struct CodaFid *dirfid,
 
 	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
-	CODA_FREE(inp, insize);
+	coda_free(inp, insize);
 	return error;
 }
 
@@ -340,7 +340,7 @@ int venus_remove(struct super_block *sb, struct CodaFid *dirfid,
 
 	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
-	CODA_FREE(inp, insize);
+	coda_free(inp, insize);
 	return error;
 }
 
@@ -370,7 +370,7 @@ int venus_readlink(struct super_block *sb, struct CodaFid *fid,
 		*(buffer + retlen) = '\0';
 	}
 
-        CODA_FREE(inp, insize);
+        coda_free(inp, insize);
         return error;
 }
 
@@ -398,7 +398,7 @@ int venus_link(struct super_block *sb, struct CodaFid *fid,
 
 	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
-	CODA_FREE(inp, insize);
+	coda_free(inp, insize);
         return error;
 }
 
@@ -433,7 +433,7 @@ int venus_symlink(struct super_block *sb, struct CodaFid *fid,
 
 	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
-	CODA_FREE(inp, insize);
+	coda_free(inp, insize);
         return error;
 }
 
@@ -450,7 +450,7 @@ int venus_fsync(struct super_block *sb, struct CodaFid *fid)
 	error = coda_upcall(coda_vcp(sb), sizeof(union inputArgs),
 			    &outsize, inp);
 
-	CODA_FREE(inp, insize);
+	coda_free(inp, insize);
 	return error;
 }
 
@@ -468,7 +468,7 @@ int venus_access(struct super_block *sb, struct CodaFid *fid, int mask)
 
 	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 
-	CODA_FREE(inp, insize);
+	coda_free(inp, insize);
 	return error;
 }
 
@@ -544,7 +544,7 @@ int venus_pioctl(struct super_block *sb, struct CodaFid *fid,
 	}
 
  exit:
-	CODA_FREE(inp, insize);
+	coda_free(inp, insize);
 	return error;
 }
 
@@ -566,7 +566,7 @@ int venus_statfs(struct dentry *dentry, struct kstatfs *sfs)
 		sfs->f_ffree  = outp->coda_statfs.stat.f_ffree;
 	}
 
-        CODA_FREE(inp, insize);
+        coda_free(inp, insize);
         return error;
 }
 
@@ -744,7 +744,7 @@ static int coda_upcall(struct venus_comm *vcp,
 	sig_req = kmalloc(sizeof(struct upc_req), GFP_KERNEL);
 	if (!sig_req) goto exit;
 
-	CODA_ALLOC((sig_req->uc_data), char *, sizeof(struct coda_in_hdr));
+	sig_req->uc_data = coda_alloc(sizeof(struct coda_in_hdr));
 	if (!sig_req->uc_data) {
 		kfree(sig_req);
 		goto exit;





