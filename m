Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab0FAEjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 00:39:08 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:49176 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750865Ab0FAEjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 00:39:07 -0400
Date: Tue, 1 Jun 2010 14:39:01 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Message-ID: <20100601043901.GA25693@gondor.apana.org.au>
References: <20100531160425.GA20344@basil.fritz.box> <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 10:44:30PM -0400, Mikulas Patocka wrote:
> Questions:
> 
> If you are optimizing it,
> 
> 1) why don't you optimize it in such a way that if one CPU submits 
> requests, the crypto work is spread among all the CPUs? Currently it 
> spreads the work only if different CPUs submit it.

Because the crypto layer already provides that functionality,
through pcrypt.  By instantiating pcrypt for a given algorithm,
you can parallelise that algorithm across CPUs.

This would be inappropriate for upper layer code as they do not
know whether the underlying algorithm should be parallelised,
e.g., a PCI offload board certainly should not be parallelised.

> 2) why not optimize software async crypto daemon (crypt/cryptd.c) instead 
> of dm-crypt, so that all kernel subsystems can actually take advantage of 
> those multi-CPU optimizations, not just dm-crypt?

Because you cannot do what Andi is doing here in the crypto layer.
What dm-crypt does today (which hasn't always been the case BTW)
hides information away (the original submitting CPU) that we cannot
recreate.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
