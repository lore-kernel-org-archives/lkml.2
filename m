Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342Ab0EEU2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:28:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:25032 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758077Ab0EEU2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:28:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,335,1270450800"; 
   d="scan'208";a="515417619"
Date: Wed, 5 May 2010 13:28:26 -0700
From: mark gross <mgross@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: markgross@thegnar.org, Len Brown <len.brown@intel.com>,
       linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100505202826.GB7450@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20100505015050.GA30591@linux.intel.com>
 <Pine.LNX.4.44L0.1005051136140.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005051136140.1885-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 11:44:39AM -0400, Alan Stern wrote:
> On Tue, 4 May 2010, mark gross wrote:
> 
> > Thanks, I think I'm starting to get it.  From this it seems that the
> > system integrator needs to identify those wake up sources that need to
> > be able to block a suspend, and figure out a way of acknowledging from
> > user mode, that its now ok to allow a suspend to happen.
> 
> The second part is easy.  Userspace doesn't need to do anything special 
> to acknowledge that a suspend is now okay; it just has to remove the 
> conditions that led the driver to block suspends in the first place.
> 
> For example, if suspends are blocked because some input event has been
> queued, emptying the input event queue should unblock suspends.
> 
> > The rev-6 proposed way is for the integrator to implement overlapping
> > blocker sections from ISR up to user mode for selected wake up devices
> > (i.e. the modem)
> > 
> > There *has* to be a better way.
> 
> Why?  What's wrong with overlapping blockers?  It's a very common
> idiom.  For example, the same sort of thing is used when locking
> subtrees of a tree: You lock the root node, and then use overlapping
> locks on the nodes leading down to the subtree you're interested in.

Because in the kenel there is only a partial ordering of calling
sequences from IRQ to usermode.  I see a lot of custom out of tree code
being developed to deal with getting the overlapping blocker sections
right, per device.

 
> > Can't we have some notification based thing that supports user mode
> > acks through a misc device or sysfs thing?   Anything to avoid the
> > overlapping blocker sections. 
> 
> Userspace acks aren't the issue; the issue is how (and when) kernel 
> drivers should initiate a blocker.  Switching to notifications, misc 
> devices, or sysfs won't help solve this issue.

communicating non-local knowledge back down to the blocking object to
tell it that it can unblock is the issue
 
> > True, you need an ack back from user mode for when its ok to allow
> > suspend to happen.  This ack is device specific and needs to be custom
> > built per product to its wake up sources.
> 
> No and no.  Nothing special is needed.  All userspace needs to do is 
> remove the condition that led to the blocker being enabled initially -- 
> which is exactly what userspace would do normally anyway.

Oh, like tell the modem that user mode has handled the ring event and
its ok to un-block?

--mgross
