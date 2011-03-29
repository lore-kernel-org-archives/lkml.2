Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1C2NfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:35:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab1C2NfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:35:16 -0400
Subject: Re: Please revert a91a2785b20
From: James Bottomley <James.Bottomley@suse.de>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        dm-devel@redhat.com, neilb@suse.de
In-Reply-To: <20110329132032.GA22921@redhat.com>
References: <alpine.LFD.2.00.1103290006070.2774@localhost6.localdomain6>
	 <alpine.LFD.2.00.1103290040300.2774@localhost6.localdomain6>
	 <20110328230319.GA12790@redhat.com> <4D918347.7050500@fusionio.com>
	 <20110329132032.GA22921@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 08:35:06 -0500
Message-ID: <1301405707.2582.4.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 09:20 -0400, Mike Snitzer wrote:
> On Tue, Mar 29 2011 at  2:59am -0400,
> Jens Axboe <jaxboe@fusionio.com> wrote:
> 
> > On 2011-03-29 01:03, Mike Snitzer wrote:
> > > On Mon, Mar 28 2011 at  6:43pm -0400,
> > > Thomas Gleixner <tglx@linutronix.de> wrote:
> > > 
> > >> Forgot to cc Jens and fixed up the borked mail address of Mike which
> > >> I took from the changelog :(
> > >>
> > >> On Tue, 29 Mar 2011, Thomas Gleixner wrote:
> > >>
> > >>> Out of the blue all my perfectly fine working test machines which use
> > >>> RAID stopped working with the very helpful error message:
> > >>>
> > >>> 	md/raid1:md1: active with 2 out of 2 mirrors
> > >>> 	md: pers->run() failed ...
> > >>>
> > >>> Reverting a91a2785b20 fixes the problem.
> > >>>
> > >>> Neither the subject line:
> > >>>
> > >>>  block: Require subsystems to explicitly allocate bio_set integrity mempool
> > >>>
> > >>> nor the changelog have any hint why that wreckage is in any way
> > >>> sensible.
> > >>>
> > >>> The wreckage happens due to:
> > >>>
> > >>> -       md_integrity_register(mddev);
> > >>> -       return 0;
> > >>> +       return md_integrity_register(mddev);
> > > 
> > > Right, a kernel.org BZ was filed on this here:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=32062
> > > 
> > > Martin is working to "conjure up a patch" to fix the common case where
> > > no devices in the MD have DIF/DIX capabilities.
> > 
> > And I see that has been merged now. So all is good?
> 
> Yes, commit 89078d572e clearly addresses the immediate concern.
> 
> But I think we have a related issue that needs discussion, given that an
> integrity profile mismatch will cause MD's assemble to fail (rather than
> warn and continue to assemble without integrity support).
> 
> DM doesn't fail to load a DM device due to a integrity profile mismatch;
> it just emits a warning and continues.
> 
> In contrast, MD will now disallow adding a normal disk (without
> integrity support) to an array that has historically had a symmetric
> integrity profile across all members.
> 
> So this begs the question: what is the correct approach?

That's easy:  Anything that would cause a change in the previously
specified user profile for the array is an error (principle of least
surprise) so it can't happen automatically.  Silently adding a non
integrity device would be nasty for the admin because they could think
they were adding an integrity disk when they weren't (for a variety of
reasons, like some problem with the HBA or incorrect settings on the
disk).  So adding a non-integrity device to an integrity profile array
should return a soft error, with an explanation.  However, the user
should be able to force the array online and change the profile.  How
it's done (tooling or kernel), I'm not particularly bothered.

James


