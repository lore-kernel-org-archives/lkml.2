Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2GWSJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:09:18 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:16043 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2GWSJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:09:16 -0400
Date: Mon, 23 Jul 2012 20:09:14 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Richard Weinberger <richard@nod.at>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-man@vger.kernel.org
Subject: Re: st_size of a symlink
In-Reply-To: <500D73FF.1070504@nod.at>
Message-ID: <alpine.LNX.2.00.1207231959410.1922@swampdragon.chaosbits.net>
References: <500D73FF.1070504@nod.at>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2012, Richard Weinberger wrote:

> Hi!
> 
> lstat(2) on /proc/$pid/exe gives me a stat object where st_size is 0.
> 
> Or:
> rw@mantary:~> ls -l /proc/$$/exe
> lrwxrwxrwx 1 rw users 0 23. Jul 17:02 /proc/16902/exe -> /bin/bash
> 
> The lstat(2) manpage says:
> "The st_size field gives the size of the file (if it is a regular file or a
> symbolic link) in bytes.  The size of a symbolic link is the length of the
> pathname it contains, without a terminating null byte."
> 
> This property is also used in the example in the readlink(2) manpage.
> 
> Is this a procfs issue or is the manpage wrong?
> 
I have relied on that behaviour (size of symlink being lengh of pathname 
it contains) in the past, so I know it used to work and I'd expect it to 
keep working.
I honestly never really thought about procfs, but checking now, it does 
seem that procfs doesn't quite do things right...

Just so we all know what kernel I'm running:
  [root@arch tmp]# uname -a
  Linux arch 3.4.6-1-ARCH #1 SMP PREEMPT Fri Jul 20 08:21:26 CEST 2012 x86_64 GNU/Linux

Let's see what procfs reports:
  [root@arch ~]# ls -l /proc/$$/exe
  lrwxrwxrwx 1 root root 0 Jul 23 19:58 /proc/884/exe -> /bin/bash
Doesn't seem quite right....

Now let's see what tmpfs reports:
  [root@arch tmp]# mount | grep /tmp
  tmpfs on /tmp type tmpfs (rw,nosuid,nodev,relatime)
  [root@arch ~]# cd /tmp
  [root@arch tmp]# ln -s /tmp foo
  [root@arch tmp]# ls -l foo
  lrwxrwxrwx 1 root root 4 Jul 23 19:59 foo -> /tmp
Seems OK.

Let's check ext4:
  [root@arch tmp]# mount | grep /home
  /dev/sda4 on /home type ext4 (rw,relatime,data=ordered)
  [root@arch tmp]# cd /home/jj
  [root@arch jj]# touch foo
  [root@arch jj]# ln -s foo bar
  [root@arch jj]# ls -l bar
  lrwxrwxrwx 1 root root 3 Jul 23 20:03 bar -> foo
Seems OK as well..

So how about devtmpfs?
  [root@arch jj]# mount | grep devtmpfs
  dev on /dev type devtmpfs (rw,nosuid,relatime,size=779400k,nr_inodes=194850,mode=755)
  [root@arch jj]# ls -l /dev/stderr 
  lrwxrwxrwx 1 root root 15 Jul 23 19:46 /dev/stderr -> /proc/self/fd/2
Also looks OK...

So, from my point of view it looks like procfs is the one who has got it 
wrong.
We should probably fix that (IMVHO).


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

