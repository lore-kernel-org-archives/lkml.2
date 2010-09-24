Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab0IXRQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:16:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab0IXRQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:16:48 -0400
Date: Fri, 24 Sep 2010 13:16:24 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 6/7 v3] overlay: hybrid overlay filesystem prototype
Message-ID: <20100924171624.GA25129@shell>
References: <20100920180404.939991832@szeredi.hu> <20100920180447.854260354@szeredi.hu> <20100922232110.GC26268@shell> <4C9CB6A1.9010904@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9CB6A1.9010904@kernel.dk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 04:33:05PM +0200, Jens Axboe wrote:
> On 2010-09-23 01:21, Valerie Aurora wrote:
> > On Mon, Sep 20, 2010 at 08:04:10PM +0200, Miklos Szeredi wrote:
> >> From: Miklos Szeredi <mszeredi@suse.cz>
> >>
> >> This overlay filesystem is a hybrid of entirely filesystem based
> >> (unionfs, aufs) and entierly VFS based (union mounts) solutions.
> > 
> > [...]
> > 
> >> +static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
> >> +{
> >> +	struct file *old_file;
> >> +	struct file *new_file;
> >> +	int error = 0;
> >> +
> >> +	if (len == 0)
> >> +		return 0;
> >> +
> >> +	old_file = path_open(old, O_RDONLY);
> >> +	if (IS_ERR(old_file))
> >> +		return PTR_ERR(old_file);
> >> +
> >> +	new_file = path_open(new, O_WRONLY);
> >> +	if (IS_ERR(new_file)) {
> >> +		error = PTR_ERR(new_file);
> >> +		goto out_fput;
> >> +	}
> >> +
> >> +	/* FIXME: copy up sparse files efficiently */
> >> +	while (len) {
> >> +		loff_t offset = new_file->f_pos;
> >> +		size_t this_len = OVL_COPY_UP_CHUNK_SIZE;
> >> +		long bytes;
> >> +
> >> +		if (len < this_len)
> >> +			this_len = len;
> >> +
> >> +		if (signal_pending_state(TASK_KILLABLE, current))
> >> +			return -EINTR;
> >> +
> >> +		bytes = do_splice_direct(old_file, &offset, new_file, this_len,
> >> +				 SPLICE_F_MOVE);
> > 
> > Interruptible copyup is good.  But it looks like splice setup is kind
> > of heavyweight and we should do it as seldom as possible.
> > 
> > What about implementing splice flag SPLICE_F_INTERRUPTIBLE instead?
> 
> The pipe alloc and such? That is lazily done and sticks around.

Thanks!  So this looks like a good way to implement interruptible
in-kernel file copyup?

-VAL
