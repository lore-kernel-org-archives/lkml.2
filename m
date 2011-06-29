Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1F2N43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 09:56:29 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59557 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1F2N42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 09:56:28 -0400
Message-ID: <4E0B2F06.3060706@canonical.com>
Date: Wed, 29 Jun 2011 21:56:22 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Keng-Yu Lin <kengyu@canonical.com>
CC: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, vanhoof@canonical.com,
        kent.lin@canonical.com, sylee@canonical.com
Subject: Re: [PATCH 2/2] ideapad-laptop: Handle the App-controlled RF event
References: <1309268154-6872-1-git-send-email-kengyu@canonical.com> <1309268154-6872-2-git-send-email-kengyu@canonical.com>
In-Reply-To: <1309268154-6872-2-git-send-email-kengyu@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2011 09:35 PM, Keng-Yu Lin wrote:
> Notification with VPC2 bit 5 set is generated when the wireless
> hotkey is pressed. BIOS fires this to notify a Windows
> application to handle the RF switch.
> 
> On Linux, there is no such application. This patch implements
> a toggle for all RF devices through accessing the EC I/O ports.
> 
> Without the explicit EC commands, the wifi LED is always on.
> 
> Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
> ---
>  drivers/platform/x86/ideapad-laptop.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
> index 820f013..5e1e971 100644
> --- a/drivers/platform/x86/ideapad-laptop.c
> +++ b/drivers/platform/x86/ideapad-laptop.c
> @@ -461,7 +461,11 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
>  		if (test_bit(vpc_bit, &vpc1)) {
>  			if (vpc_bit == 9)
>  				ideapad_sync_rfk_state(adevice);
> -			else if (vpc_bit == 4)
> +			else if (vpc_bit == 13) {
> +				read_ec_data(handle, 0x23, &vpc2);
> +				write_ec_cmd(handle, 0x24, !vpc2);
> +				ideapad_sync_rfk_state(adevice);
> +			} else if (vpc_bit == 4)
>  				read_ec_data(handle, 0x12, &vpc2);
>  			else if (vpc_bit == 1) {
>  			} else

I think its better to implement the changes in ideapad_sync_rfk_state() because we have
read switch status there. It is not necessary to read the same data twice in an event.

