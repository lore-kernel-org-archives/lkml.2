Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab0EDLUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 07:20:19 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:62684 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757204Ab0EDLUR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 07:20:17 -0400
X-AuditID: 12074424-b7b9dae000002832-89-4be002f056d6
Subject: Re: Flash IO slow 1.5 MB/s
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <n2i9b1675091005032052wd935041ew5d96f145309af801@mail.gmail.com>
Date: Tue, 4 May 2010 07:20:14 -0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <DCA014BF-2D7C-438B-8191-D8C525A8613B@mit.edu>
References: <n2i9b1675091005032052wd935041ew5d96f145309af801@mail.gmail.com>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
X-Mailer: Apple Mail (2.1078)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 3, 2010, at 11:52 PM, Trenton D. Adams wrote:
> If I mount my usb key with "sync" option, I get 500kb or less transfer
> speeds.  If I use the gnome defaults, I get 60M+ for awhile, and then
> it continually drops over time, down to the 500kb/s again.  Gnome
> defaults are...
> 
> /dev/sdc1 on /media/FLASH type vfat
> (rw,nosuid,nodev,noatime,uhelper=hal,shortname=lower,flush,uid=500)
> 
> I have done similar tests on both Rally2 64G usb stick and sandisk
> ultra (15M/s) SDHC 8G cards.  I get lousy performance on both, unless
> I set dirty bytes.  These are both FAT 32.  But, as you can see below,
> 14 minutes to transfer less than a couple gigs is a little nutty.  The
> 3 minutes is a lot nicer.  I am using 2.6.33 with a patch from
> https://bugzilla.kernel.org/show_bug.cgi?id=15374
> 
> It really looks like there's a scheduling issue.  It seems as if the
> system is IO thrashing on the flash drive, and bounces all over the
> place in terms of performance.  Sometimes it's really low, like the
> 2.73M/s, and other times it's really fast, like the 28.86M/s.
> Although you can't see it there, there were times when rsync was
> registering 200kb/s.  None of them are "really" accurate, as
> everything is queued for writing, but the final results of 1.5M/s
> (calculated from the "real" time) is terrible.
> 
> I have not seen this bad of performance on a normal USB drive, but
> only on my USB flash drive, which is FAT32.  In addition, Windows and
> Mac systems transfer easily 9M/s write speeds on my rally 2.
> 
> If I do the following...
>          echo 16000000 > /proc/sys/vm/dirty_bytes
> the performance is 9-12M/s all the way through the transfer....

Very interesting.  How much memory do you have?  (The core tuning parameter is dirty_ratio, which defaults to 20):

dirty_bytes:  Contains the amount of dirty memory at which a process generating disk writes will itself start writeback.  If dirty_bytes is written, dirty_ratio becomes a function of its value (dirty_bytes / the amount of dirtyable system memory). 

dirty_ratio:  Contains, as a percentage of total system memory, the number of pages at which a process which is generating disk writes will itself start writing out dirty data.

Or put another way, what is dirty_ratio after you set dirty_bytes to 16000000?

Something else that would be very interesting is blktrace runs with and without dirty_bytes set to 16000000. 

Also, what was the average size of the files which you were writing out with that rsync command?  Were they all avi files that were tens of megabytes?   Hundreds of megabytes?

It does sound like the writeback code is doing something disastrously wrong on USB drives, perhaps interacting with the fat fs code.

-- Ted


