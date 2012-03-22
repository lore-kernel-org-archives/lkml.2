Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395Ab2CVPjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 11:39:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45823 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab2CVPjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 11:39:14 -0400
Date: Thu, 22 Mar 2012 15:39:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Matt Helsley <matt.helsley@gmail.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v3 10/12] ima: defer calling __fput()
Message-ID: <20120322153909.GX6589@ZenIV.linux.org.uk>
References: <1332356057-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1332356057-3356-11-git-send-email-zohar@linux.vnet.ibm.com>
 <20120322142212.GV6589@ZenIV.linux.org.uk>
 <1332427986.2218.53.camel@falcor>
 <20120322150945.GW6589@ZenIV.linux.org.uk>
 <CALLzPKZTyba2ZgLea=dJW1RsY99-nOE3riVY0mCGVg7zm1SCFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKZTyba2ZgLea=dJW1RsY99-nOE3riVY0mCGVg7zm1SCFw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 05:19:09PM +0200, Kasatkin, Dmitry wrote:
> On Thu, Mar 22, 2012 at 5:09 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Thu, Mar 22, 2012 at 10:53:04AM -0400, Mimi Zohar wrote:
> >> > BTW, you've missed several other places in mm/* doing fput(), so it wouldn't
> >> > be enough to paper over your problem anyway.
> >> >
> >> > Final fput() *can* happen under mmap_sem. ??Period.
> >>
> >> I think I got that loud and clear; otherwise we wouldn't have come up
> >> with deferring the __fput(). ??We have a very real problem here - writing
> >> extended attributes requires taking the i_mutex.
> >
> > Don't do it, then? ??If you _must_ write to xattr on final fput, I'd suggest
> > starting to figure out if xattr needs its protection to be ->i_mutex - it
> > might make sense to introduce a separate mutex for xattr crap. ??Or not - I'm
> 
> "Or not" ... How to understand you?

"Or it might not make sense to go that way"
 
> > not familiar enough with the guts of xattr handling in individual filesystems
> > to tell if that would work (e.g. if it would need unpleasant changes to
> > ->setattr() instances)...

IOW, you'll need to do quite a bit of code review to tell if it's a feasible
direction or not - I can't tell without doing the same amount of RTFS; look
for the places where xattrs are modified by fs code, see how far is ->i_mutex
acquired, whether xattrs are read in the same section and whether we rely on
->i_mutex to keep the xattr values unchanged between two reads or write and
read...
