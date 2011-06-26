Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab1FZRdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 13:33:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab1FZRbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 13:31:17 -0400
Message-ID: <4E076CC6.2070408@redhat.com>
Date: Sun, 26 Jun 2011 14:30:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl doesn't
 exist
References: <4E0519B7.3000304@redhat.com> <4E0752E0.5030901@iki.fi> <4E075C45.3010200@redhat.com> <201106261913.05752.arnd@arndb.de>
In-Reply-To: <201106261913.05752.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 26-06-2011 14:13, Arnd Bergmann escreveu:
> On Sunday 26 June 2011 18:20:21 Mauro Carvalho Chehab wrote:
> 
>>> The V4L2 core probably should return -ENOIOCTLCMD when an IOCTL isn't implemented, but as long as vfs_ioctl() would stay as it is, the user space would still get -EINVAL. Or is vfs_ioctl() about to change?
>>>
>>> fs/ioctl.c:
>>> ----8<-----------
>>> static long vfs_ioctl(struct file *filp, unsigned int cmd,
>>>                       unsigned long arg)
>>> {
>>>         int error = -ENOTTY;
>>>
>>>         if (!filp->f_op || !filp->f_op->unlocked_ioctl)
>>>                 goto out;
>>>
>>>         error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
>>>         if (error == -ENOIOCTLCMD)
>>>                 error = -EINVAL;
>>>  out:
>>>         return error;
>>> }
>>> ----8<-----------
> 
> One of the differences between the old ->ioctl() and the ->unlocked_ioctl()
> function is that unlocked_ioctl could point to the same function as
> ->compat_ioctl(), so we have to catch functions returning -ENOIOCTLCMD.
> 
>> Good catch!
>>
>> At the recent git history, the return for -ENOIOCTLCMD were modified
>> by this changeset:
>>
>> commit b19dd42faf413b4705d4adb38521e82d73fa4249
>> Author: Arnd Bergmann <arnd@arndb.de>
>> Date:   Sun Jul 4 00:15:10 2010 +0200
>>
>>     bkl: Remove locked .ioctl file operation
>> ...
>> @@ -39,21 +38,12 @@ static long vfs_ioctl(struct file *filp, unsigned int cmd,
>>  {
>>         int error = -ENOTTY;
>>  
>> -   if (!filp->f_op)
>> + if (!filp->f_op || !filp->f_op->unlocked_ioctl)
>>                 goto out;
>>  
>> -   if (filp->f_op->unlocked_ioctl) {
>> -           error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
>> -           if (error == -ENOIOCTLCMD)
>> -                   error = -EINVAL;
>> -           goto out;
>> -   } else if (filp->f_op->ioctl) {
>> -           lock_kernel();
>> -           error = filp->f_op->ioctl(filp->f_path.dentry->d_inode,
>> -                                     filp, cmd, arg);
>> -           unlock_kernel();
>> ...
>>
>> Before Arnd's patch, locked ioctl's were returning -ENOIOCTLCMD, and
>> unlocked ones were returning -EINVAL. Now, the return of -ENOIOCTLCMD
>> doesn't go to userspace anymore. IMO, that's wrong and can cause
>> regressions, as some subsystems like DVB were returning -ENOIOCTLCMD
>> to userspace.
> 
> ENOIOCTLCMD should never be returned to user space, see the comment
> in include/linux/errno.h:
> 
> /*
>  * These should never be seen by user programs.  To return one of ERESTART*
>  * codes, signal_pending() MUST be set.  Note that ptrace can observe these
>  * at syscall exit tracing, but they will never be left for the debugged user
>  * process to see.
>  */
> 

Ah, ok.

> There was a lot of debate whether undefined ioctls on non-ttys should
> return -EINVAL or -ENOTTY, including mass-conversions from -ENOTTY to
> -EINVAL at some point in the pre-git era, IIRC.
> 
> Inside of v4l2, I believe this is handled by video_usercopy(), which
> turns the driver's -ENOIOCTLCMD into -ENOTTY. What cases do you observe
> where this is not done correctly and we do return ENOIOCTLCMD to
> vfs_ioctl?

Well, currently, it is returning -EINVAL maybe due to the mass-conversions
you've mentioned.

The point is that -EINVAL has too many meanings at V4L. It currently can be
either that an ioctl is not supported, or that one of the parameters had
an invalid parameter. If the userspace can't distinguish between an unimplemented
ioctl and an invalid parameter, it can't decide if it needs to fall back to
some different methods of handling a V4L device.

Maybe the answer would be to return -ENOTTY when an ioctl is not implemented.

>> Linus,
>>
>> what would be the expected behaviour?
> 
> Note that 1da177e is the initial commit to git, Linus did not write that
> code, although he might have an opinion.

Yes, I know. I'm expecting his comments on it.

Mauro.
