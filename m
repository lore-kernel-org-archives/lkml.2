Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0HMVfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:35:55 -0400
Received: from www84.your-server.de ([213.133.104.84]:38344 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0HMVfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:35:54 -0400
Subject: Re: [patch] kfifo: __must_check helper casts everything to unsigned
From: Stefani Seibold <stefani@seibold.net>
To: Dan Carpenter <error27@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20100813205936.GS645@bicker>
References: <20100813205936.GS645@bicker>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 13 Aug 2010 23:35:52 +0200
Message-ID: <1281735352.19775.1.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a new wrapper to add a __must_check to kfifo macros.  The
problem is that it casts everything to unsigned.  That breaks for places
that check stuff like:

	if (kfifo_alloc(&dlci->_fifo, 4096, GFP_KERNEL) < 0)

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Stefani Seibold <stefani@seibold.net>

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 311f875..437cc0d 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -177,6 +177,12 @@ __kfifo_must_check_helper(unsigned int val)
 	return val;
 }
 
+static inline int __must_check
+__kfifo_must_check_helper_signed(int val)
+{
+	return val;
+}
+
 /**
  * kfifo_initialized - Check if the fifo is initialized
  * @fifo: address of the fifo to check
@@ -323,7 +329,7 @@ __kfifo_must_check_helper( \
  * Return 0 if no error, otherwise an error code.
  */
 #define kfifo_alloc(fifo, size, gfp_mask) \
-__kfifo_must_check_helper( \
+__kfifo_must_check_helper_signed( \
 ({ \
 	typeof(fifo + 1) __tmp = (fifo); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
@@ -609,7 +615,7 @@ __kfifo_must_check_helper( \
  * writer, you don't need extra locking to use these macro.
  */
 #define	kfifo_from_user(fifo, from, len, copied) \
-__kfifo_must_check_helper( \
+__kfifo_must_check_helper_signed( \
 ({ \
 	typeof(fifo + 1) __tmp = (fifo); \
 	const void __user *__from = (from); \
@@ -637,7 +643,7 @@ __kfifo_must_check_helper( \
  * writer, you don't need extra locking to use these macro.
  */
 #define	kfifo_to_user(fifo, to, len, copied) \
-__kfifo_must_check_helper( \
+__kfifo_must_check_helper_signed( \
 ({ \
 	typeof(fifo + 1) __tmp = (fifo); \
 	void __user *__to = (to); \


