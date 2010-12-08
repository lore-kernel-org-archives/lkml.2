Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab0LHStp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:49:45 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4837 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896Ab0LHStm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:49:42 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Jian Peng" <jipeng@broadcom.com>
To: "Tejun Heo" <tj@kernel.org>
cc: "Robert Hancock" <hancockrwd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        ide <linux-ide@vger.kernel.org>
Date: Wed, 8 Dec 2010 10:48:26 -0800
Subject: RE: questions regarding possible violation of AHCI spec in AHCI
 driver
Thread-Topic: questions regarding possible violation of AHCI spec in
 AHCI driver
Thread-Index: AcuXBUXQGTkcdhfiQEexKejH/ikDdgAAzlkZ
Message-ID: <E18F441196CA634DB8E1F1C56A50A874319FA7E36E@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <E18F441196CA634DB8E1F1C56A50A874319F70C1F2@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFEE569.4030204@gmail.com> <4CFF58D2.4040006@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA38C43@IRVEXCHCCR01.corp.ad.broadcom.com>,<4CFFCD56.6050608@kernel.org>
In-Reply-To: <4CFFCD56.6050608@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 60E10CD13P037499306-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it is reasonable to add extra check in ahci_start_engine() without returning status of ST bit. If so, here is my patch

--- libahci.c.orig	2010-12-08 10:42:48.383976763 -0800
+++ libahci.c	2010-12-08 10:45:17.495156944 -0800
@@ -542,6 +542,13 @@
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 tmp;
+	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
+
+	/* avoid race condition per spec (end of section 10.1.2) */
+	if (status & (ATA_BUSY | ATA_DRQ) ||
+	    ahci_scr_read(&ap->link, SCR_STATUS, &tmp) ||
+	    (tmp & 0x0f) != 0x03)
+		return;
 
 	/* start DMA */
 	tmp = readl(port_mmio + PORT_CMD);

Thanks,
Jian
________________________________________
From: Tejun Heo [tj@kernel.org]
Sent: Wednesday, December 08, 2010 10:24 AM
To: Jian Peng
Cc: Robert Hancock; linux-kernel@vger.kernel.org; jgarzik@pobox.com; ide
Subject: Re: questions regarding possible violation of AHCI spec in AHCI driver

Hello,

On 12/08/2010 07:14 PM, Jian Peng wrote:
> The problem happened as follow:
>
> After power up, inside ahci_init_one(), it will call ahci_power_up()
> to toggle PxCMD.SUD bit first, then HBA will send COMRESET to
> device, and device will send first D2H FIS back. Here it will call
> ahci_start_engine() to turn on PxCMD.ST to process command. In this
> case, it may run into race condition that transaction triggered by
> toggling PxCMD.SUD is not completed yet, and that is the reason why
> extra check is required by spec to guarantee that HBA already
> received FIS and in sane state.
>
> In most HBA, either staggered spin-up feature was not supported, or
> time required for transaction is less than that between two function
> calls, it may work. IMHO, this is a clear violation of spec, and not
> robust against all HBA design.
>
> The major concern is that ahci_start_engine() is used widely in EH
> and it does not return result to reflect whether ST bit was set or
> not, this may cause trouble in some cases. I am working on verifying
> those cases with different HBAs now.

I see, so it's not that the controller actually failed but you
observed the race condition.  During EH, ahci_start_engine() is used
rather liberally when the driver wants the controller in working
condition.  The assumption is that even if the driver tries to set ST
with the incorrect condition, the controller wouldn't go crazy where
it can't be restarted later, which _must_ be true as there's no atomic
way to check the condition and set ST.

The driver at the same time guarantees that if the whole
initialization protocol succeeds, the last ahci_start_engine() is
called after hardreset is sucessfully completed and thus all the
prerequisites are met.

So, yeap, the driver might set ST when the conditions are not met but
that can't be avoided completely anyway so the controller shouldn't go
completely bonkers for that (it's okay to fail in recoverable way) and
the driver will do the last ST setting after all the conditions are
met on the success path.

Thanks.

--
tejun


