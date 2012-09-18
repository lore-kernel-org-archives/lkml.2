Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab2IRUYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:24:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37742 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab2IRUYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:24:20 -0400
Date: Tue, 18 Sep 2012 13:24:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: 3.6rc6 slab corruption.
In-Reply-To: <20120918192338.GA25845@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1209181322490.25146@chino.kir.corp.google.com>
References: <20120918143504.GA30585@redhat.com> <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com> <20120918192338.GA25845@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2012, Konrad Rzeszutek Wilk wrote:

> diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
> index 2340f69..309b235 100644
> --- a/fs/debugfs/file.c
> +++ b/fs/debugfs/file.c
> @@ -524,6 +524,7 @@ EXPORT_SYMBOL_GPL(debugfs_create_blob);
>  struct array_data {
>  	void *array;
>  	u32 elements;
> +	struct mutex lock;

This should be a spinlock.

>  };
>  
>  static int u32_array_open(struct inode *inode, struct file *file)
> @@ -580,6 +581,7 @@ static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
>  	struct array_data *data = inode->i_private;
>  	size_t size;
>  
> +	mutex_lock(&data->lock);
>  	if (*ppos == 0) {
>  		if (file->private_data) {
>  			kfree(file->private_data);
> @@ -594,6 +596,7 @@ static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
>  	if (file->private_data)
>  		size = strlen(file->private_data);
>  
> +	mutex_unlock(&data->lock);
>  	return simple_read_from_buffer(buf, len, ppos,
>  					file->private_data, size);
>  }

Your critical section isn't entirely covered since you're still accessing 
file->private_data in the call to simple_read_from_buffer().  What happens 
if a concurrent reader does file->private_data = NULL immediately after 
your unlock?
