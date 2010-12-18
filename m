Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab0LRRFK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 12:05:10 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45633 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597Ab0LRRFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 12:05:09 -0500
MIME-Version: 1.0
In-Reply-To: <1292683981-6908-3-git-send-email-rydberg@euromail.se>
References: <1292683981-6908-1-git-send-email-rydberg@euromail.se>
	<1292683981-6908-3-git-send-email-rydberg@euromail.se>
Date: Sat, 18 Dec 2010 11:05:08 -0600
Message-ID: <AANLkTinso7BZB4GxgsQshaGeka+CcjUtjB9Agdj3qFnz@mail.gmail.com>
Subject: Re: [PATCH 2/4] Input: synaptics - ignore bogus mt packet
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

On Sat, Dec 18, 2010 at 8:52 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> In multitouch mode, at least one device (fw: 7.4 id: 0x1c0b1) sometimes
> sends a final main packet with x == 1. Since the normal values are above
> 1472, this is clearly bogus. At the same time, a two-finger touch is
> signaled, even though only one finger was on the pad to begin with. This
> patch ignores the packet altogether, removing the problem.

I've seen this behavior as well although I thought it always came when
hw.z == 0 so was masked.  I guess its not to surprising its sneaking
threw with low pressures.

>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/input/mouse/synaptics.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index 8a769e9..4744064 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -526,7 +526,7 @@ static void synaptics_process_packet(struct psmouse *psmouse)
>                return;
>        }
>
> -       if (hw.z > 0) {
> +       if (hw.z > 0 && hw.x > 1) {
>                num_fingers = 1;
>                finger_width = 5;
>                if (SYN_CAP_EXTENDED(priv->capabilities)) {
> @@ -558,7 +558,7 @@ static void synaptics_process_packet(struct psmouse *psmouse)
>        if (hw.z > 30) input_report_key(dev, BTN_TOUCH, 1);
>        if (hw.z < 25) input_report_key(dev, BTN_TOUCH, 0);
>
> -       if (hw.z > 0) {
> +       if (hw.z > 0 && hw.x > 1) {
>                input_report_abs(dev, ABS_X, hw.x);
>                input_report_abs(dev, ABS_Y, YMAX_NOMINAL + YMIN_NOMINAL - hw.y);
>        }

This might read better if we change to "if (num_fingers) {" and then
we do not need to repeat the hw work around logic twice.

Also, this snippet shows I may be seeing it as well but the
BTN_TOUCH=0 when < 25 is probably masking it for most cases.

Either way:

Acked-by: Chris Bagwell <chris@cnpbagwell.com>

Chris
