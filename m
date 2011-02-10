Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1BJQUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 11:20:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:27917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab1BJQUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 11:20:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'208";a="706254181"
Date: Thu, 10 Feb 2011 08:20:37 -0800
From: Andi Kleen <ak@linux.intel.com>
To: mark gross <markgross@thegnar.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@suse.de>,
        David Alan Gilbert <linux@treblig.org>, linux-kernel@vger.kernel.org,
        Len <len.brown@intel.com>, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Patch] idle governor: Avoid lock acquisition to read pm_qos
 before entering idle
Message-ID: <20110210162037.GA19389@tassilo.jf.intel.com>
References: <1297300864.2645.128.camel@schen9-DESK>
 <20110210051042.GC4897@gvim.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210051042.GC4897@gvim.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 09:10:42PM -0800, mark gross wrote:
> On Wed, Feb 09, 2011 at 05:21:04PM -0800, Tim Chen wrote:
> > I noticed that before entering idle state, the menu idle governor will
> > look up the current pm_qos value according to the list of qos request
> > received.  This look up currently needs the acquisition of a lock to go
> > down a list of qos requests to find the qos value, slowing down the
> 
> wait a second... It gets the target_value (that is an atomic variable)
> humpf.  I was looking at 2.6.35, where this is true.  If you want to put
> back a target_value why not put it back the way it was?

I don't think the goal is to make the code look like it was before,
just to have clean and scalable code going forwards.

> I'm surprised by this as the last update to the pm_qos replaced the
> lists with a O(1) data structure so there was no more walking of pending
> requests.
> 
> What is the profile after the patch the Plist should be only one
> dereference and an if instruction slower than a cached value.

The problem with the plist is that you need to take a lock for reading
the first value. The lock is a performance problem on servers.
The reference doesn't matter at all.

> Does your patch remove the need for the locks because if it doesn't I
> don't see how it will make much of a difference?

The value itself doesn't need a lock, just the list access.

> 
> > Perhaps a better approach will be to cache the updated pm_qos value so
> > reading it does not require lock acquisition as in the patch below.   
> 
> See v2.6.35 for an possible instance of the better approach.

Tim's new code seems simpler and cleaner than what was in .35.

-Andi
