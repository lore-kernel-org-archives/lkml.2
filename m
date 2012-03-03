Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab2CCWBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 17:01:20 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:52963 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753706Ab2CCWBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 17:01:19 -0500
Date: Sat, 3 Mar 2012 23:01:17 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] pcmcia: move unbind/rebind into dev_pm_ops.complete
Message-ID: <20120303220117.GA9247@isilmar-3.linta.de>
Mail-Followup-To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201203032111.29558.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203032111.29558.chunkeey@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch 2/6 of which series? Does this depend upon other patches which
are not yet in mainline?

Best,
	Dominik

On Sat, Mar 03, 2012 at 09:11:29PM +0100, Christian Lamparter wrote:
> The idea of moving rebind procedure into pm.complete
> was taken from the usb-subsystem, which has similar
> problems with reattaching devices during/after
> resume.
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> Note: I'm not on the list; please keep the 'CC' if you have
> something to say :).
> 
> Regards,
> 	Chr
> ---
>  drivers/pcmcia/cs.c |   22 ++++++++++++++++++----
>  1 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
> index d9ea192..503596f 100644
> --- a/drivers/pcmcia/cs.c
> +++ b/drivers/pcmcia/cs.c
> @@ -512,6 +512,13 @@ static int socket_late_resume(struct pcmcia_socket *skt)
>  		return socket_insert(skt);
>  	}
>  
> +	if (!(skt->state & SOCKET_CARDBUS) && (skt->callback))
> +		skt->callback->early_resume(skt);
> +	return 0;
> +}
> +
> +static int socket_complete_resume(struct pcmcia_socket *skt)
> +{
>  #ifdef CONFIG_CARDBUS
>  	if (skt->state & SOCKET_CARDBUS) {
>  		/* We can't be sure the CardBus card is the same
> @@ -519,11 +526,8 @@ static int socket_late_resume(struct pcmcia_socket *skt)
>  		 * and re-add... */
>  		cb_free(skt);
>  		cb_alloc(skt);
> -		return 0;
>  	}
>  #endif
> -	if (!(skt->state & SOCKET_CARDBUS) && (skt->callback))
> -		skt->callback->early_resume(skt);
>  	return 0;
>  }
>  
> @@ -534,11 +538,15 @@ static int socket_late_resume(struct pcmcia_socket *skt)
>   */
>  static int socket_resume(struct pcmcia_socket *skt)
>  {
> +	int err;
>  	if (!(skt->state & SOCKET_SUSPEND))
>  		return -EBUSY;
>  
>  	socket_early_resume(skt);
> -	return socket_late_resume(skt);
> +	err = socket_late_resume(skt);
> +	if (!err)
> +		socket_complete_resume(skt);
> +	return err;
>  }
>  
>  static void socket_remove(struct pcmcia_socket *skt)
> @@ -849,6 +857,11 @@ static int __used pcmcia_socket_dev_resume(struct device *dev)
>  	return __pcmcia_pm_op(dev, socket_late_resume);
>  }
>  
> +static void __used pcmcia_socket_dev_complete(struct device *dev)
> +{
> +	__pcmcia_pm_op(dev, socket_complete_resume);
> +}
> +
>  static const struct dev_pm_ops pcmcia_socket_pm_ops = {
>  	/* dev_resume may be called with IRQs enabled */
>  	SET_SYSTEM_SLEEP_PM_OPS(NULL,
> @@ -863,6 +876,7 @@ static const struct dev_pm_ops pcmcia_socket_pm_ops = {
>  	.resume_noirq = pcmcia_socket_dev_resume_noirq,
>  	.thaw_noirq = pcmcia_socket_dev_resume_noirq,
>  	.restore_noirq = pcmcia_socket_dev_resume_noirq,
> +	.complete = pcmcia_socket_dev_complete,
>  };
>  
>  #define PCMCIA_SOCKET_CLASS_PM_OPS (&pcmcia_socket_pm_ops)
> -- 
> 1.7.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
