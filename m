Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab0FGEXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 00:23:40 -0400
Received: from 64-131-60-146.usfamily.net ([64.131.60.146]:42343 "EHLO
	mail.sandeen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab0FGEXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 00:23:39 -0400
Message-ID: <4C0C7448.7040409@sandeen.net>
Date: Sun, 06 Jun 2010 23:23:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Jeffrey Merkey <jeffmerkey@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, josef@redhat.com,
       viro@zeniv.linux.org.uk
Subject: Re: 2.6.34 echo j > /proc/sysrq-trigger causes inifnite unfreeze/Thaw
 event
References: <AANLkTim74SREZDq7VQhq6Z1hKXZLINoq0t8rkyQecmM1@mail.gmail.com> <20100607010542.GB27325@dastard>
In-Reply-To: <20100607010542.GB27325@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Thu, Jun 03, 2010 at 11:30:30PM -0600, Jeffrey Merkey wrote:
>> causes the FS Thaw stuff in fs/buffer.c to enter an infinite loop
>> filling the /var/log/messages with junk and causing the hard drive to
>> crank away endlessly.
> 
> Hmmm, looks pretty obvious what the 2.6.34 bug is:
> 
>         while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
>                 printk(KERN_WARNING "Emergency Thaw on %s\n",
>                        bdevname(sb->s_bdev, b));
> 
> thaw_bdev() returns 0 on success or not frozen, and returns non-zero
> only if the unfreeze failed. Looks like it was broken from the start
> to me.

thaw_bdev() used to return -EINVAL for not-frozen, but it no longer
does.  Seems commit 4504230a dropped this:

-       if (!bdev->bd_fsfreeze_count) {
-               mutex_unlock(&bdev->bd_fsfreeze_mutex);
-               return -EINVAL;
-       }

in favor of this:

+       int error = -EINVAL;
...
+       if (!bdev->bd_fsfreeze_count)
+               goto out_unlock;
...
+out_unlock:
        mutex_unlock(&bdev->bd_fsfreeze_mutex);
        return 0;

and now we return 0 for a thaw of a non-frozen bdev ....
this breaks the loop in the emergency thaw-er (which was
just supposed to work its way through nested freezes,
when I wrote it)

-Eric
