Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab2EMIzb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 04:55:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55694 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2EMIz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 04:55:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120513044052.GC31866@thunk.org>
References: <CAHOpdHWMcV6LjpaEhk27ULkz-wGUD0-pNH=PC+ahDn47VQ+qmQ@mail.gmail.com>
	<20120513044052.GC31866@thunk.org>
Date: Sun, 13 May 2012 10:55:28 +0200
Message-ID: <CAHOpdHW0fKaUwCkr7uKuxhkZyazjYBCe2dCjHHeQ9XaFiNhX+w@mail.gmail.com>
Subject: Re: BUG: jbd2 slowing down file copies even though no journaling file
 system is used
From: =?ISO-8859-1?Q?Bj=F6rn_Christoph?= <einkaufenbc09@googlemail.com>
To: "Ted Ts'o" <tytso@mit.edu>,
        =?ISO-8859-1?Q?Bj=F6rn_Christoph?= <einkaufenbc09@googlemail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted,

dm-1 points to my Linux-OS partition which is actually the encrypted
LVM one. However, I could also see that on some copies this actually
points to the related truecrypt partition so that makes sense there
(the dm-1 doesn't imo but not important at this point).

"echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_sync_file_enter/enable"
didn't work for me, I got a "permission denied" error. So then I
figured out I have to use "sudo -i" to get a root shell, then I can
actually echo into that file ? Very strange but an Ubuntu
issue/feature I guess.

However, I don't see that the file /sys/kernel/debug/tracing/trace
changes a lot? All I see is this even though I am clearly copying data
onto the disk via samba:

# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
           <...>-2096  [001]  1111.151516: ext4_sync_file_enter: dev
252,1 ino 3410181 parent 3410196 datasync 1
           <...>-2096  [000]  1111.201520: ext4_sync_file_enter: dev
252,1 ino 3410181 parent 3410196 datasync 0
           <...>-2096  [001]  1111.252939: ext4_sync_file_enter: dev
252,1 ino 3410181 parent 3410196 datasync 1
           <...>-2096  [000]  1111.290241: ext4_sync_file_enter: dev
252,1 ino 3410181 parent 3410196 datasync 0
           <...>-2096  [001]  1111.341757: ext4_sync_file_enter: dev
252,1 ino 3410181 parent 3410196 datasync 1
           <...>-2096  [000]  1111.367540: ext4_sync_file_enter: dev
252,1 ino 3410181 parent 3410196 datasync 0
           <...>-2096  [001]  1111.419511: ext4_sync_file_enter: dev
252,1 ino 3410181 parent 3410196 datasync 1
           <...>-2096  [000]  1111.456354: ext4_sync_file_enter: dev
252,1 ino 3410181 parent 3410196 datasync 0

PID 2096 is sshd acc. to "top" (I think this was my local copying to a
file from /dev/zero?).

Even if I copy data now, the file never changes, I always see the same
"cat" output?

I changed the entry back to 0, rebooted, changed it back to 1, started
copying a file to an ext4 partition and cat
/sys/kernel/debug/tracing/trace is just plain empty (shows "tracer:
nop", TASK-PID etc but no data).

I'm a bit lost on how to gather the required traces :(

Thanks and regards,
Bjoern

2012/5/13 Ted Ts'o <tytso@mit.edu>:
> On Sun, May 13, 2012 at 01:21:00AM +0200, Björn Christoph wrote:
>>
>> IOTOP shows this in some cases, mostly jbd2 is not there:
>>   PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND
>>   416 be/3 root        0.00 B/s   97.65 M/s  0.00 % 13.74 % [jbd2/dm-1-8]
>
> Well, the file system in that has the huge write bandwidth is
> whichever device is associated with device mapper device dm-1 (i.e.,
> with a device mapper minor number of 1).  What does "ls -l
> /dev/mapper" show you?
>
> Whatever file system is associated with it is clearly generating a lot
> of journal activity.
>
> Something that may help in determining what process is generating all
> of this journal activity (which is likely the result of something
> calling fsync a lot) is to try this:
>
> echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_sync_file_enter/enable
>
> ... then wait for a minute or so, and then capture the output of:
>
> cat /sys/kernel/debug/tracing/trace
>
> See if that shows up anything useful.
>
> Regards,
>
>                                        - Ted
