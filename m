Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1HDXSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 19:18:49 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33024 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752929Ab1HDXSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 19:18:43 -0400
X-Sasl-enc: 75/Bx0HTVnLxBKwEvp/FvvjqCWnozaNjl0nglDMD1yrX 1312499922
Date: Thu, 4 Aug 2011 16:18:38 -0700
From: Greg KH <greg@kroah.com>
To: paul.clements@steeleye.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] nbd: nbd sysfs framework
Message-ID: <20110804231838.GA2978@kroah.com>
References: <4e3b190f.NjLPBhXLsVSgFxi+%paul.clements@steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e3b190f.NjLPBhXLsVSgFxi+%paul.clements@steeleye.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[admin note, bounced to lkml?  wierd...]

On Thu, Aug 04, 2011 at 06:11:27PM -0400, paul.clements@steeleye.com wrote:
> Description: This patch adds a small framework that will simplify adding
> sysfs entries for nbd (coming later). All the locking and structure walking
> are in the main nbd_attr_ handlers and the individual entries' show and store
> handlers will be much simpler. The patch moves the one existing sysfs entry
> (pid) to use the framework. ABI docs included.

Again, I fail to understand _why_ this is needed at all.  You can
trivially add new sysfs files in an attribute group to nbd without
adding this "infrastructure", making the overall patch set much smaller,
right?

Actually, there's a problem in the original code that you should fix
that will show this in an easier way:

>  static int nbd_do_it(struct nbd_device *lo)
>  {
>  	struct request *req;
> -	int ret;
>  
>  	BUG_ON(lo->magic != LO_MAGIC);
>  
>  	lo->pid = current->pid;
> -	ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);

That should be using device_create_file() and not sysfs_create_file, as
that is what is really happening here.

Then just do the same "cast" in each of your new sysfs files that you
want to create.

Actually, you should be setting the groups pointer of the device here to
properly create the sysfs files at the correct time, instead of having
it as-is which races with userspace.  That would make the code even
smaller than it currently is today as well, and make it even easier to
add new sysfs files like you really want to do.

So, in short, no, this patch is still not acceptable.  And in the
future, properly set your Cc: lines.

greg k-h
