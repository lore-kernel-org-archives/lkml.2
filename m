Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab1J1IUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 04:20:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58994 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab1J1IUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 04:20:10 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com
Subject: Re: [PATCH 12/13] vfs: count unlinked inodes
References: <1318430946-7091-1-git-send-email-miklos@szeredi.hu>
	<1318430946-7091-13-git-send-email-miklos@szeredi.hu>
	<20111028060801.GA15345@infradead.org>
	<1319788433.13842.8.camel@tucsk.pomaz.szeredi.hu>
	<20111028080445.GA10318@infradead.org>
Date: Fri, 28 Oct 2011 10:20:06 +0200
In-Reply-To: <20111028080445.GA10318@infradead.org> (Christoph Hellwig's
	message of "Fri, 28 Oct 2011 04:04:45 -0400")
Message-ID: <87hb2t5xzd.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Fri, Oct 28, 2011 at 09:53:53AM +0200, Miklos Szeredi wrote:
>> On Fri, 2011-10-28 at 02:08 -0400, Christoph Hellwig wrote:
>> > This one gets me a repeated spew of WARN_ONs during XFS log recover,
>> > repeating the following pattern:
>> 
>> The assumption here is that set_nlink() is called with a non-zero count.
>> The point of introducing set_nlink() was to verify this assumption,
>> otherwise pending delete accounting will be screwed up.
>> 
>> If setting i_nlink to zero is not a bug in xfs we can do two things:
>> 
>>  1) do a conditional clear_nlink() in xfs_setup_inode() to document that
>> nlink can indeed be zero
>> 
>>  2) remove the warning from set_nlink().  That may hide some cases where
>> i_nlink was cleared without the intention of the filesystem but it will
>> work just fine wrt. the pending delete accounting. 
>
> I suspect 2 might be the better option.  The pattern we see here in
> XFS is pretty typical for transactional filesytems - when we mount a
> filesystem after an unclean shutdown we need to drop all inodes that
> were open but unlinked when the system crashed, and that typically
> means reading inodes from disk that have a zero i_nlink.  Maybe some
> filesystems never instanciate a VFS inode for it, but I suspect many
> do.
>
> For XFS we will actually see it during regularly testing as we have
> an ioctl that simulates a shutdown and can thus trigger log recovery
> easily, while for others like ext4 you'd actually have to do a real
> reset of your (physical or virtual) machine.

Okay, so a WARN_ON is not warranted.  Perhaps a printk instead?

While initializing nlink with zero normally shouldn't be a problem it
might indicate something unexpected.

Thanks,
Miklos

---
 fs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2011-10-27 22:26:12.000000000 +0200
+++ linux-2.6/fs/inode.c	2011-10-28 10:14:18.000000000 +0200
@@ -320,7 +320,8 @@ EXPORT_SYMBOL(clear_nlink);
  */
 void set_nlink(struct inode *inode, unsigned int nlink)
 {
-	if (WARN_ON(!nlink)) {
+	if (!nlink) {
+		printk(KERN_INFO "set_nlink() clearing i_nlink on %s inode %li\n", inode->i_sb->s_type->name, inode->i_ino);
 		clear_nlink(inode);
 	} else {
 		/* Yes, some filesystems do change nlink from zero to one */
