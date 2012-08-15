Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab2HOQ74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:59:56 -0400
Received: from nm23.access.bullet.mail.mud.yahoo.com ([66.94.237.88]:22157
	"HELO nm23.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751822Ab2HOQ7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:59:55 -0400
X-Yahoo-Newman-Id: 3559.82289.bm@smtp104.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XQkvaAwVM1kR30xe30zt7FtmDSJ0sdVRGZ1IVDYprG75_Od
 fmnFoaxGR3Uql_iKL0ojaIpOSRYdUpxEFkVrjHPORqPXieJxLmnbLecCFJps
 .Yi8cPuBs27vbQWYkZN6.MJYkqcMCsCO5GwTxpE4sdYZX5MIHPxzWtK648xW
 2ADBhetGLJ2ZdyrRvQuHzdsGif9ghQ6b0IcJbqtgOoL1HAdaPgv7ZHjRelLc
 Y9aRv0SHDb_IwTf7j2bYvXn__c7OVyDvC9cx0.vhvScZ4VmdOCsBn9OHtVEw
 aWifnCfd5V0j_G4gaPHgTeVgEzeEPTbrGuFWKZVIsZi_GjtmtSWGK5XlYbCu
 POkOfjTEJiZrElR4wI98sttMxER2ng1XNsX1WQwYMbbXLLtfscrcENqpmdJn
 doeeI_htckRkPiqqlbk.i2RH6F6dR30ukwOi8bEFbiGDEmmVT.DMndDqTDQ4
 kYBXIginHBbhBLzmrPpJ1dRFExQWlSJawJn3CHg8lDiqEwPbtG9cXLtomP51
 PRJQp51xDQMYVtQ--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <502BD587.6090807@schaufler-ca.com>
Date: Wed, 15 Aug 2012 09:59:51 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, goran.cetusic@gmail.com, romain@orebokech.com,
        mszeredi@suse.cz, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 12/13] ovl: switch to __inode_permission()
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu> <1345045700-9062-13-git-send-email-miklos@szeredi.hu>
In-Reply-To: <1345045700-9062-13-git-send-email-miklos@szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/2012 8:48 AM, Miklos Szeredi wrote:
> From: Andy Whitcroft <apw@canonical.com>
>
> When checking permissions on an overlayfs inode we do not take into
> account either device cgroup restrictions nor security permissions.
> This allows a user to mount an overlayfs layer over a restricted device
> directory and by pass those permissions to open otherwise restricted
> files.

Why is this a good idea? Either you're not including enough context
about the conditions under which this can occur, or you're suggesting
the introduction of a trivial mechanism for bypassing all file access
controls. This does not seem right.


>
> Switch over to __inode_permissions.
>
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/overlayfs/inode.c |   12 +-----------
>  1 files changed, 1 insertions(+), 11 deletions(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index e854720..f3a534f 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -100,19 +100,9 @@ int ovl_permission(struct inode *inode, int mask)
>  		if (is_upper && !IS_RDONLY(inode) && IS_RDONLY(realinode) &&
>  		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
>  			goto out_dput;
> -
> -		/*
> -		 * Nobody gets write access to an immutable file.
> -		 */
> -		err = -EACCES;
> -		if (IS_IMMUTABLE(realinode))
> -			goto out_dput;
>  	}
>  
> -	if (realinode->i_op->permission)
> -		err = realinode->i_op->permission(realinode, mask);
> -	else
> -		err = generic_permission(realinode, mask);
> +	err = __inode_permission(realinode, mask);
>  out_dput:
>  	dput(alias);
>  	return err;

