Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab0DYILe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 04:11:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:41000 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab0DYILb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 04:11:31 -0400
Message-ID: <4BD3F8B7.7080404@kernel.org>
Date: Sun, 25 Apr 2010 10:09:27 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Subject: Re: [PATCHSET UPDATED] workqueue: concurrency managed workqueue,
 take#4
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 25 Apr 2010 08:09:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've just updated the git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-cmwq

The original take#4 is now in branch review-cmwq-3.  This will
probably become take#5 soonish but I don't have access to my test
machines for some days, so this is sort of take#5 pre-release.
Changes are...

* The patchset is rebased on cpu_stop + sched/core.  cpu_stop already
  reimplements stop_machine so that it doesn't use RT workqueue, so
  this patchset simply drops RT wq support.

* Oleg's clear work->data patch moved at the head of the queue and now
  lives in the for-next branch which will be pushed to mainline on the
  next merge window.

* David reported a bug where fscache show_work function caused panic
  by accessing already dead object.  This turned out to be race
  condition between put() after execution and show().  If the put()
  after work execution is the last put, the object gets destroyed;
  however, show() could be called to describe the work is actually
  finished ending up dereferencing already freed object.  Fixed by
  deferring put() to another work if debugfs support is enabled so
  that the object stays alive while the work is executing.  Due to
  lack of test setup, I couldn't actually test this yet.  I'll verify
  it works as soon as I have access to my stuff.

* Applied Oleg's review.

  * Comments updated as suggested.

  * work_flags_to_color() replaced w/ get_work_color()

  * nr_cwqs_to_flush bug which could cause premature flush completion
    fixed.

  * Replace rewind + list_for_each_entry_safe_continue() w/
    list_for_each_entry_safe_from().

  * Don't directly write to *work_data_bits() but use __set_bit()
    instead.

  * Fixed cpu hotplug exclusion bug.

Thanks.

-- 
tejun
