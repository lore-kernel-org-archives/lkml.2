Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab1DYOyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 10:54:43 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:8044 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332Ab1DYOym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 10:54:42 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: Tejun Heo <htejun@gmail.com>, Mark Lord <kernel@teksavvy.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Date: Mon, 25 Apr 2011 15:54:38 +0100
Subject: RE: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Topic: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Index: AcwBUhgT91IanwLOQTar5zO7v1oShAB5QzNAAAdFBHA=
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32C775549E4@gretna.indigovision.com>
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com>
 <4D9CD275.9000002@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
 <4D9FACC9.7020200@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
 <4DA45CA7.9040102@teksavvy.com> <4DA467FB.6020905@teksavvy.com>
 <20110423005610.GC1576@mtj.dyndns.org> 
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

> Yeap, devices behind SATA-PATA bridge were still affected by the transfer
> mode so libata tries to slow them down too along with link speed when
> limiting speed due to errors.  Shouldn't affect native SATA devices.

Thanks.

I wrote:

> 00040055
> 00040015
> __ata_port_freeze: ata4 port frozen
> ata_port_schedule_eh: port EH scheduled
> ata_eh_thaw_port: ata4 port thawed
> ata_std_postreset: ENTER
> ata4: SATA link down (SStatus 0 SControl 310)
> ata_std_postreset: EXIT
> ata_eh_revalidate_and_attach: ENTER
> ata_eh_revalidate_and_attach: EXIT rc=-5
> ata4.00: disabled
> ata_eh_revalidate_and_attach: ENTER
> ata_eh_recover: EXIT, rc=0
> ata4: EH complete
> ata_scsi_error: EXIT
> ata_scsi_hotplug: ENTER
> ata4.00: detaching (SCSI 3:0:0:0)
> ata_scsi_hotplug: EXIT

Okay, so the ata_eh_thaw_port has raced (and won) against whatever was in the
process of masking off the irq (the __ata_port_freeze?), which then completes
leaving libata/sata_mv thinking the port is thawed while no further irqs get
generated.

Could ata_port_freeze or __ata_port_freeze (which don't claim the ap's lock)
have been invoked and then slept while ata_eh_thaw_port runs?


Bruce.


Latest News at: http://www.indigovision.com/index.php/en/news.html
