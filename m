Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2K0NBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:01:42 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:46029 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2K0NBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:01:40 -0500
MIME-Version: 1.0
In-Reply-To: <1353124734-16803-7-git-send-email-cheiny@synaptics.com>
References: <1353124734-16803-1-git-send-email-cheiny@synaptics.com>
	<1353124734-16803-7-git-send-email-cheiny@synaptics.com>
Date: Tue, 27 Nov 2012 14:01:38 +0100
Message-ID: <CAN+gG=GikXu-bJq7McYZedCy=8SgPbsktvNXzSRh04PVZg0yDQ@mail.gmail.com>
Subject: Re: [RFC PATCH 06/06] input/rmi4: F11 - 2D touch interface
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,

I did not made a full review, but at least, there is a problem in your
rmi_f11_finger_handler function:

On Sat, Nov 17, 2012 at 4:58 AM, Christopher Heiny <cheiny@synaptics.com> wrote:
> rmi_f11.c is a driver for 2D touch sensors using the RMI4 protocol.  It supports
> both touchscreen and touchpad input, in both absolute and relative formats.
> Support for Type-B multitouch is the default, Type-A support is included for
> certain legacy sensors.
>
>
> Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
>
> To: Henrik Rydberg <rydberg@euromail.se>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
> Cc: Joeri de Gram <j.de.gram@gmail.com>
>
> ---
>
>  drivers/input/rmi4/rmi_f11.c | 2813 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 2813 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/input/rmi4/rmi_f11.c b/drivers/input/rmi4/rmi_f11.c
> new file mode 100644
> index 0000000..b9a84bc
> --- /dev/null
> +++ b/drivers/input/rmi4/rmi_f11.c
[snipped]
> +static void rmi_f11_finger_handler(struct f11_data *f11,
> +                                  struct f11_2d_sensor *sensor)
> +{
> +       const u8 *f_state = sensor->data.f_state;
> +       u8 finger_state;
> +       u8 finger_pressed_count;
> +       u8 i;
> +
> +       for (i = 0, finger_pressed_count = 0; i < sensor->nbr_fingers; i++) {
> +               /* Possible of having 4 fingers per f_statet register */
> +               finger_state = (f_state[i / 4] >> (2 * (i % 4))) &
> +                                       FINGER_STATE_MASK;
> +               if (finger_state == F11_RESERVED) {
> +                       pr_err("%s: Invalid finger state[%d]:0x%02x.", __func__,
> +                                       i, finger_state);
> +                       continue;
> +               } else if ((finger_state == F11_PRESENT) ||
> +                               (finger_state == F11_INACCURATE)) {
> +                       finger_pressed_count++;
> +               }
> +
> +               if (sensor->data.abs_pos)
> +                       rmi_f11_abs_pos_report(f11, sensor, finger_state, i);
> +
> +               if (sensor->data.rel_pos)
> +                       rmi_f11_rel_pos_report(sensor, i);
> +       }
> +       input_mt_sync(sensor->input);

This should be "input_mt_sync_frame(sensor->input);"
otherwise, the synaptics xorg driver won't handle the touchpad correctly.

Cheers,
Benjamin

> +       input_sync(sensor->input);
> +}
> +
[snipped]
