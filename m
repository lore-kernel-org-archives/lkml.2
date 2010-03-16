Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899Ab0CPQ6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:58:09 -0400
Received: from isilmar.linta.de ([213.133.102.198]:41177 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759822Ab0CPQ6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:58:06 -0400
Date: Tue, 16 Mar 2010 17:57:13 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: [PATCH 1/1] PCMCIA: resource, fix lock imbalance
Message-ID: <20100316165712.GA25385@comet.dominikbrodowski.net>
Mail-Followup-To: Jiri Slaby <jslaby@suse.cz>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	jirislaby@gmail.com
References: <1268751464-15168-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268751464-15168-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK, applied -- even though this code path is actually unused in current
kernels.

Thanks,
	Dominik

On Tue, Mar 16, 2010 at 03:57:44PM +0100, Jiri Slaby wrote:
> Stanse found that one error path (when alloc_skb fails) in netdev_tx
> omits to unlock hw_priv->hwlock. Fix that by moving away from unlock in
> each fail path. Unlock at one place instead.
> 
> Introduced in 94a819f80297e1f635a7cde4ed5317612e512ba7
> (pcmcia: assert locking to struct pcmcia_device)
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> ---
>  drivers/pcmcia/pcmcia_resource.c |   28 ++++++++++++++++------------
>  1 files changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
> index b2df041..add962a 100644
> --- a/drivers/pcmcia/pcmcia_resource.c
> +++ b/drivers/pcmcia/pcmcia_resource.c
> @@ -256,6 +256,7 @@ int pcmcia_modify_configuration(struct pcmcia_device *p_dev,
>  {
>  	struct pcmcia_socket *s;
>  	config_t *c;
> +	int ret;
>  
>  	s = p_dev->socket;
>  
> @@ -264,13 +265,13 @@ int pcmcia_modify_configuration(struct pcmcia_device *p_dev,
>  
>  	if (!(s->state & SOCKET_PRESENT)) {
>  		dev_dbg(&s->dev, "No card present\n");
> -		mutex_unlock(&s->ops_mutex);
> -		return -ENODEV;
> +		ret = -ENODEV;
> +		goto unlock;
>  	}
>  	if (!(c->state & CONFIG_LOCKED)) {
>  		dev_dbg(&s->dev, "Configuration isnt't locked\n");
> -		mutex_unlock(&s->ops_mutex);
> -		return -EACCES;
> +		ret = -EACCES;
> +		goto unlock;
>  	}
>  
>  	if (mod->Attributes & CONF_IRQ_CHANGE_VALID) {
> @@ -286,7 +287,8 @@ int pcmcia_modify_configuration(struct pcmcia_device *p_dev,
>  
>  	if (mod->Attributes & CONF_VCC_CHANGE_VALID) {
>  		dev_dbg(&s->dev, "changing Vcc is not allowed at this time\n");
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto unlock;
>  	}
>  
>  	/* We only allow changing Vpp1 and Vpp2 to the same value */
> @@ -294,21 +296,21 @@ int pcmcia_modify_configuration(struct pcmcia_device *p_dev,
>  	    (mod->Attributes & CONF_VPP2_CHANGE_VALID)) {
>  		if (mod->Vpp1 != mod->Vpp2) {
>  			dev_dbg(&s->dev, "Vpp1 and Vpp2 must be the same\n");
> -			mutex_unlock(&s->ops_mutex);
> -			return -EINVAL;
> +			ret = -EINVAL;
> +			goto unlock;
>  		}
>  		s->socket.Vpp = mod->Vpp1;
>  		if (s->ops->set_socket(s, &s->socket)) {
> -			mutex_unlock(&s->ops_mutex);
>  			dev_printk(KERN_WARNING, &s->dev,
>  				   "Unable to set VPP\n");
> -			return -EIO;
> +			ret = -EIO;
> +			goto unlock;
>  		}
>  	} else if ((mod->Attributes & CONF_VPP1_CHANGE_VALID) ||
>  		   (mod->Attributes & CONF_VPP2_CHANGE_VALID)) {
>  		dev_dbg(&s->dev, "changing Vcc is not allowed at this time\n");
> -		mutex_unlock(&s->ops_mutex);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto unlock;
>  	}
>  
>  	if (mod->Attributes & CONF_IO_CHANGE_WIDTH) {
> @@ -332,9 +334,11 @@ int pcmcia_modify_configuration(struct pcmcia_device *p_dev,
>  			s->ops->set_io_map(s, &io_on);
>  		}
>  	}
> +	ret = 0;
> +unlock:
>  	mutex_unlock(&s->ops_mutex);
>  
> -	return 0;
> +	return ret;
>  } /* modify_configuration */
>  EXPORT_SYMBOL(pcmcia_modify_configuration);
>  
> -- 
> 1.7.0.1
> 
> 
