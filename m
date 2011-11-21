Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1KUWiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:38:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50439 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab1KUWiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:38:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4] PM / Memory-hotplug: Avoid task freezing failures
Date: Mon, 21 Nov 2011 23:41:39 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, pavel@ucw.cz,
        lenb@kernel.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        Chen Gong <gong.chen@linux.intel.com>
References: <20111117083042.11419.19871.stgit@srivatsabhat.in.ibm.com> <4ECA94A6.90500@linux.vnet.ibm.com> <20111121182319.GG15314@google.com>
In-Reply-To: <20111121182319.GG15314@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111212341.39359.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 21, 2011, Tejun Heo wrote:
> On Mon, Nov 21, 2011 at 11:42:54PM +0530, Srivatsa S. Bhat wrote:
> > The lock_system_sleep() function is used in the memory hotplug code at
> > several places in order to implement mutual exclusion with hibernation.
> > However, this function tries to acquire the 'pm_mutex' lock using
> > mutex_lock() and hence blocks in TASK_UNINTERRUPTIBLE state if it doesn't
> > get the lock. This would lead to task freezing failures and hence
> > hibernation failure as a consequence, even though the hibernation call path
> > successfully acquired the lock.
> > 
> > But it is to be noted that, since this task tries to acquire pm_mutex, if it
> > blocks due to this, we are *100% sure* that this task is not going to run
> > as long as hibernation sequence is in progress, since hibernation releases
> > 'pm_mutex' only at the very end, when everything is done.
> > And this means, this task is going to be anyway blocked for much more longer
> > than what the freezer intends to achieve; which means, freezing and thawing
> > doesn't really make any difference to this task!
> > 
> > So, to fix freezing failures, we just ask the freezer to skip freezing this
> > task, since it is already "frozen enough".
> > 
> > But instead of calling freezer_do_not_count() and freezer_count() as it is,
> > we use only the relevant parts of those functions, because restrictions
> > such as 'the task should be a userspace one' etc., might not be relevant in
> > this scenario.
> > 
> > v4: Redesigned the whole fix, to ask the freezer to skip freezing the task
> >     which is blocked trying to acquire 'pm_mutex' lock.
> > 
> > v3: Tejun suggested avoiding busy-looping by adding an msleep() since
> >     it is not guaranteed that we will get frozen immediately.
> > 
> > v2: Tejun pointed problems with using mutex_lock_interruptible() in a
> >     while loop, when signals not related to freezing are involved.
> >     So, replaced it with mutex_trylock().
> > 
> > Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Thanks a lot. :)

Applied to linux-pm/linux-next.

Thanks,
Rafael
