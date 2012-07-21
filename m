Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2GUA4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 20:56:40 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:40229 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab2GUA4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 20:56:38 -0400
Date: Fri, 20 Jul 2012 20:56:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, mpm@selenic.com,
        nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
        davem@davemloft.net
Subject: Re: [PATCH] dmi: Feed DMI table to /dev/random driver
Message-ID: <20120721005610.GB9399@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
	zakir@umich.edu, greg@kroah.com, mpm@selenic.com,
	nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
	davem@davemloft.net
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
 <0107910@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0107910@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 01:15:20PM -0700, Tony Luck wrote:
> Send the entire DMI (SMBIOS) table to the /dev/random driver to
> help seed its pools.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> 
> This looks a useful addition to your /dev/random series. There are
> lots of platform specific goodies in this table (BIOS version, system
> serial number and UUID, count and version number of processors, DIMM
> slot population and serial numbers, etc.)
> 
> On the system I tested the patch on the table is 9866 bytes. Is it
> OK to dump that much into add_device_randomness() in one shot? The
> alternative is to select the 'useful' bits deeper into the routines
> that parse the entries in the table.
> 
>  drivers/firmware/dmi_scan.c | 3 +++
>  1 file changed, 3 insertions(+)

This was something I was looking at doing, but I had considered the
approach you used, and had abandoned it because dmi_walk_early() gets
called ultimately via the setup_arch() call, and the random pools only
get initialized much later in the boot process.  

The fact that you didn't crash when you tested it is simply because
we're not allocating any memory or initializing any criticla data
structures in rand_initialize().  (We used to, but not any more.)

I'm a little nervous enshrining the fact that it's OK to call the
random driver before rand_initialize is called(), but it does work
today.  If we are going to do this, we need to put a big fat comment
in front of rand_initialize() indicating that it's important that we
not depend on any data structures getting initialized by
rand_initialize() before it's safe to call add_device_randomness().

The other approach was to add some new interface that random.c would
call which would grab the dmi data from rand_initialize().  But that's
going to be a lot more complicated, so I guess we should go with the
simple/stupid approach.

						- Ted
