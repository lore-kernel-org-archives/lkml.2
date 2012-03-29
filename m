Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab2C2Ezg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 00:55:36 -0400
Received: from ozlabs.org ([203.10.76.45]:45112 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab2C2Ez1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 00:55:27 -0400
From: Michael Neuling <mikey@neuling.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, arnd@arndb.de, hpa@zytor.com,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [GIT PULL] Disintegrate and kill asm/system.h
In-reply-to: <20120329154238.1ce219f7c998da45452af4b2@canb.auug.org.au>
References: <5599.1332958811@redhat.com> <30702.1332989444@neuling.org> <20120329135555.06593144b65bf81cc9191f8a@canb.auug.org.au> <20120329151544.ef2117821dfb459e8b52af48@canb.auug.org.au> <CA+55aFzn=bsH76hPDUgS-FBP=RVu51gwmRdqjkw5RJO=Q_cRfA@mail.gmail.com> <20120329154238.1ce219f7c998da45452af4b2@canb.auug.org.au>
Comments: In-reply-to Stephen Rothwell <sfr@canb.auug.org.au>
   message dated "Thu, 29 Mar 2012 15:42:38 +1100."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Thu, 29 Mar 2012 15:55:24 +1100
Message-ID: <11814.1332996924@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Can we please move that abortion into arch/powerpc/? Instead of making
> > generic code even uglier..
> 
> How about this (build tested on powerpc allyesconfig):
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 29 Mar 2012 14:58:10 +1100
> Subject: [PATCH] powerpc: fix fallout from system.h split up
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

FWIW.. this works for me too..

Acked-by: Michael Neuling <mikey@neuling.org>

Mikey

> ---
>  arch/powerpc/kernel/fadump.c |    2 +
>  arch/powerpc/kernel/irq.c    |   72 ++++++++++++++++++++++++++++++++++++++=
> ++++
>  arch/powerpc/kernel/kgdb.c   |    1 +
>  kernel/irq/irqdomain.c       |   72 --------------------------------------=
> ----
>  4 files changed, 75 insertions(+), 72 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
> index cfe7a38..18bdf74 100644
> --- a/arch/powerpc/kernel/fadump.c
> +++ b/arch/powerpc/kernel/fadump.c
> @@ -40,6 +40,8 @@
>  #include <asm/prom.h>
>  #include <asm/rtas.h>
>  #include <asm/fadump.h>
> +#include <asm/debug.h>
> +#include <asm/setup.h>
> =20
>  static struct fw_dump fw_dump;
>  static struct fadump_mem_struct fdm;
> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> index 243dbab..ff165f5 100644
> --- a/arch/powerpc/kernel/irq.c
> +++ b/arch/powerpc/kernel/irq.c
> @@ -623,3 +623,75 @@ static int __init setup_noirqdistrib(char *str)
> =20
>  __setup("noirqdistrib", setup_noirqdistrib);
>  #endif /* CONFIG_PPC64 */
> +
> +#ifdef CONFIG_VIRQ_DEBUG
> +static int virq_debug_show(struct seq_file *m, void *private)
> +{
> +	unsigned long flags;
> +	struct irq_desc *desc;
> +	const char *p;
> +	static const char none[] =3D "none";
> +	void *data;
> +	int i;
> +
> +	seq_printf(m, "%-5s  %-7s  %-15s  %-18s  %s\n", "virq", "hwirq",
> +		      "chip name", "chip data", "domain name");
> +
> +	for (i =3D 1; i < nr_irqs; i++) {
> +		desc =3D irq_to_desc(i);
> +		if (!desc)
> +			continue;
> +
> +		raw_spin_lock_irqsave(&desc->lock, flags);
> +
> +		if (desc->action && desc->action->handler) {
> +			struct irq_chip *chip;
> +
> +			seq_printf(m, "%5d  ", i);
> +			seq_printf(m, "0x%05lx  ", desc->irq_data.hwirq);
> +
> +			chip =3D irq_desc_get_chip(desc);
> +			if (chip && chip->name)
> +				p =3D chip->name;
> +			else
> +				p =3D none;
> +			seq_printf(m, "%-15s  ", p);
> +
> +			data =3D irq_desc_get_chip_data(desc);
> +			seq_printf(m, "0x%16p  ", data);
> +
> +			if (desc->irq_data.domain->of_node)
> +				p =3D desc->irq_data.domain->of_node->full_name
;
> +			else
> +				p =3D none;
> +			seq_printf(m, "%s\n", p);
> +		}
> +
> +		raw_spin_unlock_irqrestore(&desc->lock, flags);
> +	}
> +
> +	return 0;
> +}
> +
> +static int virq_debug_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, virq_debug_show, inode->i_private);
> +}
> +
> +static const struct file_operations virq_debug_fops =3D {
> +	.open =3D virq_debug_open,
> +	.read =3D seq_read,
> +	.llseek =3D seq_lseek,
> +	.release =3D single_release,
> +};
> +
> +static int __init irq_debugfs_init(void)
> +{
> +	if (debugfs_create_file("virq_mapping", S_IRUGO, powerpc_debugfs_root,
> +				 NULL, &virq_debug_fops) =3D=3D NULL)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +__initcall(irq_debugfs_init);
> +#endif /* CONFIG_VIRQ_DEBUG */
> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
> index 76a6e40..782bd0a 100644
> --- a/arch/powerpc/kernel/kgdb.c
> +++ b/arch/powerpc/kernel/kgdb.c
> @@ -24,6 +24,7 @@
>  #include <asm/current.h>
>  #include <asm/processor.h>
>  #include <asm/machdep.h>
> +#include <asm/debug.h>
> =20
>  /*
>   * This table contains the mapping between PowerPC hardware trap types, and
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index af48e59..ae645ab 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -632,78 +632,6 @@ unsigned int irq_linear_revmap(struct irq_domain *doma=
> in,
>  	return revmap[hwirq];
>  }
> =20
> -#ifdef CONFIG_VIRQ_DEBUG
> -static int virq_debug_show(struct seq_file *m, void *private)
> -{
> -	unsigned long flags;
> -	struct irq_desc *desc;
> -	const char *p;
> -	static const char none[] =3D "none";
> -	void *data;
> -	int i;
> -
> -	seq_printf(m, "%-5s  %-7s  %-15s  %-18s  %s\n", "virq", "hwirq",
> -		      "chip name", "chip data", "domain name");
> -
> -	for (i =3D 1; i < nr_irqs; i++) {
> -		desc =3D irq_to_desc(i);
> -		if (!desc)
> -			continue;
> -
> -		raw_spin_lock_irqsave(&desc->lock, flags);
> -
> -		if (desc->action && desc->action->handler) {
> -			struct irq_chip *chip;
> -
> -			seq_printf(m, "%5d  ", i);
> -			seq_printf(m, "0x%05lx  ", desc->irq_data.hwirq);
> -
> -			chip =3D irq_desc_get_chip(desc);
> -			if (chip && chip->name)
> -				p =3D chip->name;
> -			else
> -				p =3D none;
> -			seq_printf(m, "%-15s  ", p);
> -
> -			data =3D irq_desc_get_chip_data(desc);
> -			seq_printf(m, "0x%16p  ", data);
> -
> -			if (desc->irq_data.domain->of_node)
> -				p =3D desc->irq_data.domain->of_node->full_name
;
> -			else
> -				p =3D none;
> -			seq_printf(m, "%s\n", p);
> -		}
> -
> -		raw_spin_unlock_irqrestore(&desc->lock, flags);
> -	}
> -
> -	return 0;
> -}
> -
> -static int virq_debug_open(struct inode *inode, struct file *file)
> -{
> -	return single_open(file, virq_debug_show, inode->i_private);
> -}
> -
> -static const struct file_operations virq_debug_fops =3D {
> -	.open =3D virq_debug_open,
> -	.read =3D seq_read,
> -	.llseek =3D seq_lseek,
> -	.release =3D single_release,
> -};
> -
> -static int __init irq_debugfs_init(void)
> -{
> -	if (debugfs_create_file("virq_mapping", S_IRUGO, powerpc_debugfs_root,
> -				 NULL, &virq_debug_fops) =3D=3D NULL)
> -		return -ENOMEM;
> -
> -	return 0;
> -}
> -__initcall(irq_debugfs_init);
> -#endif /* CONFIG_VIRQ_DEBUG */
> -
>  int irq_domain_simple_map(struct irq_domain *d, unsigned int irq,
>  			  irq_hw_number_t hwirq)
>  {
> --=20
> 1.7.9.1
> 
> 
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
