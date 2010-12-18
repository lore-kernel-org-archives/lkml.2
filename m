Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab0LRRLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 12:11:13 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:57529 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab0LRRLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 12:11:12 -0500
MIME-Version: 1.0
In-Reply-To: <1292683981-6908-5-git-send-email-rydberg@euromail.se>
References: <1292683981-6908-1-git-send-email-rydberg@euromail.se>
	<1292683981-6908-5-git-send-email-rydberg@euromail.se>
Date: Sat, 18 Dec 2010 11:11:11 -0600
Message-ID: <AANLkTi=YVxs07E3LqMZuKP-sHQbFdQbLpox7iypq=8jN@mail.gmail.com>
Subject: Re: [PATCH 4/4] Input: synaptics - emit multitouch data
From: Chris Bagwell <chris@cnpbagwell.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't tested this one but it looks like only 2 lines different
from one I did (report as FINGER again and new cap).  So you still
have my:

Acked-by: Chris Bagwell <chris@cnpbagwell.com>

On Sat, Dec 18, 2010 at 8:53 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> In multitouch mode, two data packets are sent from the device.  Due to
> limitations in the hardware detection mechanism, individual contacts
> cannot be reliably extracted. However, the bounding rectangle of the
> individual contacts can be accurately reproduced. This patch emits the
> MT data as rectangle corners, allowing userspace to track and produce
> appropriate gestures. The number of fingers are still reported as before.
> The INPUT_PROP_SEMI_MT quirk is set to signal this special behavior.
>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/input/mouse/synaptics.c |   42 ++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 41 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index 01302db..1ae5c29 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -25,7 +25,7 @@
>
>  #include <linux/module.h>
>  #include <linux/dmi.h>
> -#include <linux/input.h>
> +#include <linux/input/mt.h>
>  #include <linux/serio.h>
>  #include <linux/libps2.h>
>  #include <linux/slab.h>
> @@ -489,6 +489,34 @@ static int synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data *
>        return 0;
>  }
>
> +static void set_slot(struct input_dev *dev, int slot, bool active, int x, int y)
> +{
> +       input_mt_slot(dev, slot);
> +       input_mt_report_slot_state(dev, MT_TOOL_FINGER, active);
> +       if (active) {
> +               input_report_abs(dev, ABS_MT_POSITION_X, x);
> +               input_report_abs(dev, ABS_MT_POSITION_Y,
> +                                YMAX_NOMINAL + YMIN_NOMINAL - y);
> +       }
> +}
> +
> +static void synaptics_report_mt_data(struct input_dev *dev,
> +                                    const struct synaptics_hw_state *a,
> +                                    const struct synaptics_hw_state *b,
> +                                    int num_fingers)
> +{
> +       if (num_fingers >= 2) {
> +               set_slot(dev, 0, true, min(a->x, b->x), min(a->y, b->y));
> +               set_slot(dev, 1, true, max(a->x, b->x), max(a->y, b->y));
> +       } else if (num_fingers == 1) {
> +               set_slot(dev, 0, true, a->x, a->y);
> +               set_slot(dev, 1, false, 0, 0);
> +       } else {
> +               set_slot(dev, 0, false, 0, 0);
> +               set_slot(dev, 1, false, 0, 0);
> +       }
> +}
> +
>  /*
>  *  called for each full received packet from the touchpad
>  */
> @@ -551,6 +579,9 @@ static void synaptics_process_packet(struct psmouse *psmouse)
>                finger_width = 0;
>        }
>
> +       if (priv->multitouch)
> +               synaptics_report_mt_data(dev, &hw, &priv->mt, num_fingers);
> +
>        /* Post events
>         * BTN_TOUCH has to be first as mousedev relies on it when doing
>         * absolute -> relative conversion
> @@ -662,6 +693,7 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
>        int i;
>
>        __set_bit(INPUT_PROP_POINTER, dev->propbit);
> +       __set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
>
>        __set_bit(EV_ABS, dev->evbit);
>        input_set_abs_params(dev, ABS_X,
> @@ -670,6 +702,14 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
>                             YMIN_NOMINAL, priv->y_max ?: YMAX_NOMINAL, 0, 0);
>        input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
>
> +       if (priv->multitouch) {
> +               input_mt_init_slots(dev, 2);
> +               input_set_abs_params(dev, ABS_MT_POSITION_X, XMIN_NOMINAL,
> +                                    priv->x_max ?: XMAX_NOMINAL, 0, 0);
> +               input_set_abs_params(dev, ABS_MT_POSITION_Y, YMIN_NOMINAL,
> +                                    priv->y_max ?: YMAX_NOMINAL, 0, 0);
> +       }
> +
>        if (SYN_CAP_PALMDETECT(priv->capabilities))
>                input_set_abs_params(dev, ABS_TOOL_WIDTH, 0, 15, 0, 0);
>
> --
> 1.7.2.3
>
>
