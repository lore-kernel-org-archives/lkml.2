Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1EPLln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 07:41:43 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:36381 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1EPLlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 07:41:42 -0400
X-Greylist: delayed 1488 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 May 2011 07:41:42 EDT
X-Spam-Flag: NO
X-Spam-Score: -22.39
Message-ID: <4DD1079E.6000209@tremplin-utc.net>
Date: Mon, 16 May 2011 13:16:46 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Mandriva/3.1.10-1 (2011.0) Thunderbird/3.1.10
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lis3lv02d: avoid divide by zero due to unchecked register
 read
References: <201105160046.31019.chunkeey@googlemail.com>
In-Reply-To: <201105160046.31019.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 16-05-11 00:46, Christian Lamparter schreef:
> After an "unexpected" reboot, I found this Oops in my logs:
>
> divide error: 0000 [#1] PREEMPT SMP
> CPU 0
> Modules linked in: lis3lv02d hp_wmi input_polldev [...]
> Pid: 390, comm: modprobe Tainted: G         C  2.6.39-rc7-wl+
> RIP: 0010:[<ffffffffa014b427>]  [<ffffffffa014b427>]
> 		 lis3lv02d_poweron+0x4e/0x94 [lis3lv02d]
> RSP: 0018:ffff8801d6407cf8  EFLAGS: 00010246
> RAX: 0000000000000bb8 RBX: ffffffffa014e000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffea00066e4708 RDI: ffff8801df002700
> RBP: ffff8801d6407d18 R08: ffffea00066c5a30 R09: ffffffff812498c9
> R10: ffff8801d7bfcea0 R11: ffff8801d7bfce10 R12: 0000000000000bb8
> R13: 00000000ffffffda R14: ffffffffa0154120 R15: ffffffffa0154030
> FS:  00007fc0705db700(0000) GS:ffff8801dfa00000(0000) knlGS:0
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007f33549174f0 CR3: 00000001d65c9000 CR4: 00000000000406f0
> Process modprobe (pid: 390, threadinfo ffff8801d6406000, task ffff8801d6b40000)
> Stack:
>   ffffffffa0154120 62ffffffa0154030 ffffffffa014e000 00000000ffffffea
>   ffff8801d6407d58 ffffffffa014bcc1 0000000000000000 0000000000000048
>   ffff8801d8bae800 00000000ffffffea 00000000ffffffda ffffffffa0154120
> Call Trace:
>   [<ffffffffa014bcc1>] lis3lv02d_init_device+0x1ce/0x496 [lis3lv02d]
>   [<ffffffffa01522ff>] lis3lv02d_add+0x10f/0x17c [hp_accel]
>   [<ffffffff81233e11>] acpi_device_probe+0x49/0x117
> [...]
> Code: 3a 75 06 80 4d ef 50 eb 04 80 4d ef 40 0f b6 55 ef be 21
> 00 00 00 48 89 df ff 53 18 44 8b 63 6c e8 3e fc ff ff 89 c1 44
> 89 e0 99<f7>  f9 89 c7 e8 93 82 ef e0 48 83 7b 30 00 74 2d 45
> 31 e4 80 7b
> RIP  [<ffffffffa014b427>] lis3lv02d_poweron+0x4e/0x94 [lis3lv02d]
>   RSP<ffff8801d6407cf8>
>
>  From my POV, it looks like the hardware is not working as expected
> and returns a bogus data rate. The driver doesn't check the result
> and directly uses it as some sort of divisor in some places:
>
> msleep(lis3->pwron_delay / lis3lv02d_get_odr());
>
> Under this circumstances, this could very well cause the
> "divide by zero" exception from above.
>
> For now, I fixed it the easiest and most obvious way:
> Check if the result is sane and if it isn't use a sane default
> instead. I went for "100" in the latter case, simply because
> /sys/devices/platform/lis3lv02d/rate returns it on a successful
> boot.
>
Hi,
Good catch! We don't want to have a kernel oops just because a device is 
sending bad data...

However, I'd fix it a bit differently: let lis3lv02d_get_odr() return 
the raw data, and create a special function 
lis3lv02d_get_pwron_delay_ms() which does the "lis3->pwron_delay / 
lis3lv02d_get_odr()" with special handling for 0 (returning a large 
value and also sending a printk_once() ).

As you have noted, we might want to check other parts of the driver to 
validate the data from the device. So far, all the code considers that 
the device is flawless :-S

Cheers,
Éric



> Signed-off-by: Christian Lamparter<chunkeey@googlemail.com>
> ---
> Oh, please keep the CC.
>
> Note: This patch is a bit experimental, I can't get the
> device to fail reliable so even with the patch, it might
> fail in a different place.
>
> Regards,
> 	Chr
> ---
> diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
> index b928bc1..96102f0 100644
> --- a/drivers/misc/lis3lv02d/lis3lv02d.c
> +++ b/drivers/misc/lis3lv02d/lis3lv02d.c
> @@ -198,12 +198,18 @@ static int lis3_3dc_rates[16] = {0, 1, 10, 25, 50, 100, 200, 400, 1600, 5000};
>   static int lis3lv02d_get_odr(void)
>   {
>   	u8 ctrl;
> -	int shift;
> +	int shift, res;
>
>   	lis3_dev.read(&lis3_dev, CTRL_REG1,&ctrl);
>   	ctrl&= lis3_dev.odr_mask;
>   	shift = ffs(lis3_dev.odr_mask) - 1;
> -	return lis3_dev.odrs[(ctrl>>  shift)];
> +	res = lis3_dev.odrs[(ctrl>>  shift)];
> +
> +	/*
> +	 * because the result is used as a divisor, it must
> +	 * not be a zero.
> +	 */
> +	return (res != 0) ? res : 100;
>   }
>
>   static int lis3lv02d_set_odr(int rate)

