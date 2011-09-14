Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888Ab1INWdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 18:33:15 -0400
Received: from mail-gw0-f52.google.com ([74.125.83.52]:63884 "EHLO
	mail-gw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab1INWdN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 18:33:13 -0400
MIME-Version: 1.0
In-Reply-To: <4E7086F0.8050009@codeaurora.org>
References: <1315029042-27513-1-git-send-email-martinez.javier@gmail.com>
 <1315029042-27513-2-git-send-email-martinez.javier@gmail.com> <4E7086F0.8050009@codeaurora.org>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Thu, 15 Sep 2011 00:32:58 +0200
Message-ID: <CAAwP0s1A4EMOBYTeEVg2WFYKnf6e+LfU2Sg_wwf7TLtjqXZBXQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/3] Input: cyttsp - Cypress TTSP capacitive
 multi-touch screen support
To: Mohan Pallaka <mpallaka@codeaurora.org>
Cc: Kevin McNeely <kev@cypress.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 12:50 PM, Mohan Pallaka <mpallaka@codeaurora.org> wrote:
>  Hi Javier,
>
> Please find my review comments.
>

Hello Mohan,

Thank you very much for the review and your comments.

> On 9/3/2011 11:20 AM, Javier Martinez Canillas wrote:
>> +
>> +struct cyttsp {
>> +       struct device *dev;
>> +       int irq;
>> +       struct input_dev *input;
>> +       char phys[32];
>> +       const struct bus_type *bus_type;
>
> Do we need to know the bus type? Rest of the code doesn't seem to
> be using this information.

You are right, will remove it.

>> +
>> +static int ttsp_write_block_data(struct cyttsp *ts, u8 command,
>> +       u8 length, void *buf)
>> +{
>> +       int retval;
>> +       if (!buf || !length)
>> +               return -EINVAL;
>> +
>> +       retval = ts->bus_ops->write(ts->bus_ops, command, length, buf);
>> +       if (retval)
>> +               msleep(CY_DELAY_DFLT);
>
> Don't we need to retry if write fails?

Yes, I'll add the retry logic also to ttsp_write_block_data().

>> +
>> +static int cyttsp_set_operational_mode(struct cyttsp *ts)
>> +{
>> +       struct cyttsp_xydata xy_data;
>> +       int retval;
>> +       int tries;
>> +       u8 cmd = CY_OPERATE_MODE;
>> +
>> +       retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd),&cmd);
>> +
>> +       if (retval<  0)
>> +               return retval;
>> +
>> +       /* wait for TTSP Device to complete switch to Operational mode */
>> +       tries = 0;
>> +       do {
>> +               msleep(CY_DELAY_DFLT);
>> +               retval = ttsp_read_block_data(ts, CY_REG_BASE,
>> +                       sizeof(xy_data),&(xy_data));
>> +       } while (!((retval == 0)&&
>> +               (xy_data.act_dist == CY_ACT_DIST_DFLT))&&
>
> what is the need for this check,"xy_data.act_dist == CY_ACT_DIST_DFLT"?
> we can pass a different value for act_dist from pdata. Another point to
> concerns me
> is that in case of i2c/spi failures "ttsp_read_block_data" will it self try
> for NUM_TRY
> and this particular code block tries till CY_DELAY_MAX, I think we are
> overdoing
> in this case.  How about keeping the "ttsp_read_block_dat" simple and let
> the
> code that uses do the retry job.

Yes, there are too many msleep() and retry here, will clean this code
and let ttsp_read_block_data() do the retry.

>> +
>> +static irqreturn_t cyttsp_irq(int irq, void *handle)
>> +{
>> +       struct cyttsp *ts = handle;
>> +       int retval;
>> +
>> +       if (ts->power_state == CY_BL_STATE)
>> +               complete(&ts->bl_ready);
>> +       else {
>> +               /* process the touches */
>> +               retval = cyttsp_xy_worker(ts);
>
> can we have a different name than cyttsp_xy_worker as we can misinterpret as
> a workqueue,
> like cyttsp_handle_tchdata. Also, we seem to be doing good amount of work in
> this function,
> how about deferring it to a workqueue to make irq handler fast to not to
> miss any irqs.

Yes, your are right worker sounds like a workqueue. Will change the
name of the handler function.

Well cyttsp_xy_worker() is calling from cyttsp_irq() which is
initialized has a threaded irq with request_threaded_irq(). I thought
it was the way to go for new drivers, isn't using a workqueue inside a
threaded irq overkill?

>> +
>> +#ifdef CONFIG_PM
>> +int cyttsp_resume(void *handle)
>> +{
>> +       struct cyttsp *ts = handle;
>
> "handle" is passed from a different path, so it is possible to be a "NULL"
> which
> could crash the machine. so I think we can have an extra check here like you
> did for core_release.

Ok, will add the check.

>>
>> +       int retval = 0;
>> +       struct cyttsp_xydata xydata;
>> +
>> +       if (ts->platform_data->use_sleep&&  (ts->power_state !=
>> +               CY_ACTIVE_STATE)) {
>> +               if (ts->platform_data->wakeup) {
>> +                       retval = ts->platform_data->wakeup();
>> +                       if (retval<  0)
>> +                               dev_dbg(ts->dev, "%s: Error, wakeup
>> failed!\n",
>> +                                       __func__);
>> +               } else {
>> +                       dev_dbg(ts->dev, "%s: Error, wakeup not
>> implemented "
>> +                               "(check board file).\n", __func__);
>> +                       retval = -ENOSYS;
>> +               }
>> +               if (!(retval<  0)) {
>> +                       retval = ttsp_read_block_data(ts, CY_REG_BASE,
>> +                               sizeof(xydata),&xydata);
>> +                       if (!(retval<  0)&&
>>  !GET_HSTMODE(xydata.hst_mode))
>> +                               ts->power_state = CY_ACTIVE_STATE;
>
> I think we need to have a error msg when it fails to resume. Also, say after
> resume if it goes to
> "bootloader"(which happens when the chip is reset) mode then touch will not
> work. So, we
> can get it out of the bootloader mode in cyttsp_xy_worker as interrupts are
> fired even in bootloader
> mode.

Yes, will add the error msg and add the logic in the irq handler to go
out from bootloader mode.

>> +
>> +int cyttsp_suspend(void *handle)
>> +{
>> +       struct cyttsp *ts = handle;
>> +       u8 sleep_mode = 0;
>> +       int retval = 0;
>> +
>> +       if (ts->platform_data->use_sleep&&
>> +               (ts->power_state == CY_ACTIVE_STATE)) {
>> +               sleep_mode = CY_DEEP_SLEEP_MODE;
>> +               retval = ttsp_write_block_data(ts,
>> +                       CY_REG_BASE, sizeof(sleep_mode),&sleep_mode);
>> +               if (!(retval<  0))
>> +                       ts->power_state = CY_SLEEP_STATE;
>> +       }
>> +       dev_dbg(ts->dev, "%s: Sleep Power state is %s\n", __func__,
>> +               (ts->power_state == CY_ACTIVE_STATE) ?
>> +               "ACTIVE" :
>> +               ((ts->power_state == CY_SLEEP_STATE) ?
>> +               "SLEEP" : "LOW POWER"));
>
> This code will not let the chip to go to low power mode since we are setting
> CY_DEEP_SLEEP_MODE directly. So, lets use platform_data's "use_sleep" flag
> to
> determine if we want to go to deep sleep or low power mode.

Ok, will change to check platform_data's to take the decision.


>> +
>> +       if (input_register_device(input_device)) {
>
> Please avoid this style of check, we will not know why it is failed.

Ok, will get the error value to know what happened.

>>
>> +               dev_dbg(ts->dev, "%s: Error, failed to register input
>> device\n",
>> +                       __func__);
>> +               goto error_input_register_device;
>> +       }
>> +
>> +       goto no_error;
>> +
>> +error_input_register_device:
>> +       input_unregister_device(input_device);
>
> Here we should use input_free_device() rather than unregister since it
> failed in
> registration.

Ok, will use input_free_device() instead.

>
> --Mohan.
>
> --
> Sent by a consultant of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
> Forum.
>
>
>

Again, thank you very much for taking the time to look at the code and
for your suggestions. Will work on this and resend.

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
