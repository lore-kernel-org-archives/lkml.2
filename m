Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1KULvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 06:51:36 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49871 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1KULvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 06:51:35 -0500
MIME-Version: 1.0
X-Originating-IP: [178.164.248.109]
In-Reply-To: <20111121113416.GA18087@infradead.org>
References: <1321873893-4544-1-git-send-email-miklos@szeredi.hu>
	<1321873893-4544-4-git-send-email-miklos@szeredi.hu>
	<20111121113416.GA18087@infradead.org>
Date: Mon, 21 Nov 2011 12:51:34 +0100
Message-ID: <CAJfpegsSnu8CeApQ9_9CCwnReADHf_Er6EN0WSTkAFumtm=dQw@mail.gmail.com>
Subject: Re: [PATCH 3/4] vfs: count unlinked inodes
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 12:34 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Nov 21, 2011 at 12:11:32PM +0100, Miklos Szeredi wrote:
>> Do not WARN_ON if set_nlink is called with zero count, just do a
>> ratelimited printk.  This happens on xfs and probably other
>> filesystems after an unclean shutdown when the filesystem reads inodes
>> which already have zero i_nlink.  Reported by Christoph Hellwig.
>
> Given that this is part of the normal recovery process printing anything
> seems like a bad idea.  I also don't think the code for this actually
> is correct.
>
> Remember when a filesystem recovery from unlinked but open inodes the
> following happens:
>
>  - we walk the list of unlinked but open inodes, and read them into
>   memory, remove the linkage and then iput it.
>
> With the current code that won't ever increment s_remove_count,

It will increment s_remove_count

+void set_nlink(struct inode *inode, unsigned int nlink)
+{
+       if (!nlink) {
+               printk_ratelimited(KERN_INFO
+                       "set_nlink() clearing i_nlink on %s inode %li\n",
+                       inode->i_sb->s_type->name, inode->i_ino);

here:

+               clear_nlink(inode);

> but
> decrement it from __destroy_inode.  I suspect the right fix is to
> simply not warn for a set_nlink to zero, but rather simply increment
> s_remove_count for that case.

I don't really care about the printk.  Without the printk
clear_nlink() is just a shorthand for set_nlink(0), which is fine, but
that's not what the original intention was AFAIK.

Thanks,
Miklos
