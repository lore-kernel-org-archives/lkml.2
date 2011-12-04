Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab1LDWKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 17:10:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42580 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab1LDWKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 17:10:21 -0500
Date: Sun, 4 Dec 2011 22:10:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: John Johansen <john.johansen@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Remove use of mnt_ns->root and fix a couple of bugs in
 d_namespace_path
Message-ID: <20111204221020.GB2203@ZenIV.linux.org.uk>
References: <1323034020-28780-1-git-send-email-john.johansen@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323034020-28780-1-git-send-email-john.johansen@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 04, 2011 at 01:27:00PM -0800, John Johansen wrote:
> +	/* is the path a sysctl? */
> +	if (path->dentry->d_sb->s_magic == PROC_SUPER_MAGIC &&
> +	    strncmp(*name, "/sys/", 5) == 0) {
> +		/* TODO: convert over to using a per namespace
> +		 * control instead of hard coded /proc
> +		 */
> +		error = prepend(name, *name - buf, "/proc", 5);
> +	}

Um?  What if some joker mounts procfs under /sys/<something> or
on /mnt/sys/something (with /mnt being mountpoint as well) and
you race with umount -l /mnt?  Because you *can* race with it
and get tmp pointing to (already freed) root of whatever had been
mounted on /mnt, with name being e.g. /sys/1/stat...  Your check
will happily assume that it's a sysctl, even though /proc/sys/1/stat
had never existed and operation was not done to it at all (it was
to /mnt/sys/1/stat, which would be the same thing as /proc/1/stat in
this setup).

> +	if ((tmp.dentry == root.dentry && tmp.mnt == root.mnt) &&
> +	    !(flags & PATH_CONNECT_PATH)) {
> +		/* disconnected path, don't return pathname starting
> +		 * with '/'
> +		 */
> +		error = -EACCES;
> +		if (*res == '/')
> +			*name = res + 1;

That's not equivalent to what it used to do and I'm not sure that it
makes much sense (not that the original had...)  Note that it will
_always_ fail with -EACCES if you have chroot environment and pass
neither PATH_CHROOT_REL nor PATH_CONNECT_PATH - in that case you'll
certainly not stop at the root of chroot jail, so the comparison will
fail.
