Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750931Ab2IST1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:27:50 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45606 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab2IST1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 15:27:47 -0400
Date: Wed, 19 Sep 2012 15:16:54 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: 3.6rc6 slab corruption.
Message-ID: <20120919191652.GA14631@phenom.dumpdata.com>
References: <20120918143504.GA30585@redhat.com>
 <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com>
 <20120918192338.GA25845@phenom.dumpdata.com>
 <CA+55aFy6=1vW4CN0_g8BgSKKdxZNZj9Yd2WG=0BFKjish=Vw=g@mail.gmail.com>
 <20120918203713.GB19300@phenom.dumpdata.com>
 <CA+55aFzZvFeCLF8fw=NYFN7C_8ObwJMeK13bN8xRodKQ0QJkTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzZvFeCLF8fw=NYFN7C_8ObwJMeK13bN8xRodKQ0QJkTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 01:49:52PM -0700, Linus Torvalds wrote:
> On Tue, Sep 18, 2012 at 1:37 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> >
> > 30 words. ~360 + 29 spaces + NULL = 390?
> 
> Just allocate the max then. That's tiny.
> 
> And it's actually just 330: max ten characters for an unsigned 32-bit number.

Linus,
Could you take a look at these two patches to see if I missed anything?
Thank you.

>From 0806b133b5b28081adf23d0d04a99636ed3b861b Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 19 Sep 2012 11:23:01 -0400
Subject: [PATCH 1/2] debugfs: Add lock for u32_array_read

Dave Jones spotted that the u32_array_read was doing something funny:

=============================================================================
BUG kmalloc-64 (Not tainted): Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff88001f4b4970-0xffff88001f4b4977. First byte 0xbb instead of 0xcc
INFO: Allocated in u32_array_read+0xd1/0x110 age=0 cpu=6 pid=32767
        __slab_alloc+0x516/0x5a5
        __kmalloc+0x213/0x2c0
        u32_array_read+0xd1/0x110
.. snip..
INFO: Freed in u32_array_read+0x99/0x110 age=0 cpu=0 pid=32749
        __slab_free+0x3f/0x3bf
        kfree+0x2d5/0x310
        u32_array_read+0x99/0x110

Linus tracked it down and found out that "debugfs is racy for that case
[read calls in parallel on the debugfs]. At least the file->private_data
accesses are, for the case of that "u32_array" case.

In fact it is racy in ...  the whole "file->private_data" access ..
If you have multiple readers on the same file, the whole

	if (file->private_data) {
		kfree(file->private_data);
		file->private_data = NULL;
	}

	file->private_data = format_array_alloc("%u", data->array,
                                                              data->elements);

thing is just a disaster waiting to happen." He suggested
putting a lock which this patch does.

The consequence of this is that it will trigger more spinlock usage,
as this particular debugfs is used to provide a histogram of spinlock
contention. But memory corruption is a worst offender then that.

Reported-by: Dave Jones <davej@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/debugfs/file.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 2340f69..c6d9088 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -524,6 +524,7 @@ EXPORT_SYMBOL_GPL(debugfs_create_blob);
 struct array_data {
 	void *array;
 	u32 elements;
+	struct mutex lock;
 };
 
 static int u32_array_open(struct inode *inode, struct file *file)
@@ -580,6 +581,7 @@ static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
 	struct array_data *data = inode->i_private;
 	size_t size;
 
+	mutex_lock(&data->lock);
 	if (*ppos == 0) {
 		if (file->private_data) {
 			kfree(file->private_data);
@@ -594,8 +596,10 @@ static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
 	if (file->private_data)
 		size = strlen(file->private_data);
 
-	return simple_read_from_buffer(buf, len, ppos,
+	size = simple_read_from_buffer(buf, len, ppos,
 					file->private_data, size);
+	mutex_unlock(&data->lock);
+	return size;
 }
 
 static int u32_array_release(struct inode *inode, struct file *file)
@@ -643,6 +647,7 @@ struct dentry *debugfs_create_u32_array(const char *name, umode_t mode,
 
 	data->array = array;
 	data->elements = elements;
+	mutex_init(&data->lock);
 
 	return debugfs_create_file(name, mode, parent, data, &u32_array_fops);
 }
-- 
1.7.7.6




>From c3937cb7144a6ead80e6aabee89420645945a926 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 19 Sep 2012 14:04:22 -0400
Subject: [PATCH 2/2] debugfs: Pre-allocate u32 array to thwart a race.

Linus spotted via code inspection "bug is slightly subtler
and probably harder to hit (but also harder to fix):

The whole format_array_alloc() code is one buggy piece of sh*t,
since afaik there is nothing that guarantees that the values cannot
change. So the notion of "let's format the output once to know how big
it is, and then a second time to actually print things into the array
we just allocated based on the first time" is pure and utter garbage,
afaik."

This patch fixes this by pre-allocating the buffer to the maximum
size during debugfs initialization by the driver. We print %u values,
so the math is pretty straightforward: 10 bytes for the maximum
that %u can use (4294967295) + spaces for the number of elements
and \n\0. We also add an extra byte to compensate for the
data->len == size check which we would hit if all of the array
entries were of their maximum size (-1U).

If we end up using exactly up to the size we allocated (this includes
the extra byte), then we allocate a new buffer twice the size.
And if we fail again, we print a warning as snprintf is doing
something silly.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 fs/debugfs/file.c |   66 ++++++++++++++++++++++------------------------------
 1 files changed, 28 insertions(+), 38 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index c6d9088..4c59200 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -524,12 +524,13 @@ EXPORT_SYMBOL_GPL(debugfs_create_blob);
 struct array_data {
 	void *array;
 	u32 elements;
+	ssize_t len;
+	char *buf;
 	struct mutex lock;
 };
 
 static int u32_array_open(struct inode *inode, struct file *file)
 {
-	file->private_data = NULL;
 	return nonseekable_open(inode, file);
 }
 
@@ -560,20 +561,6 @@ static size_t format_array(char *buf, size_t bufsize, const char *fmt,
 	return ret;
 }
 
-static char *format_array_alloc(const char *fmt, u32 *array,
-						u32 array_size)
-{
-	size_t len = format_array(NULL, 0, fmt, array, array_size);
-	char *ret;
-
-	ret = kmalloc(len, GFP_KERNEL);
-	if (ret == NULL)
-		return NULL;
-
-	format_array(ret, len, fmt, array, array_size);
-	return ret;
-}
-
 static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
 			      loff_t *ppos)
 {
@@ -582,37 +569,33 @@ static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
 	size_t size;
 
 	mutex_lock(&data->lock);
-	if (*ppos == 0) {
-		if (file->private_data) {
-			kfree(file->private_data);
-			file->private_data = NULL;
-		}
-
-		file->private_data = format_array_alloc("%u", data->array,
-							      data->elements);
+	if (*ppos == 0)
+		size = format_array(data->buf, data->len - 1 /* for \0 */,
+				    "%u", data->array, data->elements);
+	else
+		size = strlen(data->buf);
+
+	if (size == data->len) {
+		char *p = krealloc(data->buf, data->len * 2, GFP_KERNEL);
+		if (ZERO_OR_NULL_PTR(p))
+			goto out;
+		data->buf = p;
+		data->len *= 2;
+		size = format_array(data->buf, data->len - 1 /* for \0 */,
+				    "%u", data->array, data->elements);
+		/* It keeps on growing! Early pre-allocation MUST be wrong. */
+		WARN_ON(size == data->len);
 	}
-
-	size = 0;
-	if (file->private_data)
-		size = strlen(file->private_data);
-
+out:
 	size = simple_read_from_buffer(buf, len, ppos,
-					file->private_data, size);
+					data->buf, size);
 	mutex_unlock(&data->lock);
 	return size;
 }
 
-static int u32_array_release(struct inode *inode, struct file *file)
-{
-	kfree(file->private_data);
-
-	return 0;
-}
-
 static const struct file_operations u32_array_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = u32_array_open,
-	.release = u32_array_release,
 	.read	 = u32_array_read,
 	.llseek  = no_llseek,
 };
@@ -648,7 +631,14 @@ struct dentry *debugfs_create_u32_array(const char *name, umode_t mode,
 	data->array = array;
 	data->elements = elements;
 	mutex_init(&data->lock);
-
+	data->len = elements * 10 /* max value for %u */ +
+		    elements - 1 /* spaces */ + 2 /* \n\0 */ +
+		    1 /* to thwart the size == data->len check. */;
+	data->buf = kmalloc(data->len, GFP_KERNEL);
+	if (!data->buf) {
+		kfree(data);
+		return ERR_PTR(-ENOMEM);
+	}
 	return debugfs_create_file(name, mode, parent, data, &u32_array_fops);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u32_array);
-- 
1.7.7.6

