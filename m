Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2LVSKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 13:10:34 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48442 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2LVSKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 13:10:31 -0500
Subject: Re: Regression in 3.8-rc1:  "BUG: sleeping function called from
 invalid context"
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, netdev@vger.kernel.org
In-Reply-To: <20121222180247.GA10250@liondog.tnic>
References: <50D5E9D9.3070904@lwfinger.net>
	 <20121222180247.GA10250@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Dec 2012 10:10:28 -0800
Message-ID: <1356199828.21834.8500.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-22 at 19:02 +0100, Borislav Petkov wrote:
> Top-posting so that the rest can remain untouched.
> 
> Right, so AFAICT, something is holding rtnl_mutex (probably some
> rtnetlink traffic) and device_rename() is doing kstrdup with
> GFP_KERNEL which, among others, has __GFP_WAIT and *that* triggers the
> might_sleep_if() check in slab_pre_alloc_hook():
> 
> static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
> {
>         flags &= gfp_allowed_mask;
>         lockdep_trace_alloc(flags);
>         might_sleep_if(flags & __GFP_WAIT);		<--- HERE
> 
> Adding Christoph and Pekka although the slub.c might_sleep stuff is from
> 2010. Still, they might have a better idea.
> 
> Oh well, let's add netdev while we're at it. :-)

RTNL is a mutex, its perfectly valid to use GFP_KERNEL while holding a
mutex.

As replied before your mail, fix for the problem is already in David
tree.

http://git.kernel.org/?p=linux/kernel/git/davem/net.git;a=commitdiff;h=30e6c9fa93cf3dbc7cc6df1d748ad25e4264545a


Bug was added in commit c91f6df2db4972d3cc983e6988b9abf1ad02f5f9 :

http://git.kernel.org/?p=linux/kernel/git/davem/net.git;a=commit;h=c91f6df2db4972d3cc983e6988b9abf1ad02f5f9


Thanks


