Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab0CWWc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 18:32:56 -0400
Received: from crca.org.au ([74.207.252.120]:39454 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab0CWWcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 18:32:54 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BA94157.6090907@crca.org.au>
Date: Wed, 24 Mar 2010 09:31:51 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100301 Shredder/3.0.4pre
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de
Subject: Re: [PATCH] Introduce freeze_super and thaw_super for the fsfreeze
 ioctl
References: <20100323142200.GA2381@localhost.localdomain> <20100323142843.GG30031@ZenIV.linux.org.uk> <20100323143456.GC2381@localhost.localdomain> <20100323144828.GH30031@ZenIV.linux.org.uk> <20100323150301.GD2381@localhost.localdomain> <20100323150923.GI30031@ZenIV.linux.org.uk>
In-Reply-To: <20100323150923.GI30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 24/03/10 02:09, Al Viro wrote:
> On Tue, Mar 23, 2010 at 11:03:01AM -0400, Josef Bacik wrote:
>>> sb is an active reference
>>>
>>
>> I don't understand how this is an active reference?  We are talking about
>> s_active right?
>
> It's an opened file, for crying out loud!  If there is anything that makes
> sure that superblock will stay alive, that is it...
>
> And lose the "locked" argument, please.  The sane solution is to make
> get_active_super() return it unlocked and have your freeze_bdev() simply
> grab s_umount.  Unconditionally.  I'll do the first part in #untested in
> a minute or so (and make it grab s_umount in the current variant of code in
> fs/block_dev.c); then your patch would shift taking s_umount down into
> freeze_super().

Since TuxOnIce was mentioned, I guess he's thinking on the following 
routine.

Regards,

Nigel

/**
  * freeze_filesystems - lock all filesystems and force them into a 
consistent
  * state
  * @which:      What combination of fuse & non-fuse to freeze.
  */
void freeze_filesystems(int which)
{
         struct super_block *sb;

         lockdep_off();

         /*
          * Freeze in reverse order so filesystems dependant upon others are
          * frozen in the right order (eg. loopback on ext3).
          */
         list_for_each_entry_reverse(sb, &super_blocks, s_list) {
                 FS_PRINTK(KERN_INFO "Considering %s.%s: (root %p, bdev 
%x)",
                         sb->s_type->name ? sb->s_type->name : "?",
                         sb->s_subtype ? sb->s_subtype : "", sb->s_root,
                         sb->s_bdev ? sb->s_bdev->bd_dev : 0);

                 if (sb->s_type->fs_flags & FS_IS_FUSE &&
                     sb->s_frozen == SB_UNFROZEN &&
                     which & FS_FREEZER_FUSE) {
                         sb->s_frozen = SB_FREEZE_TRANS;
                         sb->s_flags |= MS_FROZEN;
                         FS_PRINTK("Fuse filesystem done.\n");
                         continue;
                 }

                 if (!sb->s_root || !sb->s_bdev ||
                     (sb->s_frozen == SB_FREEZE_TRANS) ||
                     (sb->s_flags & MS_RDONLY) ||
                     (sb->s_flags & MS_FROZEN) ||
                     !(which & FS_FREEZER_NORMAL)) {
                         FS_PRINTK(KERN_INFO "Nope.\n");
                         continue;
                 }

                 FS_PRINTK(KERN_INFO "Freezing %x... ", sb->s_bdev->bd_dev);
                 freeze_bdev(sb->s_bdev);
                 sb->s_flags |= MS_FROZEN;
                 FS_PRINTK(KERN_INFO "Done.\n");
         }

         lockdep_on();
}
