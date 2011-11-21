Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1KUQkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:40:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53916 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab1KUQkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:40:11 -0500
Date: Mon, 21 Nov 2011 08:40:06 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@ucw.cz, lenb@kernel.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] PM/Memory-hotplug: Avoid task freezing failures
Message-ID: <20111121164006.GB15314@google.com>
References: <20111117083042.11419.19871.stgit@srivatsabhat.in.ibm.com>
 <201111192257.19763.rjw@sisk.pl>
 <4EC8984E.30005@linux.vnet.ibm.com>
 <201111201124.17528.rjw@sisk.pl>
 <4EC9D557.9090008@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC9D557.9090008@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Srivatsa.

On Mon, Nov 21, 2011 at 10:06:39AM +0530, Srivatsa S. Bhat wrote:
> void lock_system_sleep(void)
> {
> 	/* simplified freezer_do_not_count() */
> 	current->flags |= PF_FREEZER_SKIP;
> 
> 	mutex_lock(&pm_mutex);
> 
> }
> 
> void unlock_system_sleep(void)
> {
> 	mutex_unlock(&pm_mutex);
> 
> 	/* simplified freezer_count() */
> 	current->flags &= ~PF_FREEZER_SKIP;
> 
> }
> 
> We probably don't want the restriction that freezer_do_not_count() and
> freezer_count() work only for userspace tasks. So I have open coded
> the relevant parts of those functions here.
> 
> I haven't tested this solution yet. Let me know if this solution looks
> good and I'll send it out as a patch after testing and analyzing some
> corner cases, if any.

Ooh ooh, I definitely like this one much better.  Oleg did something
similar w/ wait_event_freezekillable() too.  On related notes,

* I think it would be better to remove direct access to pm_mutex and
  use [un]lock_system_sleep() universally.  I don't think hinging it
  on CONFIG_HIBERNATE_CALLBACKS buys us anything.

* In the longer term, we should be able to toggle PF_NOFREEZE instead
  as SKIP doesn't mean anything different.  We'll probably need a
  better API tho.  But for now SKIP should work fine.

Thank you.

-- 
tejun
