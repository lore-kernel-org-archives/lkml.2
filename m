Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0LOIPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 03:15:45 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:56485 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab0LOIPo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 03:15:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=m09l9r+QspeuLFW3nSVvyP2rLOBedVpX1NMmuPjnK/sXdg5C3WSsqbzvMrNc39hLS7
         04eeoVIMsMdHA+i9bWJSEasiGVRzAWFcSukcsTguOCBw8958XjOEl5EMZ43mT9rsjH0M
         npwjfogtxMOfGZJ8Z5EQr9Qs3JA9XsWg+JYJs=
MIME-Version: 1.0
In-Reply-To: <1292399418.303.8.camel@wall-e>
References: <1292368360-32216-1-git-send-email-stefani@seibold.net>
	<AANLkTi=HaS+wweLaAEcBuRFx+Dr1pKU=One1gOYF55CJ@mail.gmail.com>
	<AANLkTikvN9u3dB_TzNUKjz7g39i+t+h4vt7EVKDLVjLg@mail.gmail.com>
	<1292399418.303.8.camel@wall-e>
Date: Wed, 15 Dec 2010 10:15:42 +0200
X-Google-Sender-Auth: bjb_jzVx-n8MBf2ltxK6jmOim38
Message-ID: <AANLkTimYpB2iw525_0wGT=sLkCcuy_bAx1QyG8tjRjOb@mail.gmail.com>
Subject: Re: [PATCH] cramfs: generate unique inode number for better inode
 cache usage
From: Pekka Enberg <penberg@kernel.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 9:50 AM, Stefani Seibold <stefani@seibold.net> wrote:
> No, it makes no sense, for following reasons:
>
> - Why pre-setup variables like iops, fops and aops which are in the most
> cases not needed? Because the inode is still in the cache.
>
> - Each branch is a little bit different.
>
> - The default branch is completly different, because in this case the
> init_special_inode() will be called, which sets the inode->fop.
>
> What do you think about this solution:
>
> static void setup_inode(struct inode *inode, struct cramfs_inode * cramfs_inode)
> {
>        static struct timespec zerotime;
>        inode->i_mode = cramfs_inode->mode;
>        inode->i_uid = cramfs_inode->uid;
>        /* if the lower 2 bits are zero, the inode contains data */
>        if (!(inode->i_ino & 3)) {
>                inode->i_size = size;
>                inode->i_blocks = (size - 1) / 512 + 1;
>        }
>        inode->i_gid = cramfs_inode->gid;
>        /* Struct copy intentional */
>        inode->i_mtime = inode->i_atime = inode->i_ctime = zerotime;
>        /* inode->i_nlink is left 1 - arguably wrong for directories,
>           but it's the best we can do without reading the directory
>           contents.  1 yields the right result in GNU find, even
>           without -noleaf option. */
>        unlock_new_inode(inode);
> }
>
> static struct inode *get_cramfs_inode(struct super_block *sb,
>        struct cramfs_inode * cramfs_inode, unsigned int offset)
> {
>        struct inode *inode;
>
>        switch (cram_inode->mode & S_IFMT) {
>        case S_IFREG:
>                inode = iget_locked(sb, cramino(cramfs_inode, offset));
>                if (inode && (inode->i_state & I_NEW)) {
>                        inode->i_fop = &generic_ro_fops;
>                        inode->i_data.a_ops = &cramfs_aops;
>                        setup_inode(inode, cramfs_inode);
>                }
>                break;
>        case S_IFDIR:
>                inode = iget_locked(sb, cramino(cramfs_inode, offset));
>                if (inode && (inode->i_state & I_NEW)) {
>                        inode->i_op = &cramfs_dir_inode_operations;
>                        inode->i_fop = &cramfs_directory_operations;
>                        setup_inode(inode, cramfs_inode);
>                }
>                break;
>        case S_IFLNK:
>                inode = iget_locked(sb, cramino(cramfs_inode, offset));
>                if (inode && (inode->i_state & I_NEW)) {
>                        inode->i_op = &page_symlink_inode_operations;
>                        inode->i_data.a_ops = &cramfs_aops;
>                        setup_inode(inode, cramfs_inode);
>                }
>                break;
>        default:
>                inode = iget_locked(sb, CRAMINO_UNIQ(offset));
>                if (inode && (inode->i_state & I_NEW)) {
>                        init_special_inode(inode, cramfs_inode->mode,
>                                old_decode_dev(cramfs_inode->size));
>                        setup_inode(inode, cramfs_inode);
>                }
>                break;
>        }
>        return inode;
> }

I think Linus is after something like this:

static struct inode *get_cramfs_inode(struct super_block *sb, struct
cramfs_inode * cramfs_inode, unsigned int offset)
{
        struct inode *inode;
        unsigned long ino;

        switch (cram_inode->mode & S_IFMT) {
        case S_IFREG:
        case S_IFDIR:
        case S_IFLNK:
                ino = cramino(cramfs_inode, offset);
                break;
        default:
                ino = CRAMINO_UNIQ(offset);
                break;
        }

        inode = iget_locked(sb, ino);
        if (!inode)
                return ERR_PTR(-ENOMEM);
        if (!(inode->i_state & I_NEW))
                return inode;

       switch (cram_inode->mode & S_IFMT) {
       case S_IFREG:
               inode->i_fop = &generic_ro_fops;
               inode->i_data.a_ops = &cramfs_aops;
               setup_inode(inode, cramfs_inode);
               break;
       case S_IFDIR:
               inode->i_op = &cramfs_dir_inode_operations;
               inode->i_fop = &cramfs_directory_operations;
               setup_inode(inode, cramfs_inode);
               break;
       case S_IFLNK:
               inode->i_op = &page_symlink_inode_operations;
               inode->i_data.a_ops = &cramfs_aops;
               setup_inode(inode, cramfs_inode);
               break;
       default:
               init_special_inode(inode, cramfs_inode->mode,
old_decode_dev(cramfs_inode->size));
               setup_inode(inode, cramfs_inode);
               break;
       }
       return inode;
}

You should optimize for the in-cache case.
