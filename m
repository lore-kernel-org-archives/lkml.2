Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab1GKPjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 11:39:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932224Ab1GKPjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:39:36 -0400
Date: Mon, 11 Jul 2011 11:39:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: pstore dump inside an nmi handler
Message-ID: <20110711153931.GA10083@redhat.com>
References: <20110708201731.GA3025@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301E981AB56@orsmsx505.amr.corp.intel.com>
 <20110708214941.GA20511@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708214941.GA20511@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 10:49:41PM +0100, Matthew Garrett wrote:
> On Fri, Jul 08, 2011 at 02:40:13PM -0700, Luck, Tony wrote:
> > > Inside pstore_dump(), the first thing it tries to grab is a mutex_lock()
> > > (inside an nmi hander).  This seems to be the root cause of my problems.
> > 
> > Someone else pointed out that mutex_lock() is a problem here too. They
> > wondered whether spin_lock_irqsave() would work - or whether pstore
> > backends were allowed to sleep - to which I said I hoped they didn't,
> > but wasn't really sure what the future will hold.
> 
> EFI can't sleep (at least, not as far as the kernel's concerned), so 
> we're safe there. I think it's fair to assume atomicity here - crash 
> dumping is a pretty specific situation. Although we may need to think 
> about whether pstore should be saving reboot and poweroff in that case.

Hmm, reading the ERST spec in ACPI4 (which is the backend behind pstore on
x86 boxes), it seems that reading/writing involves a state machine.  The
code doesn't seem to account for this if in the middle of reading an error
record, a system error occurs and you need to write an error record.  I
imagine the state machine would get screwed up and you would lose any info
you tried writing.

But perhaps, if we detect a spinlock is in use, we can bust it and reset
the state machine to solve that problem?

Cheers,
Don
