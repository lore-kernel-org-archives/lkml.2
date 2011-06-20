Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab1FTITp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 04:19:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48639 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1FTITm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 04:19:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kGKqUEVu2fIkTmf8VOU73PrTX5VayJkKqh+bHcjmFb3xAbSjprOo1jn2h47symbsRw
         zmjgHEUWEyEtHrLib2v3dJ+mE2pw5a3Ja+f0KV18yizezslfIxW8uyEKzKTcK4oX023D
         46Hupwadf7AQSooT18ggHdsBiaDVSCIlxDtw8=
Date: Mon, 20 Jun 2011 10:19:37 +0200
From: Tejun Heo <tj@kernel.org>
To: Yuan-Hsin Chen <yuanlmm@gmail.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        sshtylyov@mvista.com, Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: Re: [PATCH v4] ahci: move ahci_sb600_softreset to libahci.c and
 rename it
Message-ID: <20110620081937.GN2611@htj.dyndns.org>
References: <20110617120704.GH2611@htj.dyndns.org>
 <1308557202-1895-1-git-send-email-yuanlmm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308557202-1895-1-git-send-email-yuanlmm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Yuan.

Yeap, almost there, just few very minor things. :)

On Mon, Jun 20, 2011 at 04:06:41PM +0800, Yuan-Hsin Chen wrote:
>  static struct ata_port_operations ahci_sb600_ops = {
>  	.inherits		= &ahci_ops,
> -	.softreset		= ahci_sb600_softreset,
> -	.pmp_softreset		= ahci_sb600_softreset,
> +	.softreset		= ahci_pmp_retry_srst_softreset,
>  };

Why doesn't sb600 just use ahci_pmp_retry_srst_ops?

> @@ -312,6 +312,7 @@ extern struct device_attribute *ahci_sdev_attrs[];
>  	.sdev_attrs		= ahci_sdev_attrs
>  
>  extern struct ata_port_operations ahci_ops;
> +extern struct ata_port_operations ahci_pmp_retry_srst_ops;

Heh, I know I suggested that name but that is one ugly name.  If
anyone has any better idea, please come forward.

> @@ -82,6 +82,8 @@ static void ahci_pmp_attach(struct ata_port *ap);
>  static void ahci_pmp_detach(struct ata_port *ap);
>  static int ahci_softreset(struct ata_link *link, unsigned int *class,
>  			  unsigned long deadline);
> +static int ahci_pmp_retry_srst_softreset(struct ata_link *link, unsigned int *class,
> +			  unsigned long deadline);

srst equals softreset, so ahci_pmp_retry_softreset() should do.

> +struct ata_port_operations ahci_pmp_retry_srst_ops = {
> +	.inherits		= &ahci_ops,
> +	.softreset		= ahci_pmp_retry_srst_softreset,
> +};
> +EXPORT_SYMBOL_GPL(ahci_pmp_retry_srst_ops);
> +
>  struct ata_port_operations ahci_ops = {
>  	.inherits		= &sata_pmp_port_ops,

Maybe it's better to place ahci_pmp_retry_srst_ops after ahci_ops?

> +static int ahci_pmp_check_ready(struct ata_link *link)

It would be better if the name reflects that it's not for specific
workaround.

Thank you.

-- 
tejun
