Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab0JVBLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:11:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56653 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab0JVBLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:11:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Bruno Randolf <br1@einfach.org>
Subject: Re: [PATCH v3] Add generic exponentially weighted moving average (EWMA) function
Cc: kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com,
        Lars_Ericsson@telia.com, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org
In-Reply-To: <201010220953.30148.br1@einfach.org>
References: <20101021192658.C8EE.A69D9226@jp.fujitsu.com> <201010220953.30148.br1@einfach.org>
Message-Id: <20101022100316.53A3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 22 Oct 2010 10:11:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > and nit, I don't understand what you intend by 'const unsigned int'. I
> > think we can remove this const safely. it's more easy readable.
> 
> O.K. Will resend.
> 
> Apart from that, what didn't work as you expected?

It works. I meant this const has no meaning.


few additional reviewing comments is here.


> +struct ewma {
> +	unsigned int internal;
> +	unsigned int factor;
> +	unsigned int weight;
> +};

I think unsigned long is better because long is natual register size
on both 32bit and 64bit arch.
and, example, almost linux resource limit is using long or ulong. then
uint may have overflow risk if we are using this one on 64bit arch.
Does uint has any benefit? (note: scheduler loadavg has already used ulong)

> +struct ewma*
> +ewma_add(struct ewma *avg, const unsigned int val)
> +{
> +	avg->internal = avg->internal  ?
> +		(((avg->internal * (avg->weight - 1)) +
> +			(val * avg->factor)) / avg->weight) :
> +		(val * avg->factor);
> +	return avg;

Hm, if ewma_add has this function prototype, we almost always need to
typing "new = ewma_get(ewma_add(&ewma, val))". Is this intentional?
if so, why?

Why can't we simple do following?

unsigned long ewma_add(struct ewma *avg, const unsigned int val)
{
(snip)
	return ewma_get(avg);
}



