Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab1EaSlC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:41:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab1EaSlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:41:00 -0400
Subject: Re: [PATCH 1/4] Cache xattr security drop check for write v2
From: Steven Whitehouse <swhiteho@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        chris.mason@oracle.com, josef@redhat.com, agruen@linbit.com,
        "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <20110531180643.GB9261@alboin.amr.corp.intel.com>
References: <1306596354-18453-1-git-send-email-andi@firstfloor.org>
	 <1306849896.2816.22.camel@menhir>
	 <20110531180643.GB9261@alboin.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 31 May 2011 19:42:26 +0100
Message-ID: <1306867346.2816.49.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2011-05-31 at 11:06 -0700, Andi Kleen wrote:
> > It sounds like a good idea, but cluster filesystems will need to clear
> > the flag when they update their in-core inodes. Without that we could
> > have:
> > 
> >  Node A looks up inode and sets S_NOSEC since its not suid
> >  Node B does chmod +s on the inode
> >  Node A now has S_NOSEC set, but inode is suid, so writes don't clear
> > suid
> 
> Good point. I assume that's also true for network file systems.
> 
> This would essentially argue that for those putting the helper
> into the inode read paths is not optional. I'll look into this
> later.
> 
> > -	flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
> > +	flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_NOSEC);
> > +	if (!is_sxid(inode->i_mode))
> > +		flags |= S_NOSEC;
> 
> Doesn't that need a check for no xattr too? or do you not support
> those currently?
> 
> Note I added a helper for this in the latest version:
> inode_has_no_xattr()
> 
> -Andi

Yes, it should test for xattr too,

Steve.


