Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab2EGO2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:28:00 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54856 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab2EGO15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:27:57 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Nick Piggin <npiggin@gmail.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 04/16] vfs: do_last(): use inode variable
References: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
	<1335357857-16416-5-git-send-email-miklos@szeredi.hu>
	<CAPa8GCBjDjEtJsqxVrf7T3+VxGrGFMgNcjQv=5tSb4bZLOAB9Q@mail.gmail.com>
Date: Mon, 07 May 2012 16:28:21 +0200
In-Reply-To: <CAPa8GCBjDjEtJsqxVrf7T3+VxGrGFMgNcjQv=5tSb4bZLOAB9Q@mail.gmail.com>
	(Nick Piggin's message of "Tue, 1 May 2012 14:06:13 +1000")
Message-ID: <87fwbcuku2.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@gmail.com> writes:

> On 25 April 2012 22:44, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> Use helper variable instead of path->dentry->d_inode before complete_walk().
>> This will allow this code to be used in RCU mode.
>
> What do you mean, allow it to be used?

I mean allow the code to be shared between RCU and non-RCU mode.  See
10/16.

>
>>
>> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>> ---
>>  fs/namei.c |    7 ++++---
>>  1 files changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/namei.c b/fs/namei.c
>> index 46d4bf6..f21ddb3 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -2360,15 +2360,16 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
>>        if (error)
>>                nd->flags |= LOOKUP_JUMPED;
>>
>> +       inode = path->dentry->d_inode ;
>>        error = -ENOENT;
>> -       if (!path->dentry->d_inode)
>> +       if (!inode)
>>                goto exit_dput;
>>
>> -       if (path->dentry->d_inode->i_op->follow_link)
>> +       if (inode->i_op->follow_link)
>>                return NULL;
>>
>>        path_to_nameidata(path, nd);
>> -       nd->inode = path->dentry->d_inode;
>> +       nd->inode = inode;
>>        /* Why this, you ask?  _Now_ we might have grown LOOKUP_JUMPED... */
>>        error = complete_walk(nd);
>>        if (error)
>
> In rcu-walk mode, dentry->d_inode should not be accessed at all,
> outside of the core lookup code that (should) have the correct
> barriers and sequence locks.
>
> That logic should not escape into here, so I'm just not sure what
> you're doing here.

Right, dentry->d_inode is *not* going to be dereferenced in RCU mode.
In RCU mode it will jump to the place just after the "inode =
path->dentry->d_inode;" line.  See patch 10/16.

Thanks,
Miklos
