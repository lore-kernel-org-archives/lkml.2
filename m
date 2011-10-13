Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1JMWch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 18:32:37 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47720 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab1JMWcf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 18:32:35 -0400
MIME-Version: 1.0
In-Reply-To: <20111013180319.GA2308@polaris.bitmath.org>
References: <1318099080-26227-1-git-send-email-martinez.javier@gmail.com>
 <1318099080-26227-2-git-send-email-martinez.javier@gmail.com> <20111013180319.GA2308@polaris.bitmath.org>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Fri, 14 Oct 2011 00:32:15 +0200
Message-ID: <CAAwP0s0SZvWra5p0E4wuNrVrfPGEsWjnrNTAPBO+6dsVym2iDg@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] Input: cyttsp - Cypress TTSP capacitive
 multi-touch screen support
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mohan Pallaka <mpallaka@codeaurora.org>,
        Kevin McNeely <kev@cypress.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 8:03 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Javier,
>
> some more comments on the code. Presumable Dmitry will have additional
> ones later on. Thank you for your patience.
>

Hi Henrik,

Thank for your patience. Sorry for all the iterations.

>> +/* Slots management */
>> +#define CY_MAX_FINGER               4
>> +#define CY_MAX_ID                   15
>
> I realize the firmware reports ids in the range [1..14], but it is not
> visible from the code. Allowing all 16 values makes correctness
> obvious.
>

Ok, I'll change to: #define CY_MAX_ID 16.

>> +static int cyttsp_load_bl_regs(struct cyttsp *ts)
>> +{
>> +     int retval;
>> +
>> +     memset(&(ts->bl_data), 0, sizeof(struct cyttsp_bootloader_data));
>> +
>> +     ts->bl_data.bl_status = 0x10;
>> +
>> +     retval =  ttsp_read_block_data(ts, CY_REG_BASE,
>> +             sizeof(ts->bl_data), &(ts->bl_data));
>> +
>> +     return retval;
>> +}
>
> Looks like you missed the removal of retval here.
>

Yes, sorry. I'll change to return ttsp_read_block_data() so I can get
rid of the retval here.

>> +
>> +static int cyttsp_bl_app_valid(struct cyttsp *ts)
>> +{
>> +     int retval;
>> +
>> +     retval = cyttsp_load_bl_regs(ts);
>> +
>> +     if (retval < 0) {
>> +             retval = -ENODEV;
>> +             goto done;
>> +     }
>> +
>> +     if (GET_BOOTLOADERMODE(ts->bl_data.bl_status)) {
>> +             if (IS_VALID_APP(ts->bl_data.bl_status)) {
>> +                     dev_dbg(ts->dev, "%s: App found; normal boot\n",
>> +                             __func__);
>> +                     return 0;
>> +             } else {
>> +                     dev_dbg(ts->dev, "%s: NO APP; load firmware!!\n",
>> +                             __func__);
>> +                     return -ENODEV;
>> +             }
>> +     }
>> +
>> +     if (GET_HSTMODE(ts->bl_data.bl_file) == CY_OPERATE_MODE) {
>> +             if (!(IS_OPERATIONAL_ERR(ts->bl_data.bl_status))) {
>> +                     dev_dbg(ts->dev, "%s: Operational\n",
>> +                             __func__);
>> +                     return 1;
>> +             } else {
>> +                     dev_dbg(ts->dev, "%s: Operational failure\n",
>> +                             __func__);
>> +                     return -ENODEV;
>> +             }
>> +     }
>> +
>> +     dev_dbg(ts->dev, "%s: Non-Operational failure\n",
>> +             __func__);
>> +     retval = -ENODEV;
>> +done:
>> +     return retval;
>> +
>> +}
>
> Are the debug paths still necessary? There are a lot of them.
>

No I think there are not necessary any more, I'll remove them. It will
make the code cleaner.

>> +static int cyttsp_exit_bl_mode(struct cyttsp *ts)
>> +{
>> +     int retval;
>> +     int tries;
>> +     u8 bl_cmd[sizeof(bl_command)];
>> +
>> +     memcpy(bl_cmd, bl_command, sizeof(bl_command));
>> +     if (ts->platform_data->bl_keys)
>> +             memcpy(&bl_cmd[sizeof(bl_command) - CY_NUM_BL_KEYS],
>> +                     ts->platform_data->bl_keys, sizeof(bl_command));
>> +
>> +     dev_dbg(ts->dev,
>> +             "%s: bl_cmd= "
>> +             "%02X %02X %02X %02X %02X %02X %02X %02X %02X %02X %02X\n",
>> +             __func__, bl_cmd[0], bl_cmd[1], bl_cmd[2],
>> +             bl_cmd[3], bl_cmd[4], bl_cmd[5], bl_cmd[6],
>> +             bl_cmd[7], bl_cmd[8], bl_cmd[9], bl_cmd[10]);
>> +
>> +     retval = ttsp_write_block_data(ts, CY_REG_BASE,
>> +             sizeof(bl_cmd), (void *)bl_cmd);
>> +     if (retval < 0)
>> +             return retval;
>> +
>> +     /* wait for TTSP Device to complete switch to Operational mode */
>> +     tries = 0;
>> +     do {
>> +             msleep(CY_DELAY_DFLT);
>> +             retval = cyttsp_load_bl_regs(ts);
>> +     } while (!((retval == 0) &&
>> +             !GET_BOOTLOADERMODE(ts->bl_data.bl_status)) &&
>> +             (tries++ < CY_DELAY_MAX));
>> +
>> +     dev_dbg(ts->dev, "%s: check bl ready tries=%d ret=%d stat=%02X\n",
>> +             __func__, tries, retval, ts->bl_data.bl_status);
>> +
>> +     if (retval < 0)
>> +             return retval;
>> +     else if (GET_BOOTLOADERMODE(ts->bl_data.bl_status))
>> +             return -ENODEV;
>> +     else
>> +             return 0;
>> +}
>
> Regardless of if it can ever happen, programatically the (retval > 0)
> && GET_BOOTLOADERMODE(ts->bl_data.bl_status) case is slipping through here.
>

Good question. I think it can happen if the read succeed and the
device is still in bootloader mode. But I don't know the hardware
enough to confirm that.

Kevin?

>> +static int cyttsp_set_operational_mode(struct cyttsp *ts)
>> +{
>> +     struct cyttsp_xydata xy_data;
>> +     int retval;
>> +     int tries;
>> +     u8 cmd = CY_OPERATE_MODE;
>> +
>> +     retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd), &cmd);
>> +
>> +     if (retval < 0)
>> +             return retval;
>> +
>> +     /* wait for TTSP Device to complete switch to Operational mode */
>> +     tries = 0;
>> +     do {
>> +             retval = ttsp_read_block_data(ts, CY_REG_BASE,
>> +                     sizeof(xy_data), &(xy_data));
>> +     } while (!((retval == 0) &&
>> +             (xy_data.act_dist == CY_ACT_DIST_DFLT)) &&
>> +             (tries++ < CY_DELAY_MAX));
>> +
>> +     dev_dbg(ts->dev, "%s: check op ready tries=%d ret=%d dist=%02X\n",
>> +             __func__, tries, retval, xy_data.act_dist);
>> +
>> +     return retval;
>> +}
>
> So (xy_data.act_dist == CY_ACT_DIST_DFL) here is not an error?
>

Yes, it is. I'll add the check to report accordingly.

>> +static int cyttsp_set_sysinfo_mode(struct cyttsp *ts)
>> +{
>> +     int retval;
>> +     int tries;
>> +     u8 cmd = CY_SYSINFO_MODE;
>> +
>> +     memset(&(ts->sysinfo_data), 0, sizeof(struct cyttsp_sysinfo_data));
>> +
>> +     /* switch to sysinfo mode */
>> +     retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd), &cmd);
>> +     if (retval < 0)
>> +             return retval;
>> +
>> +     /* read sysinfo registers */
>> +     tries = 0;
>> +     do {
>> +             msleep(CY_DELAY_DFLT);
>> +             retval = ttsp_read_block_data(ts, CY_REG_BASE,
>> +                     sizeof(ts->sysinfo_data), &(ts->sysinfo_data));
>> +     } while (!((retval == 0) &&
>> +             !((ts->sysinfo_data.tts_verh == 0) &&
>> +             (ts->sysinfo_data.tts_verl == 0))) &&
>> +             (tries++ < CY_DELAY_MAX));
>
> Expands to (retval ||  !ts->sysinfo_data.tts_verh &&
> !ts->sysinfo_data.tts_verl) && (tries++ < CY_DELAY_MAX), which seems a
> bit simpler to me. Also, &ts->sysinfo_data could be a pointer here.
>

Yes, it is simpler. Will change it.

> Coding verh+verl as a 16-bit value?
>
> Are the timeouted (tries >= CY_DELAY_MAX) cases not errors here either?
>

Yes, we should report that also.

> <snip>
>
>> +static int cyttsp_soft_reset(struct cyttsp *ts)
>> +{
>> +     int retval;
>> +     u8 cmd = CY_SOFT_RESET_MODE;
>> +     long wait_jiffies = msecs_to_jiffies(CY_DELAY_DFLT * CY_DELAY_MAX);
>> +     /* wait for interrupt to set ready completion */
>> +     INIT_COMPLETION(ts->bl_ready);
>> +
>> +     retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd), &cmd);
>> +     if (retval < 0)
>> +             return retval;
>> +
>> +     retval = wait_for_completion_timeout(&ts->bl_ready, wait_jiffies);
>> +
>> +     if (retval > 0)
>> +             retval = 0;
>
> Seems this one slipped.
>

What cleanup do you want me to do here? Remove the last retval? or
there is some problem with the completion logic?

>> +
>> +     return retval;
>> +}
>> +
>> +static int cyttsp_hndshk(struct cyttsp *ts, u8 hst_mode)
>> +{
>> +     int retval;
>> +     u8 cmd;
>> +
>> +     cmd = hst_mode & CY_HNDSHK_BIT ?
>> +             hst_mode ^ CY_HNDSHK_BIT :
>> +             hst_mode | CY_HNDSHK_BIT;
>
> Whoa, please redo this one correctly.
>

Ok, I just realized that what you meant:

cmd = hst_mode ^ CY_HNDSHK_BIT;

is logically equivalent. Sorry for the mess with binary operators.

>> +
>> +     retval = ttsp_write_block_data(ts, CY_REG_BASE,
>> +             sizeof(cmd), (u8 *)&cmd);
>> +
>> +     return retval;
>> +}
>

Same here, will get rid of the retval with return ttsp_write_block_data().

>> +int cyttsp_resume(void *handle)
>> +{
>> +     struct cyttsp *ts = handle;
>> +     int retval = 0;
>> +     struct cyttsp_xydata xydata;
>> +
>> +     if (ts) {
>
> Neater if returning on (!ts) here instead.
>

Yes, will change that.

>> +             if (ts->platform_data->use_sleep && (ts->power_state !=
>> +                                                  CY_ACTIVE_STATE)) {
>> +                     if (ts->platform_data->wakeup) {
>> +                             retval = ts->platform_data->wakeup();
>> +                             if (retval < 0)
>> +                                     dev_dbg(ts->dev, "%s: Error, wakeup failed!\n",
>> +                                             __func__);
>> +                     } else {
>> +                             dev_dbg(ts->dev, "%s: Error, wakeup not implemented "
>> +                                     "(check board file).\n", __func__);
>> +                             retval = -ENOSYS;
>> +                     }
>> +                     if (!(retval < 0)) {
>> +                             retval = ttsp_read_block_data(ts, CY_REG_BASE,
>> +                                                           sizeof(xydata),
>> +                                                           &xydata);
>> +                             if (!(retval < 0) &&
>> +                                 !GET_HSTMODE(xydata.hst_mode))
>> +                                     ts->power_state = CY_ACTIVE_STATE;
>> +                     }
>> +             }
>> +             dev_dbg(ts->dev, "%s: Wake Up %s\n", __func__,
>> +                     (retval < 0) ? "FAIL" : "PASS");
>> +     }
>> +     return retval;
>> +}
>> +EXPORT_SYMBOL_GPL(cyttsp_resume);
>
> Thanks.
> Henrik
>

I'll fix these issues and resend in the next days. Thank you very much
for your time to review.

I'm new in kernel dev and it seems I'm still lacking "good taste" to
code, but I hope I'll get there :-)

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
