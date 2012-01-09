Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381Ab2AIUlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 15:41:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43304 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933151Ab2AIUlV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 15:41:21 -0500
MIME-Version: 1.0
X-Originating-IP: [79.157.135.38]
In-Reply-To: <20120109173523.GA5613@polaris.bitmath.org>
References: <1325722586-12886-1-git-send-email-javier@dowhile0.org>
	<1325722586-12886-2-git-send-email-javier@dowhile0.org>
	<20120109173523.GA5613@polaris.bitmath.org>
Date: Mon, 9 Jan 2012 21:41:20 +0100
Message-ID: <CABxcv==QfPnXgBLjFLxQmpWRGRDPE11aP8xMGsMbh-dJBVtQjQ@mail.gmail.com>
Subject: Re: [PATCH v8 1/3] Input: cyttsp - Cypress TTSP capacitive
 multi-touch screen support
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mohan Pallaka <mpallaka@codeaurora.org>,
        Kevin McNeely <kev@cypress.com>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 6:35 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>
> Hi Javier,
>
> > Changes for v8:
> >     Dmitry Torokhov (9):
> >     - Fix use-after-free in cyttsp_release
> >     - Remove ext() method from bus ops
> >     - Move up into main touchscreen directory
> >     - Rework Kconfig entries
> >     - Guard PM methods with CONFIG_PM_SLEEP
> >     - Device does not belong in bus structure
> >     - Set up bus type in input device
> >     - Use unified structure for ts object
> >     - Consolidate PM methods
> >
> >     Javier Martinez Canillas (5):
> >     - Add <linux/device.h> macro to cyttsp_core.h
> >     - Soft reset returns negative on error, not 0
> >     - Use CY_NUM_RETRY instead of CY_DELAY_MAX for retries
> >     - Add suspended an on boolean to cyttsp core
> >     - Rework PM functions
>
> Looking a lot better now, thank you. Some tiny comments below.
>

Hi Henrik,

Your welcome. Thank you for the review and your patience.

> > +static int ttsp_read_block_data(struct cyttsp *ts, u8 command,
> > +     u8 length, void *buf)
> > +{
> > +     int retval = -1;
> > +     int tries;
> > +
> > +     if (!buf || !length)
> > +             return -EINVAL;
> > +
> > +     for (tries = 0; tries < CY_NUM_RETRY && (retval < 0); tries++) {
> > +             retval = ts->bus_ops->read(ts->dev, command, length, buf);
> > +             if (retval)
> > +                     msleep(CY_DELAY_DFLT);
> > +     }
> > +
> > +     return retval;
> > +}
>
> Still wondering why (retval > 0) is handled the same way as (retval < 0).
>

Well, that is a convention followed in the driver. All the bus
specific read/write operations (I2C, SPI, etc) never return positive
numbers. They return 0 on success or the error value (retval < 0).

Changing that semantic could be a bit of a hassle since all the driver
assumes that behavior. But to be consistent with the rest of the
kernel and if that could be a reason to not merge the driver I can
rework that.

> > +static int cyttsp_bl_app_valid(struct cyttsp *ts)
> > +{
> > +     int retval;
> > +
> > +     retval = cyttsp_load_bl_regs(ts);
> > +
> > +     if (retval < 0) {
> > +             retval = -ENODEV;
> > +             goto done;
> > +     }
> > +
> > +     if (GET_BOOTLOADERMODE(ts->bl_data.bl_status)) {
> > +             if (IS_VALID_APP(ts->bl_data.bl_status))
> > +                     return 0;
> > +             else
> > +                     return -ENODEV;
> > +     }
> > +
> > +     if (GET_HSTMODE(ts->bl_data.bl_file) == CY_OPERATE_MODE) {
> > +             if (!(IS_OPERATIONAL_ERR(ts->bl_data.bl_status)))
> > +                     return 1;
> > +             else
> > +                     return -ENODEV;
> > +     }
> > +
> > +     retval = -ENODEV;
> > +done:
> > +     return retval;
>
> The function seems to always return ENODEV, something to simplify?
>

Actually, it returns 1 if the device is not in bootloader mode an
operational or 0 otherwise. But you are right, the function is kind of
a mess. I'll simplify this.

> > +static int cyttsp_set_sysinfo_mode(struct cyttsp *ts)
> > +{
> > +     int retval;
> > +     int tries;
> > +     u8 cmd = CY_SYSINFO_MODE;
> > +
> > +     memset(&(ts->sysinfo_data), 0, sizeof(struct cyttsp_sysinfo_data));
> > +
> > +     /* switch to sysinfo mode */
> > +     retval = ttsp_write_block_data(ts, CY_REG_BASE, sizeof(cmd), &cmd);
> > +     if (retval < 0)
> > +             return retval;
> > +
> > +     /* read sysinfo registers */
> > +     tries = 0;
> > +     do {
> > +             msleep(CY_DELAY_DFLT);
> > +             retval = ttsp_read_block_data(ts, CY_REG_BASE,
> > +                     sizeof(ts->sysinfo_data), &ts->sysinfo_data);
> > +     } while ((retval || (!ts->sysinfo_data.tts_verh &&
> > +                          !ts->sysinfo_data.tts_verl)) &&
> > +              (tries++ < CY_NUM_RETRY));
> > +
> > +     if (tries >= CY_NUM_RETRY)
> > +             return -EAGAIN;
>
> The loop above seems to appear many times in the code. Something to
> simplify?
>

Ok, will simplify this also.

> Thanks,
> Henrik

Thanks a lot and best regards,
Javier
