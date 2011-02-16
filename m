Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1BPNzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:55:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43792 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1BPNzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:55:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Vza09qb3CkF6auFiNPLqjlC2RQQxvSXig12rMGX7gpgP8HpfuIn4Z914xyGhZJ3Fkm
         9hlUncz8O89xO4tflNz5AZhJCGJKOkDL1acTaDzbyQDKa8PgQcU/eIvbdSNxR4NQAoe2
         Ay/PIoiartGVJthpKstH5gWamZ8KyCw9WUpBQ=
Subject: Re: Linux 2.6.38-rc5
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <1297854842.3201.197.camel@edumazet-laptop>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
	 <1297854842.3201.197.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 14:55:44 +0100
Message-ID: <1297864544.3201.361.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 16 février 2011 à 12:14 +0100, Eric Dumazet a écrit :
> Le mardi 15 février 2011 à 20:16 -0800, Linus Torvalds a écrit :
> > Another week, another -rc.
> > 
> > Nothing much stands out here - we've fixed some regressions
> > (including, hopefully, a BUG_ON() due to the new RCU filename lookup
> > that Ubuntu people saw), and things look fairly normal.
> 
> Using this kernel on my dev machine (2x4x2 cpus), I hit BUG_ON() in
> fs/namei.c:1461 on my kernel build (make -j16)
> 
> BUG_ON(inode != next.dentry->d_inode)
> 
> I do have DEBUG_PAGEALLOC and LOCKDEP on
> 
> 

Since I hit this BUG_ON() even on boot, I spent some time tracking it.

I bisected the problem to commit 844a391799c25d9b
(nothing in do_follow_link() is going to see RCU)

Reverting this commit makes my machine happy again.

My filesystems are ext3

# mount
/dev/sda2 on / type ext3 (rw)
none on /proc type proc (rw)
none on /sys type sysfs (rw)
none on /dev/pts type devpts (rw,gid=5,mode=620)
usbfs on /proc/bus/usb type usbfs (rw)
/dev/sda6 on /appli type ext3 (rw)
/dev/sda1 on /boot type ext3 (rw)
none on /dev/shm type tmpfs (rw)
/dev/sda7 on /opt type ext3 (rw)
/dev/sda3 on /var type ext3 (rw)
none on /sys/kernel/debug type debugfs (rw)
none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)


