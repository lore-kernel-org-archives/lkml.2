Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab2HHMTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:19:49 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48127 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757968Ab2HHMTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:19:46 -0400
Date: Wed, 8 Aug 2012 16:19:38 +0400
From: Vasily Kulikov <segoon@openwall.com>
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Matthew Wilcox <matthew@wil.cx>,
        Doug Ledford <dledford@redhat.com>, Joe Korty <joe.korty@ccur.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org,
        Dan Rosenberg <drosenberg@vsecurity.com>
Subject: Re: [kernel-hardening] [PATCH 1/2] fs: add link restrictions
Message-ID: <20120808121938.GA9995@albatros>
References: <1343262548-21743-1-git-send-email-keescook@chromium.org>
 <1343262548-21743-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343262548-21743-2-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

On Wed, Jul 25, 2012 at 17:29 -0700, Kees Cook wrote:
> +/**
> + * safe_hardlink_source - Check for safe hardlink conditions
> + * @inode: the source inode to hardlink from
> + *
> + * Return false if at least one of the following conditions:
> + *    - inode is not a regular file
> + *    - inode is setuid
> + *    - inode is setgid and group-exec
> + *    - access failure for read and write
> + *
> + * Otherwise returns true.
> + */
> +static bool safe_hardlink_source(struct inode *inode)
> +{
> +	umode_t mode = inode->i_mode;
> +
> +	/* Special files should not get pinned to the filesystem. */
> +	if (!S_ISREG(mode))
> +		return false;
> +
> +	/* Setuid files should not get pinned to the filesystem. */
> +	if (mode & S_ISUID)
> +		return false;

We don't want to make hardlinks of SUID files, but we still allow to create
hardlinks to SUID'ish cap'ed files.  Probably check whether the inode is
setcap'ed?

Probably we can enhance this further and allow LSMs to define whether this
particular file is special in LSM's point of view (IOW, it can be able to move
a process to another security domain which is served by LSM).

> +
> +	/* Executable setgid files should not get pinned to the filesystem. */
> +	if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP))
> +		return false;
> +
> +	/* Hardlinking to unreadable or unwritable sources is dangerous. */
> +	if (inode_permission(inode, MAY_READ | MAY_WRITE))
> +		return false;
> +
> +	return true;
> +}

Thanks,

-- 
Vasily
