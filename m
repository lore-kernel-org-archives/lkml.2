Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab1HHMSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:18:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61945 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab1HHMSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:18:15 -0400
MIME-Version: 1.0
In-Reply-To: <1312794961.21052.4.camel@phoenix>
References: <1312794859.21052.2.camel@phoenix>
	<1312794961.21052.4.camel@phoenix>
Date: Mon, 8 Aug 2011 14:18:14 +0200
Message-ID: <CAHR064jQkgt0B8wHX_j301eqTtEakSPw5+TeiUqPpC4AHL6YXg@mail.gmail.com>
Subject: Re: [PATCH 2/3] platform-drivers-x86: asus-wmi: fix resource leak in asus_wmi_led_exit
From: Corentin Chary <corentin.chary@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 11:16 AM, Axel Lin <axel.lin@gmail.com> wrote:
> This patch fixes wrong test for successful registered led_classdev,
> and also fixes a leak due to missing led_classdev_unregister call
> for asus->kbd_led in asus_wmi_led_exit.
>
> device_create returns &struct device pointer on success, or ERR_PTR() on error.
> Thus if led_classdev_register fails, led_cdev->dev is always not NULL.
>
> Thus to unregister a successful registered led_classdev, we should check
> (!IS_ERR_OR_NULL(asus->tpd_led.dev)) instead of (asus->tpd_led.dev).
>
> we use IS_ERR_OR_NULL instead of IS_ERR because if we havn't call
> led_classdev_register, the led_cdev->dev is NULL.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Corentin Chary <corentin.chary@gmail.com>

> ---
>  drivers/platform/x86/asus-wmi.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index 95cba9e..d1049ee 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -453,7 +453,9 @@ static enum led_brightness kbd_led_get(struct led_classdev *led_cdev)
>
>  static void asus_wmi_led_exit(struct asus_wmi *asus)
>  {
> -       if (asus->tpd_led.dev)
> +       if (!IS_ERR_OR_NULL(asus->kbd_led.dev))
> +               led_classdev_unregister(&asus->kbd_led);
> +       if (!IS_ERR_OR_NULL(asus->tpd_led.dev))
>                led_classdev_unregister(&asus->tpd_led);
>        if (asus->led_workqueue)
>                destroy_workqueue(asus->led_workqueue);
> --
> 1.7.4.1
>
>
>
>



-- 
Corentin Chary
http://xf.iksaif.net
