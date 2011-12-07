Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab1LGKhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:37:13 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:29556 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab1LGKhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:37:11 -0500
Message-ID: <4EDF41C5.1030105@oracle.com>
Date: Wed, 07 Dec 2011 18:36:53 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: jeremy@goop.org, paul.durrant@citrix.com, Ian.Campbell@citrix.com
CC: annie.li@oracle.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        kurt.hackel@oracle.com
Subject: Re: [PATCH 1/2] xen/granttable: Support sub-page grants
References: <4EDDF41E.8070200@oracle.com> <1323168999-4434-1-git-send-email-annie.li@oracle.com>
In-Reply-To: <1323168999-4434-1-git-send-email-annie.li@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4EDF41D3.00A2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +void gnttab_grant_foreign_access_ref_subpage_v2(grant_ref_t ref, domid_t domid,
> +						unsigned long frame, int flags,
> +						unsigned page_off,
> +						unsigned length)
> +{
> +	BUG_ON(flags&  (GTF_accept_transfer | GTF_reading |
> +			GTF_writing | GTF_transitive));
This is slightly changed from the initial code, welcome your suggestions.

Initial condition is:
BUG_ON(flags & (GTF_accept_transfer | GTF_reading | GTF_writing | 
GTF_sub_page | GTF_permit_access));

GTF_sub_page | GTF_permit_access will be set later in this function, so 
it is necessary to verify this flag here.
GTF_transitive and GTF_sub_page can not be enabled at same time, so 
GTF_transitive is checked here to avoid those two flags are both enabled.

Same code was changed in corresponding transitive function.

Thanks
Annie
> +	BUG_ON(grant_table_version == 1);
> +	gnttab_shared.v2[ref].sub_page.frame = frame;
> +	gnttab_shared.v2[ref].sub_page.page_off = page_off;
> +	gnttab_shared.v2[ref].sub_page.length = length;
> +	gnttab_shared.v2[ref].hdr.domid = domid;
> +	wmb();
> +	gnttab_shared.v2[ref].hdr.flags =
> +				GTF_permit_access | GTF_sub_page | flags;
> +}
>
