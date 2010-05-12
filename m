Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0ELIgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:36:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab0ELIgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:36:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100511185141.6139.98842.stgit@localhost.localdomain>
References: <20100511185141.6139.98842.stgit@localhost.localdomain> <20100511184949.6139.96826.stgit@localhost.localdomain>
To: Dan Williams <dan.j.williams@intel.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, netdev@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: Re: [PATCH 2/2] ioat2,3: convert to producer/consumer locking
Date: Wed, 12 May 2010 09:36:05 +0100
Message-ID: <31229.1273653365@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Out of interest, does it make the code smaller if you mark
ioat2_get_ring_ent() and ioat2_ring_mask() with __attribute_const__?

I'm not sure whether it'll affect how long gcc is willing to cache these, but
once computed, I would guess they won't change within the calling function.

Also, is the device you're driving watching the ring and its indices?  If so,
does it modify the indices?  If that is the case, you might need to use
read_barrier_depends() rather than smp_read_barrier_depends().

> +		prefetch(ioat2_get_ring_ent(ioat, idx + i + 1));
> +		desc = ioat2_get_ring_ent(ioat, idx + i);
>  		dump_desc_dbg(ioat, desc);
>  		tx = &desc->txd;
>  		if (tx->cookie) {

Is this right, I wonder?  You're prefetching [i+1] before reading [i]?  Doesn't
this mean that you might have to wait for [i+1] to be retrieved from RAM before
[i] can be read?  Should you instead read tx->cookie before issuing the
prefetch?  Admittedly, this is only likely to affect the reading of the head of
the queue - subsequent reads in the same loop will, of course, have been
prefetched.

David
