Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab2K0IpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:45:00 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:60405 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758315Ab2K0Io6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:44:58 -0500
From: Mathias LEBLANC <Mathias.LEBLANC@st.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>
Date: Tue, 27 Nov 2012 09:44:17 +0100
Subject: RE: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C KERNEL 3.x.x
Thread-Topic: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C KERNEL 3.x.x
Thread-Index: Ac3L/mJaN2XLnajoQX2YMQB5LUUw3gAefFKK
Message-ID: <35286B1AE75A7C47BFF0870081A31B4B3A9B501754@SAFEX1MAIL4.st.com>
References: <1353363322-2923-1-git-send-email-mathias.leblanc@st.com>,<20121126174632.GA12737@ennui.austin.ibm.com>
In-Reply-To: <20121126174632.GA12737@ennui.austin.ibm.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent,

What's version of the kernel do you compiled?
I don't understand why you have some problem with formating, i have send you the patch with no error and warning of code formating.
The tpm_continue_selftest_nocheck()  (in kernel 3.x.x) and tpm_continue_selftest() (in kernel 2.6.x) is called to have the tpm ready.
If the tpm_continue_selftest is not called by the driver, it will be use in the applications.

Regards,

Matthias Leblanc
________________________________________
From: Kent Yoder [key@linux.vnet.ibm.com]
Sent: 26 November 2012 18:46
To: Mathias LEBLANC
Cc: Rajiv Andrade; Marcel Selhorst; Sirrix AG; tpmdd-devel@lists.sourceforge.net; Debora Velarde; linux-kernel@vger.kernel.org; Jean-Luc BLANC
Subject: Re: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C KERNEL 3.x.x

Hi Mathias,

On Mon, Nov 19, 2012 at 11:15:21PM +0100, Mathias Leblanc wrote:
>  * STMicroelectronics version 1.2.0, Copyright (C) 2010
>  * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
>  * This is free software, and you are welcome to redistribute it
>  * under certain conditions.
>
> This is the driver for TPM chip from ST Microelectronics.
>
> If you have a TPM security chip from STMicroelectronics working with
> an I2C, in menuconfig or .config choose the tpm driver on
> device --> tpm and activate the protocol of your choice before compiling
> the kernel.
> The driver will be accessible from within Linux.
>
> Tested on linux x86/x64, beagleboard REV B & XM REV C and CHROMIUM OS
> on kernel 3.x.x
>
> Signed-off-by: Mathias Leblanc <mathias.leblanc@st.com>
> ---
>  drivers/char/tpm/tpm_stm_st33_i2c.c  |  903 ++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm_stm_st33_i2c.h  |   81 +++
>  include/linux/i2c/tpm_stm_st33_i2c.h |   47 ++
>  3 files changed, 1031 insertions(+)
>  create mode 100644 drivers/char/tpm/tpm_stm_st33_i2c.c
>  create mode 100644 drivers/char/tpm/tpm_stm_st33_i2c.h
>  create mode 100644 include/linux/i2c/tpm_stm_st33_i2c.h

  I'm still getting the compiler errors I mentioned earlier. I've fixed
them up with the patch below (plus some formatting), all except for the
tpm_continue_selftest_nocheck() problem. Do you really need to call
continue selftest on resume?  That strikes me as out of place here.
What's making the call to the TPM to start the self test in that case?

Please test with the patch below.

Thanks,
Kent


diff --git a/drivers/char/tpm/tpm_stm_st33_i2c.c b/drivers/char/tpm/tpm_stm_st33_i2c.c
index 52f3380..67f81b6 100644
--- a/drivers/char/tpm/tpm_stm_st33_i2c.c
+++ b/drivers/char/tpm/tpm_stm_st33_i2c.c
@@ -722,7 +722,7 @@ tpm_st33_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
                        goto _irq_set;

                intmask = TPM_GLOBAL_INT_ENABLE;
-               err = I2C_WRITE_DATA(client, TPM_INT_ENABLE + 3, &intmask, 1);
+               err = I2C_WRITE_DATA(client, (TPM_INT_ENABLE + 3), &intmask, 1);
                if (err < 0)
                        goto _irq_set;

@@ -820,10 +820,10 @@ static int tpm_st33_i2c_pm_suspend(struct i2c_client *client, pm_message_t mesg)

        if (power_mgt)
                gpio_set_value(pin_infos->io_lpcpd, 0);
-       else{
+       else {
                if (chip->data_buffer == NULL)
                        chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
-               ret = tpm_pm_suspend(&client->dev, mesg);
+               ret = tpm_pm_suspend(&client->dev);
        }
        return ret;
 }                              /* tpm_st33_i2c_suspend() */
@@ -848,12 +848,12 @@ static int tpm_st33_i2c_pm_resume(struct i2c_client *client)
                                          (chip->vendor.status(chip) &&
                                          TPM_STS_VALID) == TPM_STS_VALID,
                                          chip->vendor.timeout_b);
-       } else{
-       if (chip->data_buffer == NULL)
-               chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
-       ret = tpm_pm_resume(&client->dev);
-       if (!ret)
-               tpm_continue_selftest_nocheck(chip);
+       } else {
+               if (chip->data_buffer == NULL)
+                       chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
+               ret = tpm_pm_resume(&client->dev);
+               if (!ret)
+                       tpm_continue_selftest_nocheck(chip);
        }
        return ret;
 }                              /* tpm_st33_i2c_pm_resume() */
