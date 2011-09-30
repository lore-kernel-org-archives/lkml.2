Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab1I3ISW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 04:18:22 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:25785 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab1I3ISS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 04:18:18 -0400
X-IronPort-AV: E=Sophos;i="4.68,465,1312156800"; 
   d="scan'208";a="8143362"
Subject: Re: [Xen-devel] [PATCH 9/9] xen/p2m/debugfs: Fix potential pointer
 exception.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Dan Carpenter <error27@gmail.com>
Date: Fri, 30 Sep 2011 09:18:17 +0100
In-Reply-To: <1317325971-21603-10-git-send-email-konrad.wilk@oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
	 <1317325971-21603-10-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317370697.26672.230.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 20:52 +0100, Konrad Rzeszutek Wilk wrote:
> We could be referencing the last + 1 element of level_name[]
> array which would cause a pointer exception.

If we end up accessing it does that not mean something, i.e. should it
not be a real string here and not NULL? Otherwise isn't it a bug in the
lookup code that we end up looking there?

I think this lookup correspond to the initialisation of lvl=4 and
falling through the subsequent list of checks without matching one. In
which case I think level_name[4] should be "unknown" or even "error".

I don't think you can hit type_name[4] in the same way, type and
prev_type are always one of the TYPE_* defines, which have values 0..3
inclusive. You could make this more obvious and defend against future
changes breaking this with:
	... type_name[] = {
		[TYPE_IDENTITY] = "identity",
		[TYPE_MISSING] = "missing"
		...
	};

Ian.

> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/p2m.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 58efeb9..bc4cf0a 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -786,9 +786,9 @@ EXPORT_SYMBOL_GPL(m2p_find_override_pfn);
>  int p2m_dump_show(struct seq_file *m, void *v)
>  {
>  	static const char * const level_name[] = { "top", "middle",
> -						"entry", "abnormal" };
> +						"entry", "abnormal", NULL};
>  	static const char * const type_name[] = { "identity", "missing",
> -						"pfn", "abnormal"};
> +						"pfn", "abnormal", NULL};
>  #define TYPE_IDENTITY 0
>  #define TYPE_MISSING 1
>  #define TYPE_PFN 2


