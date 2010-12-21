Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658Ab0LUJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 04:27:16 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:57669 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754099Ab0LUJ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 04:27:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIcAEE15Lcps/2dsb2JhbACkDHTAJoVJBA
Date: Tue, 21 Dec 2010 20:26:51 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: George Spelvin <linux@horizon.com>
Cc: npiggin@gmail.com, bharrosh@panasas.com, linux-arch@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
Message-ID: <20101221092651.GA9242@amd>
References: <AANLkTikwUEBd1Ez75pQ7gw7ShZitwQOQcH6CvCdJV2np@mail.gmail.com>
 <20101219170646.482.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101219170646.482.qmail@science.horizon.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 12:06:46PM -0500, George Spelvin wrote:
> > First, a byte-by-byte strcpy_from_user of the whole name string to
> > kernel space. Then a byte-by-byte chunking and hashing component
> > paths according to '/'. Then a byte-by-byte memcmp against the
> > dentry name.
> 
> Well, you've put your finger on the obvious place to to the aligned copy,
> if you want.

Yes, this would be a nice place to align things and parse '/' compoents,
although in fact it doesn't strictly have to be a byte-by-byte copy
(although doing long loads would put a lot more complexity in fault
handling and parsing).


>  Looking into it, I note that __d_lookup() does a 32-bit
> hash compare before doing a string compare, so the memcmp should almost
> always succeed.  (Failures are due to hash collisions and rename races.)
> 
> > I'd love to do everything with 8 byte loads, do the component
> > separation and hashing at the same time as copy from user, and
> > have the padded and aligned component strings and their hash
> > available... but complexity.
> 
> It actually doesn't seem that difficult to do in fs/namei.c:do_getname
> via a heavily hacked strncpy_from_user.  Call it strhash_from_user, and
> it copies the string, while accumulating the hash and the length,
> until it hits a nul or /.  It has to return the length, the hash,
> and the termination condition: nul, /, or space exhausted.
> 
> Then you could arrange for each component to be padded so that it
> starts aligned.
> 
> (The hash and length can be stored directly in the qstr.  The length is
> only otherwise needed for components that end in /, so you could return
> a magic negative length in those cases.)

Probably, due to bloat caused by the hash for small names, and that
some filesystems do their own hashing, we should still hash in the
same place. However we can do sizeof(long) at a time hashing, which
should be nice and fast too.

 
> The main problem with initializing all the qstr structures early is that
> it can lead to an oddly dynamic PATH_MAX and/or a type of kernel
> DOS by passing in paths with many short directory names that would need
> maximal padding.

If the results are compelling enough, this could be worked around
some way. Simple realloc probably, seeing as it would be a rare case.


