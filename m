Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab1JHFwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 01:52:25 -0400
Received: from post.russia.ru ([87.242.118.101]:65295 "EHLO post.russia.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab1JHFwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 01:52:24 -0400
Message-ID: <4E8FE4E5.9040606@russia.ru>
Date: Sat, 08 Oct 2011 12:51:33 +0700
From: =?UTF-8?B?0JLQsNC70LXRgNC40Lk=?= <paramonov@russia.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110907 Thunderbird/6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, neilb@suse.de, linux-raid@vger.kernel.org,
        axboe@kernel.dk, duaneg@dghda.com,
        Alexander Beregalov <a.beregalov@gmail.com>
Subject: BUG: spinlock lockup while performing FS operations and detected
 stalls on CPUs / tasks.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SpamTest-Envelope-From: paramonov@russia.ru
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 25568 [Oct 08 2011]
X-SpamTest-Info: {received from trusted sender <paramonov@russia.ru>: common white list}
X-SpamTest-Method: white email list
X-SpamTest-Rate: 0
X-SpamTest-Status: Trusted
X-SpamTest-Status-Extended: trusted
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hy dear.

Next, I wanted to make a backup. Disconnected one drive of RAID because 
I did not have a free power connector. RAID continued to work fine. Then 
connect the other drive, which is defined as /dev/sdd. Then I made it 
XFS, mounted and tried to backup my array. Received this output in 
/var/log/messages:

---
Oct 6 08:03:16 localhost kernel: INFO: rcu_bh_state detected stalls on 
CPUs / tasks: {0 1 2 4} (detected by 5, t = 60 002 jiffies)
Oct 6 08:03:32 localhost kernel: INFO: rcu_preempt_state detected 
stalls on CPUs / tasks: {0 1 2 4} (detected by 5, t = 60 002 jiffies)
---

All stuck on this console, but worked on other alt + Fx. I can enter my 
login, but password not. Magic buttons still work some time, but the 
/var/log/messages is no longer writes. Duane Griffin (bugs.gentoo.org) 
says that I need to try to "sync"->"emergency 
unmount"->"sync"->"reboot". But this is an other things.

Next. I decided to remove the dump directly through



# dd if=/dev/md127 of=/dev/sdd



and so copy both partitions. Again, all hung after few times (about 1-2 
minutes).

Now, I concluded that the problem is not in the file system. And not 
even the hardware. Here's why:

Then do a reset, but often the computer does not restart and I have to 
press and hold the power button to shutdown. Then on again. It's 
strange, but next.

I connect back the third disc, but the raid did not take it back. Then I do:


# mdadm --zero-superblock /dev/sdd1
# mdadm --manage /dev/md0 --add /dev/sdd1


All is ok. ATTENTION! Starts synchronization array. And all done without 
any problems.

# cat /proc/mdstat
---
Personalities : [raid6] [raid5] [raid4] [multipath] [faulty]
md127 : active raid5 sdd1[3] sdb1[0] sdc1[1]
       1465146368 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[3/2] [UU_]
       [===================>.]  recovery = 99.5% (729613632/732573184) 
finish=0.9min speed=51623K/sec

unused devices: <none>
---

# cat /proc/mdstat
---
Personalities : [raid6] [raid5] [raid4] [multipath] [faulty]
md127 : active raid5 sdd1[3] sdb1[0] sdc1[1]
       1465146368 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[3/3] [UUU]

unused devices: <none>
---

Second - SMART system reports that the array disks in order. It's very 
strange! Then I concluded that problem is not in hardware. I would like 
to hear your opinion.

Still have a few thoughts.

1. Also turns off the remaining disks in the array and try to sync again 
to eliminate the problem of disk drives.
2. Try copying between the disks out of the array. But apparently it's 
the same case as the command dd.
3. I have an old IDE disk that monted next lines:

# IDE disk 160Gb
/dev/sde1 /var reiserfs defaults,auto,noatime,nodiratime,notail	0 0
/dev/sde2 /usr/portage reiserfs defaults,auto,noatime,nodiratime,notail	0 0
/dev/sde3 /usr/src reiserfs defaults,auto,noatime,nodiratime,notail	0 0
/dev/sde4 none swap sw 0 0

It's because I have a solid-state drive /dev/sda mounted as root partition.

So, this IDE drive has non-critical SMART errors listed at end of 
message by command smartctl --all /dev/sde. It is unclear how this might 
affect the command dd.


In the next time I did it. And try to sync and emergency unmount to save 
the information in the log. If it does not save, I have to hand copy a 
screen or photograph. Then post the logs and screenshots.

Sorry for my bad english, Google translator to help me.
I want to help and I need your help. Thanks.

-- previous message --

Hi!

Faced with this problem. There are RAID5, assembled by mdadm (/dev/md127),
which is divided into 2 partitions (md127p1 and md127p2). In both 
reiserfs. The
second partition is exported via NFS. Everything works, the array is 
intact and
fully synchronized. SMART says disks are healthy. But when copy too many 
files
all hangs and saves only the reset. After a reset of course runs fsck, 
and then
synchronize the array.

I have a brand new computer. Sleaze is not set. Motherboard gigabyte 
870-UD3,
Power Supply FSP 700W, memory 16Gb Kingston, CPU Phenom II X6 1090T.

I  reported an error  on  bugs.gentoo.org: 
https://bugs.gentoo.org/show_bug.cgi?id=385047
Was  compiling a custom kernel  with support for  debugging and  debug 
messages are  received.
Duane Griffin  then  sent me  upstream.

Now I have have BUG spinlock lockup on screen:

Nov 26 13:34:46 localhost kernel: BUG: spinlock lockup on CPU#2, 
mc/7609, ffff880419c37200
Oct  4 15:55:50 localhost kernel: BUG: spinlock lockup on CPU#3, 
flush-9:127/2391, ffff880419c37200
---

# smartctl --all /dev/sde
--smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.0.4-gentoo-r1] (local 
build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.7 and 7200.7 Plus
Device Model:     ST3160023A
Serial Number:    4JS0JGZ4
Firmware Version: 8.01
User Capacity:    160 040 803 840 bytes [160 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   6
ATA Standard is:  ATA/ATAPI-6 T13 1410D revision 2
Local Time is:    Sat Oct  8 12:42:29 2011 NOVT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine 
completed
					without error or no self-test has ever
					been run.
Total time to complete Offline
data collection: 		(  430) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 ( 111) minutes.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE 
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   054   048   006    Pre-fail 
Always       -       120037243
   3 Spin_Up_Time            0x0003   097   096   000    Pre-fail 
Always       -       0
   4 Start_Stop_Count        0x0032   100   100   020    Old_age 
Always       -       106
   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail 
Always       -       0
   7 Seek_Error_Rate         0x000f   086   060   030    Pre-fail 
Always       -       410368363
   9 Power_On_Hours          0x0032   069   069   000    Old_age 
Always       -       27769
  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail 
Always       -       0
  12 Power_Cycle_Count       0x0032   098   098   020    Old_age 
Always       -       2760
194 Temperature_Celsius     0x0022   048   061   000    Old_age   Always 
       -       48
195 Hardware_ECC_Recovered  0x001a   054   047   000    Old_age   Always 
       -       120037243
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always 
       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age 
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   192   000    Old_age   Always 
       -       95
200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age 
Offline      -       0
202 Data_Address_Mark_Errs  0x0032   100   253   000    Old_age   Always 
       -       0

SMART Error Log Version: 1
ATA Error Count: 6 (device log contains only the most recent five errors)
	CR = Command Register [HEX]
	FR = Features Register [HEX]
	SC = Sector Count Register [HEX]
	SN = Sector Number Register [HEX]
	CL = Cylinder Low Register [HEX]
	CH = Cylinder High Register [HEX]
	DH = Device/Head Register [HEX]
	DC = Device Command Register [HEX]
	ER = Error register [HEX]
	ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 6 occurred at disk power-on lifetime: 612 hours (25 days + 12 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   84 51 01 f6 5f 39 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00395ff6 
= 3760118

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 80 77 5f 39 e0 00      00:57:36.606  READ DMA EXT
   25 00 80 77 5f 39 e0 00      00:57:36.596  READ DMA EXT
   25 00 80 f7 5e 39 e0 00      00:57:36.588  READ DMA EXT
   25 00 80 77 5e 39 e0 00      00:57:36.573  READ DMA EXT
   25 00 58 3f 77 39 e0 00      00:57:36.572  READ DMA EXT

Error 5 occurred at disk power-on lifetime: 612 hours (25 days + 12 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   84 51 01 f6 5f 39 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00395ff6 
= 3760118

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 80 77 5f 39 e0 00      00:57:36.606  READ DMA EXT
   25 00 80 f7 5e 39 e0 00      00:57:36.596  READ DMA EXT
   25 00 80 77 5e 39 e0 00      00:57:36.588  READ DMA EXT
   25 00 58 3f 77 39 e0 00      00:57:36.573  READ DMA EXT
   25 00 80 f7 5d 39 e0 00      00:57:36.572  READ DMA EXT

Error 4 occurred at disk power-on lifetime: 612 hours (25 days + 12 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   84 51 01 76 5e 39 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00395e76 
= 3759734

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 80 f7 5d 39 e0 00      00:57:34.469  READ DMA EXT
   25 00 80 f7 5d 39 e0 00      00:57:34.454  READ DMA EXT
   25 00 80 77 5d 39 e0 00      00:57:34.445  READ DMA EXT
   25 00 80 f7 5c 39 e0 00      00:57:34.444  READ DMA EXT
   25 00 80 f7 5c 39 e0 00      00:57:34.440  READ DMA EXT

Error 3 occurred at disk power-on lifetime: 612 hours (25 days + 12 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   84 51 01 76 5e 39 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00395e76 
= 3759734

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 80 f7 5d 39 e0 00      00:57:34.469  READ DMA EXT
   25 00 80 77 5d 39 e0 00      00:57:34.454  READ DMA EXT
   25 00 80 f7 5c 39 e0 00      00:57:34.445  READ DMA EXT
   25 00 80 f7 5c 39 e0 00      00:57:34.444  READ DMA EXT
   25 00 80 bf 76 39 e0 00      00:57:34.440  READ DMA EXT

Error 2 occurred at disk power-on lifetime: 612 hours (25 days + 12 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   84 51 01 76 5d 39 e0  Error: ICRC, ABRT 1 sectors at LBA = 0x00395d76 
= 3759478

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 80 f7 5c 39 e0 00      00:57:34.469  READ DMA EXT
   25 00 80 bf 76 39 e0 00      00:57:34.454  READ DMA EXT
   25 00 80 77 5c 39 e0 00      00:57:34.445  READ DMA EXT
   25 00 80 5f c1 38 e0 00      00:57:34.444  READ DMA EXT
   25 00 28 4f 5b 39 e0 00      00:57:34.440  READ DMA EXT

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     27642 
      -
# 2  Short offline       Completed without error       00%     27345 
      -

SMART Selective self-test log data structure revision number 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.
--


---
ParamonovValery.

