Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1EXHd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:33:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62652 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab1EXHdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:33:55 -0400
Message-ID: <4DDB5F60.1080703@petalogix.com>
Date: Tue, 24 May 2011 09:33:52 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
CC: LKML <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, John Williams <john.williams@petalogix.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Thomas Chou <thomas@wytron.com.tw>
Subject: Re: Unaligned jffs2 dnode address - tested by nandsim
References: <4DD5022C.9060205@petalogix.com>
In-Reply-To: <4DD5022C.9060205@petalogix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Any update on this? Does someone know if jffs dnode should be aligned or not?
I have added some developers from mtd-utils.

I have also done test with the latest mtd-utils from git and there is still 
unaligned address.

Any suggestions?

Thanks,
Michal

BTW: I have fixed problem with unaligned access in the kernel but I think the 
problem is mainly in fs generation.

Michal Simek wrote:
> Hi,
> 
> I have reached one problem with jffs2 fs ecc tested by nandsim on 
> Microblaze.
> 
> I am getting the fault like this.
> # md5sum /mnt/delete.png
> uncorrectable error :
> uncorrectable error :
> uncorrectable error :
> uncorrectable error :
> uncorrectable error :
> mtd->read(0xcda bytes from 0xc044) returned ECC error
> Data CRC 3bcfd461 != calculated CRC e6038cde for node at 0000c000
> uncorrectable error :
> uncorrectable error :
> uncorrectable error :
> uncorrectable error :
> uncorrectable error :
> mtd->read(0xcda bytes from 0xc044) returned ECC error
> Data CRC 3bcfd461 != calculated CRC e6038cde for node at 0000c000
> 
> 
> The main problem is that there is one address with is not aligned which 
> caused that ecc counting uses wrong data.
> 
> I also found in nand_ecc code that there is written
> "It is assumed that the buffers are aligned." which is definitely wrong 
> for my case. I expect that it is 4B alignment.
> 
> I generated jffs2 filesystem by the following command (mkfs.jffs2 
> revision 1.60)
> mkfs.jffs2 -n -b -e 16KiB -t -d <folder> -o test.jffs2
> 
> test.jffs2 is also attached.
> 
> I use these command to mounted:
> flash_eraseall /dev/mtd0
> nandwrite -p /dev/mtd0 /var/ftp/test.jffs2
> mount -t jffs2 mtd:"NAND simulator partition 0" /mnt
> 
> After enable some jffs2 debug message I have got the log.
> 
> [JFFS2 DBG] (74) jffs2_add_tn_to_tree: insert fragment 0x00-0x1000, ver 
> 1 at 00000900
> [JFFS2 DBG] (74) jffs2_lookup_tn: root c0c37df8, offset 0
> [JFFS2 DBG] (74) jffs2_add_tn_to_tree: 'this' found 0x1000-0x2000 (data)
> [JFFS2 DBG] (74) jffs2_add_tn_to_tree: Ponder this ver 2, 0x1000-0x1000
> [JFFS2 DBG] (74) read_dnode: After adding ver 1:
> [JFFS2 DBG] (74) read_dnode: c78432c0: v 1 r 0x0-0x1000 ov 0
> [JFFS2 DBG] (74) read_dnode: c78432e0: v 2 r 0x1000-0x2000 ov 0
> [JFFS2 DBG] (74) read_dnode: c7843300: v 3 r 0x2000-0x3000 ov 0
> [JFFS2 DBG] (74) read_dnode: c7843320: v 4 r 0x3000-0x364a ov 0
> [JFFS2 DBG] (74) read_dnode: c7843340: v 5 r 0x364a-0x4000 ov 0
> [JFFS2 DBG] (74) read_dnode: c7843360: v 6 r 0x4000-0x5000 ov 0
> [JFFS2 DBG] (74) read_dnode: c7843380: v 7 r 0x5000-0x6000 ov 0
> [JFFS2 DBG] (74) read_dnode: c78433a0: v 8 r 0x6000-0x7000 ov 0
> [JFFS2 DBG] (74) read_dnode: c78433c0: v 9 r 0x7000-0x7316 ov 0
> 
> 
> You see that tn->fn->ofs which is 0x364a which is not aligned. This 
> offset is causing
> 
> I also tried to disable zlib compression which caused that map has 
> changed and it is aligned and there is no problem with ECC computing.
> mkfs.jffs2 -n -b -e 16KiB -t -d <folder> -o test-nozlib.jffs2 -x zlib
> 
> Have you ever seen this fault with alignment?
> I think that the problem is with test.jffs2 generation.
> Is there any option to setup that everything is aligned?
> Or are you aware about any workaround how to prevent this fault?
> 
> I do some testing directly on Microblaze. Generate random files and test 
> them and I haven't seen any problem when target read/write data from 
> jffs2 on nand with ecc. The problem is only with test.jffs2 generated on 
> host I see this fault.
> 
> Thanks,
> Michal
> 


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
