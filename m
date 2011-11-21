Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab1KUSX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:23:27 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33348 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab1KUSXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:23:25 -0500
Date: Mon, 21 Nov 2011 10:23:19 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@ucw.cz, lenb@kernel.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        Chen Gong <gong.chen@linux.intel.com>
Subject: Re: [PATCH v4] PM / Memory-hotplug: Avoid task freezing failures
Message-ID: <20111121182319.GG15314@google.com>
References: <20111117083042.11419.19871.stgit@srivatsabhat.in.ibm.com>
 <201111192257.19763.rjw@sisk.pl>
 <4EC8984E.30005@linux.vnet.ibm.com>
 <201111201124.17528.rjw@sisk.pl>
 <4EC9D557.9090008@linux.vnet.ibm.com>
 <20111121164006.GB15314@google.com>
 <4ECA84A8.5030005@linux.vnet.ibm.com>
 <4ECA94A6.90500@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECA94A6.90500@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 11:42:54PM +0530, Srivatsa S. Bhat wrote:
> The lock_system_sleep() function is used in the memory hotplug code at
> several places in order to implement mutual exclusion with hibernation.
> However, this function tries to acquire the 'pm_mutex' lock using
> mutex_lock() and hence blocks in TASK_UNINTERRUPTIBLE state if it doesn't
> get the lock. This would lead to task freezing failures and hence
> hibernation failure as a consequence, even though the hibernation call path
> successfully acquired the lock.
> 
> But it is to be noted that, since this task tries to acquire pm_mutex, if it
> blocks due to this, we are *100% sure* that this task is not going to run
> as long as hibernation sequence is in progress, since hibernation releases
> 'pm_mutex' only at the very end, when everything is done.
> And this means, this task is going to be anyway blocked for much more longer
> than what the freezer intends to achieve; which means, freezing and thawing
> doesn't really make any difference to this task!
> 
> So, to fix freezing failures, we just ask the freezer to skip freezing this
> task, since it is already "frozen enough".
> 
> But instead of calling freezer_do_not_count() and freezer_count() as it is,
> we use only the relevant parts of those functions, because restrictions
> such as 'the task should be a userspace one' etc., might not be relevant in
> this scenario.
> 
> v4: Redesigned the whole fix, to ask the freezer to skip freezing the task
>     which is blocked trying to acquire 'pm_mutex' lock.
> 
> v3: Tejun suggested avoiding busy-looping by adding an msleep() since
>     it is not guaranteed that we will get frozen immediately.
> 
> v2: Tejun pointed problems with using mutex_lock_interruptible() in a
>     while loop, when signals not related to freezing are involved.
>     So, replaced it with mutex_trylock().
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks a lot. :)

-- 
tejun
