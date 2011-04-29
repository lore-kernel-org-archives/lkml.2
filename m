Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab1D2INO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 04:13:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40752 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab1D2INK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 04:13:10 -0400
Date: Fri, 29 Apr 2011 09:12:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        shiraz.hashim@st.com,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 5/5] driver core: let dev_set_drvdata return int
	instead of void as it can fail
Message-ID: <20110429081257.GW17290@n2100.arm.linux.org.uk>
References: <20110420074248.GS31131@pengutronix.de> <1303285486-28598-1-git-send-email-u.kleine-koenig@pengutronix.de> <1303285486-28598-5-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1303285486-28598-5-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 09:44:46AM +0200, Uwe Kleine-König wrote:
> Before commit
> 
> 	b402843 (Driver core: move dev_get/set_drvdata to drivers/base/dd.c)
> 
> calling dev_set_drvdata with dev=NULL was an unchecked error. After some
> discussion about what to return in this case removing the check (and so
> producing a null pointer exception) seems fine.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/base/dd.c      |    7 +++----
>  include/linux/device.h |    2 +-
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index da57ee9..f9d69d7 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -408,17 +408,16 @@ void *dev_get_drvdata(const struct device *dev)
>  }
>  EXPORT_SYMBOL(dev_get_drvdata);
>  
> -void dev_set_drvdata(struct device *dev, void *data)
> +int dev_set_drvdata(struct device *dev, void *data)
>  {
>  	int error;
>  
> -	if (!dev)
> -		return;
>  	if (!dev->p) {
>  		error = device_private_init(dev);
>  		if (error)
> -			return;
> +			return error;
>  	}
>  	dev->p->driver_data = data;
> +	return 0;

Who is going to modify all the thousands of drivers we have in the kernel
tree to check this return value?

If the answer is no one, its pointless returning an error value in the
first place (which I think is what the original author already thought
about.)
