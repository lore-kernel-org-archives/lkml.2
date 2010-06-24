Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0FXSEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 14:04:24 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:38233 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab0FXSEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 14:04:23 -0400
Date: Thu, 24 Jun 2010 20:04:24 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Store sysfs dirent structs in rbtree
Message-ID: <20100624200424.0a7d3a57@gondolin>
In-Reply-To: <4C22C944.4040700@austin.ibm.com>
References: <4C22C944.4040700@austin.ibm.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Dirk
 Wittkopp Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010 21:56:04 -0500,
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> +static void sysfs_dirent_insert(struct sysfs_dirent *sd)
> +{
> +	struct sysfs_dirent *parent_sd = sd->s_parent;
> +	struct sysfs_dirent *d;
> +	struct rb_node **p = &parent_sd->s_dir.rb_root.rb_node;
> +	struct rb_node *parent = NULL;
> +
> +	while (*p) {
> +		int cmp_val;
> +		parent = *p;
> +		d = to_sysfs_dirent(parent);
> +
> +		cmp_val = strcmp(d->s_name, sd->s_name);
> +		if (cmp_val < 0)
> +			p = &parent->rb_left;
> +		if (cmp_val > 0)
> +			p = &parent->rb_right;
> +	}
> +
> +	rb_link_node(&sd->s_dir.rb_node, parent, p);
> +	rb_insert_color(&sd->s_dir.rb_node, &parent_sd->s_dir.rb_root);
> +}

This will run into trouble if you have duplicate names in different
namespaces. You won't see it with your patch though, since...

> @@ -536,14 +572,24 @@
>  				       const void *ns,
>  				       const unsigned char *name)
>  {
> -	struct sysfs_dirent *sd;
> -
> -	for (sd = parent_sd->s_dir.children; sd; sd = sd->s_sibling) {
> -		if (ns && sd->s_ns && (sd->s_ns != ns))
> -			continue;
> -		if (!strcmp(sd->s_name, name))
> -			return sd;
> +	struct sysfs_dirent *d;
> +	struct rb_node **p = &parent_sd->s_dir.rb_root.rb_node;
> +	struct rb_node *parent = NULL;
> +
> +	while (*p) {
> +		int cmp_val;
> +		parent = *p;
> +		d = to_sysfs_dirent(parent);
> +
> +		cmp_val = strcmp(d->s_name, name);
> +		if (cmp_val == 0)
> +			return d;
> +		else if (cmp_val < 0)
> +			p = &parent->rb_left;
> +		else /* (cmp_val > 0) */
> +			p = &parent->rb_right;
>  	}
> +
>  	return NULL;
>  }

...you removed the namespace check down here.
