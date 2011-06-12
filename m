Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab1FLVPz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 17:15:55 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:59527 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1FLVPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 17:15:54 -0400
X-Greylist: delayed 1458 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Jun 2011 17:15:53 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <anton@tuxera.com>
In-Reply-To: <20110611023947.GA9824@kroah.com>
Date: Sun, 12 Jun 2011 21:51:29 +0100
Cc: Miklos Szeredi <mszeredi@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, NeilBrown <neilb@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nbd@openwrt.org, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu
Content-Transfer-Encoding: 8BIT
Message-Id: <748B1AA7-6E40-4610-8FDF-4F49AB4226BE@tuxera.com>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <20110608153208.dc705cda.akpm@linux-foundation.org> <20110609115934.3c53f78f@notabene.brown> <20110608205233.ebfedc4d.akpm@linux-foundation.org> <20110609134947.GD13242@shadowen.org> <20110609123220.6afb9d0f.akpm@linux-foundation.org> <BANLkTimTyYp1P4qd8awvsq6PVZn1TQ5A-Q@mail.gmail.com> <1307650642.9874.10.camel@tucsk.pomaz.szeredi.hu> <EE48B29B-EC3F-44D7-9A39-07F6EA138AC4@cam.ac.uk> <20110611023947.GA9824@kroah.com>
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 11 Jun 2011, at 03:39, Greg KH wrote:
> On Thu, Jun 09, 2011 at 11:58:37PM +0100, Anton Altaparmakov wrote:
>>> NTFS has been doing nicely in userspace for almost half a decade.  It's
>>> not as fast as a kernel driver _could_ be, but it's faster than _the_
>>> kernel driver.
>> 
>> Er, sorry to disappoint but the Tuxera NTFS kernel driver is faster
>> than any user space NTFS driver could ever be.  It is faster than
>> ext3/4, too.  (-:  To give you a random example on an embedded system
>> (800MHz, 512MB RAM, 64kiB write buffer size) where NTFS in user space
>> achieves a maximum cached write throughput of ~15MiB/s, ext3 achieves
>> ~75MiB/s, ext4 ~100MiB/s and Tuxera NTFS kernel driver achieves
>> ~190MiB/s blowing ext4 out of the water by almost a factor of 2 and
>> the user space code by more than a factor of 10.  File systems in user
>> space have their applications but high performance is definitely not
>> one of them...  You might say that ext3/4 are journalling so not a
>> fair comparison so let me add that FAT32 achieves about 100MiB/s in
>> the same hardware/test, still about half of NTFS.
> 
> Talk to Tuxera,

Look at my email address.  (-;

> they have a new version of their userspace FUSE version
> that is _much_ faster than their public one, and it might be almost as
> fast as their in-kernel version for some streaming loads (where caching
> isn't necessary or needed.)

That was some time ago (before Christmas) though I admit the numbers I quoted might well be from the opensource ntfs-3g (not sure, I didn't run the tests myself).  The in-kernel driver has since taken the lead since I implemented delayed metadata updates.  That is why the in-kernel Tuxera NTFS driver now outperforms all other file systems that have been tested (whether in kernel or in user space including ext*, XFS and FAT).  The only file system approaching Tuxera (kernel) NTFS is Tuxera (kernel) exFAT which I also wrote and where I first developed the delayed metadata write idea.  (-:

I can't wait to have the time at some point to implement delayed allocation as well and then NTFS will perhaps become the fastest file system driver on the planet if it isn't already...  (-:

But yes if you confine yourself to a single i/o stream with large i/os, with only one process doing it, and you use direct i/o obviously just about any optimized file system can achieve close to the actual device speed, no matter whether in kernel or in user space.  However the CPU utilization varies dramatically.  In kernel you easily get as little as 3-10% or even less whilst in user space you end up with much higher CPU utilization and on embedded hardware this sometimes goes to 100% CPU and the i/os are sometimes even CPU limited rather than device speed limited.  But I think it is more useful when talking about speed not to limit oneself to only a single use case and then user space file systems suffer in comparison to in-kernel ones.

On embedded the kernel driver is sometimes further optimized with custom kernel/hardware based optimizations.  For example for some embedded chipsets vendor has modified the kernel so that, in combination with a modified file system (I had to adapt NTFS to the kernel changes) data is received from the network directly into the page cache pages of the file (using splice of the network socket to the target file but with a lot of vendor chipset voodoo so if I understand it correctly the network card is directly doing DMA into the mapped page cache pages).  I cannot even begin to imagine what hoops you would have to jump through in a user space file system to pull off such tricks if it is even possible at all...

Best regards,

	Anton

> So it can be done, and done well, if you know what you are doing :)
> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

