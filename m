Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab2IUJXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:23:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62275 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab2IUJXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:23:06 -0400
Date: Fri, 21 Sep 2012 02:16:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>
Subject: [patch for-3.6] fs, debugfs: fix race in u32_array_read and allocate
 array at open
In-Reply-To: <20120920211814.GB27312@konrad-lan.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1209210216000.18230@chino.kir.corp.google.com>
References: <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com> <20120918192338.GA25845@phenom.dumpdata.com> <CA+55aFy6=1vW4CN0_g8BgSKKdxZNZj9Yd2WG=0BFKjish=Vw=g@mail.gmail.com> <20120918203713.GB19300@phenom.dumpdata.com>
 <CA+55aFzZvFeCLF8fw=NYFN7C_8ObwJMeK13bN8xRodKQ0QJkTQ@mail.gmail.com> <20120919191652.GA14631@phenom.dumpdata.com> <alpine.DEB.2.00.1209191427460.6273@chino.kir.corp.google.com> <alpine.DEB.2.00.1209191438200.21378@chino.kir.corp.google.com>
 <505A7F75.8000405@linux.vnet.ibm.com> <alpine.DEB.2.00.1209191938490.10953@chino.kir.corp.google.com> <20120920211814.GB27312@konrad-lan.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

u32_array_open() is racy when multiple threads read from a file with a
seek position of zero, i.e. when two or more simultaneous reads are
occurring after the non-seekable files are created.  It is possible that
file->private_data is double-freed because the threads races between

	kfree(file->private-data);

and

	file->private_data = NULL;

The fix is to only do format_array_alloc() when the file is opened and
free it when it is closed.  This means that any thread that holds the
file open and reads multiple times will see persistent data; they must
close() and open() the file again to see new data, like a simple cat of
the file.

Reported-by: Dave Jones <davej@redhat.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Raghavendra <raghavendra.kt@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/debugfs/file.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -526,12 +526,6 @@ struct array_data {
 	u32 elements;
 };
 
-static int u32_array_open(struct inode *inode, struct file *file)
-{
-	file->private_data = NULL;
-	return nonseekable_open(inode, file);
-}
-
 static size_t format_array(char *buf, size_t bufsize, const char *fmt,
 			   u32 *array, u32 array_size)
 {
@@ -573,26 +567,21 @@ static char *format_array_alloc(const char *fmt, u32 *array,
 	return ret;
 }
 
-static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
-			      loff_t *ppos)
+static int u32_array_open(struct inode *inode, struct file *file)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	struct array_data *data = inode->i_private;
-	size_t size;
 
-	if (*ppos == 0) {
-		if (file->private_data) {
-			kfree(file->private_data);
-			file->private_data = NULL;
-		}
-
-		file->private_data = format_array_alloc("%u", data->array,
-							      data->elements);
-	}
+	file->private_data = format_array_alloc("%u", data->array,
+						      data->elements);
+	if (!file->private_data)
+		return -ENOMEM;
+	return nonseekable_open(inode, file);
+}
 
-	size = 0;
-	if (file->private_data)
-		size = strlen(file->private_data);
+static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
+			      loff_t *ppos)
+{
+	size_t size = strlen(file->private_data);
 
 	return simple_read_from_buffer(buf, len, ppos,
 					file->private_data, size);
