Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab0FATts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:49:48 -0400
Received: from smtp2.ist.utl.pt ([193.136.128.22]:34221 "EHLO smtp2.ist.utl.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab0FATtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:49:46 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jun 2010 15:49:45 EDT
Date: Tue, 1 Jun 2010 20:43:49 +0100
From: =?UTF-8?B?Q2zDoXVkaW8=?= Martins <ctpm@ist.utl.pt>
To: Ryan Kuester <rkuester@metis.kspace.net>
Cc: Eric Moore <Eric.Moore@lsi.com>, Kashyap Desai <kashyap.desai@lsi.com>,
       DL-MPTFusionLinux@lsi.com, support@lsi.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: mptsas hangs caused by ATA pass-through explained
Message-Id: <20100601204349.e13fca3b.ctpm@ist.utl.pt>
In-Reply-To: <20100426231154.GB577@kspace.net>
References: <20100426231154.GB577@kspace.net>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 26 Apr 2010 18:11:54 -0500 Ryan Kuester <rkuester@kspace.net> wrote:
> I may have an explanation for the LSI 1068 HBA hangs provoked by ATA
> pass-through commands, in particular by smartctl.
> 
> First, my version of the symptoms.  On an LSI SAS1068E B3 HBA running
> 01.29.00.00 firmware, with SATA disks, and with smartd running, I'm seeing
> occasional task, bus, and host resets, some of which lead to hard faults of
> the HBA requiring a reboot.  Abusively looping the smartctl command,
> 
>     # while true; do smartctl -a /dev/sdb > /dev/null; done
> 
> dramatically increases the frequency of these failures to nearly one per
> minute.  A high IO load through the HBA while looping smartctl seems to
> improve the chance of a full scsi host reset or a non-recoverable hang.
> 
> I reduced what smartctl was doing down to a simple test case which
> causes the hang with a single IO when pointed at the sd interface.  See
> the code at the bottom of this e-mail.  It uses an SG_IO ioctl to issue
> a single pass-through ATA identify device command.  If the buffer
> userspace gives for the read data has certain alignments, the task is
> issued to the HBA but the HBA fails to respond.  If run against the sg
> interface, neither the test code nor smartctl causes a hang.
> 
> sd and sg handle the SG_IO ioctl slightly differently.  Unless you
> specifically set a flag to do direct IO, sg passes a buffer of its own,
> which is page-aligned, to the block layer and later copies the result
> into the userspace buffer regardless of its alignment.  sd, on the other
> hand, always does direct IO unless the userspace buffer fails an
> alignment test at block/blk-map.c line 57, in which case a page-aligned
> buffer is created and used for the transfer.
> 
> The alignment test currently checks for word-alignment, the default
> setup by scsi_lib.c; therefore, userspace buffers of almost any
> alignment are given directly to the HBA as DMA targets.  The LSI 1068
> hardware doesn't seem to like at least a couple of the alignments which
> cross a page boundary (see the test code below).  Curiously, many
> page-boundary-crossing alignments do work just fine.
> 
> So, either the hardware has an bug handling certain alignments or the
> hardware has a stricter alignment requirement than the driver is
> advertising.  If stricter alignment is required, then in no case should
> misaligned buffers from userspace be allowed through without being
> bounced or at least causing an error to be returned.
> 
> It seems the mptsas driver could use blk_queue_dma_alignment() to advertise
> a stricter alignment requirement.  If it does, sd does the right thing and
> bounces misaligned buffers (see block/blk-map.c line 57).  The following
> patch to 2.6.34-rc5 makes my symptoms go away.  I'm sure this is the wrong
> place for this code, but it gets my idea across.
> 
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
> index 6796597..1e034ad 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -2450,6 +2450,8 @@ mptscsih_slave_configure(struct scsi_device *sdev)
>  		ioc->name,sdev->tagged_supported, sdev->simple_tags,
>  		sdev->ordered_tags));
>  
> +	blk_queue_dma_alignment (sdev->request_queue, 512 - 1);
> +
>  	return 0;
>  }
> 

 Hello,

 I have tested v2.6.34 on a box with 16 SATA disks attached to a
LSISAS1068E (through a port expander), with and without this patch:

 With vanilla 2.6.34 I can reliably reproduce controller timeouts both
with the example code provided by Ryan and with a simple loop like:

while : ; do for d in `ls /sys/block/ | grep sd` ; do smartctl -a /dev/$d ; done ; done

 The result are controller timeouts with the following kind of kernel messages:

mptscsih: ioc0: attempting task abort! (sc=ffff8802be18dc00)
sd 4:0:2:0: [sdc] CDB: ATA command pass through(16): 85 08 0e 00 00 00 01 00 00 00 00 00 00 00 ec 00
mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO Executed}, SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=ffff8802be18dc00)
mptbase: ioc0: LogInfo(0x31112000): Originator={PL}, Code={Reset}, SubCode(0x2000)
mptbase: ioc0: LogInfo(0x31120101): Originator={PL}, Code={Abort}, SubCode(0x0101)
mptscsih: ioc0: attempting task abort! (sc=ffff8802be18dc00)
sd 4:0:2:0: [sdc] CDB: Test Unit Ready: 00 00 00 00 00 00
mptbase: ioc0: LogInfo(0x31112000): Originator={PL}, Code={Reset}, SubCode(0x2000)
mptscsih: ioc0: task abort: SUCCESS (sc=ffff8802be18dc00)
mptscsih: ioc0: attempting target reset! (sc=ffff8802be18dc00)
sd 4:0:2:0: [sdc] CDB: ATA command pass through(16): 85 08 0e 00 00 00 01 00 00 00 00 00 00 00 ec 00
mptscsih: ioc0: target reset: SUCCESS (sc=ffff8802be18dc00)
mptbase: ioc0: LogInfo(0x31112000): Originator={PL}, Code={Reset}, SubCode(0x2000)
mptbase: ioc0: LogInfo(0x31120101): Originator={PL}, Code={Abort}, SubCode(0x0101)
mptscsih: ioc0: attempting task abort! (sc=ffff8802be18dc00)
sd 4:0:2:0: [sdc] CDB: Test Unit Ready: 00 00 00 00 00 00
mptbase: ioc0: LogInfo(0x31112000): Originator={PL}, Code={Reset}, SubCode(0x2000)
mptscsih: ioc0: task abort: SUCCESS (sc=ffff8802be18dc00)
mptscsih: ioc0: attempting bus reset! (sc=ffff8802be18dc00)
sd 4:0:2:0: [sdc] CDB: ATA command pass through(16): 85 08 0e 00 00 00 01 00 00 00 00 00 00 00 ec 00
mptscsih: ioc0: bus reset: SUCCESS (sc=ffff8802be18dc00)
mptbase: ioc0: LogInfo(0x31112000): Originator={PL}, Code={Reset}, SubCode(0x2000)
mptbase: ioc0: LogInfo(0x31120101): Originator={PL}, Code={Abort}, SubCode(0x0101)
mptbase: ioc0: LogInfo(0x31120101): Originator={PL}, Code={Abort}, SubCode(0x0101)
mptscsih: ioc0: attempting host reset! (sc=ffff8802be18dc00)
mptscsih: ioc0: host reset: SUCCESS (sc=ffff8802be18dc00)


 As described in

 https://bugzilla.kernel.org/show_bug.cgi?id=13594

 this can result in nasty side effects, like multiple drives getting
kicked out of an MD array.

 With Ryan's patch applied on top of v2.6.34 I cannot reproduce the
above problem with my simple script nor with Ryan's example.

 So, IMHO, this patch should be strongly considered for inclusion, or
else the root cause investigated further.

 So, as far as I can tell:

Tested-by: Cláudio Martins <ctpm@ist.utl.pt>

 I'm also glad to test any further patches, if it turns out that the
above is not the most correct fix for the issue.

 Thanks in advance.

 Best regards

Cláudio


> I look forward to hearing from you guys who know this hardware and code
> better than I do.  Is the hardware at fault, or should the driver be
> shielding the hardware better?  Where's the right place to add this code, if
> it's the right fix?
> 
> Does this `fix' the problem for anyone besides me?
> 
> Regards,
> -- Ryan Kuester
> 
> 
> Here is a minimal bit of test code which causes the error.  BEWARE: this
> will hose the HBA at which you point it.  If that's controlling your
> root disk, you may hang your machine.
> 
> /*
>  * sg_bomb -- send SG_IO ioctl which causes LSI 1068 HBA to hang
>  *
>  *   usage: sg_bomb <device>
>  *    e.g.: sg_bomb /dev/sdb
>  *    e.g.: sg_bomb /dev/sg1
>  *
>  *   Modify offset_into_page to adjust the degree of buffer misalignment.
>  */
> 
> #include <unistd.h>
> #include <scsi/sg.h>
> #include <sys/ioctl.h>
> #include <fcntl.h>
> #include <stdlib.h>
> 
> int main(int argc, char* argv[])
> {
>     char* filename = argv[1];
>     unsigned int offset_into_page = 0xe40;
>     // works: unsigned int offset_into_page = 0x0;
>     // hangs: unsigned int offset_into_page = 0xf00;
>     // works: unsigned int offset_into_page = 0xf04;
> 
>     unsigned char ata_identify_cmd[] = {0x85, 0x08, 0x0e, 0, 0, 0, 0x01,
>         0, 0, 0, 0, 0, 0, 0, 0xec, 0};
>     unsigned char sense[32];
>     unsigned char* data = valloc(0x2000) + offset_into_page;
>     struct sg_io_hdr hdr = {
>         .interface_id = 'S',
>         .dxfer_direction = SG_DXFER_FROM_DEV,
>         .cmdp = ata_identify_cmd,
>         .cmd_len = 16,
>         .dxferp = data,
>         .dxfer_len = 512,
>         .sbp = sense,
>         .mx_sb_len = sizeof(sense),
>         .timeout = 5000,
>     };
> 
>     int fd;
>     if ((fd = open(filename, O_RDWR|O_NONBLOCK)) < 0) 
>         perror();
> 
>     return ioctl(fd, SG_IO, &hdr);
> }
