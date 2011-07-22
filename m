Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab1GVJ7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 05:59:07 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40244 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab1GVJ7F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:59:05 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <87y5zqfxt1.fsf@tucsk.pomaz.szeredi.hu>
References: <CA+icZUVbeLU+zCAC+8wduizn6h5FUE2qzNr0bg9t3yWNbv_6Ng@mail.gmail.com>
	<CA+icZUXf1_qWF8GdQyCVxzAp-CYgQbH8iod0oBTjhWsSZLi1_g@mail.gmail.com>
	<87y5zqfxt1.fsf@tucsk.pomaz.szeredi.hu>
Date: Fri, 22 Jul 2011 11:59:03 +0200
Message-ID: <CA+icZUWGxByaiRGSdtcoY_cdRytVvSFzahzPrdgokF7cKt8q3w@mail.gmail.com>
Subject: Re: linux-next: Tree for July 20 (overlayfs)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 11:51 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Sedat Dilek <sedat.dilek@googlemail.com> writes:
>
>> On Wed, Jul 20, 2011 at 8:48 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>> Hi,
>>>
>>> I have here a problem with linux-next (next-20110720) and
>>> overlayfs-v10 (not the latest from GIT).
>>>
>>> ### OVERLAYFS
>>> # Patches from mszeredi/vfs.git#overlayfs.v10 (up to commit
>>> 00b27467b181a27c808cef0d66860eba5f450b24)
>>> # "overlay: overlay filesystem documentation"
>>> # See also <http://lkml.org/lkml/2011/6/1/456>
>>> # "[PATCH 0/7] overlay filesystem: request for inclusion"
>>> + overlayfs-v10/overlayfs-v10.patch
>>>
>>> Documentation/filesystems/porting says:
>>>
>>> [mandatory]
>>>        ->permission(), generic_permission() and ->check_acl() have lost flags
>>> argument; instead of passing IPERM_FLAG_RCU we add MAY_NOT_BLOCK into mask.
>>>        generic_permission() has also lost the check_acl argument; if you want
>>> non-NULL to be used for that inode, put it into ->i_op->check_acl.
>>>
>>> I checked with other files below fs/ and changed accordingly.
>>> So, I hope the attached patch is OK (untested, uncompiled)?
>>>
>>> What's the status of OverlayFS anyway, will it be merged into v3.1?
>>>
>>> Regards,
>>> - Sedat -
>>>
>>
>> I checked again and adapted ovl_permission().
>>
>> [ fs/namei.c ]
>> static int acl_permission_check(struct inode *inode, int mask)
>>
>> Here is a v2, which compiles.
>
> Thanks, the patch looks good.
>
> And ->fsync is another one that will have an updated API.
>
> Miklos
>
> ---
>  fs/overlayfs/readdir.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> Index: linux-2.6/fs/overlayfs/readdir.c
> ===================================================================
> --- linux-2.6.orig/fs/overlayfs/readdir.c       2011-07-21 17:07:52.000000000 +0200
> +++ linux-2.6/fs/overlayfs/readdir.c    2011-07-21 17:10:20.000000000 +0200
> @@ -386,7 +386,8 @@ static loff_t ovl_dir_llseek(struct file
>        return res;
>  }
>
> -static int ovl_dir_fsync(struct file *file, int datasync)
> +static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
> +                        int datasync)
>  {
>        struct ovl_dir_file *od = file->private_data;
>
> @@ -400,7 +401,7 @@ static int ovl_dir_fsync(struct file *fi
>                        return PTR_ERR(od->realfile);
>        }
>
> -       return vfs_fsync(od->realfile, datasync);
> +       return vfs_fsync_range(od->realfile, start, end, datasync);
>  }
>
>  static int ovl_dir_release(struct inode *inode, struct file *file)
>

Hi Miklos,

cool, thanks.
I have renamed my patch in the meanwhile to
"ovl-Fix-ovl_permission-by-adding-MAY_NOT_BLOCK-into-mask.patch".

The change was due to...

commit d749519b444db985e40b897f73ce1898b11f997e
"->permission() sanitizing: don't pass flags to generic_permission()" [1].

You want me to do a clean patch or by yourself?

Can you please, do a overlayfs-v11 on top of Linux-3.0?
I hope your work will be accepted into v3.1.

Regards,
- Sedat -

[1] http://git.us.kernel.org/?p=linux/kernel/git/viro/vfs-2.6.git;a=commitdiff;h=d749519b444db985e40b897f73ce1898b11f997e
