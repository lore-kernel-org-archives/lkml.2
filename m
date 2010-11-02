Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0KBAqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 20:46:30 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:35945 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753523Ab0KBAq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 20:46:27 -0400
Date: Tue, 2 Nov 2010 11:45:45 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, jmorris@namei.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        eparis@redhat.com, viro@zeniv.linux.org.uk,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v1.1 2/5] IMA: define readcount functions
Message-ID: <20101102004545.GQ2715@dastard>
References: <1288640739-3246-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1288640739-3246-3-git-send-email-zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288640739-3246-3-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 03:45:36PM -0400, Mimi Zohar wrote:
> Define iget/iput_readcount() functions to be called from the VFS layer.

Can't say I like the function names. i_readcount_{inc,dec} seem more
appropriate, especially so they don't get confused with inode
reference counting...

Cheers,

Dave.

> +void iput_readcount(struct inode *inode)
> +{
> +	spin_lock(&inode->i_lock);
> +	if (unlikely((atomic_read(&inode->i_readcount) == 0)))
> +		printk(KERN_INFO "i_readcount: imbalance ino %ld\n",
> +		       inode->i_ino);
> +	else
> +		atomic_dec(&inode->i_readcount);
> +	spin_unlock(&inode->i_lock);
> +}

No need for the lock just to indicate an imbalance. You could just
use:

	if (atomic_dec_return(&inode->i_readcount) < 0) {
		.....
	}

Given this is an integrity subsystem, I suspect the correct thing to
do here is BUG(), not just issue an informational message that
something is wrong with the integrity tracking....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
