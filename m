Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab1KUXIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:08:36 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:56754 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752950Ab1KUXIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:08:34 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18qs8JCRDsqPzNE0x21swLs8RBDCLwFfo6kSySXvI
	pyL5lKiVHfLTOL
Message-ID: <4ECAD9F0.9050508@gmx.de>
Date: Mon, 21 Nov 2011 23:08:32 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: Joonyoung Shim <jy0922.shim@samsung.com>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: Fix return value of fb_notifier_call_chain
References: <1321858524-19368-1-git-send-email-jy0922.shim@samsung.com>
In-Reply-To: <1321858524-19368-1-git-send-email-jy0922.shim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 06:55 AM, Joonyoung Shim wrote:
> The return value of blocking_notifier_call_chain isn't errno value, it
> is just notify return value. The ret of fb_notifier_call_chain should is
> restored to error value from notify return value using
> notifier_to_errno().

If I'm not wrong this patch would rather break things than fix them. As I
understand the notifier_calls would be required to encode the return value with
notifier_from_errno. This does not happen at the moment for fb clients, for
example fbcon_event_notify in drivers/video/console/fbcon.c, so this patch would
screw up the return values, I think.


Best regards,

Florian Tobias Schandinat

> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> ---
>  drivers/video/fb_notify.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/fb_notify.c b/drivers/video/fb_notify.c
> index 74c2da5..49a64a3 100644
> --- a/drivers/video/fb_notify.c
> +++ b/drivers/video/fb_notify.c
> @@ -42,6 +42,8 @@ EXPORT_SYMBOL(fb_unregister_client);
>   */
>  int fb_notifier_call_chain(unsigned long val, void *v)
>  {
> -	return blocking_notifier_call_chain(&fb_notifier_list, val, v);
> +	int ret = blocking_notifier_call_chain(&fb_notifier_list, val, v);
> +
> +	return notifier_to_errno(ret);
>  }
>  EXPORT_SYMBOL_GPL(fb_notifier_call_chain);

