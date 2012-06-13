Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab2FMWjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:39:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457Ab2FMWi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:38:59 -0400
Date: Thu, 14 Jun 2012 00:38:51 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Wallak <wallak@free.fr>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: File copy is very slow on linux-3.4.2 (or linux-3.3x) on a
 specific hardware: AMD FX-8150 + 990FX (solved?)
Message-ID: <20120613223851.GA17060@redhat.com>
References: <1108815600.134531433.1339443818361.JavaMail.root@zimbra44-e7.priv.proxad.net>
 <437497008.134549481.1339444456294.JavaMail.root@zimbra44-e7.priv.proxad.net>
 <20120612165357.GI6021@quack.suse.cz>
 <4FD78CE4.4000209@free.fr>
 <20120612210947.GB20007@quack.suse.cz>
 <4FD7C595.202@free.fr>
 <20120613065313.GA25425@quack.suse.cz>
 <4FD8F9F1.2000205@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD8F9F1.2000205@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 10:37:05PM +0200, Wallak wrote:
> Jan Kara wrote:
> >On Wed 13-06-12 00:41:25, Wallak wrote:
> >>Jan Kara wrote:
> >>>On Tue 12-06-12 20:39:32, Wallak wrote:
> >>>>Jan Kara wrote:
> >>>>>On Mon 11-06-12 21:54:16, wallak@free.fr wrote:
> >>>>>>I've a very annoying issue on recent kernel (linux-3.4.2-SMP) with my main motherboard (AMD FX-8150 + 990FX - 8 cores 4.1GHz), file copy is very slow (see below). The same kernel works flawlessly on an AMD E450 2 cores motherboard.
> >>>>>>
> >>>>>>Linux-3.2.20 works properly on this hardware.
> >>>>>>hdparm -t gives good results on both kernels.
> >>>>>>
> >>>>>>I've no idea where this bug come from. Do you have this issue on your hardware ? A patch is available ?
> >>>>>>
> >>>>>>
> >>>>>>*linux-3.4.2
> >>>>>>dd if=../in/file_8gb.tmp of=tmp.tmp bs=1024k count=100
> >>>>>>100+0 records in
> >>>>>>100+0 records out
> >>>>>>104857600 bytes (105 MB) copied, 132.884 s, 789 kB/s
> >>>>>>
> >>>>>>
> >>>>>>*linux-3.2.20
> >>>>>>dd if=../in/file_8gb.tmp of=tmp.tmp bs=1024k count=100
> >>>>>>100+0 records in
> >>>>>>100+0 records out
> >>>>>>104857600 bytes (105 MB) copied, 3.30793 s, 31.7 MB/s
> >>>>>   So let's separate reading and writing part first. What is the speed of
> >>>>>dd if=../in/file_8gb.tmp of=/dev/null bs=1M count=100
> >>>>>   on both kernels?
> >>>>>And what is the speed of:
> >>>>>dd if=/dev/zero of=tmp.tm bs=1M count=100
> >>>>You're right, the issue is only while writing. The results are below:
> >>>>
> >>>>#linux-3.4.2
> >>>>dd if=/dev/zero of=tmp.tm bs=1M count=100
> >>>>100+0 records in
> >>>>100+0 records out
> >>>>104857600 bytes (105 MB) copied, 151.347 s, 693 kB/s
> >>>>dd if=../in/file_8gb.tmp of=/dev/null bs=1M count=100
> >>>>100+0 records in
> >>>>100+0 records out
> >>>>104857600 bytes (105 MB) copied, 1.26228 s, 83.1 MB/s
> >>>>
> >>>>#linux-3.2.20
> >>>>dd if=/dev/zero of=tmp.tm bs=1M count=100
> >>>>100+0 records in
> >>>>100+0 records out
> >>>>104857600 bytes (105 MB) copied, 1.00838 s, 104 MB/s
> >>>>dd if=../in/file_8gb.tmp of=/dev/null bs=1M count=100
> >>>>100+0 records in
> >>>>100+0 records out
> >>>>104857600 bytes (105 MB) copied, 1.26947 s, 82.6 MB/s
> >>>>
> >>>>
> >>>>>   Also what filesystems are you using?
> >>>>This is an ext2 file system:
> >>>>
> >>>>/dev/sda6      ext2    464463364 323380956 141082408  70% /backup
> >>>   OK, I'm surprised by one thing - how come the writes do no end up cached
> >>>in memory (thus you should get much higher throughput). Is the filesystem
> >>>mounted with -o sync option by any chance?
> >>>
> >>>								Honza
> >>     I've tried with an nfs mounted drive, the issue is still there,
> >>it seems to be global. With sync enabled, the output is quite
> >>faster, that's quite unexpected.
> >>On my AMD E450 motherboard this kernel works fine - Are you able to
> >>reproduce this behavior ?
> >>
> >>
> >>#/dev/sda6 /backup ext2 rw,relatime,errors=continue 0 0
> >>(/proc/mount)
> >>100+0 records in
> >>100+0 records out
> >>104857600 bytes (105 MB) copied, 155.407 s, 675 kB/s
> >>
> >>#/dev/sda6 /backup ext2 rw,sync,relatime,errors=continue 0 0
> >>100+0 records in
> >>100+0 records out
> >>104857600 bytes (105 MB) copied, 69.7868 s, 1.5 MB/s
> >>
> >>#nfs drive - same issue:
> >>100+0 records in
> >>100+0 records out
> >>104857600 bytes (105 MB) copied, 221.572 s, 473 kB/s
> >   That's really curious. I have not seen your issue although I use current
> >kernels for development&  testing a lot. Also if it was some generic issue
> >with 3.4 I'm pretty sure we would have heard *much* more complaints from
> >other users as well. So I think it must be something specific to your setup
> >/ kernel config.
> 
> I've bisected the linux kernel, and I've found the commit that is
> related to this issue:
> commit ab8fabd46f811d5153d8a0cd2fac9a0d41fb593d
> Author: Johannes Weiner <jweiner@redhat.com>
> Date:   Tue Jan 10 15:07:42 2012 -0800
> 
>     mm: exclude reserved pages from dirtyable memory

Thanks for the bisect, this makes sense.

> HighTotal:       8052692 kB
> HighTotal:       8052692 kB
> HighFree:        7978664 kB                                   |
> HighFree:        6227412 kB
> LowTotal:         229508 kB
> LowTotal:         229508 kB
> LowFree:          195804 kB                                   |
> LowFree:          148948 kB

224M total lowmem with 8G highmem.  Sigh.  Even without this patch,
the standard dirty ratios would grant you only 29MB of dirty pages.
Subtracting the dirty reserves will take the rest.

You can make highmem dirtyable by setting

	sysctl vm.highmem_is_dirtyable=1

But this will make the number of dirtyable pages very high compared to
your lowmem.

I wonder if it would be best to just enforce a minimum amount of
dirtyable memory.  A percentage of lowmem or so to keep it from
expanding with highmem.
