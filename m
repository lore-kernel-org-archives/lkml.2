Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab1JMPWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:22:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135Ab1JMPWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:22:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOH1cHnagaAVQ+8h_thqe7sneeiE6dCcD-U_NgZoO2PZRbixMg@mail.gmail.com>
References: <CAOH1cHnagaAVQ+8h_thqe7sneeiE6dCcD-U_NgZoO2PZRbixMg@mail.gmail.com> <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com> <2150.1314882260@redhat.com> <CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com> <CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com> <5149.1317036720@redhat.com> <CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com> <CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com> <6324.1317308270@redhat.com> <CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com> <12748.1317313818@redhat.com> <CAOH1cHmFuXn3uZbyZy94-cBGCPDxLsJuskkYRteeBs75iLhssw@mail.gmail.com> <CAOH1cHn3_aeVYC73YO43zf5piKOO_=MJwbbVfhW8eAWnDahRrw@mail.gmail.com> <18003.1317336244@redhat.com> <CAOH1cHmeX56+dZEidR4AAwEkz2kr7-J12vky5G8s0vzfbO39yw@mail.gmail.com> <6261.1317385734@redhat.com> <CAOH1cHkVjTSBvqvaoWnxTB1V-dOtj1cCT_kMZpJdsyNNeUoBag@mail.gmail.com> <8905.1317984176@redhat.com> <1448.1318338!
 420@redhat.com> <CAOH1cHkTiitknOsjnu9n7B2Ax+pSgM-EFDFJodjDnamxt3RMCA@mail.gmail.com> <9908.1318413955@redhat.com> <CAOH1cHkg_eQRCHxOxiOPgO=-aZfnjts-tLFQFKffk5JjEfqy2w@mail.gmail.com> 
To: Mark Moseley <moseleymark@gmail.com>
Cc: dhowells@redhat.com,
        Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
Date: Thu, 13 Oct 2011 16:21:27 +0100
Message-ID: <32454.1318519287@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Moseley <moseleymark@gmail.com> wrote:

> So on a cleared cache with SLAB, it took a while but this finally came
> up. One interesting thing is that at some point, it logged this:
> 
> [13461.605871] [httpd ] <== __fscache_read_or_alloc_pages() = -ENOBUFS
> [invalidating]

That's okay.  Basically, a read-from-cache operation was rejected because the
cache object was in the early phase of being invalidated.  I kept it simple
here - the read might complete next time it is tried, but it's just a cache so
that shouldn't matter.

> It was a while from when it logged that until when I happened to check
> on the box again, but when I did (shortly before this traceback),
> despite constant NFS activity, nothing in the fscache cache was
> getting written out (i.e. the used bytes on the partition stopped
> changing), and without any messages about withdrawing the cache or
> anythin.

Did you look at /proc/fs/fscache/stats at all?

> [20839.802118] kernel BUG at fs/fscache/object-list.c:83!
> [20839.802733] invalid opcode: 0000 [#1] SMP

That fits with the previous BUG elsewhere in object-list.c.  It sounds like
there's a refcounting problem somewhere.

David
