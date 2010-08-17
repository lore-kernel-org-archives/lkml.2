Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab0HQWUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 18:20:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63223 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab0HQWUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 18:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fUrxGItErS+qybSHyoC7YfXyyYh9BW8M7Xw7NxJR0mMwueZbrDfegRoCRFik6wDEWR
         UpsY0bptouEYNMJFXAaUUWVzoxFqUVPU2WphtULAuBU/ocZSwiEfy+STqPO8WeDQDP/E
         cYRRQWzQB36v2iALfkf/vVF8FQJUfveunCcOk=
Date: Wed, 18 Aug 2010 00:20:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [BUG][reiserfs] page fault during kernel boot
Message-ID: <20100817222011.GA5461@nowhere>
References: <201008171125.25956.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008171125.25956.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 11:25:25AM +0300, Marin Mitov wrote:
> Hi all,
> 
> The function: reiserfs_evict_inode() ends with:
> 
> <snip>
> out:
> 	end_writeback(inode);	/* note this must go after the journal_end to prevent deadlock */
> 	dquot_drop(inode);
> 	inode->i_blocks = 0;
> 	reiserfs_write_unlock_once(inode->i_sb, depth);
> 
> no_delete:
> 	end_writeback(inode);
> 	dquot_drop(inode);
> }
> <snip>
> 
> When goto out path is taken,
> 
> end_writeback(inode);
> dquot_drop(inode);
> 
> are executed twice, leading to page fault (in my case) during the kernel boot.


Indeed. More precisely it triggers a BUG in end_writeback():

	BUG_ON(inode->i_state & I_CLEAR);

that because we call it twice.

 
> Add return; before no_delete label (but I am not quite sure that this is correct :-).



That looks correct. 

Also Andrew Benton reported this issue and tested almost
the same patch and it seemed to solve the issue.

Thanks.



> Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
> 
> ====================================================================
> --- a/fs/reiserfs/inode.c	2010-08-17 09:51:27.000000000 +0300
> +++ b/fs/reiserfs/inode.c	2010-08-17 10:45:20.000000000 +0300
> @@ -78,11 +78,12 @@ void reiserfs_evict_inode(struct inode *
>  		/* no object items are in the tree */
>  		;
>  	}
> -      out:
> +out:
>  	end_writeback(inode);	/* note this must go after the journal_end to prevent deadlock */
>  	dquot_drop(inode);
>  	inode->i_blocks = 0;
>  	reiserfs_write_unlock_once(inode->i_sb, depth);
> +	return;
>  
>  no_delete:
>  	end_writeback(inode);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

