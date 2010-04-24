Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0DXOj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 10:39:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab0DXOj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 10:39:27 -0400
Message-ID: <4BD30288.1040501@redhat.com>
Date: Sat, 24 Apr 2010 09:39:04 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: kernel list <linux-kernel@vger.kernel.org>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ecryptfs: disallow ecryptfs as underlying filesystem
References: <4BD25A4B.4050000@redhat.com> <x2s84144f021004240154g1a4dba0dnc9308abbebee9ce7@mail.gmail.com>
In-Reply-To: <x2s84144f021004240154g1a4dba0dnc9308abbebee9ce7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Sat, Apr 24, 2010 at 5:41 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> mounting stacked ecryptfs on ecryptfs has been shown to lead to bugs
>> in testing.  For crypto info in xattr, there is no mechanism for handling
>> this at all, and for normal file headers, we run into other trouble:
>>
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>> IP: [<ffffffffa015b0b3>] ecryptfs_d_revalidate+0x43/0xa0 [ecryptfs]
>> ...
>>
>> There doesn't seem to be any good usecase for this, so I'd suggest just
>> disallowing the configuration.
> 
> Maybe there's no good use case for it but it sure sounds like a good
> test case for shaking out bugs in filesystem stacking code.

I could revise the patch to allow a force-override option if you're interested
in doing that shaking.  :)

(for cryptinfo-in-xattr, though, there is simply no mechanism to support this
at all in ecryptfs, and I doubt it's a design goal, though will defer to tyhicks
on all this)

-Eric

>> Based on a patch originally, I believe, from Mike Halcrow.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
>> index af1a8f0..7ada044 100644
>> --- a/fs/ecryptfs/main.c
>> +++ b/fs/ecryptfs/main.c
>> @@ -594,28 +594,46 @@ static int ecryptfs_get_sb(struct file_system_type *fs_type, int flags,
>>                        struct vfsmount *mnt)
>>  {
>>        int rc;
>> -       struct super_block *sb;
>> +       struct super_block *sb, *lower_sb;
>> +       struct nameidata nd;
>> +
>> +       rc = path_lookup(dev_name, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &nd);
>> +       if (rc) {
>> +               printk(KERN_WARNING
>> +                       "path_lookup() failed on dev_name = [%s]\n", dev_name);
>> +               goto out;
>> +       }
>> +       lower_sb = nd.path.dentry->d_sb;
>> +       if (strcmp(lower_sb->s_type->name, "ecryptfs") == 0) {
>> +               rc = -EINVAL;
>> +               printk(KERN_ERR "Mount on filesystem of type "
>> +                       "eCryptfs explicitly disallowed due to "
>> +                       "known incompatibilities\n");
>> +               goto out_pathput;
>> +       }
>>
>>        rc = get_sb_nodev(fs_type, flags, raw_data, ecryptfs_fill_super, mnt);
>>        if (rc < 0) {
>>                printk(KERN_ERR "Getting sb failed; rc = [%d]\n", rc);
>> -               goto out;
>> +               goto out_pathput;
>>        }
>>        sb = mnt->mnt_sb;
>>        rc = ecryptfs_parse_options(sb, raw_data);
>>        if (rc) {
>>                printk(KERN_ERR "Error parsing options; rc = [%d]\n", rc);
>> -               goto out_abort;
>> +               goto out_dput;
>>        }
>>        rc = ecryptfs_read_super(sb, dev_name);
>>        if (rc) {
>>                printk(KERN_ERR "Reading sb failed; rc = [%d]\n", rc);
>> -               goto out_abort;
>> +               goto out_dput;
>>        }
>>        goto out;
>> -out_abort:
>> +out_dput:
>>        dput(sb->s_root); /* aka mnt->mnt_root, as set by get_sb_nodev() */
>>        deactivate_locked_super(sb);
>> +out_pathput:
>> +       path_put(&nd.path);
>>  out:
>>        return rc;
>>  }
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>

