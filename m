Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2CGIXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 03:23:22 -0500
Received: from mga14.intel.com ([143.182.124.37]:48557 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab2CGIXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 03:23:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="74589518"
Subject: Re: [RFC patch] spindep: add cross cache lines checking
From: Alex Shi <alex.shi@intel.com>
To: Arnd Bergmann <arnd@arndb.de>, gcc@gcc.gnu.org
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
        "mingo@redhat.com" <mingo@redhat.com>, hpa@zytor.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, andi.kleen@intel.com, gcc-help@gcc.gnu.org
In-Reply-To: <201203060932.45223.arnd@arndb.de>
References: <1330917630.18835.44.camel@debian>
	 <20120305104311.GA18556@elte.hu> <1331014414.18835.254.camel@debian>
	 <201203060932.45223.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Mar 2012 16:23:27 +0800
Message-ID: <1331108607.18835.343.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 09:32 +0000, Arnd Bergmann wrote:
> On Tuesday 06 March 2012, Alex Shi wrote:
> > I have one concern and one questions here:
> > concern: maybe the lock is in a well designed 'packed' struct, and it is
> > safe for cross lines issue. but __alignof__ will return 1;
> > 
> > struct abc{
> >         raw_spinlock_t lock1;
> >         char            a;
> >         char            b;
> > }__attribute__((packed));
> > 
> > Since the lock is the first object of struct, usually it is well placed.
> 
> No, it's actually not. The structure has an external alignment of 1, so
> if you have an array of these or put it into another struct like
> 
> struct xyz {
> 	char x;
> 	struct abc a;
> };
> 
> then it will be misaligned. Thre is no such thing as a well designed 'packed'
> struct. The only reason to use packing is to describe structures we have no
> control over such as hardware layouts and on-wire formats that have unusal
> alignments, and those will never have a spinlock on them.

Understand. thx. So is the following checking that your wanted?
===
diff --git a/include/linux/rwlock.h b/include/linux/rwlock.h
index bc2994e..64828a3 100644
--- a/include/linux/rwlock.h
+++ b/include/linux/rwlock.h
@@ -21,10 +21,12 @@
 do {								\
 	static struct lock_class_key __key;			\
 								\
+	BUILD_BUG_ON(__alignof__(lock) == 1);			\
 	__rwlock_init((lock), #lock, &__key);			\
 } while (0)
 #else
 # define rwlock_init(lock)					\
+	BUILD_BUG_ON(__alignof__(lock) == 1);			\
 	do { *(lock) = __RW_LOCK_UNLOCKED(lock); } while (0)
 #endif
 
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 7df6c17..df8a992 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -96,11 +96,13 @@
 do {								\
 	static struct lock_class_key __key;			\
 								\
+	BUILD_BUG_ON(__alignof__(lock) == 1);			\
 	__raw_spin_lock_init((lock), #lock, &__key);		\
 } while (0)
 
 #else
 # define raw_spin_lock_init(lock)				\
+	BUILD_BUG_ON(__alignof__(lock) == 1);			\
 	do { *(lock) = __RAW_SPIN_LOCK_UNLOCKED(lock); } while (0)
 #endif
 
===

Btw, 
1, it is alignof bug for default gcc on my fc15 and Ubuntu 11.10 etc?

struct sub {
        int  raw_lock;
        char a;
};
struct foo {
        struct sub z;
        int slk;
        char y;
}__attribute__((packed));

struct foo f1;

__alignof__(f1.z.raw_lock) is 4, but its address actually can align on
one byte. 

 
> 
> 	Arnd


