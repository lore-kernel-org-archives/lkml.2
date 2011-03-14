Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab1CNPEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:04:52 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:43117 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab1CNPEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:04:51 -0400
X-IronPort-AV: E=Sophos;i="4.62,316,1297036800"; 
   d="scan'208";a="4777541"
Subject: Re: [PATCH R4 4/7] xen/balloon: Protect against CPU exhaust by
 event/x process
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Daniel Kiper <dkiper@net-space.pl>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andi.kleen@intel.com" <andi.kleen@intel.com>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Dan Magenheimer" <dan.magenheimer@oracle.com>,
        "v.tolstov@selfip.ru" <v.tolstov@selfip.ru>,
        "pasik@iki.fi" <pasik@iki.fi>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        "wdauchy@gmail.com" <wdauchy@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20110308214824.GE27331@router-fw-old.local.net-space.pl>
References: <20110308214824.GE27331@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Mon, 14 Mar 2011 15:04:49 +0000
Message-ID: <1300115089.17339.2183.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 21:48 +0000, Daniel Kiper wrote:
> Protect against CPU exhaust by event/x process during
> errors by adding some delays in scheduling next event
> and retry count limit.

The addition of a default retry count limit reverses the change made in
bc2c0303226ec716854d3c208c7f84fe7aa35cd7. That change was made to allow
system wide ballooning daemons to work as expected and I don't think a
strong argument has been made for undoing it here.

I think the exponential back-off element of this patch is probably all
that is needed to avoid using too much CPU.

We are talking about polling at most once a second (backing off pretty
quickly to once every 32s with this patch) -- is that really enough to
"exhaust" the CPU running event/x?

Also this patch seems to make the driver quite chatty:

> +	pr_info("xen_balloon: Retry count: %lu/%lu\n", balloon_stats.retry_count,
> +			balloon_stats.max_retry_count);

Not needed. The balloon driver is a best effort background thing, it
doesn't need to be spamming the system logs each time something doesn't
go quite right first time, it should just continue on silently in the
background. It should only be logging if something goes catastrophically
wrong (in which case pr_info isn't really sufficient).

> +	if (rc <= 0) {
> +		pr_info("xen_balloon: %s: Cannot allocate memory\n", __func__);

Likewise.

> +			pr_info("xen_balloon: %s: Cannot allocate memory\n", __func__);

And again.

Ian.

