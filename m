Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935381Ab1JEVrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 17:47:19 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57353 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab1JEVrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 17:47:18 -0400
Date: Wed, 5 Oct 2011 14:47:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] leds: leds-lp5521: Avoid writing uninitialized value to
 LP5521_REG_OP_MODE register
Message-Id: <20111005144715.5e275a53.akpm@linux-foundation.org>
In-Reply-To: <1317806378.2834.6.camel@phoenix>
References: <1317806378.2834.6.camel@phoenix>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Oct 2011 17:19:38 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> If lp5521_read fails, engine_state variable is not initialized.
> If lp5521_read fails, we should return error.
> This patch fixes below warning.
> 
>   CC      drivers/leds/leds-lp5521.o
> drivers/leds/leds-lp5521.c: In function 'lp5521_set_engine_mode':
> drivers/leds/leds-lp5521.c:168: warning: 'engine_state' may be used uninitialized in this function
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/leds/leds-lp5521.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
> index 9fc122c..89134d9 100644
> --- a/drivers/leds/leds-lp5521.c
> +++ b/drivers/leds/leds-lp5521.c
> @@ -175,6 +175,8 @@ static int lp5521_set_engine_mode(struct lp5521_engine *engine, u8 mode)
>  		mode = LP5521_CMD_DIRECT;
>  
>  	ret = lp5521_read(client, LP5521_REG_OP_MODE, &engine_state);
> +	if (ret < 0)
> +		return ret;
>  
>  	/* set mode only for this engine */
>  	engine_state &= ~(engine->engine_mask);

OK.  And the later "ret |=" whcih was previously a bug is now just
unneeded.

--- a/drivers/leds/leds-lp5521.c~leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix
+++ a/drivers/leds/leds-lp5521.c
@@ -182,9 +182,7 @@ static int lp5521_set_engine_mode(struct
 	engine_state &= ~(engine->engine_mask);
 	mode &= engine->engine_mask;
 	engine_state |= mode;
-	ret |= lp5521_write(client, LP5521_REG_OP_MODE, engine_state);
-
-	return ret;
+	return lp5521_write(client, LP5521_REG_OP_MODE, engine_state);
 }
 
 static int lp5521_load_program(struct lp5521_engine *eng, const u8 *pattern)
_

