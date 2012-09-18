Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2IRUmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:42:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:16747 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab2IRUm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:42:29 -0400
Date: Tue, 18 Sep 2012 16:31:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: 3.6rc6 slab corruption.
Message-ID: <20120918203124.GA19300@phenom.dumpdata.com>
References: <20120918143504.GA30585@redhat.com>
 <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com>
 <20120918192338.GA25845@phenom.dumpdata.com>
 <alpine.DEB.2.00.1209181322490.25146@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209181322490.25146@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 01:24:15PM -0700, David Rientjes wrote:
> On Tue, 18 Sep 2012, Konrad Rzeszutek Wilk wrote:
> 
> > diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
> > index 2340f69..309b235 100644
> > --- a/fs/debugfs/file.c
> > +++ b/fs/debugfs/file.c
> > @@ -524,6 +524,7 @@ EXPORT_SYMBOL_GPL(debugfs_create_blob);
> >  struct array_data {
> >  	void *array;
> >  	u32 elements;
> > +	struct mutex lock;
> 
> This should be a spinlock.

I would get warnings about using a spinlock..
.. snip..
> > +	mutex_unlock(&data->lock);
> >  	return simple_read_from_buffer(buf, len, ppos,
> >  					file->private_data, size);
> >  }
> 
> Your critical section isn't entirely covered since you're still accessing 
> file->private_data in the call to simple_read_from_buffer().  What happens 
> if a concurrent reader does file->private_data = NULL immediately after 
> your unlock?

Duh!

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
