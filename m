Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab2ECLS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 07:18:59 -0400
Received: from smtp2.infineon.com ([217.10.60.23]:12338 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab2ECLS5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 07:18:57 -0400
X-SBRS: None
From: <Peter.Huewe@infineon.com>
To: <andi.shyti@gmail.com>
CC: <srajiv@linux.vnet.ibm.com>, <tpmdd@selhorst.net>,
        <tpmdd-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <olof@lixom.net>, <semenzato@google.com>
Subject: RE: [PATCH] char/tpm: Add new driver for Infineon I2C TIS TPM
Thread-Topic: [PATCH] char/tpm: Add new driver for Infineon I2C TIS TPM
Thread-Index: AQHNKGwl7vDr/9zIikWIrFlF6QAG6pa2em2AgAEsXyA=
Date: Thu, 3 May 2012 11:18:54 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D440C5823@MUCSE501.eu.infineon.com>
References: <1335967293-7728-1-git-send-email-peter.huewe@infineon.com>
 <20120502151525.GC16981@andi>
In-Reply-To: <20120502151525.GC16981@andi>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.8.248]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

first of all thanks for the review! I really appreciate it.

If we can come up with solutions to improve the driver I'm more than happy to try them out.
For the moment, I still would appreciate if the driver gets merged in its current form and we do the (remaining) improvements later on,
as the driver is in heavy use for over a year now in Google Chromebooks.


> Why don't you use the i2c_smbus* family function to read/write
> from i2c. Everything you wrote here is already implemented there,
> this is just overcode.

The reason behind this is that the soft-i2c-tpm chip needs some special handling due to wake up, its "late acknowledge protocol" and unfortunately the not supported repeated start conditions, but let me explain a bit:

- No Repeated Starts:
We always have to send a stop bit to mark the end of a transfer, otherwise the tpm simply fails to respond. 
So in order to read e.g. the access register byte we have to send:
S 0x20 W 0x00 P
S 0x20 R .... P
Thus we cannot use i2c_smbus*read* functions.


- Wakeup behavior:
After a successful transfer the soft i2c tpm goes back to sleep. When something toggles the SCL line the tpm wakes up and after some time (~50us) we can talk to it.
The i2c_smbus_xfer function does not sleep in between and thus the retry count would be pretty high (and bus speed dependent) in order to reach the 50us.
This would probably cause a lot of traffic on the i2c bus.


- "late acknowledge protocol"
The device does not support clock stretching and simply NAKs any transmission if it is not ready.
e.g. in the read case, after receiving the 'register address' to be read it needs some time to process the register address and prepare the data for transmission.
This is similar to the wakeup behavior but the sleep time might be a lot higher in case of writing.


Unfortunately I don't see any better solution at the moment for the i2c related topics.
I do acknowledge that we could have used i2c_master_send/recv but that would have saved only two or three lines (the setup of the i2c_msg struct).



About your other remarks:
>> +{
>> +	int rc = -1;
> Haven't understood why here you are initializing -1
You're right this could have been done more elegantly. I'll probably clean this up in a separate patch.


>> +static int check_locality(struct tpm_chip *chip, int loc)
>> ...
>> +	return -1;
> Please choose a valid errno
This is the same behavior as in the original tpm_tis driver:
git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/char/tpm/tpm_tis.c;hb=HEAD#l101
These functions e.g. check_locality can probably be generalized and reused by all tpm drivers, but I don't want to mix this up with this driver submission.
For the moment I'd leave it as it is.


>> +static void release_locality(struct tpm_chip *chip, int loc, int force)
>> ...
>> +		iic_tpm_write(TPM_ACCESS(loc), &buf, 1);
> here you are ignoring the failure case

Same applies to release_locality  the semantics are the same in tpm_tis.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/char/tpm/tpm_tis.c;hb=HEAD#l111


The reason behind ignoring the error code is more or less that we rely on the underlying TIS Protocol.



>> +	if (iic_tpm_read(TPM_STS(chip->vendor.locality), &buf, 1) < 0)
> I think (but not sure) that this may upset
> ./scripts/checkpatch.pl
checkpatch.pl -strict did not complain about this. It emits only one over 80 characters warning, which is 81 characters long.



>> +#ifdef CONFIG_PM
> and what if CONFIG_PM is not defined?
Then we don't need suspend and resume functions ;)

> I think this should be done in the probe function. ...
> Still this should be done in the remove function. ...
> The correct way of doing this is by using module_i2c_driver()
 
This is a valid point. I simply wasn't aware of this - the driver was initially created (and submitted) back in April 2011 where this macro did not yet exist.
I'd do a cleanup afterwards, probably with adding the probe/remove functionality - but I don't think it's a blocking point for the submission?


Thanks,
Peter

Infineon Technologies AG 
CCS TI SWT SW ESW
Tel: 	+49 821 25851-86
Fax: 	+49 821 25851-40

Peter.Huewe@infineon.com

****VISIT US AT: www.infineon.com *****
Infineon Technologies AG 
Vorsitzender des Aufsichtsrats: Wolfgang Mayrhuber 
Vorstand: Peter Bauer (Vorsitzender), Dominik Asam, Arunjai Mittal, Dr. Reinhard Ploss 
Sitz der Gesellschaft: Neubiberg 

Registergericht: München HRB 126492





