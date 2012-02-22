Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2BVTKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 14:10:07 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:53771 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754770Ab2BVTKF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 14:10:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of keescook@google.com designates 10.182.147.106 as permitted sender) smtp.mail=keescook@google.com; dkim=pass header.i=keescook@google.com
MIME-Version: 1.0
In-Reply-To: <20120222102301.GC30339@elte.hu>
References: <20120222012103.GA13295@www.outflux.net>
	<20120222102301.GC30339@elte.hu>
Date: Wed, 22 Feb 2012 11:10:04 -0800
X-Google-Sender-Auth: rz45L0OkxG_BJwpxMSFH-1rpx7E
Message-ID: <CAGXu5jLnDa9g5z76OQaF5BGbHssQVSgc3KCSwOVT9__mLww9Yg@mail.gmail.com>
Subject: Re: [PATCH] fs: hardlink creation restriction cleanup
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 2:23 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> Clean-up of hardlink restriction logic, as suggested by Andrew Morton.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  fs/namei.c |   59 +++++++++++++++++++++++++++++++++++++++++------------------
>>  1 files changed, 41 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/namei.c b/fs/namei.c
>> index 8ed4e00..a4a21a5 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -693,46 +693,69 @@ static inline int may_follow_link(struct path *link)
>>  }
>>
>>  /**
>> + * safe_hardlink_source - Check for safe hardlink conditions
>> + * @inode: the source inode to hardlink from
>> + *
>> + * Return false if at least one of the following conditions:
>> + *    - inode is not a regular file
>> + *    - inode is setuid
>> + *    - inode is setgid and group-exec
>> + *    - access failure for read and write
>> + *
>> + * Otherwise returns true.
>> + */
>> +static bool safe_hardlink_source(struct inode *inode)
>> +{
>> +     mode_t mode = inode->i_mode;
>> +
>> +     /* Special files should not get pinned to the filesystem. */
>> +     if (!S_ISREG(mode))
>> +             return false;
>> +     /* Setuid files should not get pinned to the filesystem. */
>> +     if (mode & S_ISUID)
>> +             return false;
>> +     /* Executable setgid files should not get pinned to the filesystem. */
>> +     if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP))
>> +             return false;
>> +     /* Hardlinking to unreadable or unwritable sources is dangerous. */
>> +     if (inode_permission(inode, MAY_READ | MAY_WRITE))
>> +             return false;
>> +
>> +     return true;
>
> A really minor nitpick, could we use this form please:
>
> static bool safe_hardlink_source(struct inode *inode)
> {
>        mode_t mode = inode->i_mode;
>
>        /* Special files should not get pinned to the filesystem. */
>        if (!S_ISREG(mode))
>                return false;
>
>        /* Setuid files should not get pinned to the filesystem. */
>        if (mode & S_ISUID)
>                return false;
>
>        /* Executable setgid files should not get pinned to the filesystem. */
>        if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP))
>                return false;
>
>        /* Hardlinking to unreadable or unwritable sources is dangerous. */
>        if (inode_permission(inode, MAY_READ | MAY_WRITE))
>                return false;
>
>        return true;
> }
>
> Those separate blocks of comments and conditions stand out much
> nicer this way, making it way easier on the eyes - to my eyes at
> least ;-)

Heh, sure. I've sent v2 now. :)

-Kees

-- 
Kees Cook
ChromeOS Security
