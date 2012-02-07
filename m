Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab2BGGX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:23:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37469 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab2BGGX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:23:57 -0500
Date: Tue, 7 Feb 2012 10:23:53 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 2/6] oom: Get rid of sparse warnings
Message-ID: <20120207062353.GA24687@oksana.dev.rtsoft.ru>
References: <20120203163056.GA4190@redhat.com>
 <20120206162935.GB5117@oksana.dev.rtsoft.ru>
 <CAHGf_=oVQQRdfNYm0gOwzjxbUqPB5jMdsibLATCrt718-sMm7w@mail.gmail.com>
 <20120207042026.GA25524@oksana.dev.rtsoft.ru>
 <CAHGf_=rW-EJvj-hsKgEGw4F4uAKMv-U-iG6aROzw2rN4tXPFFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHGf_=rW-EJvj-hsKgEGw4F4uAKMv-U-iG6aROzw2rN4tXPFFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 12:38:58AM -0500, KOSAKI Motohiro wrote:
> >> task struct only have allock_lock, not alloc_loc.
> >
> > Funnily, but sparse does not care. :-) __release(foo) will work as
> > well. Seems like sparse counts locking balance globally.
> >
> > This is now fixed in the patch down below, thanks for catching.
> >
> >> Moreover we don't release
> >> the lock in this code path. Seems odd.
> >
> > Indeed. That's exactly what sparse seeing is as well. We exit
> > without releasing the lock, which is bad (in sparse' eyes). So
> > we lie to sparse, telling it that we do release, so it shut ups.
> 
> Hmmm....
> 
> To be honest, I really dislike any lie annotation. Why? It is very
> fragile and easily
> become broken from unrelated but near line changes. Please consider to
> enhance sparse at first.

I somewhat doubt that it is possible to "enhance it". We keep the
lock held conditionaly, so we need too place the hint in the
code itself. I believe the best we can do would be something like
this:

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 4a24354..61d91f2 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -14,6 +14,7 @@
 # define __releases(x)	__attribute__((context(x,1,0)))
 # define __acquire(x)	__context__(x,1)
 # define __release(x)	__context__(x,-1)
+# define __ret_with_lock(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
 # define __percpu	__attribute__((noderef, address_space(3)))
 #ifdef CONFIG_SPARSE_RCU_POINTER
@@ -37,6 +38,7 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 # define __releases(x)
 # define __acquire(x) (void)0
 # define __release(x) (void)0
+# define __ret_with_lock(x)
 # define __cond_lock(x,c) (c)
 # define __percpu
 # define __rcu

And then use it instead of __release().

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
