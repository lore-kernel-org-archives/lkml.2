Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1IBOr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 10:47:56 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:60547 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab1IBOrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 10:47:53 -0400
Message-ID: <4E60EC61.4030004@linux.vnet.ibm.com>
Date: Fri, 02 Sep 2011 11:46:57 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Christophe Henri RICARD <christophe-h.ricard@st.com>
CC: Mohamed TABET <mohamed.tabet@st.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, "joe@perches.com" <joe@perches.com>,
        matt mooney <mfm@muteddisk.com>, Sean NEWTON <sean.newton@st.com>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>
Subject: Re: [PATCH 1/1] TPM: new stm i2c device driver
References: <0B9F1C5B86169C4EA9D042C251022E491060F260A1@SAFEX1MAIL3.st.com> <0B9F1C5B86169C4EA9D042C251022E4922E010E857@SAFEX1MAIL3.st.com> <8F888FAFF364DD4D9683684315E0207DD25D1F05CC@SAFEX1MAIL3.st.com> <4E569A0F.40601@linux.vnet.ibm.com> <0B9F1C5B86169C4EA9D042C251022E4922E010E8E0@SAFEX1MAIL3.st.com>
In-Reply-To: <0B9F1C5B86169C4EA9D042C251022E4922E010E8E0@SAFEX1MAIL3.st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
x-cbid: 11090214-2362-0000-0000-000004B43634
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25-08-2011 16:05, Christophe Henri RICARD wrote:
> The 1/3 was placed by accident. I did reply on this one to make sure everybody would be able to do the follow up.
> Just did the correction.
The ideal would be you submitting another one, that applies on top of 
James' security-testing-2.6 tree.

Also, make sure you run scripts/checkpatch.pl over it before 
submitting, its result so far:

total: 991 errors, 287 warnings, 882 lines checked

The code doesn't have a single tab, only spaces. Not sure if it was due 
a mail client configuration, if so take a look at Documentation/email-clients.txt, 
if that wasn't the case, make sure you run scripts/Lindent over you code prior to 
posting it.

What does st9 in the driver's name stand for? Please rename it to tpm_stm_i2c.

More comments below:

> Thanks
> Christophe
>>>> +
>>>> +#define TPM_STS_DATA_AVAIL 0x10
This one and..
>> TPM_STS_ACCEPT_COMMAND)
>>>> +enum tis_defaults {
>>>> +     TIS_SHORT_TIMEOUT = 750,        /* ms */
>>>> +     TIS_LONG_TIMEOUT = 2000,        /* 2 sec */
>>>> +};
>>>> +
... these values are in the tpm_tis.c already, given there's now more drivers using it, they
should be moved to tpm.h then and not get defined again.
>>>> +/*
>>>> + * gpio_readpin is a wrapper to read a gpio value.
>>>> + * Use generic gpio APIs
>>>> + * @param: pin_id, the pin identifier where the value will be read.
>>>> + * @return: the gpio value (should be 0 or 1) or negative errno
>>>> + */
>>>> +static int gpio_readpin(int pin_id)
>>>> +{
>>>> +     int ret;
>>>> +     ret = gpio_direction_input(pin_id);
>>>> +     if (ret == 0)
>>>> +             return gpio_get_value(pin_id);
>>>> +     return ret;
>>>> +}
>>>> +
>>>> +/*
>>>> + * tpm_stm_i2c_status is not implemented because TIS registers are not implemented.
>>>> + */
>>>> +static u8 tpm_stm_i2c_status(struct tpm_chip *chip)
>>>> +{
>>>> +     u8 state_data, state_command;
>>>> +
>>>> +     state_data = gpio_readpin(pin_infos->data_avail_pin);
>>>> +     state_command = gpio_readpin(pin_infos->accept_pin);
>>>> +     return (state_data << 4) | state_command;
>>>> +}
>>>> +
>>>> +static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>>>> +                      wait_queue_head_t *queue)
Sounds a copy & paste issue here, but *queue isn't being used here.
>>>> +{
>>>> +     unsigned long stop;
>>>> +     u8 status;
>>>> +
>>>> +     FUNC_ENTER();
>>>> +
>>>> +     /* check current status */
>>>> +     status = tpm_stm_i2c_status(chip);
>>>> +     if (status == mask)
>>>> +             return 0;
>>>> +     if (status == TPM_STS_CANCEL)
>>>> +             goto end;
>>>> +     stop = jiffies + timeout;
>>>> +     do {
>>>> +             msleep(TPM_TIMEOUT);
>>>> +             status = tpm_stm_i2c_status(chip);
>>>> +             if ((status & mask) == mask)
>>>> +                     return 0;
>>>> +     } while (time_before(jiffies, stop));
>>>> +end:
>>>> +     return -ETIME;
>>>> +}
>>>> +
This is very similar to what's in tpm_tis.c, given there's one more user for it now, it's a good time
to move it to tpm.c and provide it tpm_stm_i2c_status or tpm_tis_status as a function pointer.
>>>> +/*
>>>> + * tpm_st19_i2c_ioctl provides 2 handles:
>>>> + * - TPMIOC_CANCEL: allow to CANCEL a TPM commands execution.
>>>> + *   See tpm_stm_i2c_cancel description above
>>>> + * - TPMIOC_TRANSMIT: allow to transmit a TPM commands.
>>>> + *
>>>> + * @return: In case of success, return TPM response size.
>>>> + * In other case return < 0 value describing the issue.
>>>> + */
>>>> +/*#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 36)
>>>> +static ssize_t tpm_st19_i2c_ioctl(struct inode *inode, struct file
>>>> *file,
>>>> +                               unsigned int cmd, unsigned long arg)
>>>> +#else*/
>>>> +static long tpm_st19_i2c_unlocked_ioctl(struct file *file,
>>>> +                                     unsigned int cmd, unsigned long arg)
Please remove the commented ifdef logic.
>>>> +/*#endif*/
>>>> +{
>>>> +     int in_size = 0, out_size = 0, ret = -ENOTTY;
>>>> +     struct tpm_chip *chip = file->private_data;
>>>> +
>>>> +     lock_kernel();
>>>> +     switch (cmd) {
>>>> +     case TPMIOC_CANCEL:
>>>> +             tpm_stm_i2c_cancel(chip);
>>>> +             ret = -ENOSYS;
>>>> +             break;
>>>> +     case TPMIOC_TRANSMIT:
>>>> +             if (copy_from_user(chip->data_buffer,
>>>> +                                (const char *)arg,
>> TPM_HEADER_SIZE)) {
>>>> +                     ret = -EFAULT;
>>>> +                     break;
>>>> +             }
>>>> +
>>>> +             in_size = be32_to_cpu(*(__be32 *) (chip->data_buffer +
>> 2));
>>>> +             if (copy_from_user(chip->data_buffer,
>>>> +                                (const char *)arg, in_size)) {
>>>> +                     ret = -EFAULT;
>>>> +                     break;
>>>> +             }
>>>> +
>>>> +             tpm_stm_i2c_send(chip, chip->data_buffer, in_size);
>>>> +
>>>> +             out_size = tpm_stm_i2c_recv(chip, chip->data_buffer,
>>>> +                                         TPM_BUFSIZE);
>>>> +             if (copy_to_user((char *)arg, chip->data_buffer,
>> out_size))
>>>> {
>>>> +                     ret = -EFAULT;
>>>> +                     break;
>>>> +             }
>>>> +             ret = out_size;
>>>> +             break;
>>>> +     }
>>>> +     unlock_kernel();
>>>> +     return ret;
>>>> +}
>>>> +
>>>> +static const struct file_operations tpm_st19_i2c_fops = {
>>>> +     .owner = THIS_MODULE,
>>>> +     .llseek = no_llseek,
>>>> +     .read = tpm_read,
>>>> +
>>>> +     /*#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 36)
>>>> +        .ioctl = tpm_st19_i2c_ioctl,
>>>> +        #else */
>>>> +     .unlocked_ioctl = tpm_st19_i2c_unlocked_ioctl,
>>>> +     /*#endif */
Same here.

Rajiv

