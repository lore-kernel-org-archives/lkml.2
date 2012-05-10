Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2EJGtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 02:49:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59663 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578Ab2EJGtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 02:49:10 -0400
Date: Thu, 10 May 2012 08:49:04 +0200
From: Andi Shyti <andi.shyti@gmail.com>
To: Peter.Huewe@infineon.com
Cc: srajiv@linux.vnet.ibm.com, tpmdd@selhorst.net,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        olof@lixom.net, semenzato@google.com
Subject: Re: [PATCH] char/tpm: Add new driver for Infineon I2C TIS TPM
Message-ID: <20120510064904.GA2493@andi>
Mail-Followup-To: Peter.Huewe@infineon.com, srajiv@linux.vnet.ibm.com,
	tpmdd@selhorst.net, tpmdd-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, olof@lixom.net, semenzato@google.com
References: <1335967293-7728-1-git-send-email-peter.huewe@infineon.com>
 <20120502151525.GC16981@andi>
 <74A44E99E3274B4CB570415926B37D440C5823@MUCSE501.eu.infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74A44E99E3274B4CB570415926B37D440C5823@MUCSE501.eu.infineon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

sorry for the delay, finally I got some time to reply :)

On Thu, May 03, 2012 at 11:18:54AM +0000, Peter.Huewe@infineon.com wrote:
> Hi Andi,
> 
> first of all thanks for the review! I really appreciate it.

You're welcome, I hope it helps :)

> If we can come up with solutions to improve the driver I'm more than happy to try them out.
> For the moment, I still would appreciate if the driver gets merged in its current form and we do the (remaining) improvements later on,
> as the driver is in heavy use for over a year now in Google Chromebooks.
> 
> 
> > Why don't you use the i2c_smbus* family function to read/write
> > from i2c. Everything you wrote here is already implemented there,
> > this is just overcode.
> 
> The reason behind this is that the soft-i2c-tpm chip needs some special handling due to wake up, its "late acknowledge protocol" and unfortunately the not supported repeated start conditions, but let me explain a bit:
> 
> - No Repeated Starts:
> We always have to send a stop bit to mark the end of a transfer, otherwise the tpm simply fails to respond. 
> So in order to read e.g. the access register byte we have to send:
> S 0x20 W 0x00 P
> S 0x20 R .... P
> Thus we cannot use i2c_smbus*read* functions.
> 
> 
> - Wakeup behavior:
> After a successful transfer the soft i2c tpm goes back to sleep. When something toggles the SCL line the tpm wakes up and after some time (~50us) we can talk to it.
> The i2c_smbus_xfer function does not sleep in between and thus the retry count would be pretty high (and bus speed dependent) in order to reach the 50us.
> This would probably cause a lot of traffic on the i2c bus.
> 
> 
> - "late acknowledge protocol"
> The device does not support clock stretching and simply NAKs any transmission if it is not ready.
> e.g. in the read case, after receiving the 'register address' to be read it needs some time to process the register address and prepare the data for transmission.
> This is similar to the wakeup behavior but the sleep time might be a lot higher in case of writing.
> 
> 
> Unfortunately I don't see any better solution at the moment for the i2c related topics.
> I do acknowledge that we could have used i2c_master_send/recv but that would have saved only two or three lines (the setup of the i2c_msg struct).

I understand, we had already a lively discussion on the other
patch on this driver about that.
I underlined there that personally I don't like code which is
written twice.
Which is exactly the i2c driver that you are using?
Do you think it could clean up the driver if you add to this bus
the smbus_xfer functions? At the end is a chip issue, not a
driver, so that implementing this function could help all the
device drivers that are using this chip.

> About your other remarks:
> >> +{
> >> +	int rc = -1;
> > Haven't understood why here you are initializing -1
> You're right this could have been done more elegantly. I'll probably clean this up in a separate patch.
> 
> 
> >> +static int check_locality(struct tpm_chip *chip, int loc)
> >> ...
> >> +	return -1;
> > Please choose a valid errno
> This is the same behavior as in the original tpm_tis driver:
> git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/char/tpm/tpm_tis.c;hb=HEAD#l101
> These functions e.g. check_locality can probably be generalized and reused by all tpm drivers, but I don't want to mix this up with this driver submission.
> For the moment I'd leave it as it is.

OK, but bear in mind '-1' is an awful error code :)

> >> +static void release_locality(struct tpm_chip *chip, int loc, int force)
> >> ...
> >> +		iic_tpm_write(TPM_ACCESS(loc), &buf, 1);
> > here you are ignoring the failure case
> 
> Same applies to release_locality  the semantics are the same in tpm_tis.
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/char/tpm/tpm_tis.c;hb=HEAD#l111
> 
> 
> The reason behind ignoring the error code is more or less that we rely on the underlying TIS Protocol.

OK, but considering failures is never enough. If you will correct
this patch later on, it could be nice to consider every failure.
In my opinion who writes drivers should never rely 100% on the
above and below layers.

> >> +	if (iic_tpm_read(TPM_STS(chip->vendor.locality), &buf, 1) < 0)
> > I think (but not sure) that this may upset
> > ./scripts/checkpatch.pl
> checkpatch.pl -strict did not complain about this. It emits only one over 80 characters warning, which is 81 characters long.

I like to pander to checkpatch.pl, it's always better to have 0
error and 0 warnings

> >> +#ifdef CONFIG_PM
> > and what if CONFIG_PM is not defined?
> Then we don't need suspend and resume functions ;)

I think that considering the case that CONFIG_PM is not defined
could be a good use, something like

#ifdef CONFIG_PM

[...]

#else

[...] <--- here you can define the functions as null

#endif

this because, if in the future someone else will like to use
embedded in the code the power management functions can do it
easily without adding extra #ifdefs which pollute the code.

> > I think this should be done in the probe function. ...
> > Still this should be done in the remove function. ...
> > The correct way of doing this is by using module_i2c_driver()
>  
> This is a valid point. I simply wasn't aware of this - the driver was initially created (and submitted) back in April 2011 where this macro did not yet exist.
> I'd do a cleanup afterwards, probably with adding the probe/remove functionality - 

Yes, it's true the modle_i2c_driver is quite new as a define. In
order to use this macro definition, you should make all your
initialization in the probe function. The reason behind this is
that the module_i2c_driver, in his long queue of function calls,
comes across the probe, if the probe failes for some reasons,
then the kernel is able to manage it.
While if you make all the initializations on the __init function,
then is like cheating somehow.

> but I don't think it's a blocking point for the submission?

I don't know, I'm a reviewer by chance, this is up to the
maintainers. For sure the driver works, but I think that there is
still room for some improvements.

Andi
