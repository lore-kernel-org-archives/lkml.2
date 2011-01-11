Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab1AKSJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 13:09:29 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:1809 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246Ab1AKSJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 13:09:24 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Jian Peng" <jipeng@broadcom.com>
To: "Tejun Heo" <tj@kernel.org>
cc: "Robert Hancock" <hancockrwd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        ide <linux-ide@vger.kernel.org>
Date: Tue, 11 Jan 2011 10:09:08 -0800
Subject: RE: questions regarding possible violation of AHCI spec in AHCI
 driver
Thread-Topic: questions regarding possible violation of AHCI spec in
 AHCI driver
Thread-Index: AcuXKv3f9b1YXwAXSnSrKGFxpppTuwaiwuSQ
Message-ID: <E18F441196CA634DB8E1F1C56A50A874319FD72B23@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <E18F441196CA634DB8E1F1C56A50A874319F70C1F2@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFEE569.4030204@gmail.com> <4CFF58D2.4040006@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA38C43@IRVEXCHCCR01.corp.ad.broadcom.com>,<4CFFCD56.6050608@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA7E36E@IRVEXCHCCR01.corp.ad.broadcom.com>,<4CFFD3EB.10800@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA7E36F@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4CFFE29C.7080205@kernel.org>
 <E18F441196CA634DB8E1F1C56A50A874319FA38CD3@IRVEXCHCCR01.corp.ad.broadcom.com>
 <4D000C8B.5040904@kernel.org>
In-Reply-To: <4D000C8B.5040904@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 613242983P055195875-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tejun,

Happy Holiday! I want to revisit this issue and hopefully get consensus on it asap.

Here is the sequence that will cause problem if BSY|DRQ and SSTS.DET was not checked in start_engine:

1. SUD bit was set in ahci_power_up() to start communication between host and device
2. START bit was set in ahci_start_engine() to prepare for data transfer (should check condition and do not set START bit here per spec)
By the time, host did not receive first FIS so BSY|DRQ was not cleared
3. inside ahci_hardreset(), call ahci_stop_engine() first, host controller will take time to clean up internal pipeline and transit to idle state
4. toggle SCTL.DET to reset interface, now COMRESET was not sent since internal state machine stuck at #2 and #3 (per spec), BSY|DRQ bit was not cleared
5. call ahci_start_engine() again and try to read ID from device but interface is busy since BSY bit was not cleared, failed here

At the end of section 10.1 of AHCI spec (rev 1.3), it states

Software shall not set PxCMD.ST to '1' until it is determined that a functional device is present on the port
as determined by PxTFD.STS.BSY = '0', PxTFD.STS.DRQ = '0', and PxSSTS.DET = 3h.

It is likely used to prevent host controller from jumping into wrong state before first FIS was received.

Please review this issue, and let me know how to resolve it by either adopting my previous patch, or creating a new patch.

Thanks,
Jian


Here is my previous patch against 2.6.37-rc3

> 
> --- libahci.c.orig	2010-12-08 10:42:48.383976763 -0800
> +++ libahci.c	2010-12-08 10:45:17.495156944 -0800
> @@ -542,6 +542,13 @@
>  {
>  	void __iomem *port_mmio = ahci_port_base(ap);
>  	u32 tmp;
> +	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
> +
> +	/* avoid race condition per spec (end of section 10.1.2) */
> +	if (status & (ATA_BUSY | ATA_DRQ) ||
> +	    ahci_scr_read(&ap->link, SCR_STATUS, &tmp) ||
> +	    (tmp & 0x0f) != 0x03)
> +		return;
>  
>  	/* start DMA */
>  	tmp = readl(port_mmio + PORT_CMD);

-----Original Message-----
From: Tejun Heo [mailto:tj@kernel.org] 
Sent: Wednesday, December 08, 2010 2:54 PM
To: Jian Peng
Cc: Robert Hancock; linux-kernel@vger.kernel.org; jgarzik@pobox.com; ide
Subject: Re: questions regarding possible violation of AHCI spec in AHCI driver

Hello, Jian.

On 12/08/2010 09:09 PM, Jian Peng wrote:
> The controller may take much longer time to recover in this case,
> and leads to wrong HW state after stop_engine() inside
> ahci_hardreset() and cause device type checking failure due to
> unfinished HW state change and missing D2H FIS after start_engine()
> again inside ahci_hardreset(). I guess this is the reason why AHCI
> spec try to emphasize.

I don't necessarily agree there.  The requirement is impossible to
reliably satisfy to begin with (it's inherently racy) and most specs
are filled with "the outcome is undefined" when they don't _need_ to
be well defined.  The hardware can do "eh.. well, whatever, I don't
know" but shouldn't get lost and fail to react to further
state-resetting actions.

> Yes, without this change, Broadcom controller will fail due to above
> reason.

Okay, so, the controller goes bonkers if ST is set when prerequisites
are not met.  You know that the problem can still happen with the
proposed change, right?  It's much less likely but definitely can and
actually is likely to happen once in a blue moon.  It isn't too
uncommon for link to take some time to stabilize after a PHY event
(including hardreset) and some devices will end up sending multiple
D2H Reg FISes in the process with conflicting status.  Also, note that
the delay between the check and ST setting could be substantial
especially with parallel probing / booting.

I'm not objecting to the change but you guys probably want to fix the
controller in following revisions.  If we're gonna make the change,
I'd like to go with the previous version without the vendor check.
What is the timeframe for the controller release?  Would it be enough
to merge the change during 2.6.38-rc1?  After baking it for some time
in 2.6.38, we can propagate the change back through -stable.

Thanks.

-- 
tejun


