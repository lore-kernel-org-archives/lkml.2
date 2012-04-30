Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab2D3QQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 12:16:04 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46281 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755011Ab2D3QQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 12:16:03 -0400
Message-ID: <1335802560.22209.2.camel@joe2Laptop>
Subject: Re: [PATCH v2] edac_mc: Cleanup per-dimm_info debug messages
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Date: Mon, 30 Apr 2012 09:16:00 -0700
In-Reply-To: <1335798160-9879-1-git-send-email-mchehab@redhat.com>
References: <4F9E9958.6010606@redhat.com>
	 <1335798160-9879-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-30 at 12:02 -0300, Mauro Carvalho Chehab wrote:
> The edac_mc_alloc() routine allocates one dimm_info device for all
> possible memories, including the non-filled ones. The debug messages
> there are somewhat confusing. So, cleans them, by moving the code
> that prints the memory location to edac_mc, and using it on both
> edac_mc_sysfs and edac_mc.
[]
> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
[]
> @@ -40,6 +40,25 @@
>  static DEFINE_MUTEX(mem_ctls_mutex);
>  static LIST_HEAD(mc_devices);
>  
> +unsigned edac_dimm_info_location(struct dimm_info *dimm, char *buf,
> +			         int len)
> +{
> +	struct mem_ctl_info *mci = dimm->mci;
> +	int i, n, count = 0;
> +	char *p = buf;
> +
> +	for (i = 0; i < mci->n_layers; i++) {
> +		n = snprintf(p, len, "%s %d ",
> +			      edac_layer_name[mci->layers[i].type],
> +			      dimm->location[i]);
> +		p += n;
> +		len -= n;
> +		count += n;
> +	}

I believe this snprintf can be unsafe
when the buffer length len is exceeded.

if len is negative, it's promoted to size_t
and continues to write into p.


