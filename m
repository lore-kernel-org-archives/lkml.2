Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966469Ab2FBHzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 03:55:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50904 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966455Ab2FBHzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 03:55:15 -0400
Subject: Re: [PATCH] tty: add lockdep annotations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <1338621438.2760.1679.camel@edumazet-glaptop>
References: <4FC6189B.9080909@fusionio.com>
	 <1338402812.2760.413.camel@edumazet-glaptop>
	 <4FC66D3D.6080509@fusionio.com>
	 <1338404902.2760.451.camel@edumazet-glaptop>
	 <1338410107.2760.544.camel@edumazet-glaptop>
	 <1338456918.2760.1318.camel@edumazet-glaptop>
	 <1338574627.2760.1545.camel@edumazet-glaptop>
	 <CA+55aFzrbmGjghmR3M=fWrGUdy6BDu+SVXz6rjM4QAuUjfxk_w@mail.gmail.com>
	 <1338583498.2760.1648.camel@edumazet-glaptop>
	 <20120601215620.305155c0@pyramind.ukuu.org.uk>
	 <1338584389.2760.1653.camel@edumazet-glaptop>
	 <1338621438.2760.1679.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jun 2012 09:55:08 +0200
Message-ID: <1338623708.2760.1691.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

On Sat, 2012-06-02 at 09:17 +0200, Eric Dumazet wrote:

> 
> Here is the patch I am currently testing (need to boot the machine ~50
> times to make sure it is the right fix)

Seems good, but am still doing reboots to make sure.

We should add a debugging code to kref to catch poisoned refcounts...

Something like :

[PATCH] kref: detects poisoned refcounts

Catch kref_get() done on freed memory, if slub/slab are poisoning the
freed area.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/kref.h   |    2 ++
 include/linux/poison.h |    3 +++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 9c07dce..d8e90a1 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -18,6 +18,7 @@
 #include <linux/bug.h>
 #include <linux/atomic.h>
 #include <linux/kernel.h>
+#include <linux/poison.h>
 
 struct kref {
 	atomic_t refcount;
@@ -39,6 +40,7 @@ static inline void kref_init(struct kref *kref)
 static inline void kref_get(struct kref *kref)
 {
 	WARN_ON(!atomic_read(&kref->refcount));
+	WARN_ON(atomic_read(&kref->refcount) == POISON_FREE_INT);
 	atomic_inc(&kref->refcount);
 }
 
diff --git a/include/linux/poison.h b/include/linux/poison.h
index 2110a81..2947582 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -48,6 +48,9 @@
 #define POISON_FREE	0x6b	/* for use-after-free poisoning */
 #define	POISON_END	0xa5	/* end-byte of poisoning */
 
+#define POISON_FREE_SHORT ((POISON_FREE << 8) + POISON_FREE)
+#define POISON_FREE_INT   ((POISON_FREE_SHORT << 16) + POISON_FREE_SHORT)
+
 /********** arch/$ARCH/mm/init.c **********/
 #define POISON_FREE_INITMEM	0xcc
 


