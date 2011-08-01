Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1HAPqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 11:46:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab1HAPqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 11:46:42 -0400
Date: Mon, 1 Aug 2011 11:46:37 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110801154636.GA2096@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're seeing a scheduling while atomic backtrace in rawhide from pidmap_init
(https://bugzilla.redhat.com/show_bug.cgi?id=726877).  While this seems
mostly harmless given that there isn't anything else to schedule to at
this point, I do wonder why things are marked as needing rescheduled so
early.

We get to might_sleep through the might_sleep_if call in
slab_pre_alloc_hook because both kzalloc and KMEM_CACHE are called with
GFP_KERNEL.  That eventually has a call chain like:

might_resched->_cond_resched->should_resched

which apparently returns true.  Why the initial thread says it should
reschedule at this point, I'm not sure.

I tried cheating by making the kzalloc call in pidmap_init use GFP_IOFS
instead of GFP_KERNEL to avoid the might_sleep_if call, and that worked
but I can't do the same for the kmalloc calls in kmem_cache_create, so
getting to the bottom of why should_resched is returning true seems to
be a better approach.

josh
