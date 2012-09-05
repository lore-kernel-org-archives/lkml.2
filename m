Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab2IEFwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:52:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55712 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2IEFwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:52:22 -0400
Date: Tue, 4 Sep 2012 22:52:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Vojtech Bocek <vbocek@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Input: joydev - fix axes values sent in initial
 js_event
Message-ID: <20120905055218.GA24715@core.coreip.homeip.net>
References: <1344895914-32127-1-git-send-email-vbocek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344895914-32127-1-git-send-email-vbocek@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vojtech,

On Tue, Aug 14, 2012 at 12:11:54AM +0200, Vojtech Bocek wrote:
> Initial input event has not yet arrived in joydev_connect()
> where values are set, which means default values of input_absinfo
> are used for init event, not the actual values from joystick.

So what guarantees that joystick events will arrive in time, before
joydev_generate_startup_event() is called? It looks like your solution
is racy...

I wonder if we should not generate the startup event until we have seen
at least one EV_SYN, i.e. entire device state has been transmitted to
us.
> 
> Signed-off-by: Vojtech Bocek <vbocek@gmail.com>
> ---
>  drivers/input/joydev.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
> index 26043cc..11f24b4 100644
> --- a/drivers/input/joydev.c
> +++ b/drivers/input/joydev.c
> @@ -318,9 +318,14 @@ static int joydev_generate_startup_event(struct joydev_client *client,
>  			event->value = !!test_bit(joydev->keypam[event->number],
>  						  input->key);
>  		} else {
> +			int evnum = client->startup - joydev->nkey;
> +			int val = input_abs_get_val(input, joydev->abspam[evnum]);
> +
> +			joydev->abs[evnum] = joydev_correct(val, &joydev->corr[evnum]);
> +
>  			event->type = JS_EVENT_AXIS | JS_EVENT_INIT;
> -			event->number = client->startup - joydev->nkey;
> -			event->value = joydev->abs[event->number];
> +			event->number = evnum;
> +			event->value = joydev->abs[evnum];
>  		}
>  		client->startup++;
>  	}
> -- 
> 1.7.10.4
> 

Thanks.

-- 
Dmitry
