Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1DJNlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 09:41:49 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:37108 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab1DJNls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 09:41:48 -0400
Subject: block: ioc->refcount accessed twice in put_io_context()?
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 10 Apr 2011 15:41:40 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.0 (3.0.0-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1302442907.5366.15.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) Looking for clues to solve a problem I ran into, I noticed something
odd in block/blk-ioc.c:put_io_context(). It seems it accesses the atomic
variable ioc->refcount twice in a way which suggests things might race.

1) Code is more exact than words, so this (entirely untested) patch to
solve this possible race might describe better what this is all about:

@@ -33,12 +33,16 @@ static void cfq_dtor(struct io_context *ioc)
  */
 int put_io_context(struct io_context *ioc)
 {
+       int new;
+
        if (ioc == NULL)
                return 1;
 
-       BUG_ON(atomic_long_read(&ioc->refcount) == 0);
+       new = atomic_long_dec_return(&ioc->refcount);
+
+       BUG_ON(new < 0);
 
-       if (atomic_long_dec_and_test(&ioc->refcount)) {
+       if (new == 0) {
                rcu_read_lock();
                cfq_dtor(ioc);
                rcu_read_unlock();


Paul Bolle

