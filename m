Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab2D3J7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 05:59:12 -0400
Received: from segfault.kiev.ua ([193.193.193.4]:43726 "EHLO segfault.kiev.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab2D3J7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 05:59:11 -0400
Date: Mon, 30 Apr 2012 12:58:35 +0300
From: Valentin Nechayev <netch@netch.kiev.ua>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
Message-ID: <20120430095835.GF51635@netch.kiev.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F78D30B.4070205@zytor.com>
 <20120402010819.76d31790@pyramind.ukuu.org.uk>
X-42: On
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Sun, Apr 01, 2012 at 15:13:31, hpa wrote about "Re: [PATCH] nextfd(2)": 

> - There is a huge backwards compatibility problem with this for a
> substantial transition period; using /proc/self/fd has worked for a very
> long time already.
> 
> - Your nextfd() system call will require more system calls that the
> typical case for reading /proc/self/fd, because each getdents() system
> call handles multiple readdir() invocations.

First, your forecast is very doubtfully correct in typical case when a
process checks extra descriptors to close; seeing tools like sendmail
shows that typically the all this long cycle does no work. So, it will
reduce to one nextfd() which returns final error, instead of
open()+getdents()+close().

Second, the principal advantage of nextfd() approach that it doesn't
consumer additional resources for its work, compared with open() which
allocates yet another descriptor. So, it could fail unpredictably.

Typical Unix-like system has at least four kinds of critical resources;
"critical" means here that they could be requested even in case of
lack of such resource, to provide a kind of graceful shutdown. They
are virtual memory, file descriptors, threads and disk space, all
possibly limited per-system, per-user or per-process. The current lack
of a measure to provide work when a resource is exhausted gives only
one possible reaction - to die immediately; this is now typical
reaction to memory allocation failure. I'm already sick of seeing
a language runtime which crash with messages like "cannot allocate
500M" when doing GC; this isn't single example but common approach of
such a devil-may-care attitude to application stability.

It isn't hard to expand the current approach in two ways: 1) allowing
to allocate reserve pool which will be then used by compating or
shutdown actions; 2) making actions which are typical on such
compacting using minimum of resources, even with some loss of
uniformity, API orthogonality and simplicity. Yep, this way is long
and can spend decades - more long than /proc existence - but it is
good to achieve.

Seems all this was in mind of Alexey Dobriyan when he proposed
nextfd(); maybe not with the same level of details, but in general.

 Mon, Apr 02, 2012 at 01:08:19, alan wrote about "Re: [PATCH] nextfd(2)": 

> If I've rlimited you to no file handles then you already lost whichever
> approach you use. Just abort.

Well, this is the good illustration to my words. In real work I don't
want to use the world when abort() is not simply the only case for
complicated state, but the suggestion. My software isn't
samurai-inspired kamikaze.


-netch-
