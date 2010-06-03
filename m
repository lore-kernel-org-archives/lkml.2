Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab0FCTRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:17:21 -0400
Received: from pluto.express.org ([64.62.190.206]:42837 "EHLO
	pluto.express.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0FCTRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:17:19 -0400
X-Greylist: delayed 2929 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jun 2010 15:17:19 EDT
Date: Thu, 3 Jun 2010 14:28:30 -0400 (EDT)
From: "William R. Lorenz" <wrl@express.org>
To: linux-kernel@vger.kernel.org
Subject: dm-multipath + libcheckers/tur.c instability
Message-ID: <Pine.LNX.4.64.1005271951350.22612@pluto.express.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have an interesting issue where dm-multipath marks one path (out of 
many) as down and multipath-tools' tur checker brings it back up, repeat.

   May 27 22:21:45 box kernel: sd_init_command: disk=sdah, block=12411960, count=8
   May 27 22:21:45 box kernel: Finishing 8 sectors
   May 27 22:21:45 box kernel: Retry with 0xffff8103138da080
   May 27 22:21:45 box kernel: device-mapper: multipath: Failing path 66:16.
   May 27 22:21:57 box kernel: sd_ioctl: disk=sdah, cmd=0x2285
   May 27 22:21:57 box multipathd: sdah: tur checker reports path is up
   May 27 22:21:57 box kernel: sd_ioctl: disk=sdah, cmd=0x2285
     [... repeat sd_ioctl ...]
   May 27 22:22:20 box kernel: sd_init_command: disk=sdah, block=12412744, count=72
   May 27 22:22:20 box kernel: Finishing 72 sectors
   May 27 22:22:20 box kernel: Retry with 0xffff8104983ece40
   May 27 22:22:20 box kernel: device-mapper: multipath: Failing path 66:16.
   May 27 22:22:27 box kernel: sd_ioctl: disk=sdah, cmd=0x2285
   May 27 22:22:27 box multipathd: sdah: tur checker reports path is up
   May 27 22:22:27 box kernel: sd_ioctl: disk=sdah, cmd=0x2285
     [... repeat sd_ioctl ...]
   [... REPEAT sequence ...]

(This logging is via `echo 0xffffffff >/proc/sys/dev/scsi/logging_level`.)
While this particular sdah path is down, others are up and working well:

   mpathc (360050768019081c13700000000000112) dm-2 IBM,2145
   [size=10G][features=1 queue_if_no_path][hwhandler=0]
   \_ round-robin 0 [prio=100][active]
    \_ 1:0:1:7 sdah 66:16  [failed][ready] <=-- bad path
    \_ 0:0:0:7 sdg  8:96   [active][ready]
   \_ round-robin 0 [prio=20][enabled]
    \_ 0:0:1:7 sdv  65:80  [active][ready]
    \_ 1:0:0:7 sdw  65:96  [active][ready]

The bad path toggles between active/ready and failed states depending on 
the time it's sampled.  When failed, its counterpart handles I/O requests:

   May 27 22:22:20 box kernel: sd_init_command: disk=sdg, block=12412744, count=72
   May 27 22:22:20 box kernel: sdg : block=12412744
   May 27 22:22:20 box kernel: sdg : writing 72/72 512 byte blocks.
   May 27 22:22:20 box kernel: scsi_add_timer: scmd: ffff8103138dab00, time: 15000, (ffffffff880062a5)
   May 27 22:22:20 box kernel: sd 0:0:0:7: send 0xffff8103138dab00                  sd 0:0:0:7:
   May 27 22:22:20 box kernel:         command: Write(10): 2a 00 00 bd 67 48 00 00 48 00
   May 27 22:22:20 box kernel: buffer = 0xffff8103611f4e00, bufflen = 36864, done = 0xffffffff8802e6a6, queuecommand 0xffffffff88053250
   May 27 22:22:20 box kernel: leaving scsi_dispatch_cmnd()
   May 27 22:22:20 box kernel: scsi_delete_timer: scmd: ffff8103138dab00, rtn: 1
   May 27 22:22:20 box kernel: sd 0:0:0:7: done 0xffff8103138dab00 SUCCESS        0 sd 0:0:0:7:

I've tracked this down in the kernel code -- it seems things get here, at 
which point of the conditions in the if() below cause the logged error:

   if (!sdp || !scsi_device_online(sdp) ||
       block + blk_rq_sectors(rq) > get_capacity(disk)) {
           SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
                                           "Finishing %u sectors\n",
                                           blk_rq_sectors(rq)));
           SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
                                           "Retry with 0x%p\n", SCpnt));
           goto out;
   }

Then tur comes around, checks the device and marks the PATH_UP, repeat.

This has happened on more than one server, in more than one datacenter. 
Backend storage in all cases is an IBM SAN Volume Controller (IBM SVC 
2145) with a Brocade FC fabric.  Unfortunately, this isn't a reproducible 
problem; however, I do have a server that's currently exhibiting this 
issue.  Either re-zoning the LUNs or disconnecting and reconnecting the 
fibre corrects the issue, and I suspect this is because it forces the 
initator to re-PLOGI to the SCSI target, although this is not certain.

Why the difference between tur's check and scsi_device_online(), assuming 
this is the condition that triggers the if() above?  Also, is there any 
additional debugging info I can capture to further isolate this issue?

It seems to me the path should be up or down, but not flapping.

Thanks in advance,


--
William R. Lorenz
