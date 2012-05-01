Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab2EADJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 23:09:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:51422 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250Ab2EADJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 23:09:03 -0400
Message-ID: <1335841603.3621.8.camel@pasglop>
Subject: Re: [PATCH v3 03/17] powerpc: Add PFO support to the VIO bus
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        rcj@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
Date: Tue, 01 May 2012 13:06:43 +1000
In-Reply-To: <1334243302.18090.10.camel@key-ThinkPad-W510>
References: <1334242825.18090.4.camel@key-ThinkPad-W510>
	 <1334243302.18090.10.camel@key-ThinkPad-W510>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hrm... I don't like that much:

> +	if (op->timeout)
> +		deadline = jiffies + msecs_to_jiffies(op->timeout);
> +
> +	while (true) {
> +		hret = plpar_hcall_norets(H_COP, op->flags,
> +				vdev->resource_id,
> +				op->in, op->inlen, op->out,
> +				op->outlen, op->csbcpb);
> +
> +		if (hret == H_SUCCESS ||
> +		    (hret != H_NOT_ENOUGH_RESOURCES &&
> +		     hret != H_BUSY && hret != H_RESOURCE) ||
> +		    (op->timeout && time_after(deadline, jiffies)))
> +			break;
> +
> +		dev_dbg(dev, "%s: hcall ret(%ld), retrying.\n", __func__, hret);
> +	}
> +

Is this meant to be called in atomic context ? If not, maybe it should
at the very least do a cond_resched() ?

Else, what about ceding the processor ? Or at the very least reducing
the thread priority for a bit ?

Shouldn't we also enforce to always have a timeout ? IE. Something like
30s or so if nothing specified to avoid having the kernel just hard
lock...

In general I don't like that sort of synchronous code, I'd rather return
the busy status up the chain which gives a chance to the caller to take
more appropriate measures depending on what it's doing, but that really
depends what you use that synchronous call for. I suppose if it's for
configuration type operations, it's ok...

Cheers,
Ben.


