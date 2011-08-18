Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab1HRPA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 11:00:57 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:35820 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755006Ab1HRPA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 11:00:56 -0400
Date: Thu, 18 Aug 2011 08:00:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/5] fs: add netlink notification interface
Message-Id: <20110818080053.ce65d17e.rdunlap@xenotime.net>
In-Reply-To: <1313669906-14931-2-git-send-email-lczerner@redhat.com>
References: <1313669906-14931-1-git-send-email-lczerner@redhat.com>
	<1313669906-14931-2-git-send-email-lczerner@redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011 14:18:22 +0200 Lukas Czerner wrote:


>  fs/Makefile        |    2 +-
>  fs/netlink.c       |  107 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h |   11 +++++
>  3 files changed, 119 insertions(+), 1 deletions(-)
>  create mode 100644 fs/netlink.c

Hi,

Does this build OK when CONFIG_NET is not enabled?

and also for kernels that do not have CONFIG_NET enabled:  are these
new netlink messages basically duplicates of printk() calls that are
already there and will remain there?

Thanks.

> diff --git a/fs/Makefile b/fs/Makefile
> index afc1096..7e9c61f 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
>  		attr.o bad_inode.o file.o filesystems.o namespace.o \
>  		seq_file.o xattr.o libfs.o fs-writeback.o \
>  		pnode.o drop_caches.o splice.o sync.o utimes.o \
> -		stack.o fs_struct.o statfs.o
> +		stack.o fs_struct.o statfs.o netlink.o
>  
>  ifeq ($(CONFIG_BLOCK),y)
>  obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
> diff --git a/fs/netlink.c b/fs/netlink.c
> new file mode 100644
> index 0000000..15c44a1
> --- /dev/null
> +++ b/fs/netlink.c
> @@ -0,0 +1,107 @@
> +#include <linux/fs.h>
> +#include <linux/cred.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <net/netlink.h>
> +#include <net/genetlink.h>
> +
> +enum {
> +	FS_NL_A_UNSPEC,
> +	FS_NL_A_WARNING,
> +	FS_NL_A_DEV_MAJOR,
> +	FS_NL_A_DEV_MINOR,
> +	FS_NL_A_CAUSED_ID,
> +	__FS_NL_A_MAX,
> +};
> +#define FS_NL_A_MAX (__FS_NL_A_MAX - 1)
> +
> +enum {
> +	FS_NL_C_UNSPEC,
> +	FS_NL_C_WARNING,
> +	__FS_NL_C_MAX,
> +};
> +#define FS_NL_C_MAX (__FS_NL_C_MAX - 1)
> +
> +
> +static struct genl_family fs_genl_family = {
> +	.id = GENL_ID_GENERATE,
> +	.hdrsize = 0,
> +	.name = "FS_MSG",
> +	.version = 1,
> +	.maxattr = FS_NL_A_MAX,
> +};
> +static int registered;
> +
> +/**
> + * fs_nl_send_warning - Send warning from file system to userspace
> + * @dev: The device on which the fs is mounted
> + * @warntype: The type of the warning
> + *
> + * This can be used by file systems to send a warning message to the
> + * userspace.
> + */
> +
> +void fs_nl_send_warning(dev_t dev, unsigned int warntype)
> +{
> +	static atomic_t seq;
> +	struct sk_buff *skb;
> +	void *msg_head;
> +	int ret;
> +	int msg_size = nla_total_size(sizeof(u64)) +
> +			3 * nla_total_size(sizeof(u32));
> +
> +	/* We have to allocate using GFP_NOFS as we are called from a
> +	 * filesystem performing write and thus further recursion into
> +	 * the fs to free some data could cause deadlocks. */
> +	skb = genlmsg_new(msg_size, GFP_NOFS);
> +	if (!skb) {
> +		printk(KERN_ERR
> +		  "VFS: Not enough memory to send fs warning.\n");
> +		return;
> +	}
> +	msg_head = genlmsg_put(skb, 0, atomic_add_return(1, &seq),
> +			&fs_genl_family, 0, FS_NL_C_WARNING);
> +	if (!msg_head) {
> +		printk(KERN_ERR
> +		  "VFS: Cannot store netlink header in fs warning.\n");
> +		goto err_out;
> +	}
> +	ret = nla_put_u32(skb, FS_NL_A_WARNING, warntype);
> +	if (ret)
> +		goto attr_err_out;
> +	ret = nla_put_u32(skb, FS_NL_A_DEV_MAJOR, MAJOR(dev));
> +	if (ret)
> +		goto attr_err_out;
> +	ret = nla_put_u32(skb, FS_NL_A_DEV_MINOR, MINOR(dev));
> +	if (ret)
> +		goto attr_err_out;
> +	ret = nla_put_u64(skb, FS_NL_A_CAUSED_ID, current_uid());
> +	if (ret)
> +		goto attr_err_out;
> +	genlmsg_end(skb, msg_head);
> +	genlmsg_multicast(skb, 0, fs_genl_family.id, GFP_NOFS);
> +	return;
> +attr_err_out:
> +	printk(KERN_ERR "VFS: Not enough space to compose "
> +			"fs netlink message!\n");
> +err_out:
> +	kfree_skb(skb);
> +}
> +EXPORT_SYMBOL(fs_nl_send_warning);
> +
> +void init_fs_nl_family(void)
> +{
> +	if (registered)
> +		return;
> +
> +	if (genl_register_family(&fs_genl_family) != 0) {
> +		printk(KERN_ERR
> +		       "VFS: Failed to create fs netlink interface.\n");
> +		return;
> +	}
> +	registered = 1;
> +}
> +EXPORT_SYMBOL(init_fs_nl_family);


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
