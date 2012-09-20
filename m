Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2ITM7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:59:32 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:34431 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab2ITM7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:59:30 -0400
Message-ID: <505B1257.5060702@linux.vnet.ibm.com>
Date: Thu, 20 Sep 2012 18:25:51 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>
Subject: Re: 3.6rc6 slab corruption.
References: <20120918143504.GA30585@redhat.com> <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com> <20120918192338.GA25845@phenom.dumpdata.com> <CA+55aFy6=1vW4CN0_g8BgSKKdxZNZj9Yd2WG=0BFKjish=Vw=g@mail.gmail.com> <20120918203713.GB19300@phenom.dumpdata.com> <CA+55aFzZvFeCLF8fw=NYFN7C_8ObwJMeK13bN8xRodKQ0QJkTQ@mail.gmail.com> <20120919191652.GA14631@phenom.dumpdata.com>
In-Reply-To: <20120919191652.GA14631@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092012-3568-0000-0000-0000027DDBFC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 12:46 AM, Konrad Rzeszutek Wilk wrote:
> On Tue, Sep 18, 2012 at 01:49:52PM -0700, Linus Torvalds wrote:
>> On Tue, Sep 18, 2012 at 1:37 PM, Konrad Rzeszutek Wilk
>> <konrad.wilk@oracle.com>  wrote:
>>>
>>> 30 words. ~360 + 29 spaces + NULL = 390?
>>
>> Just allocate the max then. That's tiny.
>>
>> And it's actually just 330: max ten characters for an unsigned 32-bit number.
>
> Linus,
> Could you take a look at these two patches to see if I missed anything?
> Thank you.
>
>> From 0806b133b5b28081adf23d0d04a99636ed3b861b Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk<konrad.wilk@oracle.com>
> Date: Wed, 19 Sep 2012 11:23:01 -0400
> Subject: [PATCH 1/2] debugfs: Add lock for u32_array_read
>
> Dave Jones spotted that the u32_array_read was doing something funny:
>
> =============================================================================
> BUG kmalloc-64 (Not tainted): Redzone overwritten
> -----------------------------------------------------------------------------
>
> INFO: 0xffff88001f4b4970-0xffff88001f4b4977. First byte 0xbb instead of 0xcc
> INFO: Allocated in u32_array_read+0xd1/0x110 age=0 cpu=6 pid=32767
>          __slab_alloc+0x516/0x5a5
>          __kmalloc+0x213/0x2c0
>          u32_array_read+0xd1/0x110
> .. snip..
> INFO: Freed in u32_array_read+0x99/0x110 age=0 cpu=0 pid=32749
>          __slab_free+0x3f/0x3bf
>          kfree+0x2d5/0x310
>          u32_array_read+0x99/0x110
>
> Linus tracked it down and found out that "debugfs is racy for that case
> [read calls in parallel on the debugfs]. At least the file->private_data
> accesses are, for the case of that "u32_array" case.
>
> In fact it is racy in ...  the whole "file->private_data" access ..
> If you have multiple readers on the same file, the whole
>
> 	if (file->private_data) {
> 		kfree(file->private_data);
> 		file->private_data = NULL;
> 	}
>
> 	file->private_data = format_array_alloc("%u", data->array,
>                                                                data->elements);
>
> thing is just a disaster waiting to happen." He suggested
> putting a lock which this patch does.
>
> The consequence of this is that it will trigger more spinlock usage,
> as this particular debugfs is used to provide a histogram of spinlock
> contention. But memory corruption is a worst offender then that.
>
> Reported-by: Dave Jones<davej@redhat.com>
> Suggested-by: Linus Torvalds<torvalds@linux-foundation.org>
Tested-by: Raghavendra <raghavendra.kt@linux.vnet.ibm.com>

> ---
>   fs/debugfs/file.c |    7 ++++++-
>   1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
> index 2340f69..c6d9088 100644
> --- a/fs/debugfs/file.c
> +++ b/fs/debugfs/file.c
> @@ -524,6 +524,7 @@ EXPORT_SYMBOL_GPL(debugfs_create_blob);
>   struct array_data {
>   	void *array;
>   	u32 elements;
> +	struct mutex lock;
>   };
>
>   static int u32_array_open(struct inode *inode, struct file *file)
> @@ -580,6 +581,7 @@ static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
>   	struct array_data *data = inode->i_private;
>   	size_t size;
>
> +	mutex_lock(&data->lock);
>   	if (*ppos == 0) {
>   		if (file->private_data) {
>   			kfree(file->private_data);
> @@ -594,8 +596,10 @@ static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
>   	if (file->private_data)
>   		size = strlen(file->private_data);
>
> -	return simple_read_from_buffer(buf, len, ppos,
> +	size = simple_read_from_buffer(buf, len, ppos,
>   					file->private_data, size);
> +	mutex_unlock(&data->lock);
> +	return size;
>   }
>
>   static int u32_array_release(struct inode *inode, struct file *file)
> @@ -643,6 +647,7 @@ struct dentry *debugfs_create_u32_array(const char *name, umode_t mode,
>
>   	data->array = array;
>   	data->elements = elements;
> +	mutex_init(&data->lock);
>
>   	return debugfs_create_file(name, mode, parent, data,&u32_array_fops);
>   }

I was also able to reproduce the problem with pthread usage  and
David's  msleep  trick.

[   65.438698] BUG kmalloc-96 (Not tainted): Object already free
[   65.534572] BUG kmalloc-96 (Not tainted): Poison overwritten
[ 2488.195923] BUG kmalloc-96 (Not tainted): Redzone overwritten
all the above BUG without David's array allocation in open patch
  and Konrad's mutex patch.
(Both the patches tested separately)


