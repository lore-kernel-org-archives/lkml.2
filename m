Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab2C0Wso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:48:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47673 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab2C0Wsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:48:42 -0400
Date: Tue, 27 Mar 2012 15:48:37 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 2/2] firmware_class: Move request_firmware_nowait() to
 workqueues
Message-ID: <20120327224837.GC22371@google.com>
References: <201203260000.34377.rjw@sisk.pl>
 <1332883710-7486-2-git-send-email-sboyd@codeaurora.org>
 <20120327220108.GB22371@google.com>
 <201203280021.27582.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203280021.27582.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 12:21:27AM +0200, Rafael J. Wysocki wrote:
> On Wednesday, March 28, 2012, Tejun Heo wrote:
> > On Tue, Mar 27, 2012 at 02:28:30PM -0700, Stephen Boyd wrote:
> > > Oddly enough a work_struct was already part of the firmware_work
> > > structure but nobody was using it. Instead of creating a new
> > > kthread for each request_firmware_nowait() call just schedule the
> > > work on the long system workqueue. This should avoid some overhead
> > > in forking new threads when they're not strictly necessary.
> > > 
> > > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > > ---
> > > 
> > > Is it better to use alloc_workqueue() and not put these on the system
> > > long workqueue?
> > 
> > No, just use schedule_work() unless there are specific requirements
> > which can't be fulfilled that way (e.g. it's on memory allocation
> > path, may consume large amount of cpu cycles, ...)
> 
> It may wait quite long.

That shouldn't matter.  system_long_wq's name is a bit misleading at
this point.  The only reason it's used currently is to avoid cyclic
dependency involving flush_workqueue(), which calls for clearer
solution anyway.  So, yeap, using system_wq should be fine here.

Thank you.

-- 
tejun
