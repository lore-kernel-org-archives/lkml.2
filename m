Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab0HRWI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 18:08:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55034 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab0HRWI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 18:08:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 19 Aug 2010 00:08:15 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] Documentation: kernel-locking: mutex_trylock cannot be used
 in interrupt context
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Matthew Wilcox <matthew@wil.cx>
cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Message-ID: <tkrat.12a11fb05527c6ed@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chapter 6 is right about mutex_trylock, but chapter 10 wasn't.
This error was introduced during semaphore-to-mutex conversion of the
Unreliable guide. :-)

If user context which performs mutex_lock() or mutex_trylock() is
preempted by interrupt context which performs mutex_trylock() on the
same mutex instance, a deadlock occurs.  This is because these functions
do not disable local IRQs when they operate on mutex->wait_lock.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 Documentation/DocBook/kernel-locking.tmpl |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: b/Documentation/DocBook/kernel-locking.tmpl
===================================================================
--- a/Documentation/DocBook/kernel-locking.tmpl
+++ b/Documentation/DocBook/kernel-locking.tmpl
@@ -1922,9 +1922,12 @@ machines due to caching.
       <function>mutex_lock()</function>
       </para>
       <para>
-       There is a <function>mutex_trylock()</function> which can be
-       used inside interrupt context, as it will not sleep.
+       There is a <function>mutex_trylock()</function> which does not
+       sleep.  Still, it must not be used inside interrupt context since
+       its implementation is not safe for that.
        <function>mutex_unlock()</function> will also never sleep.
+       It cannot be used in interrupt context either since a mutex
+       must be released by the same task that acquired it.
       </para>
      </listitem>
     </itemizedlist>

