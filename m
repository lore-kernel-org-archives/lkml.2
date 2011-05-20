Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409Ab1ETNTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:19:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37580 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab1ETNTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:19:38 -0400
Date: Fri, 20 May 2011 15:19:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2] x86: UV uv_tlb.c cleanup
Message-ID: <20110520131927.GB17699@elte.hu>
References: <E1QNPH2-0006eo-8E@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QNPH2-0006eo-8E@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, the whole file looks a lot better now. A few small details:

* Cliff Wickman <cpw@sgi.com> wrote:

> +	vp = kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
> +	uvhub_descs = (struct uvhub_desc *)vp;
> +	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
> +	uvhub_mask = kzalloc((nuvhubs+7)/8, GFP_KERNEL);
> +
> +	if (get_cpu_topology(base_part_pnode, uvhub_descs, uvhub_mask)) {
> +		kfree(uvhub_descs);
> +		kfree(uvhub_mask);
> +		return 1;
> +	}
> +	if (summarize_uvhub_sockets(nuvhubs, uvhub_descs, uvhub_mask)) {
> +		kfree(uvhub_descs);
> +		kfree(uvhub_mask);
> +		return 1;
> +	}
> +
>  	kfree(uvhub_descs);
>  	kfree(uvhub_mask);
> +	init_per_cpu_tunables();
>  	return 0;

Look how the teardown of uvhub_descs and uvhub_mask is repeated 3 times (!).

What we do in the kernel instead are:

	if (func())
		goto fail;

	if (func2())
		goto fail;

	ret = 0;
out:
	kfree(ptr1);
	kfree(ptr2);

	return ret;

fail:
	ret = 1;
	goto out;
}

this makes it more obvious and more readable.

Thanks,

	Ingo
