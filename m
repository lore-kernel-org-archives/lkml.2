Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550Ab2CVUYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:24:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35682 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759512Ab2CVUYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:24:47 -0400
Date: Thu, 22 Mar 2012 20:24:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: Regression introduced by
 bfcfaa77bdf0f775263e906015982a608df01c76 (vfs: use 'unsigned long' accesses
 for dcache name comparison and hashing)
Message-ID: <20120322202445.GB6589@ZenIV.linux.org.uk>
References: <20120322183845.GA17264@phenom.dumpdata.com>
 <20120322200918.GZ6589@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120322200918.GZ6589@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 08:09:19PM +0000, Al Viro wrote:

> Interesting... that's exactly 8 characters.  Oh, I see - hash_name() gets
> an extra multiplication by 9 in this case.  Look: full_name_hash() will
> handle the first word, decrement len by 8, set hash to <first word> and
> bugger off on !len.  hash_name(), OTOH, will go through the loops once,
> with hash and a both 0.  hash stays 0, a becomes <first word>.  No NUL or
> / in it, so in we go again; hash becomes a * 9, i.e. <first word> * 9.
> a becomes the second word, with mask != 0.  And we are out of the loop,
> and proceed to add nothing to hash (the name is over at that point).  As
> the result, we get hash mismatch for names that are 8 bytes long or
> multiple thereof.

OK, full_name_hash()/hash_name() definitely have a mismatch and it's on the
names of length 8*n: trivial experiment shows that we have
name hash_name full_name_hash
a 61 61
ab 6261 6261
abc 636261 636261
abcd 64636261 64636261
abcdabc 64c6c4c2 64c6c4c2
abcdabcd efcead5 c8c6c4c2
abcdabcd9 efceb0e efceb0e

Linus, which way do you prefer to shift it?  Should hash_name() change to
match full_name_hash() or should it be the other way round?

What happens is that you get multiplication by 9 and adding 0 in the former,
after having added the last full word.  In the latter we add the last full
word, see that there's nothing left and bugger off.
