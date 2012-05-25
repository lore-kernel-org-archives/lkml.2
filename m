Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab2EYU55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:57:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55329 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab2EYU5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:57:55 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        paul.gortmaker@windriver.com
Subject: [PATCH 0/3] Generic rb tree code
Date: Fri, 25 May 2012 13:57:38 -0700
Message-Id: <1337979461-19654-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, users of the rb tree code have to open code their own search and
insert functions. This provides generic versions that you pass a comparison
function to.

I highly doubt the extra function calls are going to have a measurable
performance impact in practice - the pointer chasing is going to dominate. I
did provide inline versions just in case, though - it's modelled after the
spinlock code.

The inline version of rb_search() is important for another reason, though - you
have to pass rb_search a pointer to your struct for it to compare against,
which has to be allocated on the stack. For most users I think that'll be fine,
but for the elevator code struct rb_node is embedded in struct request, which
is rather large. By using the inline version that stack allocation goes away.

(I looked at the generated assembly of elv_rb_find() before and after, and if
I'm reading it right it's not using any extra stack. Code is a bit worse, but
IMO removing code duplication is worth it).

Kent Overstreet (3):
  rbtree: Add rb_insert(), rb_search(), etc.
  timerqueue: convert to generic rb tree code
  block: convert elevator to generic rb tree code

 block/elevator.c       |   42 ++++++------------
 include/linux/rbtree.h |  110 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/rbtree.c           |   28 ++++++++++++
 lib/timerqueue.c       |   23 ++++------
 4 files changed, 159 insertions(+), 44 deletions(-)

-- 
1.7.9.3.327.g2980b

