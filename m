Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab1FWVi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 17:38:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36373 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932717Ab1FWVi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 17:38:28 -0400
Date: Thu, 23 Jun 2011 17:38:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI / PM: Block races between runtime PM and system
 sleep
In-Reply-To: <201106232316.56769.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1106231727180.2033-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011, Rafael J. Wysocki wrote:

> > Then maybe this disable_depth > 0 case should return something other
> > than 0.  Something new, like -EACCES.  That way the caller would
> > realize something strange was going on but wouldn't have to treat the 
> > situation as an error.
> 
> I would be fine with that, but then we'd need to reserve that error code,
> so that it's not returned by subsystem callbacks (or even we should convert
> it to a different error code if it is returned by the subsystem callback in
> rpm_resume()). 
> 
> > After all, the return value from pm_runtime_get_sync() is documented to 
> > be the error code for the underlying pm_runtime_resume().  It doesn't 
> > refer to the increment operation -- that always succeeds.
> 
> That means we should change the caller, which is the SCSI subsystem in this
> particular case, to check the error code.  The problem with this approach
> is that the same error code may be returned in a different situation, so
> we should prevent that from happening in the first place.  Still, suppose
> that we do that and that the caller checks the error code.  What is it
> supposed to do in that situation?  The only reasonable action for the
> caller is to ignore the error code if it means disable_depth > 0 and go
> on with whatever it has to do, but that's what it will do if the
> pm_runtime_get_sync() returns 0 in that situation.
> 
> So, in my opinion it simply may be best to update the documentation of
> pm_runtime_get_sync() along with the code changes. :-)

The only reason you're doing this is for the SCSI error-handler 
routine?

I think it would be easier to change that routine instead of the PM 
core.  It should be smart enough to know that a runtime PM call isn't 
needed during a system sleep transition, i.e., between the scsi_host's 
suspend and resume callbacks.  Maybe check the new is_suspended flag.  
You'd also have to make sure the scsi_host wasn't runtime suspended 
when the sleep begins, rather like PCI.

I'm still not clear on why the error handler needs to run at this time.

Alan Stern

