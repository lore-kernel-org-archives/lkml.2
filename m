Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab1FWEm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 00:42:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:45325 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab1FWEmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 00:42:55 -0400
Subject: Re: [PATCH] libata/sas: only set FROZEN flag if new EH is supported
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, wayneb@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        mbizon@freebox.fr, jgarzik@pobox.com
In-Reply-To: <1308803461.32158.191.camel@pasglop>
References: <20110615191747.GA6324@us.ibm.com>
	 <4DF90FCA.1040706@linux.vnet.ibm.com> <20110615233417.GB6324@us.ibm.com>
	 <20110616075114.GH8141@htj.dyndns.org>
	 <4DFA0507.3090609@linux.vnet.ibm.com> <20110616152836.GA15268@us.ibm.com>
	 <20110621160714.GA14174@us.ibm.com>  <4E00FF58.7070802@linux.vnet.ibm.com>
	 <1308803461.32158.191.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jun 2011 14:42:00 +1000
Message-ID: <1308804120.32158.202.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 14:31 +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2011-06-21 at 15:30 -0500, Brian King wrote:
> > Looks good to me. Jeff/Tejun - any issues with merging this?
> 
> BTW. Current upstream with that patch applied on a machine here leads to
> several oddities, I don't know at this point whether any of that is
> actually a regression :

Ooops... pressed "send" too quickly. Here's a log excerpt with some
comments:

ipr: IBM Power RAID SCSI Device Driver version: 2.5.2 (April 27, 2011)
ipr 0000:04:00.0: Found IOA with IRQ: 129
ipr 0000:04:00.0: Initializing IOA.
ipr 0000:04:00.0: Starting IOA initialization sequence.
ipr 0000:04:00.0: Adapter firmware version: 04220029
ipr 0000:04:00.0: IOA initialized.
scsi0 : IBM 2B4C Storage Adapter
scsi 0:0:4:0: Direct-Access     IBM      ST9300603SS      BB09 PQ: 0 ANSI: 6
scsi scan: INQUIRY result too short (5), using 36

-> Are these odd INQUIRY results expected ?

scsi 0:0:5:0: Direct-Access                                    PQ: 0 ANSI: 0
scsi 0:0:6:0: Direct-Access     IBM      ST9300603SS      BB09 PQ: 0 ANSI: 6
scsi 0:0:7:0: Direct-Access     IBM      ST9300603SS      BB09 PQ: 0 ANSI: 6
scsi scan: INQUIRY result too short (5), using 36
scsi 0:0:18:0: Direct-Access                                    PQ: 0 ANSI: 0
scsi 0:2:18:0: Enclosure         IBM      PSBPD6E4A  3GSAS 0109 PQ: 0 ANSI: 4
scsi: unknown device type 31
scsi 0:255:255:255: No Device         IBM      2B4C001SISIOA    0150 PQ: 0 ANSI: 0

-> The above looks odd, not sure what it means

ipr 0000:05:00.0: Found IOA with IRQ: 130
ipr 0000:05:00.0: Initializing IOA.
scsi 0:254:0:0: Processor         IBM      57CB001SISIOA    0150 PQ: 0 ANSI: 0
ipr 0000:05:00.0: Starting IOA initialization sequence.
ipr 0000:05:00.0: Adapter firmware version: 04220029
ipr 0000:05:00.0: IOA initialized.
scsi1 : IBM 57CB Storage Adapter
scsi scan: INQUIRY result too short (5), using 36
scsi 1:0:4:0: Direct-Access                                    PQ: 0 ANSI: 0
scsi 1:0:5:0: Direct-Access     IBM      ST9300603SS      BB09 PQ: 0 ANSI: 6
scsi scan: INQUIRY result too short (5), using 36
scsi 1:0:6:0: Direct-Access                                    PQ: 0 ANSI: 0
scsi 1:0:7:0: Direct-Access     IBM      ST9300603SS      BB09 PQ: 0 ANSI: 6
scsi 1:0:18:0: Enclosure         IBM      PSBPD6E4A  3GSAS 0109 PQ: 0 ANSI: 4
scsi: On host 1 channel 0 id 18 only 511 (max_scsi_report_luns) of 402653184 luns reported, try increasing max_scsi_report_luns.
scsi: host 1 channel 0 id 18 lun 0xc0000007f01e810f has a LUN larger than currently supported.

-> Now that looks horribly wrong... that LUN number looks like a kernel pointer

scsi scan: INQUIRY result too short (5), using 36
scsi 1:2:18:0: Direct-Access                                    PQ: 0 ANSI: 0
ata1.00: ATAPI: IBM     RMBO0040532, SA61, max UDMA/100
ata1.00: failed to IDENTIFY (device reports invalid type, err_mask=0x0)
ata1.00: revalidation failed (errno=-22)
ata1.00: disabled

-> So SATA works "better" with the patch but doesn't actually work properly :-)

scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured

-> That error could give us more info... not sure what it means, we do have plenty of 
memory...
 
scsi 1:8:0:0: Enclosure         IBM      VSBPD6E4B  3GSAS   01 PQ: 0 ANSI: 2
scsi: unknown device type 31
scsi 1:255:255:255: No Device         IBM      57CB001SISIOA    0150 PQ: 0 ANSI: 0
work_for_cpu used greatest stack depth: 9520 bytes left
st: Version 20101219, fixed bufsize 32768, s/g segs 256
sd 0:0:4:0: [sda] 585937500 512-byte logical blocks: (300 GB/279 GiB)
sd 0:0:5:0: [sdb] 585937500 512-byte logical blocks: (300 GB/279 GiB)
sd 0:0:6:0: [sdc] 585937500 512-byte logical blocks: (300 GB/279 GiB)
sd 0:0:7:0: [sdd] 585937500 512-byte logical blocks: (300 GB/279 GiB)
sd 0:0:18:0: [sde] READ CAPACITY failed
sd 0:0:18:0: [sde]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:18:0: [sde]  Sense Key : Illegal Request [current] 
sd 0:0:18:0: [sde]  Add. Sense: Invalid command operation code

-> Any idea what's up with that guy ?

sd 0:0:4:0: Attached scsi generic sg0 type 0
sd 0:0:5:0: [sdb] Write Protect is off
sd 0:0:5:0: Attached scsi generic sg1 type 0
sd 0:0:18:0: [sde] Test WP failed, assume Write Enabled
sd 0:0:6:0: Attached scsi generic sg2 type 0
sd 0:0:18:0: [sde] Asking for cache data failed
sd 0:0:7:0: Attached scsi generic sg3 type 0
sd 0:0:18:0: [sde] Assuming drive cache: write through
sd 1:2:18:0: [sdj] READ CAPACITY failed
sd 1:2:18:0: [sdj]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 1:2:18:0: [sdj]  Sense Key : Illegal Request [current] 
sd 1:2:18:0: [sdj]  Add. Sense: Invalid command operation code

-> And this one ?

There's more below ...

sd 0:0:18:0: Attached scsi generic sg4 type 0
sd 1:0:4:0: [sdf] 585937500 512-byte logical blocks: (300 GB/279 GiB)
scsi 0:2:18:0: Attached scsi generic sg5 type 13
sd 1:0:6:0: [sdh] 585937500 512-byte logical blocks: (300 GB/279 GiB)
scsi 0:255:255:255: Attached scsi generic sg6 type 31
scsi 0:254:0:0: Attached scsi generic sg7 type 3
sd 1:0:4:0: Attached scsi generic sg8 type 0
sd 1:2:18:0: [sdj] Test WP failed, assume Write Enabled
sd 1:0:5:0: Attached scsi generic sg9 type 0
sd 1:0:6:0: Attached scsi generic sg10 type 0
sd 1:0:7:0: [sdi] 585937500 512-byte logical blocks: (300 GB/279 GiB)
sd 1:2:18:0: [sdj] Asking for cache data failed
sd 1:2:18:0: [sdj] Assuming drive cache: write through
sd 1:0:7:0: Attached scsi generic sg11 type 0
scsi 1:0:18:0: Attached scsi generic sg12 type 13
sd 0:0:4:0: [sda] Write Protect is off
sd 1:2:18:0: Attached scsi generic sg13 type 0
sd 0:0:18:0: [sde] READ CAPACITY failed
sd 0:0:18:0: [sde]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:18:0: [sde]  Sense Key : Illegal Request [current] 
sd 0:0:18:0: [sde]  Add. Sense: Invalid command operation code
scsi 1:8:0:0: Attached scsi generic sg14 type 13
scsi 1:255:255:255: Attached scsi generic sg15 type 31
e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
e1000: Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
sd 1:0:6:0: [sdh] Write Protect is off
sd 0:0:5:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 0:0:18:0: [sde] Test WP failed, assume Write Enabled
sd 0:0:7:0: [sdd] Write Protect is off
sd 1:2:18:0: [sdj] READ CAPACITY failed
sd 1:2:18:0: [sdj]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 1:2:18:0: [sdj]  Sense Key : Illegal Request [current] 
sd 1:2:18:0: [sdj]  Add. Sense: Invalid command operation code
sd 0:0:18:0: [sde] Asking for cache data failed
sd 0:0:18:0: [sde] Assuming drive cache: write through
sd 0:0:18:0: [sde] Attached SCSI disk
sd 1:0:5:0: [sdg] 585937500 512-byte logical blocks: (300 GB/279 GiB)
sd 1:0:4:0: [sdf] Write Protect is off
sd 1:2:18:0: [sdj] Test WP failed, assume Write Enabled
sd 0:0:6:0: [sdc] Write Protect is off
sd 1:2:18:0: [sdj] Asking for cache data failed
sd 1:2:18:0: [sdj] Assuming drive cache: write through
sd 1:2:18:0: [sdj] Attached SCSI disk
sd 0:0:7:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 0:0:4:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 1:0:6:0: [sdh] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 1:0:4:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 1:0:5:0: [sdg] Write Protect is off
sd 1:0:7:0: [sdi] Write Protect is off
sd 0:0:6:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 1:0:7:0: [sdi] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 1:0:5:0: [sdg] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdb: unknown partition table
 sdd: unknown partition table
 sdh: unknown partition table
 sdi: unknown partition table
 sdf: [AIX] unknown partition table
 sdg: unknown partition table
e1000e 0002:03:00.0: Disabling ASPM  L1
 sdc: unknown partition table
e1000e 0002:03:00.0: (unregistered net_device): Failed to initialize MSI interrupts.  Falling back to legacy interrupts.
scsi 1:254:0:0: Processor         IBM      2B4C001SISIOA    0150 PQ: 0 ANSI: 0
 sda: [AIX] unknown partition table
sd 0:0:5:0: [sdb] Attached SCSI disk
sd 1:0:6:0: [sdh] Attached SCSI disk
sd 1:0:7:0: [sdi] Attached SCSI disk
sd 0:0:6:0: [sdc] Attached SCSI disk
sd 1:0:5:0: [sdg] Attached SCSI disk
sd 0:0:7:0: [sdd] Attached SCSI disk
scsi 1:254:0:0: Attached scsi generic sg16 type 3
sd 1:0:4:0: [sdf] Attached SCSI disk
sd 0:0:4:0: [sda] Attached SCSI disk

Cheers,
Ben.
> 
> 
> > Thanks,
> > 
> > Brian
> > 
> > On 06/21/2011 11:07 AM, Nishanth Aravamudan wrote:
> > > Ping on this -- Tejun, Brian, Jeff, this is a pretty annoying 2.6.39
> > > regression which it would be good to have fixed in 3.0.
> > > 
> > > Thanks,
> > > Nish
> > > 
> > > On 16.06.2011 [08:28:36 -0700], Nishanth Aravamudan wrote:
> > >> On 16.06.2011 [08:28:39 -0500], Brian King wrote:
> > >>> On 06/16/2011 02:51 AM, Tejun Heo wrote:
> > >>>> On Wed, Jun 15, 2011 at 04:34:17PM -0700, Nishanth Aravamudan wrote:
> > >>>>>> That looks like the right thing to do. For ipr's usage of
> > >>>>>> libata, we don't have the concept of a port frozen state, so this flag
> > >>>>>> should really never get set. The alternate way to fix this would be to
> > >>>>>> only set ATA_PFLAG_FROZEN in ata_port_alloc if ap->ops->error_handler
> > >>>>>> is not NULL.
> > >>>>>
> > >>>>> It seemed like ipr is as you say, but I wasn't sure if it was
> > >>>>> appropriate to make the change above in the common libata-scis code or
> > >>>>> not. I don't want to break some other device on accident.
> > >>>>>
> > >>>>> Also, I tried your suggestion, but I don't think that can happen in
> > >>>>> ata_port_alloc? ata_port_alloc is allocated ap itself, and it seems like
> > >>>>> ap->ops typically gets set only after ata_port_alloc returns?
> > >>>>
> > >>>> Maybe we can test error_handler in ata_sas_port_start()?
> > >>>
> > >>> Good point. Since libsas is converted to the new eh now, we would need to have
> > >>> this test.
> > >>
> > >> Commit 7b3a24c57d2eeda8dba9c205342b12689c4679f9 ("ahci: don't enable
> > >> port irq before handler is registered") caused a regression for CD-ROMs
> > >> attached to the IPR SATA bus on Power machines:
> > >>
> > >>   ata_port_alloc: ENTER
> > >>   ata_port_probe: ata1: bus probe begin
> > >>   ata1.00: ata_dev_read_id: ENTER
> > >>   ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
> > >>   ata1.00: ata_dev_read_id: ENTER
> > >>   ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
> > >>   ata1.00: limiting speed to UDMA7:PIO5
> > >>   ata1.00: ata_dev_read_id: ENTER
> > >>   ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
> > >>   ata1.00: disabled
> > >>   ata_port_probe: ata1: bus probe end
> > >>   scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
> > >>
> > >> The FROZEN flag added in that commit is only cleared by the new EH code,
> > >> which is not used by ipr. Clear this flag in the SAS code if we don't
> > >> support new EH.
> > >>
> > >> Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > >> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> > >>
> > >> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> > >> index d51f979..ebe1685 100644
> > >> --- a/drivers/ata/libata-scsi.c
> > >> +++ b/drivers/ata/libata-scsi.c
> > >> @@ -3797,6 +3797,12 @@ EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
> > >>   */
> > >>  int ata_sas_port_start(struct ata_port *ap)
> > >>  {
> > >> +	/*
> > >> +	 * the port is marked as frozen at allocation time, but if we don't
> > >> +	 * have new eh, we won't thaw it
> > >> +	 */
> > >> +	if (!ap->ops->error_handler)
> > >> +		ap->pflags &= ~ATA_PFLAG_FROZEN;
> > >>  	return 0;
> > >>  }
> > >>  EXPORT_SYMBOL_GPL(ata_sas_port_start);
> > >>
> > >>
> > >> -- 
> > >> Nishanth Aravamudan <nacc@us.ibm.com>
> > >> IBM Linux Technology Center
> > > 
> > 
> > 
> 


