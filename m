Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab2IMFTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 01:19:34 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35358 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab2IMFTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 01:19:32 -0400
Date: Wed, 12 Sep 2012 22:19:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 03/20] Input: Make sure we follow all EV_KEY events
Message-ID: <20120913051928.GE17105@core.coreip.homeip.net>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
 <1346528835-363-4-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346528835-363-4-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 09:46:58PM +0200, Henrik Rydberg wrote:
> For some EV_KEY types, sending a larger-than-one value causes the
> input state to oscillate. This patch makes sure this cannot happen,
> clearing up the autorepeat bypass logic in the process.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> ---
>  drivers/input/input.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 8ebf116..4d64500 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -239,24 +239,30 @@ static void input_handle_event(struct input_dev *dev,
>  		break;
>  
>  	case EV_KEY:
> -		if (is_event_supported(code, dev->keybit, KEY_MAX) &&
> -		    !!test_bit(code, dev->key) != value) {
> +		if (is_event_supported(code, dev->keybit, KEY_MAX)) {
> +
> +			/* auto-repeat bypasses state updates */
> +			if (value == 2) {
> +				disposition = INPUT_PASS_TO_HANDLERS;
> +				break;
> +			}
> +
> +			if (!!test_bit(code, dev->key) != !!value) {
>  
> -			if (value != 2) {
>  				__change_bit(code, dev->key);
> +				disposition = INPUT_PASS_TO_HANDLERS;
> +
>  				if (value)
>  					input_start_autorepeat(dev, code);
>  				else
>  					input_stop_autorepeat(dev);
>  			}
> -
> -			disposition = INPUT_PASS_TO_HANDLERS;
>  		}
>  		break;
>  
>  	case EV_SW:
>  		if (is_event_supported(code, dev->swbit, SW_MAX) &&
> -		    !!test_bit(code, dev->sw) != value) {
> +		    !!test_bit(code, dev->sw) != !!value) {
>  
>  			__change_bit(code, dev->sw);
>  			disposition = INPUT_PASS_TO_HANDLERS;
> @@ -283,7 +289,7 @@ static void input_handle_event(struct input_dev *dev,
>  
>  	case EV_LED:
>  		if (is_event_supported(code, dev->ledbit, LED_MAX) &&
> -		    !!test_bit(code, dev->led) != value) {
> +		    !!test_bit(code, dev->led) != !!value) {
>  
>  			__change_bit(code, dev->led);
>  			disposition = INPUT_PASS_TO_ALL;
> -- 
> 1.7.12
> 

-- 
Dmitry
