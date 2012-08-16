Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab2HPIaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:30:23 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53448 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab2HPIaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:30:20 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUX32x5qiyxhAakxvo0Y4ypEA=DiurP5WCxbYmFi07+O4A@mail.gmail.com>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
	<1345045700-9062-9-git-send-email-miklos@szeredi.hu>
	<CA+icZUX32x5qiyxhAakxvo0Y4ypEA=DiurP5WCxbYmFi07+O4A@mail.gmail.com>
Date: Thu, 16 Aug 2012 10:30:17 +0200
Message-ID: <CA+icZUWK3EWzJoy4Qji20Foi0TsUAy+LbnTWj=-8AyikGnsO3A@mail.gmail.com>
Subject: Re: [PATCH 08/13] fs: limit filesystem stacking depth
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, goran.cetusic@gmail.com, romain@orebokech.com,
        mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 10:02 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Wed, Aug 15, 2012 at 5:48 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> Add a simple read-only counter to super_block that indicates deep this
>> is in the stack of filesystems.  Previously ecryptfs was the only
>> stackable filesystem and it explicitly disallowed multiple layers of
>> itself.
>>
>> Overlayfs, however, can be stacked recursively and also may be stacked
>> on top of ecryptfs or vice versa.
>>
>> To limit the kernel stack usage we must limit the depth of the
>> filesystem stack.  Initially the limit is set to 2.
>>
>
> Hi,
>
> I have tested OverlayFS for a long time with "fs-stack-depth=3".
> The original OverlayFS test-case script  from Jordi was slightly
> modified (see "testcase-ovl-v3.sh").
> I have sent my test-results to Andy and Jordi (tested with the
> patchset from Andy against Linux-v3.4 [1] with Ext4-FS).
> The attached test-case script *requires* "fs-stack-depth=3" to run
> properly (patch attached).
>
> So, I have 2 questions:
>
> [1] FS-stack-limitation
>
> Is a "fs-stack-depth>=2" (like "3") critical?
> Is your setting to "2" just a defensive (and initial) one?
> Can you explain your choice a bit more as ecryptFS is involved in this
> limitation, too.
>
> [2] Test-Case/Use-Case scripts
>
> It would be *very very very* helpful if you could provide or even ship
> in the Linux-kernel a test-case/use-case script, Thanks!
> Maybe describe "Documentation/filesystems/overlayfs.txt" would be a good place?
> Helpful could be a "simple" and a "complex" testing scenario?
>
> - Sedat -
>
>
> [1] http://git.kernel.org/?p=linux/kernel/git/apw/overlayfs.git;a=shortlog;h=refs/heads/overlayfs.v12apw1
>

[ Removing <hramrach@centrum.cz> (Email-address seems to be dead) ]

Just for the sake of completeness and some notes:

Jordi dropped your "fs-stack-depth" patch completely in his tests.
AFAICS he uses OverlayFS for his debian-based own distro.
I put some references to his OverlayFS work in [1] and [2].

Pesonally, I have tested against Debian/sid.
With Ubuntu/precise I got a rebel (just wanting a stable development
environment than wasting my time with fixing unstable packages - as
there is Debian/wheezy freeze sid (unstable) branch/distribution
cannot be called a "working environment") and did my recent testings
on this platform.

- Sedat -

[1] http://livenet.selfip.com/ftp/debian/overlayfs/
[2] http://livenet.selfip.com/ftp/debian/overlayfs/test/


>> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>> ---
>>  fs/ecryptfs/main.c   |    7 +++++++
>>  fs/overlayfs/super.c |   10 ++++++++++
>>  include/linux/fs.h   |   11 +++++++++++
>>  3 files changed, 28 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
>> index 2768138..344fb2c 100644
>> --- a/fs/ecryptfs/main.c
>> +++ b/fs/ecryptfs/main.c
>> @@ -565,6 +565,13 @@ static struct dentry *ecryptfs_mount(struct file_system_type *fs_type, int flags
>>         s->s_maxbytes = path.dentry->d_sb->s_maxbytes;
>>         s->s_blocksize = path.dentry->d_sb->s_blocksize;
>>         s->s_magic = ECRYPTFS_SUPER_MAGIC;
>> +       s->s_stack_depth = path.dentry->d_sb->s_stack_depth + 1;
>> +
>> +       rc = -EINVAL;
>> +       if (s->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
>> +               printk(KERN_ERR "eCryptfs: maximum fs stacking depth exceeded\n");
>> +               goto out_free;
>> +       }
>>
>>         inode = ecryptfs_get_inode(path.dentry->d_inode, s);
>>         rc = PTR_ERR(inode);
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 69a2099..64d2695 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -551,6 +551,16 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>>             !S_ISDIR(lowerpath.dentry->d_inode->i_mode))
>>                 goto out_put_lowerpath;
>>
>> +       sb->s_stack_depth = max(upperpath.mnt->mnt_sb->s_stack_depth,
>> +                               lowerpath.mnt->mnt_sb->s_stack_depth) + 1;
>> +
>> +       err = -EINVAL;
>> +       if (sb->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
>> +               printk(KERN_ERR "overlayfs: maximum fs stacking depth exceeded\n");
>> +               goto out_put_lowerpath;
>> +       }
>> +
>> +
>>         ufs->upper_mnt = clone_private_mount(&upperpath);
>>         err = PTR_ERR(ufs->upper_mnt);
>>         if (IS_ERR(ufs->upper_mnt)) {
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index abc7a53..1265e24 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -505,6 +505,12 @@ struct iattr {
>>   */
>>  #include <linux/quota.h>
>>
>> +/*
>> + * Maximum number of layers of fs stack.  Needs to be limited to
>> + * prevent kernel stack overflow
>> + */
>> +#define FILESYSTEM_MAX_STACK_DEPTH 2
>> +
>>  /**
>>   * enum positive_aop_returns - aop return codes with specific semantics
>>   *
>> @@ -1579,6 +1585,11 @@ struct super_block {
>>
>>         /* Being remounted read-only */
>>         int s_readonly_remount;
>> +
>> +       /*
>> +        * Indicates how deep in a filesystem stack this SB is
>> +        */
>> +       int s_stack_depth;
>>  };
>>
>>  /* superblock cache pruning functions */
>> --
>> 1.7.7
>>
