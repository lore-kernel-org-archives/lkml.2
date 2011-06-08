Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1FHRaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:30:35 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:53433 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab1FHRad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:30:33 -0400
Date: Wed, 8 Jun 2011 11:30:31 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: David Jander <david@protonic.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/6] GPIO: pca953x.c: Set device platform_data pointer
 after allocating it
Message-ID: <20110608173031.GK8499@ponder.secretlab.ca>
References: <1307537314-4345-1-git-send-email-david@protonic.nl>
 <1307537314-4345-3-git-send-email-david@protonic.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307537314-4345-3-git-send-email-david@protonic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 02:48:30PM +0200, David Jander wrote:
> In the case that we obtain device-tree data to fill in platform_data,
> the dev.platform_data pointer needs to be set, since it is used by
> functions such as pca953x_irq_setup() later on.
> 
> Signed-off-by: David Jander <david@protonic.nl>
> ---
>  drivers/gpio/pca953x.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
> index b31f881..2dff562 100644
> --- a/drivers/gpio/pca953x.c
> +++ b/drivers/gpio/pca953x.c
> @@ -660,6 +660,7 @@ static int __devinit pca953x_probe(struct i2c_client *client,
>  		 * dynamically and must be freed in the driver
>  		 */
>  		chip->dyn_pdata = pdata;
> +		client->dev.platform_data = pdata;

No, this is illegal.  The dev->platform_data pointer must be
considered immutable by the device driver.  Otherwise you risk
breaking driver unbind/rebind use case.

Instead, the driver should be fixed so that it doesn't look at the
client->dev.platform_data pointer after .probe() has returned.  You
can do this by copying the relevant data into the driver's private
data structure.

g.

