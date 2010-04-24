Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab0DXIy4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 04:54:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:41243 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab0DXIyx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 04:54:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qw9rd98pI1gnwYnh+TYxTfyjuhdAXxNlN5sKxpjtCkYJ3SORgebVlHriK6BVyOMeIv
         vokbtyDmqBOrPssEOOKFlkGGuQjQNBSHtRyMDqw0Q8fb/GEpgQRWj6+3a7pf9POVzmBw
         +yGxnRP+qMgQHi0gLAwgNHbkRwZBDkeplo+MU=
MIME-Version: 1.0
In-Reply-To: <4BD25A4B.4050000@redhat.com>
References: <4BD25A4B.4050000@redhat.com>
Date: Sat, 24 Apr 2010 11:54:51 +0300
X-Google-Sender-Auth: b0abfa0c0f85aacf
Message-ID: <x2s84144f021004240154g1a4dba0dnc9308abbebee9ce7@mail.gmail.com>
Subject: Re: [PATCH] ecryptfs: disallow ecryptfs as underlying filesystem
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Eric Sandeen <sandeen@redhat.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 5:41 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> mounting stacked ecryptfs on ecryptfs has been shown to lead to bugs
> in testing.  For crypto info in xattr, there is no mechanism for handling
> this at all, and for normal file headers, we run into other trouble:
>
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> IP: [<ffffffffa015b0b3>] ecryptfs_d_revalidate+0x43/0xa0 [ecryptfs]
> ...
>
> There doesn't seem to be any good usecase for this, so I'd suggest just
> disallowing the configuration.

Maybe there's no good use case for it but it sure sounds like a good
test case for shaking out bugs in filesystem stacking code.

> Based on a patch originally, I believe, from Mike Halcrow.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
> index af1a8f0..7ada044 100644
> --- a/fs/ecryptfs/main.c
> +++ b/fs/ecryptfs/main.c
> @@ -594,28 +594,46 @@ static int ecryptfs_get_sb(struct file_system_type *fs_type, int flags,
>                        struct vfsmount *mnt)
>  {
>        int rc;
> -       struct super_block *sb;
> +       struct super_block *sb, *lower_sb;
> +       struct nameidata nd;
> +
> +       rc = path_lookup(dev_name, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &nd);
> +       if (rc) {
> +               printk(KERN_WARNING
> +                       "path_lookup() failed on dev_name = [%s]\n", dev_name);
> +               goto out;
> +       }
> +       lower_sb = nd.path.dentry->d_sb;
> +       if (strcmp(lower_sb->s_type->name, "ecryptfs") == 0) {
> +               rc = -EINVAL;
> +               printk(KERN_ERR "Mount on filesystem of type "
> +                       "eCryptfs explicitly disallowed due to "
> +                       "known incompatibilities\n");
> +               goto out_pathput;
> +       }
>
>        rc = get_sb_nodev(fs_type, flags, raw_data, ecryptfs_fill_super, mnt);
>        if (rc < 0) {
>                printk(KERN_ERR "Getting sb failed; rc = [%d]\n", rc);
> -               goto out;
> +               goto out_pathput;
>        }
>        sb = mnt->mnt_sb;
>        rc = ecryptfs_parse_options(sb, raw_data);
>        if (rc) {
>                printk(KERN_ERR "Error parsing options; rc = [%d]\n", rc);
> -               goto out_abort;
> +               goto out_dput;
>        }
>        rc = ecryptfs_read_super(sb, dev_name);
>        if (rc) {
>                printk(KERN_ERR "Reading sb failed; rc = [%d]\n", rc);
> -               goto out_abort;
> +               goto out_dput;
>        }
>        goto out;
> -out_abort:
> +out_dput:
>        dput(sb->s_root); /* aka mnt->mnt_root, as set by get_sb_nodev() */
>        deactivate_locked_super(sb);
> +out_pathput:
> +       path_put(&nd.path);
>  out:
>        return rc;
>  }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
