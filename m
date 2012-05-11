Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab2EKPjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:39:07 -0400
Received: from natasha.panasas.com ([67.152.220.90]:38864 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab2EKPi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:38:57 -0400
Message-ID: <4FAD30D7.3070208@panasas.com>
Date: Fri, 11 May 2012 18:31:35 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Ludwig Nussel <ludwig.nussel@suse.de>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>,
        open list:
	EXT2 FILE SYSTEM <linux-ext4@vger.kernel.org>,
        "; open list":
	DOCUMENTATION <linux-doc@vger.kernel.org>, ;
Illegal-Object: Syntax error in To: addresses found on vger.kernel.org:
	To:	;open list:DOCUMENTATION <linux-doc@vger.kernel.org>
			^-extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH RESEND] implement uid and gid mount options for ext2,
 ext3 and ext4
References: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.de> <20120511034945.GA15892@mobil.systemanalysen.net>
In-Reply-To: <20120511034945.GA15892@mobil.systemanalysen.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 06:49 AM, Roland Eggner wrote:

> On 2012-05-10 Thu 16:42 +0200, Ludwig Nussel wrote:
>> …
>> When using 'real' file systems on removable storage devices such as
>> hard disks or usb sticks people quickly face the problem that their
>> Linux users have different uids on different machines. Therefore one
>> cannot modify or even read files created on a different machine
>> without running chown as root or storing everything with mode 777.
>> Simple file systems such as vfat don't have that problem as they
>> don't store file ownership information and one can pass the uid
>> files should belong to as mount option.
>>
>> The following two patches (for 3.4.0-rc4) implement the uid (and
>> gid) mount option for ext2, ext3 and ext4 to make them actually
>> useful on removable media. If a file system is mounted with the uid
>> option all files appear to be owned by the specified uid. Only newly
>> created files actually end up with that uid as owner on disk though.
>> Ownership of existing files cannot be changed permanently if the uid
>> option was specified.
>>
>> Acked-by: Rob Landley <rob@landley.net>
>> Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
>> ---
>>  Documentation/filesystems/ext2.txt |    9 ++++++
>>  Documentation/filesystems/ext3.txt |    9 ++++++
>>  Documentation/filesystems/ext4.txt |    9 ++++++
>>  fs/ext2/ext2.h                     |    8 +++++
>>  fs/ext2/inode.c                    |   42 ++++++++++++++++++++------
>>  fs/ext2/super.c                    |   57 +++++++++++++++++++++++++++++++++++-
>>  fs/ext3/ext3.h                     |    8 +++++
>>  fs/ext3/inode.c                    |   50 ++++++++++++++++++++++---------
>>  fs/ext3/super.c                    |   57 +++++++++++++++++++++++++++++++++++-
>>  fs/ext4/ext4.h                     |    4 ++
>>  fs/ext4/inode.c                    |   50 ++++++++++++++++++++++---------
>>  fs/ext4/super.c                    |   49 ++++++++++++++++++++++++++++++-
>>  12 files changed, 311 insertions(+), 41 deletions(-)
>>
>> …
> 
> 
> In short:
> .........
> Problem solving at its root is more efficient than at “end of pipe”.
> 
> 
> 
> IMHO this is an example of “end of pipe“ thinking with following downsides:
> ...........................................................................
> *  Maintainers point of view:
>    *  Introduces new problems:  Breaking holes in the access restrictions
>       provided by the Linux kernel at will of unprivileged users would render
>       the kernel unusable for reliable operation in multiuser environments.
>    *  Adds code complexity and risk of bugs.
>    *  Adds future maintainance load.
> *  Users point of view:
>    *  Editing /etc/fstab or using mount commands with options not in
>       /etc/fstab require root privileges anyway, at least on sane systems.
>    *  Adds usage complexity (new vs. old files, on disk vs. pretended UIDs …).
>    *  Adds risk of usage errors.
> 
> 
> 
> IMHO the “right thing to do” is to solve the problem at its root:
> .................................................................
> My habit is, whenever I use {group,user}add commands:
> *  In advance I create a list of all current and future users (user, GID, UID)
>    common to all systems that might exchange files.  The list is designed to
>    have “headroom” for future additions.
> *  I always consult this list and use options --gid $userGID --uid $userUID to
>    {group,user}add commands.
> *  Exchanging files with an unforeseen system is an exception, which requires
>    root privileges anyway,
> 
> Advantages:
> *  Decent migration of files to other systems via backups, external storage …
> *  No NEW wholes in the access restrictions provided by the Linux kernel.
> *  No NEW kernel code possibly introducing bugs.
> *  No need to learn new mount options.
> *  No NEW risks of usage errors.
> 
> 
> Summary:
> ........
> *  If UIDs differ on machines FORESEEN for file exchange, this is an
>    administrator error, not a kernel deficit.
> *  File exchange with an UNFORESEEN system requires root privileges anyway.
> 
> 


I agree with Ludwig completely!!! Thanks, good policy rules.

1. ext* are nothing special and are not a special domain of removable media.
   (If any vfat is dominant at that end)

2. What the hell does removable-media means? and how is it different then
   something else? is ext* over iscsi removable? a soft-mount NFS, is it
   removable?

Above sounds to me like a huge security breach, and actually a data-corruption.

In the NFS world I hang around, we constantly encounter multiple domain
uid/gid views, and it does not mean we blow a hole in POSIX security rules.

The root that mounts this FS can just copy+chmod or just-chmod them.
Next we'll see auto-mounters use these flags and goodbye file-access-control.

There is some convenience you do not allow. a password-less root, and no access
control at all is most convenient would you say?

I bet this code opens up an attack vector like crazy. Windows viruses welcome.

No thanks
Boaz

> 

> Thanks,
> Roland Eggner


