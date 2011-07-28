Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab1G1BVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 21:21:50 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56200 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab1G1BVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 21:21:40 -0400
Message-ID: <4E30B9CE.4010800@gmail.com>
Date: Wed, 27 Jul 2011 18:22:22 -0700
From: William King <quentusrex@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Seagate harddrives problems with SB7x0 AHCI
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem:
I have run into what appears to be a driver problem with the Seagate 
Barracuda 7200.12 drives. The symptom is io load of 10-15 times the load 
for other drives. To the point the box becomes fully io-bound and 
unresponsive when even installing apt packages or rsync of a 100MB file.

Background:
I have two servers with nearly identical hardware: Alpha has Seagate 
Barracuda 7200.12 1TB drives model: ST31000528AS and Bravo that has 
Western Digital Cavaliar Black 1TB model: 'WDC WD1001FALS-0'. Both 
servers have Ubuntu 11.04 64bit server installed, and have fully updated 
to the 2.3.38-10 kernel. More hardware info and logs can be located 
here: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/815540

The server hardware manufacturer page is:
http://www.supermicro.com/Aplus/system/1U/1042/AS-1042G-TF.cfm

Command outputs:
# lspci |grep SATA
00:11.0 SATA controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 SATA 
Controller [AHCI mode]

# uname -a
Linux alpha-mule 2.6.38-10-server #46-Ubuntu SMP Tue Jun 28 16:31:00 UTC 
2011 x86_64 x86_64 x86_64 GNU/Linux


Steps to confirm/reproduce and narrow scope:
I have taken the hard drives from Bravo, put them into Alpha reinstalled 
and there is no problem. Also I have placed some older Seagate Barracuda 
7200.9 80GB drives in Alpha and the problem does not exist then either. 
I used iotop and iostats to watch the reported io load as well as the 
read/write speeds to the disk. I then used rsync with a bandwidth 
limitation to measure the performance difference between the two servers 
in terms of server load and iotop reported IO%.

A cat of /proc/interrupts show an order of magnitude more interrupts for 
ahci on Alpha than Bravo for the same amount of traffic during an rsync.

I have hdparm -t /dev/sda test and have seen a performance of ~50MB/s on 
the Seagate 7200.12 drive while the specs and other benchmarks claim 
speeds of up to 140MB/s. The Western Digital in the same hardware are 
able to reach speeds of ~105MB/s and the Seagate 7200.9 gets ~65MB/s. 
The hard drive was not in use at the time of the hdparm test.

I took a perf capture of a fio random read test on each machines. The 
test completes in 4 seconds on Alpha and 2 minutes 45 seconds on Bravo 
and the perf stats show all the extra time being spent in the kernel 
scheduler section.

I initially had the Seagate hard drives on firmware CC46 then updated 
them to the latest firmware of CC49. No change detected between firmwares.

I have setup alpha to be able to rebuild the Ubuntu Kernel with patches 
so I can easily test new changes. Also I have the linux kernel git tree 
cloned so while it would be possible, I would be more comfortable 
testing on the Ubuntu version of the 2.6.38-10 kernel.

-William King
