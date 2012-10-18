Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab2JRKf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:35:58 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:22582 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab2JRKf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:35:56 -0400
X-IronPort-AV: E=Sophos;i="4.80,606,1344211200"; 
   d="scan'208";a="15250985"
Message-ID: <1350556553.2460.108.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH V3 6/6]: PVH:privcmd changes.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 18 Oct 2012 11:35:53 +0100
In-Reply-To: <20121017173448.7ef4c0b1@mantra.us.oracle.com>
References: <20121017173448.7ef4c0b1@mantra.us.oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> @@ -439,6 +490,19 @@ static long privcmd_ioctl(struct file *file,
>  	return ret;
>  }
>  
> +static void privcmd_close(struct vm_area_struct *vma)
> +{
> +	struct page **pages = vma ? vma->vm_private_data : NULL;

Can VMA really be NULL?...

> +	int numpgs = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;

...I assume not since you unconditionally dereference it here.

> +	if (!pages || !numpgs || !xen_feature(XENFEAT_auto_translated_physmap))

In the non-xlat case pages will (or should!) be 1 here which will pass
the first clause of the test.

Although the later clauses will catch this I think it would be worth
ordering the checks such that they are each valid, perhaps by pulling
the feature check to the front or by separating the !xlat case from the
other two which are valid iff xlat == True.


