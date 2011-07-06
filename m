Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1GFMGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 08:06:36 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:57451 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab1GFMGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 08:06:34 -0400
Message-ID: <4E144F82.8060300@mvista.com>
Date: Wed, 06 Jul 2011 16:05:22 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Vitaly Kuzmichev <vkuzmichev@mvista.com>
CC: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, Wim Van Sebroeck <wim@iguana.be>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        arm@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 3/6] mpcore_wdt: Fix WDIOC_SETOPTIONS handling
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <1309892440-3260-4-git-send-email-vkuzmichev@mvista.com>
In-Reply-To: <1309892440-3260-4-git-send-email-vkuzmichev@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05-07-2011 23:00, Vitaly Kuzmichev wrote:

> According to the include/linux/watchdog.h WDIOC_SETOPTIONS is
> classified as 'read from device' ioctl call:
>    #define WDIOC_SETOPTIONS        _IOR(WATCHDOG_IOCTL_BASE, 4, int)

> However, the driver 'mpcore_wdt' performs 'copy_from_user' only if
> _IOC_WRITE is set, thus the local variable 'uarg' which is used in
> WDIOC_SETOPTIONS handling remains uninitialized.

> The proper way to fix this is to bind WDIOC_SETOPTIONS to _IOW,
> but this will break compatibility.
> So adding additional condition for performing 'copy_from_user'.

> Signed-off-by: Vitaly Kuzmichev<vkuzmichev@mvista.com>
> ---
>   drivers/watchdog/mpcore_wdt.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)

> diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
> index 7a3d6b2..b330a0a 100644
> --- a/drivers/watchdog/mpcore_wdt.c
> +++ b/drivers/watchdog/mpcore_wdt.c
> @@ -240,7 +240,8 @@ static long mpcore_wdt_ioctl(struct file *file, unsigned int cmd,
>   	if (_IOC_DIR(cmd)&&  _IOC_SIZE(cmd)>  sizeof(uarg))
>   		return -ENOTTY;
>
> -	if (_IOC_DIR(cmd) & _IOC_WRITE) {
> +	if (_IOC_DIR(cmd) & _IOC_WRITE

    I think you need parens around this.

> +			|| cmd == WDIOC_SETOPTIONS) {
>   		ret = copy_from_user(&uarg, (void __user *)arg, _IOC_SIZE(cmd));
>   		if (ret)
>   			return -EFAULT;

WBR, Sergei
