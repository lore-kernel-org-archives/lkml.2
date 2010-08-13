Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab0HMVAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:00:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42891 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab0HMVAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=MZgZvyYM17u2S+tPNGwT2pJ7jrkxy3uKdS4nr07lQnWlFS6lyHk/wrSiJC3A2jm3AD
         WV2aNy0WKBEaQfcpGzIUl6ySbbNaITNipOj2S4+DHfpDgTCzWt/ho9rAsgfcCyuocuk2
         1o6ln7r8LzfFJqaoydTC92IUBXM4/URBxreyI=
Date: Fri, 13 Aug 2010 22:59:58 +0200
From: Dan Carpenter <error27@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] kfifo: __must_check helper casts everything to unsigned
Message-ID: <20100813205936.GS645@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Stefani Seibold <stefani@seibold.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <ak@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a new wrapper to add a __must_check to kfifo macros.  The
problem is that it casts everything to unsigned.  That breaks for places
that check stuff like:

	if (kfifo_alloc(&dlci->_fifo, 4096, GFP_KERNEL) < 0)

Signed-off-by: Dan Carpenter <error27@gmail.com>

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
