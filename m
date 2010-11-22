Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab0KVQyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:54:47 -0500
Received: from bgs.hu ([195.70.62.77]:42663 "HELO mail.bgs.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750790Ab0KVQyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:54:46 -0500
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Nov 2010 11:54:45 EST
Message-ID: <4CEA9EB1.4000209@bgs.hu>
Date: Mon, 22 Nov 2010 17:47:45 +0100
From: Bgs <bgs@bgs.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101106 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Apparent non-sync related to CF+(u)mount
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Greetings,

I've ran into a strange problem that (to me) seems to be around the kernel.

Nutshell description: when using CF (compact flash) remount read-only 
does not flush to the card, only umount does.

Detailed description:

I have a lot of systems that boot from CF cards. Been doing that for 
years. Most of the system is on read-only mounted partitions. I have 
integrity checks based on the hash of the read-only partitions. The 
problem I ran into comes when I update the system. What I expect is that 
after 'remount read-write' -> update -> 'remount read-only' (-> and a 
safety sync, practice from old-old times), the hash should be stable for 
the partition. What I found is that after reboot the hash changes and 
becomes stable from there. I tracked the change down to the umounting on 
a CF card.

So here is the 'hash history':

Before mount: old hash
After mount read-only: old hash
After update+remount read-only: new intermittent hash
After umount (or reboot for a system): new hash

I did several tests with:
- HDD
- Loopback device
- CF on ATA
- CF on USB reader
- USB flash drive
- Different CF manufacturers and products
- Different filesystems (xfs, ext3, vfat)
- Different kernels (and even distros)
- Sync()
- Waiting times after remount

The only combination that manifests the effect is any that has CF and 
change only happens at umount.

Tests were made at least on the following kernel versions:
- 2.6.32-24-generic, 32 bit (Ubuntu 10.04LTS)
- 2.6.33, 64 bit (Vanilla, Slackware current)
- 2.6.35.22, 64 bit (Ubuntu 10.10)

It's 100% reproducible.

There is either some badly cached, unwritten data somewhere ('badly' 
means that reading back from the device should give the right data 
regardless of it being written out or not). It's not (just) inode 
related or alike as I found from the following test:

Made a 200MB partition and used a 10MB random data written to a file as 
'update'. I did a dd copy of the partition after the partition was 
remounted read-only and after umount. Doing a cmp on the two images gave 
me a bit over 10MB of difference. This was more or less expected as I 
noticed that umounting after update always takes time while with non-CF 
media only the remount does.

It might or might not be related, but the first differing byte is at 
48kiB+1.

Any ideas where the problem lies? As the behavior itself is out of 
ordinary I tried to make various tests but I may have missed some still.

Regards
Bgs


