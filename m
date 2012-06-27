Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2F0JYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:24:30 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:18775 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2F0JY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:24:28 -0400
Date: Wed, 27 Jun 2012 11:24:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: ben-linux@fluff.org, seth.heasley@intel.com, ben@decadent.org.uk,
        David.Woodhouse@intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org, bleung@chromium.org
Subject: Re: [PATCH 0/3 v2] i2c: i801: enable irq
Message-ID: <20120627112402.26576746@endymion.delvare>
In-Reply-To: <1325847502-17841-1-git-send-email-djkurtz@chromium.org>
References: <1325847502-17841-1-git-send-email-djkurtz@chromium.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again Daniel,

On Fri,  6 Jan 2012 18:58:19 +0800, Daniel Kurtz wrote:
> This is a second version of a set of patches enables the Intel PCH SMBus
> controller interrupt.  It refactors the second two patches a little bit by
> relying on DEV_ERR interrupt for timeouts, instead of using an explicit
> wait_event_timeout.
> 
> The first attempt received absolutely no response. Maybe this time someone
> will be interested.
> 
> The SMBus Host Controller Interrupt can signify:
>  INTR - the end of a complete transaction
>  DEV_ERR - that a device did not ACK a transaction
>  BYTE_DONE - the completion of a single byte during a byte-by-byte transaction
> 
> This patchset arrives with the following caveats:
> 
>  1)  It has only been tested with a Cougar Point (Intel 6 Series PCH) SMBus
> controller, so the irq is only enabled for that chip type.

I just finished testing (my modified version of the driver [1] which
includes all the fixes discussed in this thread so far) on my ICH7-M
machine which is running kernel 3.0. I could only test SMBus quick
write and SMBus byte read, but that worked just fine. Speed boost is
impressive, with a factor 7.0x for the former and 2.1x for the latter!
Very nice, thanks Daniel!

[1] http://khali.linux-fr.org/devel/misc/i2c-i801/
    Everyone is invited to test this on ICH5+, just add your device ID
    to the list of interrupt-enabled devices if it's not there yet,
    test and report.

>  2) It has not been tested with any devices that do transactions that use the
>     PEC.  In fact, I believe that an additional small patch would be required
>     to the driver working correctly in interrupt mode with PEC.

Couldn't test that either.

> 
>  3) It has not been tested in SMBus Slave mode.

Well the driver doesn't support it yet anyway.

> 
>  4) It has not been tested with SMI#-type interrupts.

I don't think it can work at all. As I understand it, you have to fall
back to polled mode if interrupts are set to SMI#. Probably not a big
deal in practice, my 4 test systems have interrupt set to PCI type. I
think it's easier for the BIOS to do busy polling than interrupt
handling, so unless the BIOS needs the SMBus slave mode, it probably
will never set interrupt mode to SMI# for the SMBus.

> 
>  5) The BIOS has to configure the PCH SMBus IRQ properly.

Sounds like a reasonable assumption.

> 
>  6) It has not been tested with a device that does byte-by-byte smbus (non-i2c)
>     reads.

I planned on testing this on my ICH3-M system, but it turns out your
interrupt-based implementation only works for ICH5 and later chips. As
ICH5 and later chips all implement the block buffer, there's no reason
for the byte-by-byte-code to ever be used for SMBus block transactions.
However, the block buffer feature can be disabled for testing purpose
by passing module parameter disable_features=0x0002.

I just did, and actually it doesn't work. i2cdump shows 32 bytes no
matter what the device said. Debug log shows that the driver reads
fewer bytes from the device though, as it is supposed to. So I think
the problem is simply that the interrupt path is missing this compared
to the polled path:

		if (i == 1 && read_write == I2C_SMBUS_READ
		 && command != I2C_SMBUS_I2C_BLOCK_DATA) {
			len = inb_p(SMBHSTDAT0(priv));
			(...)
			data->block[0] = len;
		}

I.e. we don't let the caller know how many bytes we actually read from
the device. I fixed it with:

--- i2c-i801.orig/i2c-i801.c	2012-06-27 09:51:25.000000000 +0200
+++ i2c-i801/i2c-i801.c	2012-06-27 11:10:25.362853361 +0200
@@ -408,6 +408,24 @@ static irqreturn_t i801_isr(int irq, voi
 
 	if (hststs & SMBHSTSTS_BYTE_DONE) {
 		if (priv->is_read) {
+			if (priv->count == 0
+			 && (priv->cmd & 0x1c) == I801_BLOCK_DATA) {
+				priv->len = inb_p(SMBHSTDAT0(priv));
+				if (priv->len < 1
+				 || priv->len > I2C_SMBUS_BLOCK_MAX) {
+					dev_err(&priv->pci_dev->dev,
+						"Illegal SMBus block read size %d\n",
+						priv->len);
+					/* FIXME: Recover */
+					priv->len = I2C_SMBUS_BLOCK_MAX;
+				} else {
+					dev_dbg(&priv->pci_dev->dev,
+						"SMBus block read size is %d\n",
+						priv->len);
+				}
+				priv->data[-1] = priv->len;
+			}
+
 			if (priv->count < priv->len) {
 				priv->data[priv->count++] = inb(SMBBLKDAT(priv));
 

Context in your version of the driver will be somewhat different, but
you get the idea.

>  7) It has not been tested with smbus 'process call' transactions.

Can't test this either. Devices implementing these are quite rare.

> 
> If would be very helpful if somebody could help test on other chipsets, with
> a PEC device, or on additional BIOS that woudl be very helpful.
> 
> In the meantime, the interrupt behavior is only enabled on the Cougar Point,
> and even here, it can be completely disabled with the "Interrupt" feature like
> other advanced features of the driver.

Tested so far, successfully: ICH5, ICH7-M and ICH10. Tested and didn't
work: ICH3-M (but at least I tested there was no regression introduced
by your patches.)

I think it's time to respin this patch series with all the fixes I
suggested, unless you object to some of the non-critical changes. If
you don't have the time, just tell me and I can take care, if you don't
mind. I really would like to see this patch set go in kernel 3.6, which
means it should go into linux-next ASAP.

Thanks again,
-- 
Jean Delvare
