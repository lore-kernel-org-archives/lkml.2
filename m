Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab2ITXAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:00:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47860 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab2ITXAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:00:07 -0400
Date: Thu, 20 Sep 2012 15:57:28 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: gregkh@linuxfoundation.org, keescook@chromium.org, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>
Subject: Re: [PATCH] pstore: avoid recursive spinlocks in the
 oops_in_progress case
Message-ID: <20120920225727.GD29721@lizard>
References: <1347903824.29767.15.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1347903824.29767.15.camel@cliu38-desktop-build>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 01:43:44AM +0800, Chuansheng Liu wrote:
> Like 8250 driver, when pstore is registered as a console,
> to avoid recursive spinlocks when panic happening, change the
> spin_lock_irqsave to spin_trylock_irqsave when oops_in_progress
> is true.
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  fs/pstore/platform.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index 29996e8..cbcb5fc 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -164,7 +164,12 @@ static void pstore_console_write(struct console *con, const char *s, unsigned c)
>  
>  		if (c > psinfo->bufsize)
>  			c = psinfo->bufsize;
> -		spin_lock_irqsave(&psinfo->buf_lock, flags);
> +
> +		if (oops_in_progress) {
> +			if (!spin_trylock_irqsave(&psinfo->buf_lock, flags))
> +				break;

Mm... why break?

Like 8250, in this case it's better still log the console.
That is, something along these lines:

bool locked = 1;

if (oops_in_progress)
	locked = spin_trylock_irqsave(&psinfo->buf_lock, flags);
else
	spin_lock_irqsave(&psinfo->buf_lock, flags);

memcpy(psinfo->buf, s, c);
psinfo->write(PSTORE_TYPE_CONSOLE, 0, NULL, 0, c, psinfo);

if (locked)
	spin_unlock_irqrestore(&psinfo->buf_lock, flags);


Thanks,

Anton.

> +		} else
> +			spin_lock_irqsave(&psinfo->buf_lock, flags);
>  		memcpy(psinfo->buf, s, c);
>  		psinfo->write(PSTORE_TYPE_CONSOLE, 0, NULL, 0, c, psinfo);
>  		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
> -- 
> 1.7.0.4
