Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab2DJMjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 08:39:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33131 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab2DJMjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 08:39:05 -0400
Message-ID: <4F842987.9010600@mvista.com>
Date: Tue, 10 Apr 2012 16:37:27 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/2] usb/ehci-hub: Add workaround for EG20T/ML7213/ML7223/ML7831
References: <1334030835-4681-1-git-send-email-tomoya.rohm@gmail.com>
In-Reply-To: <1334030835-4681-1-git-send-email-tomoya.rohm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-04-2012 8:07, Tomoya MORINAGA wrote:

> ISSUE: When a bit of EHCI status register (USBSTS) is set
> as 1, if the corresponded bit of EHCI interrupt enable
> register(USBINTR) is set as 1, an interrupt occurs.
> After that, even if the bit of USBINTR is set as 0, the
> interrupt continues occurring.
> Workaround: Clear the bit 3 of USBSTS before enabling the
> interrupt, at resume process.

> This patch is for
> Intel EG20T PCH
> LAPIS Semiconductor ML7213 IOH
> LAPIS Semiconductor ML7223 IOH
> LAPIS Semiconductor ML7831 IOH

> Signed-off-by: Tomoya MORINAGA<tomoya.rohm@gmail.com>
> ---
>   drivers/usb/host/ehci-hub.c |   18 ++++++++++++++++++
>   1 files changed, 18 insertions(+), 0 deletions(-)

> diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
> index 256fbd4..7ddb62e 100644
> --- a/drivers/usb/host/ehci-hub.c
> +++ b/drivers/usb/host/ehci-hub.c
[...]
> @@ -451,6 +452,23 @@ static int ehci_bus_resume (struct usb_hcd *hcd)
>
>   	ehci->next_statechange = jiffies + msecs_to_jiffies(5);
>
> +	if ((pdev->vendor == PCI_VENDOR_ID_INTEL&&  pdev->device == 0x8807) ||
> +	   (pdev->vendor == PCI_VENDOR_ID_INTEL&&  pdev->device == 0x880F) ||
> +	   (pdev->vendor == 0x10DB&&  pdev->device == 0x801C) || /* ML7213 */
> +	   (pdev->vendor == 0x10DB&&  pdev->device == 0x8007) || /* ML7223 */
> +	   (pdev->vendor == 0x10DB&&  pdev->device == 0x8807)) { /* ML7831 */

    Why not:

	if ((pdev->vendor == PCI_VENDOR_ID_INTEL &&
	    (pdev->device == 0x8807 || pdev->device == 0x880F)) ||
	    (pdev->vendor == 0x10DB &&
	    (pdev->device == 0x801C || /* ML7213 */
	     pdev->device == 0x8007 || /* ML7223 */
	     pdev->device == 0x8807)   /* ML7831 */
	)) {

which avoids the duplicate checks? The same about the next patch.

WBR, Sergei
