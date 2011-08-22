Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab1HVV46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 17:56:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47780 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1HVV45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 17:56:57 -0400
Subject: Re: [PATCH 3/4] string: introduce memchr_inv
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Joern Engel <joern@logfs.org>, logfs@logfs.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>, linux-arch@vger.kernel.org
In-Reply-To: <20110822135218.f2d9f462.akpm@linux-foundation.org>
References: <1314030548-21082-1-git-send-email-akinobu.mita@gmail.com>
	 <1314030548-21082-4-git-send-email-akinobu.mita@gmail.com>
	 <20110822135218.f2d9f462.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Aug 2011 23:56:51 +0200
Message-ID: <1314050211.4791.4.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 22 août 2011 à 13:52 -0700, Andrew Morton a écrit :
> On Tue, 23 Aug 2011 01:29:07 +0900
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 
> > memchr_inv() is mainly used to check whether the whole buffer is filled
> > with just a specified byte.
> > 
> > The function name and prototype are stolen from logfs and the
> > implementation is from SLUB.
> > 
> > ...
> >
> > +/**
> > + * memchr_inv - Find a character in an area of memory.
> > + * @s: The memory area
> > + * @c: The byte to search for
> > + * @n: The size of the area.
> 
> This text seems to be stolen from memchr().  I guess it's close enough.
> 
> > + * returns the address of the first character other than @c, or %NULL
> > + * if the whole buffer contains just @c.
> > + */
> > +void *memchr_inv(const void *start, int c, size_t bytes)
> > +{
> > +	u8 value = c;
> > +	u64 value64;
> > +	unsigned int words, prefix;
> > +
> > +	if (bytes <= 16)
> > +		return check_bytes8(start, value, bytes);
> > +
> > +	value64 = value | value << 8 | value << 16 | value << 24;
> > +	value64 = (value64 & 0xffffffff) | value64 << 32;
> > +	prefix = 8 - ((unsigned long)start) % 8;
> > +

<snip>

> > +	if (prefix) {
> > +		u8 *r = check_bytes8(start, value, prefix);
> > +		if (r)
> > +			return r;
> > +		start += prefix;
> > +		bytes -= prefix;
> > +	}

</snip>

Please note Andrew the previous code just make sure 'start' is aligned
on 8 bytes boundary. (It is suboptimal because if 'start' was already
aligned, we call the slow check_bytes(start, value, 8))

Code should probably do

prefix = (unsigned long)start % 8;
if (prefix) {
	prefix = 8 - prefix;
	r = check_bytes8(start, value, prefix);
	...



> > +
> > +	words = bytes / 8;
> > +
> > +	while (words) {
> > +		if (*(u64 *)start != value64)



