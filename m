Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab1AKS5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 13:57:39 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4130 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932549Ab1AKS5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 13:57:36 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Jian Peng" <jipeng@broadcom.com>
To: "Tejun Heo" <tj@kernel.org>
cc: "Robert Hancock" <hancockrwd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        ide <linux-ide@vger.kernel.org>
Date: Tue, 11 Jan 2011 10:55:13 -0800
Subject: RE: questions regarding possible violation of AHCI spec in AHCI
 driver
Thread-Topic: questions regarding possible violation of AHCI spec in
 AHCI driver
Thread-Index: AcuxvLEYfxTI8DClTzu6mB1CuO9wEAABGKc5
Message-ID: <E18F441196CA634DB8E1F1C56A50A874319FA7E37B@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <4CFF58D2.4040006@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA38C43@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFFCD56.6050608@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA7E36E@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFFD3EB.10800@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA7E36F@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFFE29C.7080205@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA38CD3@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4D000C8B.5040904@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FD72B23@IRVEXCHCCR01.corp.ad.broadcom.com>,<20110111182323.GG15933@htj.dyndns.org>
In-Reply-To: <20110111182323.GG15933@htj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 613277EF3P055232404-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tejun,

Here is new patch based on your suggestion (against 2.6.37 release)

--- libahci.c.orig	2011-01-11 10:46:56.623991326 -0800
+++ libahci.c	2011-01-11 10:52:19.634036938 -0800
@@ -542,6 +542,15 @@
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 tmp;
+	u8 status;
+	
+	status = readl(port_mmio + PORT_TFDATA);
+	if (status & (ATA_BUSY | ATA_DRQ) ||
+	    ahci_scr_read(&ap->link, SCR_STATUS, &tmp) ||
+	    (tmp & 0x0f) != 0x03) {
+		printk(KERN_DEBUG "START bit was not set in %s\n", __func__);
+		return;
+	}	
 
 	/* start DMA */
 	tmp = readl(port_mmio + PORT_CMD);

I will test host controller made by other vendors and report issues soon.

Thanks,
Jian

________________________________________
From: Tejun Heo [htejun@gmail.com] On Behalf Of Tejun Heo [tj@kernel.org]
Sent: Tuesday, January 11, 2011 10:23 AM
To: Jian Peng
Cc: Robert Hancock; linux-kernel@vger.kernel.org; jgarzik@pobox.com; ide
Subject: Re: questions regarding possible violation of AHCI spec in AHCI driver

Hello,

On Tue, Jan 11, 2011 at 10:09:08AM -0800, Jian Peng wrote:
> Happy Holiday! I want to revisit this issue and hopefully get
> consensus on it asap.

Happy new year!

> Here is the sequence that will cause problem if BSY|DRQ and SSTS.DET
> was not checked in start_engine:
>
> 1. SUD bit was set in ahci_power_up() to start communication between
>    host and device
> 2. START bit was set in ahci_start_engine() to prepare for data
>    transfer (should check condition and do not set START bit here
>    per spec)
> By the time, host did not receive first FIS so BSY|DRQ was not
> cleared
> 3. inside ahci_hardreset(), call ahci_stop_engine() first, host
>    controller will take time to clean up internal pipeline and
>    transit to idle state
> 4. toggle SCTL.DET to reset interface, now COMRESET was not sent
>    since internal state machine stuck at #2 and #3 (per> spec),
>    BSY|DRQ bit was not cleared
> 5. call ahci_start_engine() again and try to read ID from device but
>    interface is busy since BSY bit was not cleared, failed here
>
> At the end of section 10.1 of AHCI spec (rev 1.3), it states
>
> Software shall not set PxCMD.ST to '1' until it is determined that a
> functional device is present on the port as determined by
> PxTFD.STS.BSY = '0', PxTFD.STS.DRQ = '0', and PxSSTS.DET = 3h.
>
> It is likely used to prevent host controller from jumping into wrong
> state before first FIS was received.

I still have to say it's pretty silly of the controller to stall
inrecoverably.

> Please review this issue, and let me know how to resolve it by
> either adopting my previous patch, or creating a new patch.

You haven't really brought up any new issue so my comment stays the
same.

>> I'm not objecting to the change but you guys probably want to fix
>> the controller in following revisions.  If we're gonna make the
>> change, I'd like to go with the previous version without the vendor
>> check.  What is the timeframe for the controller release?  Would it
>> be enough to merge the change during 2.6.38-rc1?  After baking it
>> for some time in 2.6.38, we can propagate the change back through
>> -stable.

So, yeah, let's proceed with the patch.  Please make the following
changes and resubmit.

* Please don't do readl() on the same line as variable declaration and
  drop the unnecessary & 0xff.

* Hmmm... please consider adding a KERN_DEBUG message when
  ahci_start_port() exits without starting the port.  Just in case it
  causes problems on other controllers.

Thank you.

--
tejun


