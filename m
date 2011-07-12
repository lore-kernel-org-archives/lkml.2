Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab1GLWZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 18:25:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756027Ab1GLWZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 18:25:12 -0400
Date: Tue, 12 Jul 2011 15:24:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] libfs: fix simple_attr_write on 32bit machine
Message-Id: <20110712152449.08db152d.akpm@linux-foundation.org>
In-Reply-To: <1310187626-2371-1-git-send-email-akinobu.mita@gmail.com>
References: <1310187626-2371-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  9 Jul 2011 14:00:26 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> Assume that /sys/kernel/debug/dummy64 is debugfs file created by
> debugfs_create_x64().
> 
> 	# cd /sys/kernel/debug
> 	# echo 0x1234567812345678 > dummy64
> 	# cat dummy64
> 	0x0000000012345678
> 
> 	# echo 0x80000000 > dummy64
> 	# cat dummy64
> 	0xffffffff80000000
> 
> The value more than INT_MAX cannot be written to the debugfs file
> created by debugfs_create_u64 or debugfs_create_x64 on 32bit machine.
> Because simple_attr_write() uses simple_strtol() for the conversion.
> 
> To fix this, use simple_strtoll() instead.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  fs/libfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index c88eab5..275ca474 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -822,7 +822,7 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
>  		goto out;
>  
>  	attr->set_buf[size] = '\0';
> -	val = simple_strtol(attr->set_buf, NULL, 0);
> +	val = simple_strtoll(attr->set_buf, NULL, 0);
>  	ret = attr->set(attr->data, val);
>  	if (ret == 0)
>  		ret = len; /* on success, claim we got the whole input */

It should strictly be simple_strtoull(), but I guess that doesn't
change anything.

And it should always have been strict_*(), now known as kstrto*().  But
that interface fix is non-back-compatible so it's too late to fix it.

