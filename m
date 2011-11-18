Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab1KRLCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:02:48 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:22973 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab1KRLCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:02:47 -0500
X-IronPort-AV: E=Sophos;i="4.69,532,1315180800"; 
   d="scan'208";a="9006595"
Subject: Re: [PATCH 2/3] xen/granttable: Grant tables V2 implementation
From: Ian Campbell <Ian.Campbell@citrix.com>
To: ANNIE LI <annie.li@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Date: Fri, 18 Nov 2011 11:02:45 +0000
In-Reply-To: <4EC62FE5.2080608@oracle.com>
References: <4EC3B62F.6080702@oracle.com>
	 <1321451372-13596-1-git-send-email-annie.li@oracle.com>
	 <4EC62FE5.2080608@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1321614166.3664.311.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 10:13 +0000, ANNIE LI wrote:
> static void gnttab_request_version(void)
>  {
> -       grant_table_version = 1;
> -       gnttab_interface = &gnttab_v1_ops;
> +       int rc;
> +       struct gnttab_set_version gsv;
> +       const char *str = "we need grant tables version 2, but only version 1 is available\n";
> +
> +       gsv.version = 2;
> +       rc = HYPERVISOR_grant_table_op(GNTTABOP_set_version, &gsv, 1);
> +       if (rc == 0) {
> +               grant_table_version = 2;
> +               gnttab_interface = &gnttab_v2_ops;
> +       } else {
> +               if (grant_table_version == 2) {

	  } else if (...) {
		panic
	  } else {
		setup v1
	  }

> +                       /*
> +                        * If we've already used version 2 features,
> +                        * but then suddenly discover that they're not
> +                        * available (e.g. migrating to an older
> +                        * version of Xen), almost unbounded badness
> +                        * can happen.
> +                        */
> +                       xen_raw_printk(str);
> +                       panic(str);

I expect you've just copied this style from elsewhere but I really
dislike this duplication of prints. If panic is not useful here we
really ought to address that at the root instead of going around
patching things to print every panic message twice. I thought
earlyprintk was supposed to solve this problem. Perhaps a generic
early_panic_print could be added to the panic code?

If we stick with this (which is fair enough since it is outside the
scope of this series) you should move the const char *str into this code
block so it is near to the use.

> +               }
> +               grant_table_version = 1;
> +               gnttab_interface = &gnttab_v1_ops;
> +       }
>         printk(KERN_INFO "Grant tables using version %d layout.\n",
>                 grant_table_version);
>  } 

