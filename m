Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab0EZVBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 17:01:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62169 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab0EZVBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 17:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cRKE5BF1LyQ1sFeQVjIwIpedvwWOgnLvq8XDRc1f/uSobucncMq3/JGflToCq5v/HR
         aE26jHN2C+Zr0VPKP/LnmgB60ysOVmI0syW8RJWxjA2GpHfcJB2HgC1Hz2CxWkDPm1q4
         gygSOiXlASYYoK3bRYDlyTtsxQqwzBEyF79+o=
MIME-Version: 1.0
In-Reply-To: <1274658541.2810.58.camel@localhost>
References: <201005221535.38939.shawn.starr@rogers.com>
	 <4BF83CBF.8080300@gmail.com>
	 <20100522204426.GO31073@ZenIV.linux.org.uk>
	 <AANLkTimffWnIjHIEW54AoVxiALEoFkJZJJ7u57ZChDuy@mail.gmail.com>
	 <1274570731.2810.45.camel@localhost>
	 <AANLkTimnJ2FJtvVJxRHHEr99td7aNCpdpQT9F461Z3IU@mail.gmail.com>
	 <1274658541.2810.58.camel@localhost>
Date: Wed, 26 May 2010 23:01:40 +0200
Message-ID: <AANLkTilIpEo3LSE9FuGpTh3OKHT12_v2rHRWUXRc_QhC@mail.gmail.com>
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

On Mon, May 24, 2010 at 1:49 AM, Eric Paris <eparis@redhat.com> wrote:
> On Sun, 2010-05-23 at 22:20 +0200, Alessandro Suardi wrote:
>> On Sun, May 23, 2010 at 1:25 AM, Eric Paris <eparis@redhat.com> wrote:
>
>> > I'm feeling like this is a udev bug, but the only fix is going to be to
>> > revert and paper over anything else that has problems with
>> > (mode & S_IFMNT) == 0
>> >
>> > -Eric
>
>> [root@duff ~]# cat udevd.proc.pid.fd.out
>> lr-x------. 1 root root 64 2010-05-23 22:15 6 -> anon_inode:inotify
>> lrwx------. 1 root root 64 2010-05-23 22:15 7 -> anon_inode:[signalfd]
>
>> [root@duff ~]# head -30 udevd.strace.log
>> Process 1734 attached - interrupt to quit
>> poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6, events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5, 3000) = 1 ([{fd=6, revents=POLLIN}])
>> ioctl(6, FIONREAD, [0])                 = 0
>
> Well at least I see what is wrong.  Before the change ioctl(FIONREAD)
> would go down this code path:
>
> sys_ioctl()
>  do_vfs_ioctl()
>    vfs_ioctl()
>      filp->f_ops->ioctl()
>        inotify_ioctl()
>          returns the answer.
>
> After the change we instead get:
>
> sys_ioctl()
>  do_vfs_ioctl()
>    file_ioctl()
>      which would return put_user(i_size_read(inode) - filp->f_pos, p)
>
> If there is no rule that all inodes must be of a known S_IFMNT then I
> guess the best fix is to just revert and I'll fix up the symptoms.  If
> there is such an unwritten rule (which seems perfectly reasonable) we
> can either special case the anon_inode to push FIONREAD down to
> vfs_ioctl or move FIONREAD down to vfs_ioctl and force everyone else to
> implement it.
>
> Al?  Maybe you have better ideas?

2.6.34-git11 with F12's just-updated udev-145-21.fc12.x86_64 is still
 exposing this issue... ATM I'm simply killing udevd right after booting,
 but it's definitely not an optimal solution.

If more thought to a better fix is required, perhaps it's best for now to
 just revert the change that introduced the regression.

thanks,

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
