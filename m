Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab1GLPej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 11:34:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab1GLPei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 11:34:38 -0400
Date: Tue, 12 Jul 2011 11:34:36 -0400
From: Don Zickus <dzickus@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "mjg@redhat.com" <mjg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ying.huang@intel.com
Subject: Re: pstore dump inside an nmi handler
Message-ID: <20110712153436.GL3765@redhat.com>
References: <20110708201731.GA3025@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301E981AB56@orsmsx505.amr.corp.intel.com>
 <20110711215541.GF2938@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711215541.GF2938@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 05:55:41PM -0400, Don Zickus wrote:
> On Fri, Jul 08, 2011 at 02:40:13PM -0700, Luck, Tony wrote:
> > > Inside pstore_dump(), the first thing it tries to grab is a mutex_lock()
> > > (inside an nmi hander).  This seems to be the root cause of my problems.
> > 
> > Someone else pointed out that mutex_lock() is a problem here too. They
> > wondered whether spin_lock_irqsave() would work - or whether pstore
> > backends were allowed to sleep - to which I said I hoped they didn't,
> > but wasn't really sure what the future will hold.
> > 
> > So ... ideas (and patches) are most welcome.
> 
> I tested the spin_lock_irqsave thing on my one box where it was failing
> and got past my initial problem into kdump.  So that is a positive and I
> can post the patch for that.  Though it probably isn't a complete
> solution, it is better than a mutex.
> 
> However, I have been scratching my head at a follow up problem, which is
> when I inject an error which produces an NMI->GHES->panic, the error
> record doesn't get stored under pstore (or maybe ERST too).  I do see the
> ERST code follow all the correct steps in storing the kmsg_dump logs into
> the ERST table.  Just on the reboot, when I mount pstore it isn't there.

Actually, is it expected that the ERST can handle only 8 records?  Also if
you remove those records with pstore mount under /mnt; 'rm -rf
/mnt/dmesg-*', are those records removed immediately or are they cached to
be removed later?  IOW, if a did a 'rm -rf ..' and then an 'echo c >
/proc/sysrq-trigger' immediately after it, would I expect those records to
be removed or not?  Testing shows they are removed on reboot but the later
'echo c > ..' didn't save any new error records. :-/

Cheers,
Don
