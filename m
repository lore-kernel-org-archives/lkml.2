Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab2LQONa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:13:30 -0500
Received: from relay.parallels.com ([195.214.232.42]:58955 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2LQON3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:13:29 -0500
Message-ID: <50CF288E.8060002@parallels.com>
Date: Mon, 17 Dec 2012 18:13:34 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Brian Foster <bfoster@redhat.com>
CC: <miklos@szeredi.hu>, <dev@parallels.com>, <xemul@parallels.com>,
        <fuse-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: Re: [PATCH 5/6] fuse: truncate file if async dio failed
References: <20121214151424.27155.45971.stgit@maximpc.sw.ru> <20121214152113.27155.58793.stgit@maximpc.sw.ru> <50CB8931.2000305@redhat.com>
In-Reply-To: <50CB8931.2000305@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

12/15/2012 12:16 AM, Brian Foster пишет:
> On 12/14/2012 10:21 AM, Maxim V. Patlasov wrote:
>> The patch improves error handling in fuse_direct_IO(): if we successfully
>> submitted several fuse requests on behalf of synchronous direct write
>> extending file and some of them failed, let's try to do our best to clean-up.
>>
>> Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
>> ---
>>   fs/fuse/file.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>>   1 files changed, 53 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
>> index 05eed23..b6e9b8d 100644
>> --- a/fs/fuse/file.c
>> +++ b/fs/fuse/file.c
>> @@ -2340,6 +2340,53 @@ int fuse_notify_poll_wakeup(struct fuse_conn *fc,
>>   	return 0;
>>   }
>>   
>> +static void fuse_do_truncate(struct file *file)
>> +{
>> +	struct fuse_file *ff = file->private_data;
>> +	struct inode *inode = file->f_mapping->host;
>> +	struct fuse_conn *fc = get_fuse_conn(inode);
>> +	struct fuse_req *req;
>> +	struct fuse_setattr_in inarg;
>> +	struct fuse_attr_out outarg;
>> +	int err;
>> +
>> +	req = fuse_get_req_nopages(fc);
>> +	if (IS_ERR(req)) {
>> +		printk(KERN_WARNING "failed to allocate req for truncate "
>> +		       "(%ld)\n", PTR_ERR(req));
>> +		return;
>> +	}
>> +
>> +	memset(&inarg, 0, sizeof(inarg));
>> +	memset(&outarg, 0, sizeof(outarg));
>> +
>> +	inarg.valid |= FATTR_SIZE;
>> +	inarg.size = i_size_read(inode);
>> +
>> +	inarg.valid |= FATTR_FH;
>> +	inarg.fh = ff->fh;
>> +
>> +	req->in.h.opcode = FUSE_SETATTR;
>> +	req->in.h.nodeid = get_node_id(inode);
>> +	req->in.numargs = 1;
>> +	req->in.args[0].size = sizeof(inarg);
>> +	req->in.args[0].value = &inarg;
>> +	req->out.numargs = 1;
>> +	if (fc->minor < 9)
>> +		req->out.args[0].size = FUSE_COMPAT_ATTR_OUT_SIZE;
>> +	else
>> +		req->out.args[0].size = sizeof(outarg);
>> +	req->out.args[0].value = &outarg;
>> +
>> +	fuse_request_send(fc, req);
>> +	err = req->out.h.error;
>> +	fuse_put_request(fc, req);
>> +
>> +	if (err)
>> +		printk(KERN_WARNING "failed to truncate to %lld with error "
>> +		       "%d\n", i_size_read(inode), err);
>> +}
>> +
> fuse_do_truncate() looks fairly close to fuse_do_setattr(). Is there any
> reason we couldn't make fuse_do_setattr() non-static, change the dentry
> parameter to an inode and use that?

fuse_do_setattr() performs extra checks that fuse_do_truncate() needn't. 
Some of them are harmless, some not: fuse_allow_task() may return 0 if 
task credentials changed. E.g. super-user successfully opened a file, 
then setuid(other_user_uid), then write(2) to the file. write(2) doesn't 
check uid, but fuse_do_truncate() - via fuse_allow_task() - does.

This non-POSIX behaviour (ftruncate(2) returning -1 with errno==EACCES) 
was introduced long time ago:

> commit e57ac68378a287d6336d187b26971f35f7ee7251
> Author: Miklos Szeredi <mszeredi@suse.cz>
> Date:   Thu Oct 18 03:06:58 2007 -0700
>
>     fuse: fix allowing operations
>
>     The following operation didn't check if sending the request was 
> allowed:
>
>       setattr
>       listxattr
>       statfs
>
>     Some other operations don't explicitly do the check, but VFS calls
>     ->permission() which checks this.
>
>     Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

and I'm not sure whether it was done intentionally or not. Maybe Miklos 
could shed some light on it...

Thanks,
Maxim
