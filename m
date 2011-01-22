Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab1AVBRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:17:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:45786 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab1AVBRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:17:35 -0500
From: Jens Axboe <jaxboe@fusionio.com>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH 0/10] On-stack explicit block queue plugging
Date: Sat, 22 Jan 2011 01:17:19 +0000
Message-Id: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
X-Mailer: git-send-email 1.7.3.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 22 Jan 2011 01:17:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is something that I have been sitting on for a while and
I finally got a bit of time to bring it up to date and at least
ensure that basic functionality was there.

Currently we use what I call implicit IO plugging for block devices.
This means that the target block device queue may or may not be
"plugged" when someone submits IO. The IO submitter has to
ensure that the IO is sent off by calling a function to submit
it. This ugliness propagates through to the vm, which needs a
->sync_page() hook to ensure that things are submitted if someone
ends up waiting on a page.

Additionally, queue plugging ends up being a burden on the
queue lock (which is already heavily contended in some cases).
By moving to an explicit plugging scheme we make the API nicer,
get rid of the ->sync_page() vm hack, and allow IO to be queued
up in an on-stack structure and submitted in batches to the
block device queue.

Right now only submission of mergeable IO is lockless, the next
step is ensuring that rq allocation can be less queue lock
intensive and get some benefits there as well. There's an
unrelated batching change in this series as well that doesn't
really belong that's the start of that.

The patch boots and runs on my laptop, but apart from that I make
no guarantees as to the state of it. Particularly the md and dm
changes are quite invasive and need both careful review (and then,
I'm sure, bug fixing) and testing.

Patches are against 2.6.38-rc1 and can also be found in the block
git tree, in the for-2.6.39/stack-plug branch.

I'm traveling, so I'll tend to replies/comments/reviews/bugs on
this patch series when I get back early next week.

-- 
Jens Axboe

