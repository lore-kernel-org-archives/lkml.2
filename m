Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1HIJPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 05:15:22 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:11077 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1HIJPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 05:15:20 -0400
X-IronPort-AV: E=Sophos;i="4.67,342,1309737600"; 
   d="scan'208";a="7171929"
Subject: Re: [Xen-devel] [PATCH 1/3] xen/pv-on-hvm kexec: add xs_introduce
 to shutdown watches from old kernel
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        Konrad <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
In-Reply-To: <20110804162054.096018606@aepfle.de>
References: <20110804162053.723541930@aepfle.de>
	 <20110804162054.096018606@aepfle.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 9 Aug 2011 10:15:18 +0100
Message-ID: <1312881318.26263.44.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: linux-3.0/drivers/xen/xenbus/xenbus_xs.c
> ===================================================================
> --- linux-3.0.orig/drivers/xen/xenbus/xenbus_xs.c
> +++ linux-3.0/drivers/xen/xenbus/xenbus_xs.c
> @@ -620,6 +620,20 @@ static struct xenbus_watch *find_watch(c
>  	return NULL;
>  }
>  
> +static int xs_introduce(const char *domid, const char *mfn, const char *port)
> +{
> +	struct kvec iov[3];
> +
> +	iov[0].iov_base = (char *)domid;
> +	iov[0].iov_len = strlen(domid) + 1;
> +	iov[1].iov_base = (char *)mfn;
> +	iov[1].iov_len = strlen(mfn) + 1;
> +	iov[2].iov_base = (char *)port;
> +	iov[2].iov_len = strlen(port) + 1;
> +
> +	return xs_error(xs_talkv(XBT_NIL, XS_INTRODUCE, iov,
> +				 ARRAY_SIZE(iov), NULL));

What should we do if this fails?

> +}
>  /* Register callback to watch this node. */
>  int register_xenbus_watch(struct xenbus_watch *watch)
>  {
> @@ -867,10 +881,11 @@ static int xenbus_thread(void *unused)
>  	return 0;
>  }
>  
> -int xs_init(void)
> +int xs_init(unsigned long xen_store_mfn)
>  {
>  	int err;
>  	struct task_struct *task;
> +	char domid[12], mfn[24], port[24];
>  
>  	INIT_LIST_HEAD(&xs_state.reply_list);
>  	spin_lock_init(&xs_state.reply_lock);
> @@ -897,5 +912,15 @@ int xs_init(void)
>  	if (IS_ERR(task))
>  		return PTR_ERR(task);
>  
> +	snprintf(domid, sizeof(domid), "%u", DOMID_SELF);
> +	snprintf(mfn, sizeof(mfn), "%lu", xen_store_mfn);
> +	snprintf(port, sizeof(port), "%d", xen_store_evtchn);

These can be within the if, or better within the xs_introduce function
itself.

> +	if (xen_hvm_domain()) {
> +		/* shutdown watches for kexec boot */
> +		err = xs_introduce(domid, mfn, port);
> +		if (err)
> +			printk(KERN_WARNING "xs_introduce failed: %d\n", err);
> +	}
> +
>  	return 0;
>  }
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel


