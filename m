Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab0IUWUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:20:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753491Ab0IUWUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:20:34 -0400
Date: Tue, 21 Sep 2010 15:20:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 04/14] memstick: core: fix device_register() error
 handling
Message-Id: <20100921152031.30365b3f.akpm@linux-foundation.org>
In-Reply-To: <1284900889-24369-1-git-send-email-segooon@gmail.com>
References: <1284900889-24369-1-git-send-email-segooon@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Sep 2010 16:54:49 +0400
Vasiliy Kulikov <segooon@gmail.com> wrote:

> If device_register() fails then call put_device().
> See comment to device_register.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  compile tested.
> 
>  drivers/memstick/core/memstick.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
> index c00fe82..4303b7e 100644
> --- a/drivers/memstick/core/memstick.c
> +++ b/drivers/memstick/core/memstick.c
> @@ -465,6 +465,7 @@ static void memstick_check(struct work_struct *work)
>  		if (!host->card) {
>  			host->card = card;
>  			if (device_register(&card->dev)) {
> +				put_device(&card->dev);
>  				kfree(host->card);
>  				host->card = NULL;
>  			}

A failed device_register() takes a bogus ref on the not-registered
device?  It's no surprise that people are getting this wrong.  

The principle of least surprise says: fix device_register()!
