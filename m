Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab1ELJeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:34:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56022 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1ELJem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:34:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ln2/nXS/q+gBq7ZJMG8oP7vA9G/PsSx6I2ShV9peoTKBTIo0W4m1AHTjI77+dPuxud
         wOX/3MTUeG7q9NWXRiQ8sc0HDywLJpfjNdx1SW9255meyTIPz0vMqPJmHTkjrWQHOm1s
         q9xvuLa5ARok3sxx6neZ4kyrMUaS/QSbvNW+k=
Message-ID: <4DCBA9A5.9040306@gmail.com>
Date: Thu, 12 May 2011 11:34:29 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: jlbec@evilplan.org
CC: Jiri Slaby <jslaby@suse.cz>, npiggin@kernel.dk,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: OOPS in configfs when doing d_delete
References: <4D623C62.8030509@suse.cz> <20110221104359.GA18538@noexit> <4D6242AD.2090600@suse.cz> <20110222091415.GD30966@noexit>
In-Reply-To: <20110222091415.GD30966@noexit>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 10:14 AM, Joel Becker wrote:
> On Mon, Feb 21, 2011 at 11:47:09AM +0100, Jiri Slaby wrote:
>>> 	I think you're right about the superfluous test, but I need more
>>> investigation to see what's going on.  Thanks for the report.
>>> 	What was causing attach_group() to fail?  Do you know?
>>
>> Dunno, I just modprobe'd the configfs example from Doc dir
>> (configfs_example_macros).
> 
> 	I'm going to revisit the failed example (which shouldn't fail, I
> would think).  Can you try the following patch to safely handle the
> failure rather than crashing the kernel?
> 
> Joel

Hi, what's the status of this? (It's verified to work some time ago.)

> From 68bbb327c48fdcdc48b71435d19b9e899745adf0 Mon Sep 17 00:00:00 2001
> From: Joel Becker <jlbec@evilplan.org>
> Date: Tue, 22 Feb 2011 01:09:49 -0800
> Subject: [PATCH] configfs: Don't try to d_delete() negative dentries.
> 
> When configfs is faking mkdir() on its subsystem or default group
> objects, it starts by adding a negative dentry.  It then tries to
> instantiate the group.  If that should fail, it must clean up after
> itself.
> 
> I was using d_delete() here, but configfs_attach_group() promises to
> return an empty dentry on error.  d_delete() explodes with the entry
> dentry.  Let's try d_drop() instead.  The unhashing is what we want for
> our dentry.
> 
> Signed-off-by: Joel Becker <jlbec@evilplan.org>
> ---
>  fs/configfs/dir.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
> index 90ff3cb..2af26b8 100644
> --- a/fs/configfs/dir.c
> +++ b/fs/configfs/dir.c
> @@ -689,7 +689,8 @@ static int create_default_group(struct config_group *parent_group,
>  			sd = child->d_fsdata;
>  			sd->s_type |= CONFIGFS_USET_DEFAULT;
>  		} else {
> -			d_delete(child);
> +			BUG_ON(child->d_inode);
> +			d_drop(child);
>  			dput(child);
>  		}
>  	}
> @@ -1683,7 +1684,8 @@ int configfs_register_subsystem(struct configfs_subsystem *subsys)
>  		err = configfs_attach_group(sd->s_element, &group->cg_item,
>  					    dentry);
>  		if (err) {
> -			d_delete(dentry);
> +			BUG_ON(dentry->d_inode);
> +			d_drop(dentry);
>  			dput(dentry);
>  		} else {
>  			spin_lock(&configfs_dirent_lock);


-- 
js
