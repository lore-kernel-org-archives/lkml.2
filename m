Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab2ECGr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:47:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53136 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab2ECGrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:47:55 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <877gwxacti.fsf@skywalker.in.ibm.com>
References: <1335669917-23970-1-git-send-email-vapier@gentoo.org>
 <CAKgNAkgykZJV59WJXW9c9gVwXhn=WNYKxo_W1GM7ocHEEFqEXg@mail.gmail.com> <877gwxacti.fsf@skywalker.in.ibm.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 3 May 2012 18:47:32 +1200
Message-ID: <CAKgNAkiRH8p=Dp1tqkb3D9oRVCOSnj2bofgFN5x2svntN7vtPg@mail.gmail.com>
Subject: Re: [PATCH] open(2): document O_PATH
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-man@vger.kernel.org,
        viro@zeniv.linux.org.uk, Richard Weinberger <richard@nod.at>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aneesh,

[...]

>> --- a/man2/open.2
>> +++ b/man2/open.2
>> @@ -428,6 +427,66 @@ For a discussion of the effect of
>>  in conjunction with mandatory file locks and with file leases, see
>>  .BR fcntl (2).
>>  .TP
>> +.BR O_PATH " (since Linux 2.6.39)"
>> +.\" commit 1abf0c718f15a56a0a435588d1b104c7a37dc9bd
>> +Obtain a file descriptor that is used only for fetching file attributes.
>> +The file itself is not opened, and most file operations (e.g.,
>> +.BR read (2),
>> +.BR write (2))
>> +fail with the error
>> +.BR EBADF .
>> +The following operations
>> +.I can
>> +be performed on the resulting file descriptor:
>> +.RS
>> +.IP * 3
>> +Closing the file descriptor
>> +.RB ( close (2)).
>> +.\" FIXME Commit 1abf0c718f15a56a0a435588d1b104c7a37dc9bdcw
>> +.\" message says that closing the file descriptor does not affect
>> +.\" POSIX locks or dnotify.
>> +.\" However, my testing shows that it DOES affect dnotify (and inotify).
>> +.\" Does close() affect POSIX locks?
>> +.IP *
>
>
> IIUC what an O_PATH descritor doesn't do is to flush dnotify markers
>
>        if (likely(!(filp->f_mode & FMODE_PATH))) {
>                dnotify_flush(filp, id);
>                locks_remove_posix(filp, id);
>        }
>
> I don't know much about markers, but as per fsnotify_backend.h
>
> /*
>  * a mark is simply an object attached to an in core inode which allows an
>  * fsnotify listener to indicate they are either no longer interested in events
>  * of a type matching mask or only interested in those events.
>  *
>  * these are flushed when an inode is evicted from core and may be flushed
>  * when the inode is modified (as seen by fsnotify_access).  Some fsnotify users
>  * (such as dnotify) will flush these when the open fd is closed and not at
>  * inode eviction or modification.
>  */
> struct fsnotify_mark {

Unfortunately, I'm still none the wiser about what this means for
O_PATH file descriptors...

> It also doesn't remove posix locks. I tested this with a test prg
>
>    struct flock flock;
>    flock.l_type = F_WRLCK;
>    flock.l_whence = SEEK_SET;
>    flock.l_start = 0;
>    flock.l_len = 0;
>    fd = open(argv[1], O_RDWR);
>    fcntl(fd, F_SETLKW, &flock);
>    fd = open(argv[1], O_PATH);
>    close(fd);
>
> The close doesn't result in lock release.

Okay -- I'll add mention of this to the O_PATH description.

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
