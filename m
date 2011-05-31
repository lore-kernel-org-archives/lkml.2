Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab1EaSGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:06:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:55158 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab1EaSGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:06:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,298,1304319600"; 
   d="scan'208";a="9946838"
Date: Tue, 31 May 2011 11:06:43 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        chris.mason@oracle.com, josef@redhat.com, agruen@linbit.com,
        "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 1/4] Cache xattr security drop check for write v2
Message-ID: <20110531180643.GB9261@alboin.amr.corp.intel.com>
References: <1306596354-18453-1-git-send-email-andi@firstfloor.org>
 <1306849896.2816.22.camel@menhir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306849896.2816.22.camel@menhir>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It sounds like a good idea, but cluster filesystems will need to clear
> the flag when they update their in-core inodes. Without that we could
> have:
> 
>  Node A looks up inode and sets S_NOSEC since its not suid
>  Node B does chmod +s on the inode
>  Node A now has S_NOSEC set, but inode is suid, so writes don't clear
> suid

Good point. I assume that's also true for network file systems.

This would essentially argue that for those putting the helper
into the inode read paths is not optional. I'll look into this
later.

> -	flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
> +	flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_NOSEC);
> +	if (!is_sxid(inode->i_mode))
> +		flags |= S_NOSEC;

Doesn't that need a check for no xattr too? or do you not support
those currently?

Note I added a helper for this in the latest version:
inode_has_no_xattr()

-Andi
