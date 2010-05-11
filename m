Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab0EKVWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 17:22:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630Ab0EKVV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 17:21:59 -0400
Date: Tue, 11 May 2010 14:21:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>,
       Zach Brown <zach.brown@oracle.com>, Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 2/2] ipc/sem.c: move wake_up_process out of the spinlock
 section
Message-Id: <20100511142149.83bb3538.akpm@linux-foundation.org>
In-Reply-To: <1272481588-1941-3-git-send-email-manfred@colorfullife.com>
References: <1272481588-1941-1-git-send-email-manfred@colorfullife.com>
	<1272481588-1941-2-git-send-email-manfred@colorfullife.com>
	<1272481588-1941-3-git-send-email-manfred@colorfullife.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 21:06:27 +0200
Manfred Spraul <manfred@colorfullife.com> wrote:

> The wake-up part of semtimedop() consists out of two steps:
> - the right tasks must be identified.
> - they must be woken up.
> 
> Right now, both steps run while the array spinlock is held.
> This patch reorders the code and moves the actual wake_up_process()
> behind the point where the spinlock is dropped.
> 
> The code also moves setting sem->sem_otime to one place: It does not
> make sense to set the last modify time multiple times.

ipc/sem.c: In function 'update_queue':
ipc/sem.c:545: warning: 'retval' may be used uninitialized in this function

which indeed was a bug.

--- a/ipc/sem.c~ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix-2
+++ a/ipc/sem.c
@@ -542,7 +542,7 @@ static int update_queue(struct sem_array
 	struct list_head *walk;
 	struct list_head *pending_list;
 	int offset;
-	int retval;
+	int retval = 0;
 
 	/* if there are complex operations around, then knowing the semaphore
 	 * that was modified doesn't help us. Assume that multiple semaphores
_

But I worry that the patch which you sent might not have been the one
which you tested.

