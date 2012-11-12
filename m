Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab2KLVg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:36:27 -0500
Received: from spam1.webland.se ([91.207.112.90]:61364 "EHLO spam1.webland.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab2KLVgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:36:22 -0500
From: Arvid Brodin <Arvid.Brodin@xdin.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "David Rientjes" <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] fs/proc: Add process text segment md5-summing
Thread-Topic: [PATCH] fs/proc: Add process text segment md5-summing
Thread-Index: AQHNwR2/ztk+j5SgV0uxA9FSmTsHGA==
Date: Mon, 12 Nov 2012 21:36:17 +0000
Message-ID: <50A16BD0.7030600@xdin.com>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20120410
 Thunderbird/8.0
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE97B8B7FE132C4B91A38E3BA537DD27@redbull.xdin.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qACLaSDg011684

Adds /proc/<pid>/text_md5sum which, when read, calculates an md5sum over
the process' text segment. This can detect some cases where the system RAM
has been disturbed by e.g. ESD or cosmic radiation (on systems where ECC
is not available). It might also detect some accidental or malicious
modifications of executables, where the perpetrator has not bothered to
cover up the tracks.

Signed-off-by: Arvid Brodin <arvid.brodin@xdin.com>
---

I'm not sure which tree this should go into. I made this patch against
next-20121112.

I had some questions and posted this patch before to get them answered. See
http://www.spinics.net/lists/kernel/msg1428503.html for the comments I
received and my responses.

Changes since the post linked above:

 * Fixed possible (probable!) crash due to not using get_task_mm()
   to lock task->mm.
 * Changed help text to clarify that this is not a security patch.
   Thanks goes to the people commenting about this!

 fs/proc/Kconfig |   14 +++++++
 fs/proc/base.c  |  112 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+), 0 deletions(-)

diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index 15af622..97fe118 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -67,3 +67,17 @@ config PROC_PAGE_MONITOR
 	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
 	  /proc/kpagecount, and /proc/kpageflags. Disabling these
           interfaces will reduce the size of the kernel by approximately 4kb.
+
+config PROC_TEXT_MD5SUM
+	bool "/proc/<pid>/text_md5sum support"
+	depends on PROC_FS
+	select CRYPTO
+	select CRYPTO_MD5
+	help
+	  Read /proc/<pid>/text_md5sum to get the kernel to perform an MD5
+	  checksum over the process' text segment and print the result. This
+	  can detect some cases where the system RAM has been disturbed by
+	  e.g. ESD or cosmic radiation (on systems where ECC is not available).
+	  It might also detect some accidental or malicious modifications of
+	  executables, where the perpetrator has not bothered to cover up the
+	  tracks.
diff --git a/fs/proc/base.c b/fs/proc/base.c
index b268bdf..b9c5fda 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -85,6 +85,10 @@
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
 #include <linux/flex_array.h>
+#ifdef CONFIG_PROC_TEXT_MD5SUM
+#include <linux/scatterlist.h>
+#include <linux/crypto.h>
+#endif
 #ifdef CONFIG_HARDWALL
 #include <asm/hardwall.h>
 #endif
@@ -2526,6 +2530,111 @@ static int proc_pid_personality(struct seq_file *m, struct
pid_namespace *ns,
 	return err;
 }

+#ifdef CONFIG_PROC_TEXT_MD5SUM
+#define MD5_DIGEST_SIZE 16
+static int proc_get_text_md5sum(struct seq_file *m, struct pid_namespace *ns,
+				struct pid *pid, struct task_struct *task)
+{
+	int retval;
+	int text_size;
+	int nr_pages, nr_pages_mapped;
+	int i;
+	struct mm_struct *mm;
+	struct page **pages;
+	struct scatterlist *sgl, *sg;
+	u8 result[MD5_DIGEST_SIZE + 2];
+	struct crypto_hash *tfm;
+	struct hash_desc desc;
+
+	retval = 0;
+
+	mm = get_task_mm(task);
+	if (!mm)
+		return -EINVAL;
+
+	text_size = mm->end_code - mm->start_code;
+	nr_pages = (text_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+
+
+	/**** User page code ****/
+
+	pages = kmalloc(nr_pages * sizeof(*pages), GFP_KERNEL);
+	if (!pages) {
+		retval = -ENOMEM;
+		goto err_pages;
+	}
+
+	down_read(&mm->mmap_sem);
+	nr_pages_mapped = get_user_pages(current, mm,
+				mm->start_code, nr_pages, 0, 0, pages, NULL);
+	up_read(&mm->mmap_sem);
+	if (nr_pages_mapped < 0) {
+		retval = nr_pages_mapped;
+		goto err_mapped;
+	}
+	if (nr_pages_mapped < nr_pages) {
+		retval = -EBUSY; /* Weird error code for this,
+				    but couldn't find any better */
+		goto err_not_all_pages;
+	}
+
+
+	/**** Scatterlist code ****/
+
+	sgl = kmalloc(nr_pages_mapped * sizeof(*sgl), GFP_KERNEL);
+	if (!sgl) {
+		retval = -ENOMEM;
+		goto err_sg;
+	}
+
+	sg_init_table(sgl, nr_pages_mapped);
+	for_each_sg(sgl, sg, nr_pages_mapped, i)
+		sg_set_page(sg, pages[i], (i < nr_pages_mapped) ? PAGE_SIZE :
+						text_size & ~PAGE_MASK, 0);
+
+
+	/**** Crypto code ****/
+
+	tfm = crypto_alloc_hash("md5", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm)) {
+		retval = -ENOMEM;
+		goto err_crypto;
+	}
+
+	desc.tfm = tfm;
+	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	memset(result, 0, MD5_DIGEST_SIZE + 2);
+	retval = crypto_hash_digest(&desc, sgl, text_size, result);
+	if (retval)
+		goto err_digest;
+
+	for (i = 0; i < MD5_DIGEST_SIZE; i++)
+		seq_printf(m, "%02x", result[i]);
+	seq_printf(m, "\n");
+
+
+err_digest:
+	crypto_free_hash(tfm);
+
+err_crypto:
+	kfree(sgl);
+
+err_sg:
+err_not_all_pages:
+	for (i = 0; i < nr_pages_mapped; i++)
+		put_page(pages[i]);
+
+err_mapped:
+	kfree(pages);
+
+err_pages:
+	mmput(mm);
+
+	return retval;
+}
+#endif /* CONFIG_PROC_TEXT_MD5SUM */
+
 /*
  * Thread groups
  */
@@ -2621,6 +2730,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
 #endif
+#ifdef CONFIG_PROC_TEXT_MD5SUM
+	ONE("text_md5sum", S_IRUGO, proc_get_text_md5sum),
+#endif
 };

 static int proc_tgid_base_readdir(struct file * filp,
-- 
1.7.3.4


-- 
Arvid Brodin | Consultant (Linux)
XDIN AB | KnarrarnÃ¤sgatan 7 | SE-164 40 Kista | Sweden | xdin.comÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
