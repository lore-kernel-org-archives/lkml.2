Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1I3GpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 02:45:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45314 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab1I3GpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 02:45:05 -0400
Message-ID: <4E856476.6060808@suse.cz>
Date: Fri, 30 Sep 2011 08:40:54 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110922 Thunderbird/7.0
MIME-Version: 1.0
To: Doug Ledford <dledford@xsintricity.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Fix up return value from mq_open()
References: <4E85263D.3030905@xsintricity.com>
In-Reply-To: <4E85263D.3030905@xsintricity.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2011 04:15 AM, Doug Ledford wrote:
> Commit d40dcdb ipc/mqueue.c: fix mq_open() return value
> changed the return value for mq_open() to return
> 
> EMFILE - The process already has the maximum number of files and
>                message queues open.
> 
> instead of
> 
> ENOMEM - Insufficient memory.
> 
> While the portion of d40dcdb that introduced using ERR_PTR() to
> propagate the condition were helpful, the change to the type of error
> was not.  The specific test that was failing was a memory space test.
> It can fail if there are too many message queues open and this one would
> cause us to exceed the tasks counter for memory bytes capacity (aka, int
> wrap) or it can fail if the total number of bytes already allocated plus
> this allocation will exceed the user's RLIMIT for POSIX message queues.

Yes, then it should not definitely return ENOMEM, right? You exceeded a
limit, not ran out of memory. At least for the latter case.

>  However, depending on the values passed in via an attribute struct,
> this could happen on the 1st file or the 100th file. There is no direct
> relationship to file count in this test.  There is only a direct
> correlation to memory usage.  Therefore return the code to giving ENOMEM
> instead of EMFILE.
...
> commit b80e4058e2b4234fb33a9fd84b4ce288e8ba65cb
> Author: Doug Ledford <dledford@redhat.com>
> Date:   Thu Sep 29 19:02:47 2011 -0400
> 
>     ipc/mqueue: make the error returns match the conditions
>     
>     We should not return -EMFILE when the problem is memory usage.

Sorry, I still don't udnerstand, how this test:
  u->mq_bytes + mq_bytes > task_rlimit(p, RLIMIT_MSGQUEUE)
is about running out of memory. I see only a test for exceeding some
quota. Should this be changed, change it to something like ENOSPC.

> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 0474ddb..3e53604 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -165,7 +165,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
>  		    u->mq_bytes + mq_bytes > task_rlimit(p, RLIMIT_MSGQUEUE)) {
>  			spin_unlock(&mq_lock);
>  			/* mqueue_evict_inode() releases info->messages */
> -			ret = -EMFILE;
> +			ret = -ENOMEM;

The code now looks like:
int ret = -ENOMEM;
...
if (sth)
  ret = -ENOMEM;
...
return ret;

which is not good.

thanks,
-- 
js
suse labs
