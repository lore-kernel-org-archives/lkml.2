Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1C2NV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:21:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab1C2NV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:21:27 -0400
Date: Tue, 29 Mar 2011 09:20:32 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        dm-devel@redhat.com, neilb@suse.de
Subject: Re: Please revert a91a2785b20
Message-ID: <20110329132032.GA22921@redhat.com>
References: <alpine.LFD.2.00.1103290006070.2774@localhost6.localdomain6>
 <alpine.LFD.2.00.1103290040300.2774@localhost6.localdomain6>
 <20110328230319.GA12790@redhat.com>
 <4D918347.7050500@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D918347.7050500@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29 2011 at  2:59am -0400,
Jens Axboe <jaxboe@fusionio.com> wrote:

> On 2011-03-29 01:03, Mike Snitzer wrote:
> > On Mon, Mar 28 2011 at  6:43pm -0400,
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> >> Forgot to cc Jens and fixed up the borked mail address of Mike which
> >> I took from the changelog :(
> >>
> >> On Tue, 29 Mar 2011, Thomas Gleixner wrote:
> >>
> >>> Out of the blue all my perfectly fine working test machines which use
> >>> RAID stopped working with the very helpful error message:
> >>>
> >>> 	md/raid1:md1: active with 2 out of 2 mirrors
> >>> 	md: pers->run() failed ...
> >>>
> >>> Reverting a91a2785b20 fixes the problem.
> >>>
> >>> Neither the subject line:
> >>>
> >>>  block: Require subsystems to explicitly allocate bio_set integrity mempool
> >>>
> >>> nor the changelog have any hint why that wreckage is in any way
> >>> sensible.
> >>>
> >>> The wreckage happens due to:
> >>>
> >>> -       md_integrity_register(mddev);
> >>> -       return 0;
> >>> +       return md_integrity_register(mddev);
> > 
> > Right, a kernel.org BZ was filed on this here:
> > https://bugzilla.kernel.org/show_bug.cgi?id=32062
> > 
> > Martin is working to "conjure up a patch" to fix the common case where
> > no devices in the MD have DIF/DIX capabilities.
> 
> And I see that has been merged now. So all is good?

Yes, commit 89078d572e clearly addresses the immediate concern.

But I think we have a related issue that needs discussion, given that an
integrity profile mismatch will cause MD's assemble to fail (rather than
warn and continue to assemble without integrity support).

DM doesn't fail to load a DM device due to a integrity profile mismatch;
it just emits a warning and continues.

In contrast, MD will now disallow adding a normal disk (without
integrity support) to an array that has historically had a symmetric
integrity profile across all members.

So this begs the question: what is the correct approach?

At the moment I prefer the more forgiving approach that DM provides.
But I can appreciate the other school of thought where a mismatch is a
hard failure during device assembly (avoids possibility of falling back
to not using integrity capabilities).

Mike
