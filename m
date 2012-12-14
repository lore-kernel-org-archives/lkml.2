Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab2LNUS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 15:18:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab2LNUS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 15:18:58 -0500
Message-ID: <50CB8931.2000305@redhat.com>
Date: Fri, 14 Dec 2012 15:16:49 -0500
From: Brian Foster <bfoster@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Maxim V. Patlasov" <MPatlasov@parallels.com>
CC: miklos@szeredi.hu, dev@parallels.com, xemul@parallels.com,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Subject: Re: [PATCH 5/6] fuse: truncate file if async dio failed
References: <20121214151424.27155.45971.stgit@maximpc.sw.ru> <20121214152113.27155.58793.stgit@maximpc.sw.ru>
In-Reply-To: <20121214152113.27155.58793.stgit@maximpc.sw.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 10:21 AM, Maxim V. Patlasov wrote:
> The patch improves error handling in fuse_direct_IO(): if we successfully
> submitted several fuse requests on behalf of synchronous direct write
> extending file and some of them failed, let's try to do our best to clean-up.
> 
> Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
> ---
>  fs/fuse/file.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 53 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 05eed23..b6e9b8d 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -2340,6 +2340,53 @@ int fuse_notify_poll_wakeup(struct fuse_conn *fc,
>  	return 0;
>  }
>  
> +static void fuse_do_truncate(struct file *file)
> +{
> +	struct fuse_file *ff = file->private_data;
> +	struct inode *inode = file->f_mapping->host;
> +	struct fuse_conn *fc = get_fuse_conn(inode);
> +	struct fuse_req *req;
> +	struct fuse_setattr_in inarg;
> +	struct fuse_attr_out outarg;
> +	int err;
> +
> +	req = fuse_get_req_nopages(fc);
> +	if (IS_ERR(req)) {
> +		printk(KERN_WARNING "failed to allocate req for truncate "
> +		       "(%ld)\n", PTR_ERR(req));
> +		return;
> +	}
> +
> +	memset(&inarg, 0, sizeof(inarg));
> +	memset(&outarg, 0, sizeof(outarg));
> +
> +	inarg.valid |= FATTR_SIZE;
> +	inarg.size = i_size_read(inode);
> +
> +	inarg.valid |= FATTR_FH;
> +	inarg.fh = ff->fh;
> +
> +	req->in.h.opcode = FUSE_SETATTR;
> +	req->in.h.nodeid = get_node_id(inode);
> +	req->in.numargs = 1;
> +	req->in.args[0].size = sizeof(inarg);
> +	req->in.args[0].value = &inarg;
> +	req->out.numargs = 1;
> +	if (fc->minor < 9)
> +		req->out.args[0].size = FUSE_COMPAT_ATTR_OUT_SIZE;
> +	else
> +		req->out.args[0].size = sizeof(outarg);
> +	req->out.args[0].value = &outarg;
> +
> +	fuse_request_send(fc, req);
> +	err = req->out.h.error;
> +	fuse_put_request(fc, req);
> +
> +	if (err)
> +		printk(KERN_WARNING "failed to truncate to %lld with error "
> +		       "%d\n", i_size_read(inode), err);
> +}
> +

fuse_do_truncate() looks fairly close to fuse_do_setattr(). Is there any
reason we couldn't make fuse_do_setattr() non-static, change the dentry
parameter to an inode and use that?

Brian

>  static ssize_t
>  fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
>  			loff_t offset, unsigned long nr_segs)
> @@ -2400,8 +2447,12 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
>  		kfree(io);
>  	}
>  
> -	if (rw == WRITE && ret > 0)
> -		fuse_write_update_size(inode, pos);
> +	if (rw == WRITE) {
> +		if (ret > 0)
> +			fuse_write_update_size(inode, pos);
> +		else if (ret < 0 && offset + count > i_size)
> +			fuse_do_truncate(file);
> +	}
>  
>  	return ret;
>  }
> 

