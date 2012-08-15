Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab2HORfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 13:35:05 -0400
Received: from nm1-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.27]:27214
	"HELO nm1-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756000Ab2HORfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 13:35:03 -0400
X-Yahoo-Newman-Id: 403200.70157.bm@smtp105.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: g91ktZAVM1lgXmHJozQQhMPojwHQocx1DDZLT6AApXbhQRw
 NumDm9swfr_CoHodZ769g6mOJ6GM5GOSTXRN5iGF7INtcdVngI4fsUELeqIR
 VARL8nRuXqfOkQ.mctMxm.J6mNx5YAJmWzwcwy3beL5Up5Yxd6wejsyxWwCr
 dFTZFILoDI5DqyNt_mcGJ5n4_Bx.L55mwgsAtTl2_a.capm_Rg3ltiRMNnPn
 EhupTCGBnDRrPtFKpsmIoJDSTL6zeOoyrea3B4o2e6.CVPuOUg2QVfENb5f7
 jHpzbh10JyPqKITBVt9Eep.ge_ZZL2N01ig5D8w4CpziO0n.byUAYQBSszgY
 N1yQaWz.CDHx6lM3Fw9NZXIF2GwpcPaq_2zNDbs8WWMqeT1fj8JqXvJDBtBf
 eX8KrG1oFYGC_PXP3koGp01WZgLp6isSrPLPCi2IP32Wpptyf3F9baOpUh73
 1VgSnEnxtQxfUatkugOwaxKDdHWLQcqxFHWmpoFst
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <502BDDC2.6030502@schaufler-ca.com>
Date: Wed, 15 Aug 2012 10:34:58 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, nbd@openwrt.org, neilb@suse.de,
        hramrach@centrum.cz, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        ricwheeler@gmail.com, dhowells@redhat.com, hpj@urpla.net,
        sedat.dilek@googlemail.com, penberg@kernel.org,
        goran.cetusic@gmail.com, romain@orebokech.com, mszeredi@suse.cz
Subject: Re: [PATCH 12/13] ovl: switch to __inode_permission()
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu> <1345045700-9062-13-git-send-email-miklos@szeredi.hu> <502BD587.6090807@schaufler-ca.com> <20120815170758.GP29100@dm>
In-Reply-To: <20120815170758.GP29100@dm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/2012 10:07 AM, Andy Whitcroft wrote:
> On Wed, Aug 15, 2012 at 09:59:51AM -0700, Casey Schaufler wrote:
>> On 8/15/2012 8:48 AM, Miklos Szeredi wrote:
>>> From: Andy Whitcroft <apw@canonical.com>
>>>
>>> When checking permissions on an overlayfs inode we do not take into
>>> account either device cgroup restrictions nor security permissions.
>>> This allows a user to mount an overlayfs layer over a restricted device
>>> directory and by pass those permissions to open otherwise restricted
>>> files.
>> Why is this a good idea? Either you're not including enough context
>> about the conditions under which this can occur, or you're suggesting
>> the introduction of a trivial mechanism for bypassing all file access
>> controls. This does not seem right.
> It is stating that the unprotected case is how things was before this
> patch switches us over to __inode_permisssions.  The patch is closing
> the hole indicated.

Well, that's good then. Carry on.

>
> -apw
>>> Switch over to __inode_permissions.
>>>
>>> Signed-off-by: Andy Whitcroft <apw@canonical.com>
>>> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>>> ---
>>>  fs/overlayfs/inode.c |   12 +-----------
>>>  1 files changed, 1 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
>>> index e854720..f3a534f 100644
>>> --- a/fs/overlayfs/inode.c
>>> +++ b/fs/overlayfs/inode.c
>>> @@ -100,19 +100,9 @@ int ovl_permission(struct inode *inode, int mask)
>>>  		if (is_upper && !IS_RDONLY(inode) && IS_RDONLY(realinode) &&
>>>  		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
>>>  			goto out_dput;
>>> -
>>> -		/*
>>> -		 * Nobody gets write access to an immutable file.
>>> -		 */
>>> -		err = -EACCES;
>>> -		if (IS_IMMUTABLE(realinode))
>>> -			goto out_dput;
>>>  	}
>>>  
>>> -	if (realinode->i_op->permission)
>>> -		err = realinode->i_op->permission(realinode, mask);
>>> -	else
>>> -		err = generic_permission(realinode, mask);
>>> +	err = __inode_permission(realinode, mask);
>>>  out_dput:
>>>  	dput(alias);
>>>  	return err;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

