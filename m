Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2IHTCP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 15:02:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51089 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab2IHTCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 15:02:10 -0400
Date: Sat, 8 Sep 2012 12:02:04 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7 V6] workqueue: fix idle worker depletion
Message-ID: <20120908190204.GA12773@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1347124383-18723-1-git-send-email-laijs@cn.fujitsu.com>
 <1347124383-18723-5-git-send-email-laijs@cn.fujitsu.com>
 <20120908174044.GD10788@dhcp-172-17-108-109.mtv.corp.google.com>
 <CACvQF53dj+fVdYf6uSPREGbtLTBvLcaqX1CJN6XVQOCPx3ttsA@mail.gmail.com>
 <20120908175354.GH10788@dhcp-172-17-108-109.mtv.corp.google.com>
 <CACvQF51edrK2LhPbEk6890uxANnLQGp8E2LsTi+dZGgn24y_zw@mail.gmail.com>
 <20120908181107.GJ10788@dhcp-172-17-108-109.mtv.corp.google.com>
 <CACvQF51PY95Eg+DLhZ4ZRRNK0x9q+pOzrPfZbhTnPvk35j8PNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF51PY95Eg+DLhZ4ZRRNK0x9q+pOzrPfZbhTnPvk35j8PNg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Sun, Sep 09, 2012 at 02:34:02AM +0800, Lai Jiangshan wrote:
> in 3.6 busy_worker_rebind() handle WORKER_REBIND bit,
> not WORKER_UNBOUND bit.
>
> busy_worker_rebind() takes struct work_struct *work argument, we have to
> add new patch to add a helper and restruct it at first.

What's wrong with just treating manager as busy.  Factor out,
rebind_work scheduling from rebind_workers() and call it for busy
workers and the manager if it exists.  manage_workers() only need to
call process_scheduled_works().  Wouldn't that work?

> worker_maybe_bind_and_lock() 's mean is very clear
> here. busy_worker_rebind() seems for busy workers, manager is not
> busy workers.

I don't know.  It just seems unnecessarily wordy.  If you don't like
reusing the busy worker path, how about just calling
maybe_bind_and_lock() unconditionally after locking manager_mutex?  I
mean, can't it just do the following?

	spin_unlock_irq(&gcwq->lock);

	/*
	 * Explain what's going on.
	 */
	mutex_lock(&pool->manager_mutex);
	if (worker_maybe_bind_and_lock(worker))
		worker_clr_flags(worker, WORKER_UNBOUND);
	ret = true;

Thanks.

-- 
tejun
