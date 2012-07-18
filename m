Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2GRVeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 17:34:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54064 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab2GRVd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 17:33:57 -0400
Date: Wed, 18 Jul 2012 22:33:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
        reiserfs-devel@vger.kernel.org
Subject: Re: [Bug 3.4.5] reiserfs: mutex_destroy called with locked mutex
Message-ID: <20120718213355.GV31729@ZenIV.linux.org.uk>
References: <5006491D.8070004@t-online.de>
 <CA+55aFzv5mntf6y9e_r5=v+beG19xBv67EpA=dP0-Zw1CQrGGg@mail.gmail.com>
 <20120718212044.GU31729@ZenIV.linux.org.uk>
 <CA+55aFyHpgbJ9Pn5xn_ALkvzjQBOWog2qLbwwtrKbPHSGpa6pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyHpgbJ9Pn5xn_ALkvzjQBOWog2qLbwwtrKbPHSGpa6pA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 02:25:02PM -0700, Linus Torvalds wrote:
> On Wed, Jul 18, 2012 at 2:20 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Wed, Jul 18, 2012 at 09:26:57AM -0700, Linus Torvalds wrote:
> >>
> >> So I don't think the freeing code could trigger, but a concurrent
> >> lookup then trying to look up the new directory (and taking the new
> >> directory i_semaphore lock) could happen, afaik.
> >
> > Umm...  The thing is, we'd get WARN_ON() in iput_final() triggering in
> > that scenario before lockdep could complain.
> 
> Not for the "look up directory in the dcache, and then lock that
> inode" case, afaik. You'd get the lock before iput_final(), no?
> 
> So then "unlock_new_inode()" would run with the inode mutex held,
> which could explain the lockdep warning, no?

Umm..  Right you are, I was thinking about the "can the freeing code
actually trigger".  OK; I'm still not sure this should go in before
-final, but it could be the reason behind those (false positive)
warnings from lockdep.  Could probably step into something nasty
around e.g. writeback or quota, so maybe it's worth doing just in
case...

It's definitely the right thing to do wrt not giving the rest of the
VFS/VM nasty surprises - everything might work correctly with IO
coming on such still-I_NEW-and-locked inode, but that's not a case
that will be often considered when modifying code.  The only questions
are "is this the WARN_ON() Knut had stepped on" (and I agree with your
scenario now) and "is it critical enough to shove it into the tree
less than a week before -final".  Up to you...
