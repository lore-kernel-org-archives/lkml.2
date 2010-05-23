Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab0EWUU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 16:20:26 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56314 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab0EWUUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 16:20:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hwULqV3Ft1QTfxFm9KqCenMDVBg31doc9Kf6pGdHX/Jkh+uEzFgJCaHKGLoWdmsmej
         zsUx4ozzpV8iZFU2ped8QYDeSO+Gt4weoEGi/ISzkqCMr+XnK5g4JEALo4Gy9T3b83Xk
         nPbggN1xRwJnq4VVf/dli0BVdrJtHFFtkUoVE=
MIME-Version: 1.0
In-Reply-To: <1274570731.2810.45.camel@localhost>
References: <201005221535.38939.shawn.starr@rogers.com>
	 <4BF83CBF.8080300@gmail.com>
	 <20100522204426.GO31073@ZenIV.linux.org.uk>
	 <AANLkTimffWnIjHIEW54AoVxiALEoFkJZJJ7u57ZChDuy@mail.gmail.com>
	 <1274570731.2810.45.camel@localhost>
Date: Sun, 23 May 2010 22:20:23 +0200
Message-ID: <AANLkTimnJ2FJtvVJxRHHEr99td7aNCpdpQT9F461Z3IU@mail.gmail.com>
Subject: Re: [2.6.34-git8][regression] massive polling problems with udevd and 
	other processes
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>, Al Viro <viro@zeniv.linux.org.uk>,
       walt <w41ter@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 1:25 AM, Eric Paris <eparis@redhat.com> wrote:
> On Sat, 2010-05-22 at 18:59 -0400, Eric Paris wrote:
>> On Sat, May 22, 2010 at 4:44 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > On Sat, May 22, 2010 at 01:21:19PM -0700, walt wrote:
>> >> On 05/22/2010 12:35 PM, Shawn Starr wrote:
>> >> >Just built today's snapshot from linus's tree and have problems with udev
>> >> >using 100% cpu and KDE processes also pegging cpus.
>> >> >
>> >> >This is with Fedora 13 + snapshot kernel from git.
>> >> >
>> >> >Anyone else noticing this?
>> >>
>> >> Yes, just bisected it to this:
>> >>
>> >> commit a7cf4145bb86aaf85d4d4d29a69b50b688e2e49d
>> >> Author: Eric Paris <eparis@>
>> >> Date:   Fri May 14 11:44:10 2010 -0400
>> >>
>> >>     anon_inode: set S_IFREG on the anon_inode
>> >
>> > Cute...  Frankly, I'd be fine with just reverting that one and teaching
>> > selinux to STFU.  However, I wonder what specifically is getting polled.
>> > Which anon_inode users?
>>
>> On my system udev has both inotify and signalfd open.  He's asking for
>> more of the strace.  If the ONLY thing that udev is doing is polling
>> with no other syscalls at all it's a udev problem (although maybe one
>> where we have to maintain bug for bug compatibility.
>>
>> Can you show us a more lines of strace context and the output of ls -l
>> /proc/$PID/fd ?  That should give us a better idea what udev is doing
>> and which anon_inode we are dealing with.
>
> I'm wondering if this isn't a udev bug brought on by the combination of:
>
> commit c44dcc56d2b5c79ba3063d20f76e5347e2e418f6
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Thu Feb 11 02:24:46 2010 -0500
>
>    switch inotify_user to anon_inode
>
>    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk
>
> and a7cf4145bb86aaf85d4d4d29a69b50b688e2e49d (the commit in question).
> Before c44dcc56 the inotify inode would have been an S_IFDIR and maybe
> for that reason wouldn't have made it into the udev polling set?  The
> inotify inode would have been nothing after c44dcc56 (obviously) and now
> that it is S_IFREG maybe udev is putting it in the polling set for some
> reason....
>
> I'm feeling like this is a udev bug, but the only fix is going to be to
> revert and paper over anything else that has problems with
> (mode & S_IFMNT) == 0
>
> -Eric

Same issue here with -git8 and udevd...

[root@duff ~]# cat udevd.ps.out
root      1734 95.4  0.0  11336  1464 ?        R<s  22:14   2:11 /sbin/udevd -d
root      2163  0.0  0.0  12388  2600 ?        S<   22:14   0:00 /sbin/udevd -d
root      2277  0.0  0.0  12256  2472 ?        S<   22:14   0:00 /sbin/udevd -d
root      2282  0.0  0.0  12256  2396 ?        S<   22:14   0:00 /sbin/udevd -d
root      2283  0.0  0.0  11332  1376 ?        S<   22:14   0:00 /sbin/udevd -d
root      2293  0.0  0.0  11332  1364 ?        S<   22:14   0:00 /sbin/udevd -d
root      3082  0.0  0.0 102796   784 tty2     S+   22:16   0:00 grep udevd
[root@duff ~]# cat udevd.proc.pid.fd.out
total 0
lrwx------. 1 root root 64 2010-05-23 22:15 0 -> /dev/null
lrwx------. 1 root root 64 2010-05-23 22:15 1 -> /dev/null
lrwx------. 1 root root 64 2010-05-23 22:15 2 -> /dev/null
lrwx------. 1 root root 64 2010-05-23 22:15 3 -> /dev/.udev/queue.bin
lrwx------. 1 root root 64 2010-05-23 22:15 4 -> socket:[6579]
lrwx------. 1 root root 64 2010-05-23 22:15 5 -> socket:[6580]
lr-x------. 1 root root 64 2010-05-23 22:15 6 -> anon_inode:inotify
lrwx------. 1 root root 64 2010-05-23 22:15 7 -> anon_inode:[signalfd]
lrwx------. 1 root root 64 2010-05-23 22:15 8 -> socket:[6581]
lrwx------. 1 root root 64 2010-05-23 22:15 9 -> socket:[6582]
[root@duff ~]# head -30 udevd.strace.log
Process 1734 attached - interrupt to quit
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6,
events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5,
3000) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6,
events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5,
3000) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6,
events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5,
3000) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6,
events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5,
3000) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6,
events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5,
3000) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6,
events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5,
3000) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6,
events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5,
3000) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6,
events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5,
3000) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6,
events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5,
3000) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6,
events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5,
3000) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6,
events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5,
3000) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6,
events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5,
3000) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6,
events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5,
3000) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6,
events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5,
3000) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
