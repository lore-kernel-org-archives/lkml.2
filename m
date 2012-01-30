Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab2A3O0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:26:38 -0500
Received: from firewall1.hosting.leiceps.dk ([188.180.106.28]:48939 "EHLO
	firewall1.hosting.leiceps.dk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752099Ab2A3O0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:26:36 -0500
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jan 2012 09:26:36 EST
X-AuditID: 0ac700ea-b7f3d6d000000d21-2c-4f26a5a41d09
Message-ID: <4F26A70D.2040901@leiceps.dk>
Date: Mon, 30 Jan 2012 15:19:57 +0100
From: Lars Karlslund <lars@leiceps.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120119 Thunderbird/10.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: Possible mpt2sas 4k sector bug
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsXCdZxBUnfJUjV/g1mzdC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG74+32Ar6zCu616xiaWBcotzFyMkhIWAicbDrMiuELSZx4d56
	ti5GLg4hgflMEud3fWQESQgJLGKU6J7rCGLzCmhK/HvUxAZiswioSmxccRHIZudgE1CTOKfe
	xcjBISoQIvG50QqiWFDi5MwnLCC2iICSxPdr3WADhQXUJVp7rzGD2MwCthIX5lxngbDlJba/
	ncMMsVRGYtHBG4wTGPlmIRk1C0nLLCQtCxiZVzHy5lbo5aRmJqcWFOulZG9ihITOqx2MmzsM
	DjEKcDAq8fAG/FP1F2JNLCuuzD3EKMHBrCTCqz9HzV+INyWxsiq1KD++qDQntfgQIxMHp1QD
	46LXKQk951denmVis0RcMzF7XlzU4c+uBq8Wlz/WZJzGf/r1nL5dos26V86xp+2edd5L+GMT
	z4LVO/V/x33gWxeTdaV7S3HNg8lSK4PfST9cm8uRM8fr6X2v+B1KsgVcPPNqjq+xvpRpX/dm
	/ZKS2wnZreczVaJuPVPjPhlv++Djf4aH7/7ZtSmxFGckGmoxFxUnAgAlRhGY+wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have assembled a system with a LSI 9116i controller (aka 9201-16i), 
and have hit a weird problem with basic disk-access.

Doing writes with anything lower than 4k block size, generates lots of 
reads on the drives.

These are the system details, basically it's an Ubuntu 11.10 64-bit with 
latest updates.

System is on SSD drive on onboard SATA controller (sda).
8 x 1TB drives with 512bytes sector size on LSI controller (sdb to sdi)
1 x 750GB drive with 512bytes sector size also on LSI controller (sdj - 
just to verify that it's not the model of drives that are the problem)

Problem is, doing everything but 4k+ writes on the drives, generates 
massive reads from the drives, before doing the actual writes.

# dd if=/dev/zero of=/dev/sdb bs=512 count=1000000
1000000+0 records in
1000000+0 records out
512000000 bytes (512 MB) copied, 21.5398 s, 23.8 MB/s

dstat output while doing this:

# dstat -Dsdb
You did not select any stats, using -cdngy by default.
----total-cpu-usage---- --dsk/sdb-- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
   0   0 100   0   0   0|1592B 1590B|   0     0 |   0     0 |  59    97
   0   0 100   0   0   0|   0     0 | 330B  836B|   0     0 | 121   149
   0   0 100   0   0   0|   0     0 | 540B 2750B|   0     0 |  70   118
   0   1  88  10   0   0|  31M    0 | 497B  114B|   0     0 |8057    24k
   0   1  88  11   0   0|  32M    0 |1212B   19k|   0     0 |8268    24k
   0   1  88  11   0   0|  32M    0 | 151B  322B|   0     0 |8235    24k
   0   2  88  11   0   0|  32M    0 | 151B  322B|   0     0 |8219    25k
   0   1  88  11   0   0|  32M    0 | 186B  322B|   0     0 |8219    24k
   0   1  88  11   0   0|  32M    0 | 271B  322B|   0     0 |8225    24k
   0   2  88  11   0   0|  32M    0 | 126B  322B|   0     0 |8202    24k
   0   1  88  11   0   0|  32M    0 | 271B  322B|   0     0 |8179    24k
   0   1  88  11   0   0|  32M    0 | 211B  322B|   0     0 |8229    25k
   0   1  88  11   0   0|  32M    0 |  66B  322B|   0     0 |8208    24k
   0   1  88  11   0   0|  32M    0 | 151B  322B|   0     0 |8201    24k
   0   1  88  11   0   0|  32M    0 |  66B  322B|   0     0 |8217    24k
   0   1  86  13   0   0|  11M   57M| 653B  322B|   0     0 |3119  8828
   0   1  88  12   0   0|2576k   76M| 149B  338B|   0     0 | 874  2061
   0   1  88  12   0   0|  14M   39M|  66B  338B|   0     0 |3853    11k
   0   1  88  11   0   0|  15M   47M| 149B  338B|   0     0 |3912    11k
   0   1  88  12   0   0|5832k   64M|  66B  338B|   0     0 |1664  4507
   0   0  88  12   0   0|2792k   72M| 390B  494B|   0     0 | 946  2253
   0   1  88  11   0   0|  21M   22M| 150B  322B|   0     0 |5463    16k
   0   1  88  11   0   0|  13M   47M| 360B 2570B|   0     0 |3521    10k
   0   2  87  11   0   0|  24M   26M| 906B   15k|   0     0 |6487    19k
   0   1  92   7   0   0| 336k   41M|  66B  338B|   0     0 | 805   929
   0   0 100   0   0   0|   0     0 | 616B 2618B|   0     0 |  62    96
   0   0 100   0   0   0|   0     0 |1085B   14k|   0     0 |  87   144
   0   0 100   0   0   0|   0     0 |  66B  306B|   0     0 |  44    71
   0   0 100   0   0   0|   0     0 | 329B  486B|   0     0 |  89   134
   0   0 100   0   0   0|   0     0 |  66B  306B|   0     0 |  67   111
   0   0 100   0   0   0|   0     0 | 149B  306B|   0     0 |  61   106

I.e. lots of reads before the writes??

Doing dd with bs=4k fixes this, giving expected behaviour:

# dd if=/dev/zero of=/dev/sdb bs=4k count=125000
125000+0 records in
125000+0 records out
512000000 bytes (512 MB) copied, 6.16785 s, 83.0 MB/s

And dstat output while doing this:

# dstat -Dsdb
You did not select any stats, using -cdngy by default.
----total-cpu-usage---- --dsk/sdb-- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
   0   0 100   0   0   0|3180B 3177B|   0     0 |   0     0 |  59    98
   0   0 100   0   0   0|   0     0 | 508B 3098B|   0     0 | 158   173
   0   3  94   2   0   0|   0    15M| 262B  114B|   0     0 | 320   242
   0   0  86  14   0   0|   0    82M|   0     0 |   0     0 | 239   146
   0   0  88  12   0   0|   0    83M| 772B   10k|   0     0 | 261   141
   0   0  87  12   0   0|   0    83M| 239B  322B|   0     0 | 258   150
   0   0  88  12   0   0|   0    83M| 210B  322B|   0     0 | 252   123
   0   0  88  12   0   0|   0    81M| 210B  322B|   0     0 | 229   164
   0   1  88  11   0   0| 336k   62M| 186B  322B|   0     0 | 521   843
   0   0 100   0   0   0|   0     0 | 210B  338B|   0     0 | 252   206
   0   0 100   0   0   0|   0     0 | 540B 2780B|   0     0 |  79   128
   0   0 100   0   0   0|   0     0 | 643B   10k|   0     0 |  71   117

Details of system:

# lspci | grep LSI
05:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic 
SAS2116 PCI-Express Fusion-MPT SAS-2 [Meteor] (rev 02)

# uname -a
Linux storage-ng 3.2.2-030202-generic #201201252035 SMP Thu Jan 26 
01:36:10 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

(also tested with 3.0.0-15server)

# fdisk /dev/sdb
Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x39411ba9

Controller firmware upgraded from 7 (version on board when I got it), to 
12, verified with dmesg:
# dmesg | grep mpt2sas
[    3.122653] mpt2sas version 10.100.00.00 loaded
[    3.123197] mpt2sas 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> 
IRQ 16
[    3.123218] mpt2sas 0000:05:00.0: setting latency timer to 64
[    3.123225] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total 
mem (8176204 kB)
[    3.123303] mpt2sas 0000:05:00.0: irq 46 for MSI/MSI-X
[    3.123320] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 46
[    3.123329] mpt2sas0: iomem(0x00000000f8ffc000), 
mapped(0xffffc900117b8000), size(16384)
[    3.123338] mpt2sas0: ioport(0x000000000000e000), size(256)
[    3.409371] mpt2sas0: sending message unit reset !!
[    3.417363] mpt2sas0: message unit reset: SUCCESS
[    3.585191] mpt2sas0: Allocated physical memory: size(15199 kB)
[    3.585203] mpt2sas0: Current Controller Queue Depth(7385), Max 
Controller Queue Depth(7632)
[    3.585209] mpt2sas0: Scatter Gather Elements per IO(128)
[    3.817976] mpt2sas0: LSISAS2116: FWVersion(12.00.00.00), 
ChipRevision(0x02), BiosVersion(07.23.01.00)
[    3.817991] mpt2sas0: Protocol=(Initiator,Target), 
Capabilities=(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
[    3.818250] mpt2sas0: sending port enable !!
[    3.823717] mpt2sas0: host_add: handle(0x0001), 
sas_addr(0x500062b2000c3600), phys(16)
[    3.833476] mpt2sas0: port enable: SUCCESS

So now I'm stuck ... any ideas?

Please cc to my mail, as I am not subscribed here.


Thanks,

Lars Karlslund

