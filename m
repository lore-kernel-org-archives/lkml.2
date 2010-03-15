Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab0COSi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:38:59 -0400
Received: from tenax.loup.net ([209.169.16.66]:57891 "EHLO tenax.loup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab0COSi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:38:58 -0400
Date: Mon, 15 Mar 2010 12:25:30 -0600
Message-Id: <201003151825.o2FIPUTV006948@alien.loup.net>
From: Mike Hayward <hayward@loup.net>
To: linux-kernel@vger.kernel.org
CC: mvds.00@gmail.com
Subject: SCSI GENERIC command queueing for block storage is unstable.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After discovering that O_NONBLOCK reads and writes were actually
blocking calls, I attempted to use the SCSI generic driver for
nonblocking io.  The good news is that it is nonblocking; the bad news
is that it is not dependable in any of the systems I have tested with.

Does anyone know if these defects have been fixed in later kernels?

1. When queueing, write can occassionally return errno 12 (ENOMEM, Cannot
   allocate memory).  This is documented in the SCSI GENERIC HOWTO,
   however only for indirect io and it says extremely rare.  I can cause
   it easily within a few hours and it can return even for direct io when
   no io's are queued and 80% of the ram is free or in buffer cache.  The
   fd polls as available for writing, but retrying never clears the error
   and the fd is no longer usable.  This is a complete show stopper.

   Linux 2.6.22.1-32.fc6 #1 SMP Wed Aug 1 14:30:16 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux

   There were no errors logged by the driver. Here is the offending
   sg_io_hdr, note all values are in hex:

   interface_id    S
   dxfer_direction fffffffd  (SG_DXFER_FROM_DEV)
   cmd_len         a         (it's a READ 10)
   mx_sb_len       fc
   iovec_count     0
   dxfer_len       200000
   dxferp          1c1f400
   cmdp            896518
   sbp             896528
   timeout         20000
   flags           1         (SG_FLAG_DIRECT_IO)
   pack_id         0
   usr_ptr         8964e0

2. Issuing a lot of concurrent io (READ_10 in this case) to SATA
   drives causes the the commands to be aborted for no good reason.
   I can reproducibly cause the problem within a few seconds on
   known good hardware.

   I issue 16 concurrent 64k reads to each of eight sata drives, but
   it would probably blow with fewer.  Perhaps this is a clue to what
   is going on: even if just using one drive, driver_duration shows
   the reads take far longer than normal (greater than 10ms) when
   first starting to queue io, then the performance behaves more like
   one would expect from a sata disk drive.

   This problem is reproducible on multiple x86_64 kernels and logs
   errors as the drive/bus appears to be reset.  Older kernels are
   less verbose about it and report with Fixed Sense instead of
   descriptors, but the same ATA event is occuring.

   Linux opt1 2.6.25-14.fc9.x86_64 #1 SMP Thu May 1 06:06:21 EDT 2008 x86_64 x86_64 x86_64 GNU/Linux

   interface_id S dxfer_direction -3 cmd_len 10 mx_sb_len 252 iovec_count 0 dxfer_len 10000 dxferp 0x2161200
   cmdp 22a9b58 sbp 22a9b68 timeout 20000 flags 1 pack_id 0 usr_ptr 0x22a9b20
   CDB 28 00 00 04 c9 03 00 00 80 00 02 02 00 00 00 00
   CDB READ_10 RELADR 0 FUA 0 DPO 0 LBA 0004c903 TRANSFERLEN 0080
   CDB Control Vendor 0 NACA 0 LINK 0
   status 2 masked_status 1 host_status 0 driver_status 8 resid 0 duration 243 info 1
   SENSE FIXED RESPONSE CODE 72 VALID 0 SENSEKEY NO_SENSE
   SENSE FIXED ILI 0 EOM 0 FILEMARK 0 INFO 00000000 ASENSELEN 0c
   SENSE FIXED COMMANDINFO 000a8000 ADDSENSE 0000
   SENSE FIXED FRUCODE 00
   SKSData SKSV 0

   ata9.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
   ata9.00: port_status 0x20080000
   ata9.00: cmd c8/00:80:03:c9:04/00:00:00:00:00/e0 tag 0 dma 65536 in
            res 50/00:00:82:c9:04/00:00:00:00:00/e0 Emask 0x2 (HSM violation)
   ata9.00: status: { DRDY }
   ata9: soft resetting link
   ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
   ata9.00: configured for UDMA/133
   ata9: EH complete
   sd 8:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
   sd 8:0:0:0: [sdd] Write Protect is off
   sd 8:0:0:0: [sdd] Mode Sense: 00 3a 00 00
   sd 8:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

   Linux opt2.loup.net 2.6.18-1.2798.fc6 #1 SMP Mon Oct 16 14:39:22 EDT 2006 x86_64 x86_64 x86_64 GNU/Linux

   CDB READ_10 RELADR 0 FUA 0 DPO 0 LBA 000fb903 TRANSFERLEN 0080
   CDB Control Vendor 0 NACA 0 LINK 0
   status 2 masked_status 1 host_status 0 driver_status 8 resid 10000 duration 4 info 1
   SENSE FIXED RESPONSE CODE 70 VALID 0 SENSEKEY ABORTED_COMMAND
   SENSE FIXED ILI 0 EOM 0 FILEMARK 0 INFO 00000000 ASENSELEN 0a
   SENSE FIXED COMMANDINFO 00000000 ADDSENSE 0000
   SENSE FIXED FRUCODE 00
   SKSData SKSV 0

   ata5: no sense translation for status: 0x50
   ata5: translated ATA stat/err 0x50/00 to SCSI SK/ASC/ASCQ 0xb/00/00
   ata5: status=0x50 { DriveReady SeekComplete }

   Linux opt3.loup.net 2.6.22.1-32.fc6 #1 SMP Wed Aug 1 14:30:16 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux

   CDB READ_10 RELADR 0 FUA 0 DPO 0 LBA 00031803 TRANSFERLEN 0080
   CDB Control Vendor 0 NACA 0 LINK 0
   status 2 masked_status 1 host_status 0 driver_status 8 resid 0 duration 243 info 1
   SENSE FIXED RESPONSE CODE 72 VALID 0 SENSEKEY NO_SENSE
   SENSE FIXED ILI 0 EOM 0 FILEMARK 0 INFO 00000000 ASENSELEN 0c
   SENSE FIXED COMMANDINFO 000a8000 ADDSENSE 0000
   SENSE FIXED FRUCODE 00
   SKSData SKSV 0

   ata9.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
   ata9.00: (port_status 0x20080000)
   ata9.00: cmd c8/00:80:03:1d:1b/00:00:00:00:00/e0 tag 0 cdb 0x0 data 65536 in
            res 50/00:00:82:1d:1b/00:00:00:00:00/e0 Emask 0x2 (HSM violation)
   ata9: soft resetting port
   ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
   ata9.00: configured for UDMA/133
   ata9: EH complete
   sd 8:0:0:0: [sde] 625142448 512-byte hardware sectors (320073 MB)
   sd 8:0:0:0: [sde] Write Protect is off
   sd 8:0:0:0: [sde] Mode Sense: 00 3a 00 00
   sd 8:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

The following aren't so much show stoppers, but they are defects
and/or can cause serious performance problems.

3. hdr.timeout is NOOP!  Despite what HOWTO says, READ_10, WRITE_10
   succeed even if hdr.driver_duration exceeds timeout.

4. If dxferlen is less than the READ_10 data transferlen, the SCSI
   command sometimes reports success when it shouldn't succeed.  This
   is data corruption and makes debugging very difficult; don't ask me
   how I know :-)

5. I've noticed after queueing the first command, subsequent commands
   tend to complete in reverse order even though HOWTO indicates oldest
   will be returned first.  driver_duration seems to confirm reverse
   order execution, particularly noticable when ios seem to take a long
   time.  This is a performance defect if it's what's really happening
   since it isn't desirable behavior if, for example, ios are generally
   ordered by lba and issued one at a time by kernel to a non queueing
   block device.

   Completion Command #  hdr.driver_duration (us)
   1          22         14979
   2          20         14981
   3          19         14982
   4          17         14984
   5          16         14985
   6          15         14986
   7          14         14988
   8          12         14990
   9          11         14991
   10         10         14992

   This reverse order behavior is trivial to reproduce even with 16
   concurrent INQUIRY commands.

6. There appears to be no fair queueing mechanism for scsi commands
   issued from multiple processes to separate devices over a shared
   bus.  For example, an io can easily be starved in queue for more
   than half a minute with just four processes issuing 16 slow ios
   at a time.  Reducing number of ios at a time to 2 per process
   decreases average and maximum latency to tolerable levels.

- Mike
