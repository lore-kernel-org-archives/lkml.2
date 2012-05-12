Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761560Ab2ELAUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:20:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42602 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761454Ab2ELAUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:20:15 -0400
Date: Fri, 11 May 2012 17:18:41 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 10/11] pstore/ram: Switch to persistent_ram routines
Message-ID: <20120512001840.GJ14782@lizard>
References: <20120512001506.GA8653@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120512001506.GA8653@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch switches pstore RAM backend to use persistent_ram routines,
one step closer to the ECC support.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c |  109 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 60 insertions(+), 49 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index b26b58e..cf0ad92 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -62,7 +62,7 @@ MODULE_PARM_DESC(dump_oops,
 		"set to 1 to dump oopses, 0 to only dump panics (default 1)");
 
 struct ramoops_context {
-	void *virt_addr;
+	struct persistent_ram_zone **przs;
 	phys_addr_t phys_addr;
 	unsigned long size;
 	size_t record_size;
@@ -90,39 +90,56 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 				   struct pstore_info *psi)
 {
 	ssize_t size;
-	char *rambuf;
 	struct ramoops_context *cxt = psi->data;
+	struct persistent_ram_zone *prz;
 
 	if (cxt->read_count >= cxt->max_count)
 		return -EINVAL;
+
 	*id = cxt->read_count++;
+	prz = cxt->przs[*id];
+
 	/* Only supports dmesg output so far. */
 	*type = PSTORE_TYPE_DMESG;
 	/* TODO(kees): Bogus time for the moment. */
 	time->tv_sec = 0;
 	time->tv_nsec = 0;
 
-	rambuf = cxt->virt_addr + (*id * cxt->record_size);
-	size = strnlen(rambuf, cxt->record_size);
+	size = persistent_ram_old_size(prz);
 	*buf = kmalloc(size, GFP_KERNEL);
 	if (*buf == NULL)
 		return -ENOMEM;
-	memcpy(*buf, rambuf, size);
+	memcpy(*buf, persistent_ram_old(prz), size);
 
 	return size;
 }
 
+static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
+{
+	char *hdr;
+	struct timeval timestamp;
+	size_t len;
+
+	do_gettimeofday(&timestamp);
+	hdr = kasprintf(GFP_ATOMIC, RAMOOPS_KERNMSG_HDR "%lu.%lu\n",
+		(long)timestamp.tv_sec, (long)timestamp.tv_usec);
+	WARN_ON_ONCE(!hdr);
+	len = hdr ? strlen(hdr) : 0;
+	persistent_ram_write(prz, hdr, len);
+	kfree(hdr);
+
+	return len;
+}
+
 static int ramoops_pstore_write(enum pstore_type_id type,
 				enum kmsg_dump_reason reason,
 				u64 *id,
 				unsigned int part,
 				size_t size, struct pstore_info *psi)
 {
-	char *buf;
-	size_t res;
-	struct timeval timestamp;
 	struct ramoops_context *cxt = psi->data;
-	size_t available = cxt->record_size;
+	struct persistent_ram_zone *prz = cxt->przs[cxt->count];
+	size_t hlen;
 
 	/* Currently ramoops is designed to only store dmesg dumps. */
 	if (type != PSTORE_TYPE_DMESG)
@@ -147,22 +164,10 @@ static int ramoops_pstore_write(enum pstore_type_id type,
 	if (part != 1)
 		return -ENOSPC;
 
-	buf = cxt->virt_addr + (cxt->count * cxt->record_size);
-
-	res = sprintf(buf, "%s", RAMOOPS_KERNMSG_HDR);
-	buf += res;
-	available -= res;
-
-	do_gettimeofday(&timestamp);
-	res = sprintf(buf, "%lu.%lu\n", (long)timestamp.tv_sec, (long)timestamp.tv_usec);
-	buf += res;
-	available -= res;
-
-	if (size > available)
-		size = available;
-
-	memcpy(buf, cxt->pstore.buf, size);
-	memset(buf + size, '\0', available - size);
+	hlen = ramoops_write_kmsg_hdr(prz);
+	if (size + hlen > prz->buffer_size)
+		size = prz->buffer_size - hlen;
+	persistent_ram_write(prz, cxt->pstore.buf, size);
 
 	cxt->count = (cxt->count + 1) % cxt->max_count;
 
@@ -172,14 +177,12 @@ static int ramoops_pstore_write(enum pstore_type_id type,
 static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
 				struct pstore_info *psi)
 {
-	char *buf;
 	struct ramoops_context *cxt = psi->data;
 
 	if (id >= cxt->max_count)
 		return -EINVAL;
 
-	buf = cxt->virt_addr + (id * cxt->record_size);
-	memset(buf, '\0', cxt->record_size);
+	persistent_ram_free_old(cxt->przs[id]);
 
 	return 0;
 }
@@ -200,6 +203,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	struct ramoops_platform_data *pdata = pdev->dev.platform_data;
 	struct ramoops_context *cxt = &oops_cxt;
 	int err = -EINVAL;
+	int i;
 
 	/* Only a single ramoops area allowed at a time, so fail extra
 	 * probes.
@@ -237,32 +241,37 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	cxt->record_size = pdata->record_size;
 	cxt->dump_oops = pdata->dump_oops;
 
+	cxt->przs = kzalloc(sizeof(*cxt->przs) * cxt->max_count, GFP_KERNEL);
+	if (!cxt->przs) {
+		pr_err("failed to initialize a prz array\n");
+		goto fail_przs;
+	}
+
+	for (i = 0; i < cxt->max_count; i++) {
+		size_t sz = cxt->record_size;
+		phys_addr_t start = cxt->phys_addr + sz * i;
+
+		cxt->przs[i] = persistent_ram_new(start, sz, 0);
+		if (IS_ERR(cxt->przs[i])) {
+			err = PTR_ERR(cxt->przs[i]);
+			pr_err("failed to initialize a prz\n");
+			goto fail_prz;
+		}
+	}
+
 	cxt->pstore.data = cxt;
-	cxt->pstore.bufsize = cxt->record_size;
-	cxt->pstore.buf = kmalloc(cxt->pstore.bufsize, GFP_KERNEL);
 	spin_lock_init(&cxt->pstore.buf_lock);
+	cxt->pstore.bufsize = cxt->przs[0]->buffer_size;
+	cxt->pstore.buf = kmalloc(cxt->pstore.bufsize, GFP_KERNEL);
 	if (!cxt->pstore.buf) {
 		pr_err("cannot allocate pstore buffer\n");
 		goto fail_clear;
 	}
 
-	if (!request_mem_region(cxt->phys_addr, cxt->size, "ramoops")) {
-		pr_err("request mem region (0x%lx@0x%llx) failed\n",
-			cxt->size, (unsigned long long)cxt->phys_addr);
-		err = -EINVAL;
-		goto fail_buf;
-	}
-
-	cxt->virt_addr = ioremap(cxt->phys_addr,  cxt->size);
-	if (!cxt->virt_addr) {
-		pr_err("ioremap failed\n");
-		goto fail_mem_region;
-	}
-
 	err = pstore_register(&cxt->pstore);
 	if (err) {
 		pr_err("registering with pstore failed\n");
-		goto fail_iounmap;
+		goto fail_pstore;
 	}
 
 	/*
@@ -280,15 +289,17 @@ static int __init ramoops_probe(struct platform_device *pdev)
 
 	return 0;
 
-fail_iounmap:
-	iounmap(cxt->virt_addr);
-fail_mem_region:
-	release_mem_region(cxt->phys_addr, cxt->size);
-fail_buf:
+fail_pstore:
 	kfree(cxt->pstore.buf);
 fail_clear:
 	cxt->pstore.bufsize = 0;
 	cxt->max_count = 0;
+fail_przs:
+	for (i = 0; cxt->przs[i]; i++)
+		persistent_ram_free(cxt->przs[i]);
+	kfree(cxt->przs);
+fail_prz:
+	kfree(cxt->pstore.buf);
 fail_out:
 	return err;
 }
-- 
1.7.9.2

