Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0KITxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:53:45 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55111 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab0KITxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:53:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uLcoWU/22sqHtFj+5MgV0D7Rn9FGJ8u0RmjWBrB2LsF2mcqdG06Zf1/M0MZbvRMzjj
         b8e3cUKaZUC8cd/GRGxuwCYoZbzNyKte3g2L9KQAhAuki+DGZBnWXY9o8IOROlKuO/Co
         kqdC59c7Fy70LGP9l0ViIkBYb0KNBhE6KhAtA=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1011071753560.26056@swampdragon.chaosbits.net>
References: <AANLkTikRKVBzO=ruy=JDmBF28NiUdJmAqb4-1VhK0QBX@mail.gmail.com>
	<AANLkTinzJ9a+9w7G5X0uZpX2o-L8E6XW98VFKoF1R_-S@mail.gmail.com>
	<AANLkTinDDG0ZkNFJZXuV9k3nJgueUW=ph8AuHgyeAXji@mail.gmail.com>
	<AANLkTikvSGNE7uGn5p0tfJNg4Hz5WRmLRC8cXu7+GhMk@mail.gmail.com>
	<20101028090002.GA12446@elte.hu>
	<AANLkTinoGGLTN2JRwjJtF6Ra5auZVg+VSa=TyrtAkDor@mail.gmail.com>
	<20101028133036.GA30565@elte.hu>
	<20101028170132.GY27796@think>
	<alpine.LNX.2.00.1011050032440.16015@swampdragon.chaosbits.net>
	<alpine.LNX.2.00.1011050047220.16015@swampdragon.chaosbits.net>
	<20101105014334.GF13830@dastard>
	<alpine.LNX.2.00.1011071753560.26056@swampdragon.chaosbits.net>
Date: Tue, 9 Nov 2010 22:47:38 +0300
Message-ID: <AANLkTinZCBs_JO0Ug58uJdWEuqx=xzzBn2nJzdYr7+hb@mail.gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
From: Evgeniy Ivanov <lolkaantimat@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ted Ts'o" <tytso@mit.edu>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Sanjoy Mahajan <sanjoy@olin.edu>,
        Steven Barrett <damentz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have almost same problem (system is less interactive, but no freeze happens).
Here are tests I use (written by Alexander Nekrasov):
logrotate.sh (hard writer): http://pastebin.com/PPnSvP2f
writetest (small writer): http://pastebin.com/616JvWEK

If you run "writetest 15 realtime" timings will be OK, but if you also
run "logrotate.sh 300 3" you will see that RT processes start trashing
(timings periodically increase from 50ms to 2000-4000ms).
I do tests on 2.6.31, but same happens on 2.6.36. CFQ with default
settings is used. I've played with page-background.c and noticed, that
writeback still works for RT processes (no write through/disk wait). I
even tried to increase dirty_ratio for RT processes. Also I've limited
memory consumed by dd (logrotate.sh), since I had situation when it
consumed too much and kernel started to reclaim pages.

It doesn't want to work on ext3 (compiled and mounted like Linus
suggested in this thread), but works fine on ext4 with
"data=writeback" and on XFS. I'm not sure if it means that problem in
ext3 and in journaling (in case of ext4 without data=writeback).
I'm not sure if "data=writeback" (makes ext4 journaling similar to
XFS) really fixes the problem, probably it increases FS bandwidth, so
we just don't see the problem, but it can still present.

On Sun, Nov 7, 2010 at 8:16 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Fri, 5 Nov 2010, Dave Chinner wrote:
>
>> On Fri, Nov 05, 2010 at 12:48:17AM +0100, Jesper Juhl wrote:
>> > On Fri, 5 Nov 2010, Jesper Juhl wrote:
>> >
>> > > On Thu, 28 Oct 2010, Chris Mason wrote:
>> > >
>> > > > On Thu, Oct 28, 2010 at 03:30:36PM +0200, Ingo Molnar wrote:
>> > > > >
>> > > > > "Many seconds freezes" and slowdowns wont be fixed via the VFS scalability patches
>> > > > > i'm afraid.
>> > > > >
>> > > > > This has the appearance of some really bad IO or VM latency problem. Unfixed and
>> > > > > present in stable kernel versions going from years ago all the way to v2.6.36.
>> > > >
>> > > > Hmmm, the workload you're describing here has two special parts.  First
>> > > > it dramatically overloads the disk, and then it has guis doing things
>> > > > waiting for the disk.
>> > > >
>> > >
>> > > Just want to chime in with a 'me too'.
>> > >
>> > > I see something similar on Arch Linux when doing 'pacman -Syyuv' and there
>> > > are many (as in more than 5-10) updates to apply. While the update is
>> > > running (even if that's all the system is doing) system responsiveness is
>> > > terrible - just starting 'chromium' which is usually instant (at least
>> > > less than 2 sec at worst) can take upwards of 10 seconds and the mouse
>> > > cursor in X starts to jump a bit as well and switching virtual desktops
>> > > noticably lags when redrawing the new desktop if there's a full screen app
>> > > like gimp or OpenOffice open there. This is on a Lenovo Thinkpad R61i
>> > > which has a 'Intel(R) Core(TM)2 Duo CPU T7250 @ 2.00GHz' CPU, 2GB of
>> > > memory and 499996 kilobytes of swap.
>> > >
>> > Forgot to mention the kernel I currently experience this with :
>> >
>> > [jj@dragon ~]$ uname -a
>> > Linux dragon 2.6.35-ARCH #1 SMP PREEMPT Sat Oct 30 21:22:26 CEST 2010 x86_64 Intel(R) Core(TM)2 Duo CPU T7250 @ 2.00GHz GenuineIntel GNU/Linux
>>
>> I think anyone reporting a interactivity problem also needs to
>> indicate what their filesystem is, what mount paramters they are
>> using, what their storage config is, whether barriers are active or
>> not, what elevator they are using, whether one or more of the
>> applications are issuing fsync() or sync() calls, and so on.
>>
> Some details below.
>
> [jj@dragon ~]$ mount
> proc on /proc type proc (rw,relatime)
> sys on /sys type sysfs (rw,relatime)
> udev on /dev type devtmpfs
> (rw,nosuid,relatime,size=10240k,nr_inodes=255749,mode=755)
> /dev/disk/by-uuid/61d104a5-4f7b-40ef-a9c8-44ad2765513e on / type ext4 (rw,commit=0)
> devpts on /dev/pts type devpts (rw)
> shm on /dev/shm type tmpfs (rw,nosuid,nodev)
>
> [root@dragon ~]# hdparm -v /dev/disk/by-uuid/61d104a5-4f7b-40ef-a9c8-44ad2765513e
>
> /dev/disk/by-uuid/61d104a5-4f7b-40ef-a9c8-44ad2765513e:
>  multcount     = 16 (on)
>  IO_support    =  1 (32-bit)
>  readonly      =  0 (off)
>  readahead     = 256 (on)
>  geometry      = 9729/255/63, sectors = 25220160, start = 119644560
>
> [root@dragon ~]# dmesg | grep -i ext4
> EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: (null)
> EXT4-fs (sda4): re-mounted. Opts: (null)
> EXT4-fs (sda4): re-mounted. Opts: (null)
> EXT4-fs (sda4): re-mounted. Opts: commit=0
>
> The elevator in use is CFQ.
>
> The app that's causing the system to behave this way (the 'pacman' package
> manager in Arch Linux) makes a few calls (2-4)  to fsync() during its run,
> but that's all.
>
>
> --
> Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
> Plain text mails only, please      http://www.expita.com/nomime.html
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom policy in Canada: sign http://dissolvethecrtc.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Evgeniy Ivanov
