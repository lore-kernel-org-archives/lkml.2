Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1DZNN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:13:29 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:3502 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab1DZNN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:13:28 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: Tejun Heo <htejun@gmail.com>
CC: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Date: Tue, 26 Apr 2011 14:13:22 +0100
Subject: RE: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Topic: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Index: AcwDZQOErR4ywRmFQ4+ROv7B4FXTBwArcBMg
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32C77554BDC@gretna.indigovision.com>
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com>
 <4D9CD275.9000002@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
 <4D9FACC9.7020200@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
 <4DA45CA7.9040102@teksavvy.com> <4DA467FB.6020905@teksavvy.com>
 <20110423005610.GC1576@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C775549E4@gretna.indigovision.com>
 <20110425162242.GB30828@mtj.dyndns.org>
In-Reply-To: <20110425162242.GB30828@mtj.dyndns.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun wrote:
> ata4 is reporting link down and the device is detached and port
> disabled afterwards.  Doesn't seem to have much to do with
> freezing/thawing?

After all processing of a normal unplug event has completed, the port is left
thawed (and the irq enabled) to allow future hotplug events on this port to be
actioned.  In the case of the port lockups that I have seen the port appears
to be left frozen, with the irq disabled, and I am hypothesising that this is
due to a race between the freeze and the thaw.

Below is some additional tracing leading up to a port lockup, with some more
DPRINTK statements added.  The port freeze appears to be happening after the
port thaw.  The irq mask writes that are output by mv_set_main_irq_mask seem
to show the irqs left masked off.

...
__ata_port_freeze: ata4 port frozen
ata_port_schedule_eh: port EH scheduled
mv_set_main_irq_mask: skipped write in mv_set_main_irq_mask: 00040015, 00040015
__ata_port_freeze: ata4 port frozen
ata4: hard resetting link
sata_link_hardreset: ENTER
sata_link_hardreset: EXIT, rc=0
ata_sff_softreset: ENTER
ata_sff_softreset: about to softreset, devmask=1
ata_bus_softreset: ata4: bus reset via SRST
ata_dev_classify: found ATA device by sig
ata_sff_softreset: EXIT, classes[0]=1 [1]=0
mv_eh_thaw: ENTER
00040055
mv_eh_thaw: EXIT
ata_eh_thaw_port: ata4 port thawed
ata_std_postreset: ENTER
00040015
__ata_port_freeze: ata4 port frozen
ata_port_schedule_eh: port EH scheduled
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata_std_postreset: EXIT
ata_eh_revalidate_and_attach: ENTER
ata_eh_revalidate_and_attach: EXIT rc=-5
ata4.00: disabled
ata_eh_revalidate_and_attach: ENTER
ata_eh_recover: EXIT, rc=0
ata4: EH complete
ata_scsi_error: EXIT
ata_scsi_hotplug: ENTER
ata4.00: detaching (SCSI 3:0:0:0)
ata_scsi_hotplug: EXIT

The port is unresponsive at this point.


And another lockup, with tracing showing entering and leaving mv_eh_freeze:

...
ata_sff_tf_load: hob: feat 0x0 nsect 0x0, lba 0x0 0x0 0x0
ata_sff_tf_load: feat 0x0 nsect 0x0 lba 0x0 0x0 0x0
ata_sff_tf_load: device 0xE0
ata_sff_exec_command: ata4: cmd 0x27
mv_eh_freeze: ENTER
00040015
mv_eh_freeze: EXIT
__ata_port_freeze: ata4 port frozen
ata_sff_flush_pio_task: ENTER
ata4.00: failed to read native max address (err_mask=0x1)
ata4.00: HPA support seems broken, skipping HPA handling
ata4.00: revalidation failed (errno=-5)
ata4.00: disabled
mv_eh_freeze: ENTER
mv_set_main_irq_mask: skipped write in mv_set_main_irq_mask: 00040015, 00040015
mv_eh_freeze: EXIT
__ata_port_freeze: ata4 port frozen
ata4: hard resetting link
sata_link_hardreset: ENTER
sata_link_hardreset: EXIT, rc=0
ata_sff_softreset: ENTER
ata_sff_softreset: about to softreset, devmask=1
ata_bus_softreset: ata4: bus reset via SRST
ata_dev_classify: found ATA device by sig
ata_sff_softreset: EXIT, classes[0]=1 [1]=0
mv_eh_thaw: ENTER
00040055
mv_eh_thaw: EXIT
mv_eh_freeze: ENTER
00040015
mv_eh_freeze: EXIT
__ata_port_freeze: ata4 port frozen
ata_port_schedule_eh: port EH scheduled
ata_eh_thaw_port: ata4 port thawed
ata_std_postreset: ENTER
ata4: SATA link down (SStatus 0 SControl 310)
ata_std_postreset: EXIT
ata_eh_revalidate_and_attach: ENTER
ata_eh_recover: EXIT, rc=0
ata4: EH complete
ata_scsi_error: EXIT
ata_scsi_hotplug: ENTER
ata4.00: detaching (SCSI 3:0:0:0)
ata_scsi_hotplug: EXIT

The port is unresponsive at this point.

The output shows "ata_eh_thaw_port: ata4 port thawed" after the
"__ata_port_freeze: ata4 port frozen", but the tracing suggests that the actual
work enabling the irqs has been carried out before the irqs are subsequently
disabled.


Bruce.


Latest News at: http://www.indigovision.com/index.php/en/news.html
