Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab2BUQfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 11:35:33 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:32852 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab2BUQfc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 11:35:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of djkurtz@google.com designates 10.229.78.204 as permitted sender) smtp.mail=djkurtz@google.com; dkim=pass header.i=djkurtz@google.com
MIME-Version: 1.0
In-Reply-To: <1329836858-9369-1-git-send-email-cywang@chromium.org>
References: <1329836858-9369-1-git-send-email-cywang@chromium.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 22 Feb 2012 00:35:09 +0800
X-Google-Sender-Auth: 40DkgIkfph5h9YJZ1q9lduvKWKY
Message-ID: <CAGS+omAK-dWjJjjDDXtwM90bTx--ngEL6KTtxzdcQGtd-xEPEQ@mail.gmail.com>
Subject: Re: [PATCH] CHROMIUM: Input: synaptics - filter out the events with
 low z values
To: Chung-yih Wang <cywang@chromium.org>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 11:07 PM, Chung-yih Wang <cywang@chromium.org> wrote:
> The single touch path imposes a minimum z value (with hysterisis) before
> registering BTN_TOUCH. Apply the same (hard coded) threshold when
> deciding how many fingers to report in the semi-mt path.
>
> This patch improves performance of the Google Cr-48 chromebook's
> extremely sensitive Synaptics profile sensor touchpad by filtering out
> touch events for hovering fingers.
>
> Note: We continue to use the same hard coded threshold value used in the
> single touch case as it appears this works just as well on these
> multitouch profile sensor pads as on whatever pads it was originally
> discovered.
>
> Signed-off-by: Chung-Yih Wang <cywang@chromium.org>

Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>

> ---
>  drivers/input/mouse/synaptics.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index 8081a0a..7936a1a 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -568,17 +568,22 @@ static void synaptics_report_semi_mt_slot(struct input_dev *dev, int slot,
>        }
>  }
>
> +static bool finger_touched(const struct synaptics_hw_state *hw)
> +{
> +       return (hw->z > 30);
> +}
> +
>  static void synaptics_report_semi_mt_data(struct input_dev *dev,
>                                          const struct synaptics_hw_state *a,
>                                          const struct synaptics_hw_state *b,
>                                          int num_fingers)
>  {
> -       if (num_fingers >= 2) {
> +       if ((num_fingers >= 2) && finger_touched(a) && finger_touched(b)) {
>                synaptics_report_semi_mt_slot(dev, 0, true, min(a->x, b->x),
>                                              min(a->y, b->y));
>                synaptics_report_semi_mt_slot(dev, 1, true, max(a->x, b->x),
>                                              max(a->y, b->y));
> -       } else if (num_fingers == 1) {
> +       } else if ((num_fingers == 1) && finger_touched(a)) {
>                synaptics_report_semi_mt_slot(dev, 0, true, a->x, a->y);
>                synaptics_report_semi_mt_slot(dev, 1, false, 0, 0);
>        } else {
> @@ -1040,7 +1045,8 @@ static void synaptics_process_packet(struct psmouse *psmouse)
>         * BTN_TOUCH has to be first as mousedev relies on it when doing
>         * absolute -> relative conversion
>         */
> -       if (hw.z > 30) input_report_key(dev, BTN_TOUCH, 1);
> +       if (finger_touched(&hw))
> +               input_report_key(dev, BTN_TOUCH, 1);
>        if (hw.z < 25) input_report_key(dev, BTN_TOUCH, 0);
>
>        if (num_fingers > 0) {
> --
> 1.7.7.3
>
