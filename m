Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab0DFRy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:54:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757274Ab0DFRyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:54:52 -0400
Message-ID: <4BBB756A.1020502@suse.com>
Date: Tue, 06 Apr 2010 13:54:50 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-2.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Edward Shishkin <edward.shishkin@gmail.com>
Cc: ReiserFS Devel <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch 3/3] reiserfs: remove privroot hiding in lookup
References: <20090505193014.926371851@suse.com> <20090505193206.968741619@suse.com> <4BB60BA9.20607@gmail.com>
In-Reply-To: <4BB60BA9.20607@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/02/2010 11:22 AM, Edward Shishkin wrote:
> Jeff Mahoney wrote:
>>  With Al Viro's patch to move privroot lookup to fs mount, there's no
>> need
>>  to have special code to hide the privroot in reiserfs_lookup.
>>   
> 
> Jeff, this implication looks strange. IMHO Viro's patch just pins this in
> the cache for mount session, while after your "cleanup" everyone can
> walk here (including non-privileged users) and do what they want. Um?


Oh hey. Yeah that's bad. I can reproduce that on my system. The privroot
lookup was supposed to be poisoned but apparently that's not working as
expected.

I'll take a look.

- -Jeff

> Edward.
> 
>>  I've also cleaned up the privroot hiding in reiserfs_readdir_dentry and
>>  removed the last user of reiserfs_xattrs().
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/reiserfs/dir.c              |   24 +++++++++++++-----------
>>  fs/reiserfs/namei.c            |   17 ++---------------
>>  fs/reiserfs/xattr.c            |    2 +-
>>  include/linux/reiserfs_fs_sb.h |    1 -
>>  4 files changed, 16 insertions(+), 28 deletions(-)
>>
>> --- a/fs/reiserfs/dir.c
>> +++ b/fs/reiserfs/dir.c
>> @@ -41,6 +41,18 @@ static int reiserfs_dir_fsync(struct fil
>>  
>>  #define store_ih(where,what) copy_item_head (where, what)
>>  
>> +static inline bool is_privroot_deh(struct dentry *dir,
>> +                   struct reiserfs_de_head *deh)
>> +{
>> +    int ret = 0;
>> +#ifdef CONFIG_REISERFS_FS_XATTR
>> +    struct dentry *privroot = REISERFS_SB(dir->d_sb)->priv_root;
>> +    ret = (dir == dir->d_parent && privroot->d_inode &&
>> +           deh->deh_objectid ==
>> INODE_PKEY(privroot->d_inode)->k_objectid);
>> +#endif
>> +    return ret;
>> +}
>> +
>>  int reiserfs_readdir_dentry(struct dentry *dentry, void *dirent,
>>                 filldir_t filldir, loff_t *pos)
>>  {
>> @@ -138,18 +150,8 @@ int reiserfs_readdir_dentry(struct dentr
>>                  }
>>  
>>                  /* Ignore the .reiserfs_priv entry */
>> -                if (reiserfs_xattrs(inode->i_sb) &&
>> -                    !old_format_only(inode->i_sb) &&
>> -                    dentry == inode->i_sb->s_root &&
>> -                    REISERFS_SB(inode->i_sb)->priv_root &&
>> -                    REISERFS_SB(inode->i_sb)->priv_root->d_inode
>> -                    && deh_objectid(deh) ==
>> -                    le32_to_cpu(INODE_PKEY
>> -                        (REISERFS_SB(inode->i_sb)->
>> -                         priv_root->d_inode)->
>> -                        k_objectid)) {
>> +                if (is_privroot_deh(dentry, deh))
>>                      continue;
>> -                }
>>  
>>                  d_off = deh_offset(deh);
>>                  *pos = d_off;
>> --- a/fs/reiserfs/namei.c
>> +++ b/fs/reiserfs/namei.c
>> @@ -338,21 +338,8 @@ static struct dentry *reiserfs_lookup(st
>>                  &path_to_entry, &de);
>>      pathrelse(&path_to_entry);
>>      if (retval == NAME_FOUND) {
>> -        /* Hide the .reiserfs_priv directory */
>> -        if (reiserfs_xattrs(dir->i_sb) &&
>> -            !old_format_only(dir->i_sb) &&
>> -            REISERFS_SB(dir->i_sb)->priv_root &&
>> -            REISERFS_SB(dir->i_sb)->priv_root->d_inode &&
>> -            de.de_objectid ==
>> -            le32_to_cpu(INODE_PKEY
>> -                (REISERFS_SB(dir->i_sb)->priv_root->d_inode)->
>> -                k_objectid)) {
>> -            reiserfs_write_unlock(dir->i_sb);
>> -            return ERR_PTR(-EACCES);
>> -        }
>> -
>> -        inode =
>> -            reiserfs_iget(dir->i_sb, (struct cpu_key *)&(de.de_dir_id));
>> +        inode = reiserfs_iget(dir->i_sb,
>> +                      (struct cpu_key *)&(de.de_dir_id));
>>          if (!inode || IS_ERR(inode)) {
>>              reiserfs_write_unlock(dir->i_sb);
>>              return ERR_PTR(-EACCES);
>> --- a/fs/reiserfs/xattr.c
>> +++ b/fs/reiserfs/xattr.c
>> @@ -841,7 +841,7 @@ ssize_t reiserfs_listxattr(struct dentry
>>      if (!dentry->d_inode)
>>          return -EINVAL;
>>  
>> -    if (!reiserfs_xattrs(dentry->d_sb) ||
>> +    if (!dentry->d_sb->s_xattr ||
>>          get_inode_sd_version(dentry->d_inode) == STAT_DATA_V1)
>>          return -EOPNOTSUPP;
>>  
>> --- a/include/linux/reiserfs_fs_sb.h
>> +++ b/include/linux/reiserfs_fs_sb.h
>> @@ -488,7 +488,6 @@ enum reiserfs_mount_options {
>>  #define reiserfs_data_log(s) (REISERFS_SB(s)->s_mount_opt & (1 <<
>> REISERFS_DATA_LOG))
>>  #define reiserfs_data_ordered(s) (REISERFS_SB(s)->s_mount_opt & (1 <<
>> REISERFS_DATA_ORDERED))
>>  #define reiserfs_data_writeback(s) (REISERFS_SB(s)->s_mount_opt & (1
>> << REISERFS_DATA_WRITEBACK))
>> -#define reiserfs_xattrs(s) ((s)->s_xattr != NULL)
>>  #define reiserfs_xattrs_user(s) (REISERFS_SB(s)->s_mount_opt & (1 <<
>> REISERFS_XATTRS_USER))
>>  #define reiserfs_posixacl(s) (REISERFS_SB(s)->s_mount_opt & (1 <<
>> REISERFS_POSIXACL))
>>  #define reiserfs_xattrs_optional(s) (reiserfs_xattrs_user(s) ||
>> reiserfs_posixacl(s))
>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> reiserfs-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>   
> 


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAku7dWoACgkQLPWxlyuTD7J8twCfeOXZTZot0wocKnhDoSy/ED/s
IrwAniBOs1YcTC67mH4dD+ggyx65ZA3X
=uKLG
-----END PGP SIGNATURE-----
