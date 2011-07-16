Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab1GPCJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 22:09:49 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:33198 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751383Ab1GPCJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 22:09:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=GE6jkIVnd6GypuWs/hsOq4SjFLAHWxIL7sAteFVBNPKelh8vKQUJsYIprl62nhtvxZBAwo5ISQFzMCGRke6Ef3YuvRKjECiN5+zNUmYMMLwpaf64HkRlmxLSgSXpsu+u;
Date: Fri, 15 Jul 2011 19:09:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, wim@iguana.be, tim.bird@am.sony.com
Subject: Re: [RFC 1/6] Documentation: watchdog: add guide how to convert
 drivers to new framework
Message-Id: <20110715190945.352c9130.rdunlap@xenotime.net>
In-Reply-To: <1310588766-16638-2-git-send-email-w.sang@pengutronix.de>
References: <1310588766-16638-1-git-send-email-w.sang@pengutronix.de>
	<1310588766-16638-2-git-send-email-w.sang@pengutronix.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 22:26:01 +0200 Wolfram Sang wrote:

> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
>  .../watchdog/convert_drivers_to_kernel_api.txt     |  195 ++++++++++++++++++++
>  1 files changed, 195 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/watchdog/convert_drivers_to_kernel_api.txt
> 
> diff --git a/Documentation/watchdog/convert_drivers_to_kernel_api.txt b/Documentation/watchdog/convert_drivers_to_kernel_api.txt
> new file mode 100644
> index 0000000..9c0cff9
> --- /dev/null
> +++ b/Documentation/watchdog/convert_drivers_to_kernel_api.txt
> @@ -0,0 +1,195 @@
> +Converting old watchdog drivers to the watchdog framework
> +by Wolfram Sang <w.sang@pengutronix.de>
> +=========================================================
> +
> +Before the watchdog framework came into the kernel, every driver had to
> +implement the API on its own. Now, as the framework factored out the common
> +components, those drivers can be lightened making it a user of the framework.
> +This document shall guide you for this task. The necessary steps are described
> +as well as things to look out for.
> +
> +
> +Remove the file_operations struct
> +---------------------------------
> +
> +Old drivers define their own file_operations for actions like open(), write(),
> +etc... These are now handled by the framework and just call the driver when
> +needed. So, in general, the file operations-struct and assorted functions can

                               file operations struct

> +go. Only very few driver-specific details have to be moved to other functions.
> +Here is a overview of the functions and probably needed actions:
> +
> +- open: Everything dealing with resource management (file-open checks, magic
> +  close preparations) can simply go. Device specific stuff needs to go to the
> +  driver specific start-function. Note that for some drivers, the start-function
> +  also serves as the ping-function. If that is the case and you need start/stop
> +  to be balanced (clocks!), you are better off refactoring a separate start-function.
> +
> +- close: Same hints as for open apply.
> +
> +- write: Can simply go, all defined behaviour is taken care of by the framework,
> +  i.e. ping on write and magic char ('V') handling.
> +
> +- ioctl: While the driver is allowed to have extensions to the IOCTL interface,
> +  the most common ones are handled by the framework, supported by some assistance
> +  from the driver:
> +
[snip]
> +
> +  Other IOCTLs can be served using the ioctl-callback. Note that this is mainly
> +  intended for porting old drivers, new drivers should not invent private IOCTLs.

                          old drivers; new drivers

> +  Private IOCTLs are processed first. When the callback returns with
> +  -ENOIOCTLCMD, the IOCTLs of the framework will be tried, too. Any other error
> +  is directly given to the user.
> +
> +Example conversion:
> +
> +-static const struct file_operations s3c2410wdt_fops = {
> +-       .owner          = THIS_MODULE,
> +-       .llseek         = no_llseek,
> +-       .write          = s3c2410wdt_write,
> +-       .unlocked_ioctl = s3c2410wdt_ioctl,
> +-       .open           = s3c2410wdt_open,
> +-       .release        = s3c2410wdt_release,
> +-};
> +
> +Check the functions for device-specific stuff and keep it for later
> +refactoring. The rest can go.
> +
> +
> +Remove the miscdevice
> +---------------------
[snip]

> +Remove obsolete includes and defines
> +------------------------------------
[snip]
> +
> +Add the watchdog operations
> +---------------------------
> +
> +All possible callbacks are defined in 'struct watchdog_ops'. You can find it
> +explained in 'watchdog-kernel-api.txt' in this directory. start(), stop() and
> +owner must be set, the rest is optional. You will easily find corresponding

I would say:          the rest are optional.

> +functions in the old driver. Note that you will now get a pointer to the
> +watchdog_device as a parameter to these functions, so you probably have to
> +change the function header. Other changes are most likely not needed, because
> +here simply happens the direct hardware access. If you have device-specific
> +code left from the above steps, it should be refactored into these callbacks.
> +
> +Here is a simple example:
[snip]

> +Add the watchdog device
> +-----------------------
[snip]

> +Register the watchdog device
> +----------------------------
[snip]

> +Update the Kconfig-entry
> +------------------------
> +
> +The entry for the driver now needs to select WATCHDOG_CORE:
> +
> ++       select WATCHDOG_CORE
> +
> +
> +Create a patch and send it to upstream
> +--------------------------------------
> +
> +Make sure you understood Documentation/SubmittingPatches and send your patch to
> +linux-watchdog@vger.kernel.org. We are looking forward to it :)

Good job.  Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
