Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab2GERhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 13:37:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58426 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab2GERhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 13:37:42 -0400
Date: Thu, 5 Jul 2012 21:37:29 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [rfc 2/7] procfs: Convert /proc/pid/fdinfo/ handling routines to
 seq-file
Message-ID: <20120705173729.GC16586@moon>
References: <20120627110116.201735815@openvz.org>
 <20120627110512.485189390@openvz.org>
 <4FF3F2B6.5040909@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF3F2B6.5040909@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 11:37:26AM +0400, Pavel Emelyanov wrote:
...
> 
> I believe we can still have the proc_fdinfo_read and proc_fd_link code non-splitted.
> Just push a callback pointer ino the proc_fd_info (as usual -- we an opaque void *argument).

Hi Pavel, sorry for delay (was busy a bit). It seems this wont work.
Look, previously we have had

static int proc_fd_info(struct inode *inode, struct path *path, char *info)
{
	struct task_struct *task = get_proc_task(inode);
	...

	if (info) {
		...
	}

	this makes info argument optional
}

static int proc_fd_link(struct dentry *dentry, struct path *path)
{
	return proc_fd_info(dentry->d_inode, path, NULL);
}

it's possible because we didn't use seq-files engine. One we switch to
seq-files the old proc_fd_info become a part of

static const struct file_operations proc_fdinfo_file_operations = {
	.open		= seq_fdinfo_open,

ie the declaration of seq_fdinfo_open is restricted to file_operations::open
method and I can't add opaque void *argument here.

Sure I can add one more wrapper function but I guess this increase code
complexity which I tried to escape.

	Cyrill
