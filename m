Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab2GTC5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 22:57:37 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47121 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2GTC5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 22:57:36 -0400
Message-ID: <5008C90A.50705@linux.vnet.ibm.com>
Date: Thu, 19 Jul 2012 19:57:14 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Cody Schafer <cody@linux.vnet.ibm.com>
CC: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] perf: prevent overflow in size calculation
References: <87a9yv2r5q.fsf@sejong.aot.lge.com> <1342752552-3065-1-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1342752552-3065-1-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072002-2398-0000-0000-000008A3FEA0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>   	struct annotation *notes = symbol__annotation(sym);
>   	const size_t size = symbol__size(sym);
> -	size_t sizeof_sym_hist = (sizeof(struct sym_hist) + size * sizeof(u64));
> +	size_t sizeof_sym_hist;
> +
> +	/* Check for overflow when calculating sizeof_sym_hist */
> +	if (size > (SIZE_MAX / sizeof(u64) - sizeof(struct sym_hist)))
> +		return -1;
> +
> +	sizeof_sym_hist = (sizeof(struct sym_hist) + size * sizeof(u64));
> +
> +	/* Check for overflow in zalloc argument */
> +	if (sizeof_sym_hist > (SIZE_MAX / symbol_conf.nr_events
> +				- sizeof(*notes->src)))
> +		return -1;
>
>   	notes->src = zalloc(sizeof(*notes->src) + symbol_conf.nr_events * sizeof_sym_hist);
>   	if (notes->src == NULL)
>

Actually, I don't think this is correct either (subtraction seems to 
occur in the wrong spot).

