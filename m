Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab2HOVQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 17:16:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37094 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab2HOVQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 17:16:31 -0400
Date: Wed, 15 Aug 2012 22:16:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 3/8] procfs: Add ability to plug in auxiliary fdinfo
 providers
Message-ID: <20120815211628.GN23464@ZenIV.linux.org.uk>
References: <20120815092116.700948346@openvz.org>
 <20120815092409.507162379@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815092409.507162379@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 01:21:19PM +0400, Cyrill Gorcunov wrote:
> -static int fdinfo_open_helper(struct inode *inode, int *f_flags, struct path *path)
> +static int fdinfo_open_helper(struct inode *inode, int *f_flags, struct file **f_file, struct path *path)

Bloody bad taste, that...  This kind of optional arguments is almost always
a bad sign - tends to happen when you have two barely related functions
crammed into one.  And yes, proc_fd_info() suffers the same braindamage.
Trying to avoid code duplication is generally a good thing, but it's not
always worth doing - less obfuscated code wins.

>  static int seq_show(struct seq_file *m, void *v)
>  {
>  	struct proc_fdinfo *fdinfo = m->private;
> -	seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
> -		   (long long)fdinfo->f_pos,
> -		   fdinfo->f_flags);
> -	return 0;
> +	int ret;
> +
> +	ret = seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
> +			 (long long)fdinfo->f_file->f_pos,
> +			 fdinfo->f_flags);

Realistically, that one is not going to overflow; you are almost certainly
wasting more cycles on that check of !ret just below than you'll save on
not going into ->show_fdinfo() in case of full buffer.

> +	if (!ret && fdinfo->f_file->f_op->show_fdinfo)
> +		ret = fdinfo->f_file->f_op->show_fdinfo(m, fdinfo->f_file);
> +
> +	return ret;
>  }
  
> +	ret = single_open(file, seq_show, fdinfo);
> +	if (ret) {
> +		put_filp(fdinfo->f_file);

Excuse me?  We should *never* do put_filp() on anything that has already
been opened.  Think what happens if you race with close(); close() would
rip the reference from descriptor table and do fput(), leaving you with
the last reference to that struct file.  You really don't want to just
go and free it.  IOW, that one should be fput().

> +	put_filp(fdinfo->f_file);
Ditto.
