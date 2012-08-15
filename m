Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab2HOV3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 17:29:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45173 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab2HOV33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 17:29:29 -0400
Date: Wed, 15 Aug 2012 22:29:27 +0100
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
Message-ID: <20120815212927.GO23464@ZenIV.linux.org.uk>
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
>  struct proc_fdinfo {
> -	loff_t	f_pos;
> -	int	f_flags;
> +	struct file	*f_file;
> +	int		f_flags;
>  };

> +	struct proc_fdinfo *fdinfo;
> +	struct seq_file *m;
> +	int ret;
>  
>  	fdinfo = kzalloc(sizeof(*fdinfo), GFP_KERNEL);
>  	if (!fdinfo)
>  		return -ENOMEM;

> +	ret = single_open(file, seq_show, fdinfo);
> +	if (ret) {
> +		put_filp(fdinfo->f_file);
> +		goto err_free;
>  	}
>  
> +	m = file->private_data;
> +	m->private = fdinfo;

This, BTW, is too convoluted for its own good.  What you need is
something like
struct whatever {
	struct seq_file *m;
	struct file *f;
	int flags;
};
with single allocation of that sucker in your ->open().  Set
file->private_data to address of seq_file field in your object *before*
calling seq_open() and don't bother with m->private at all - just use
container_of(m, struct whatever, m) in your ->show() to get to that
structure...
