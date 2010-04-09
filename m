Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab0DIE0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 00:26:50 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:57665 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0DIE0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 00:26:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oXQ8YR7qy+AdH9rODOXueSR9XrOwArDAVFirQoB2/jkO92pgSx95xuiv2wCKEP1Lrf
         O6a1byH6md+wTP3gBdCEfL4ontmaEkeOASN/phHs4/IdEKX2rD8fU54wZJhsEL4N6MHY
         Kp3Zn3OIDhqwMZC74tpCJV2eynqLej5G48hPI=
Message-ID: <4BBEAC83.9060301@garzik.org>
Date: Fri, 09 Apr 2010 00:26:43 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
CC: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: 2.6.33: libata issues with VIA SATA/PATA controller
References: <201004090043.o390hSjL014351@turbo.physics.adelaide.edu.au>
In-Reply-To: <201004090043.o390hSjL014351@turbo.physics.adelaide.edu.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 08:43 PM, Jonathan Woithe wrote:
> Hi
>
> I have a machine equipped with the following SATA/PATA controllers:
>
>   * 00:0f.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/
>     VT823x/A/C PIPC Bus Master IDE (rev 06)
>
>   * 00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA RAID
>     Controller (rev 80)
>
> Two hard drives are attached to the SATA controller (messages from 2.6.24.2):
>
>    scsi 0:0:0:0: Direct-Access     ATA      WDC WD2502ABYS-0 02.0 PQ: 0 ANSI: 5
>    scsi 1:0:0:0: Direct-Access     ATA      WDC WD2502ABYS-0 02.0 PQ: 0 ANSI: 5
>
> Both drives are jumpered to force 1.5 Gbps SATA speed.  This is needed
> because these WD drives won't automatically fall back to 1.5 Gbps if 3.0
> Gbps isn't requested, and the VIA controller in use is only capable of
> 1.5 Gbps.
>
> The PATA interface has a tape drive attached as primary master and a CD
> writer attached as secondary master.  Under 2.6.24.2 these show up as
>
>    hda: SONY SDX-260V, ATAPI TAPE drive
>    hdc: ATAPI 40X CD-ROM CD-R/RW drive, 2048kB Cache
>
> The problem I have is that I am unable to boot 2.6.33 (or 2.6.33.2).  The
> interfaces are probed but it seems the system has trouble communicating
> reliably over the SATA links.  Sometimes both drives are identified
> correctly, only to encounter I/O errors when the partition table is read.
> Other times failures occur during the drive detection phase.  The problem
> persists even when both PATA devices have been unplugged, so the PATA
> devices themselves are not the cause.  In all cases the end result is the
> same: the rootfs can't be found, the kernel panics.
>
> The 2.6.33.2 I have tried to boot today is configured to use libata VIA PATA
> support.  The 2.6.24.2 kernel (which mostly works, except for some issues
> with ide-tape which might be hardware related) instead uses the old ide
> driver for the PATA interface.  I have not yet been able to test whether
> disabling the VIA PATA component of libata works around the problem.  The
> reason for enabling libata VIA PATA support is due to ongoing issues with
> ide-tape in recent kernels (I've tried from 2.6.29 on).  The suggestion was
> made to try libata since its tape driver was in better shape.
>
> Unfortunately the machine in question is a production machine and I have
> limited opportunities to reboot and test kernels.  I also didn't have a
> camera handy to take screen shots this morning during testing.  The
> following are messages I noted by hand before they were scrolled away by the
> panic.
>
>    ata1: lost interrupt status 0x50
>    unhandled error code
>    Result: hostbyte=0x00, driverbyte=0x06
>    CDB: cdb[0] = 0x28 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x08 0x00
>    end request: I/O error, dev sda, sector 0
>
> The same was repeated for ata2 / sdb.
>
> Another group of messages which crops up during drive detection is:
>
>    qc timeout cmd 0x27
>    failed to read native max address (error mask 0x4)
>    HPA suport seems broken, skipping HPA handling
>
> I would like to try to get to the bottom of what's happening here.  This
> problem does not occur in 2.6.24.2 (using the VIA ide PATA driver).  Both
> 2.6.33 and 2.6.33.2 (with the VIA libata PATA driver) suffer from the
> problem.  If there are further tests I can do please let me know and I'll do
> my best to schedule them (given that the machine in question is a production
> system).  Also ask if you require more information about the machine.
>
> Finally, there's a complete dmsg output I get from 2.6.24.2 at the end of
> this email in case it contains additional useful information on the hardware
> configuration of this system.  Please CC me any replies to ensure I see them
> (I monitor lkml via web gateways, so it's easy to miss followups at times).

(adding linux-ide to CC)

A complete dmesg is definitely useful.  Posting one from the failing 
kernel would be preferred, though.  That will show us libata boot 
messages as well as the failures you are seeing, in full detail.

Also, please try the latest 2.6.34-rc kernel, as that has several fixes 
for both pata_via and sata_via which did not make 2.6.33.

	Jeff



