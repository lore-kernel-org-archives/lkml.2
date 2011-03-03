Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1CCIaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:30:24 -0500
Received: from www.tglx.de ([62.245.132.106]:56699 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab1CCIaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:30:21 -0500
Date: Thu, 3 Mar 2011 09:28:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matt Helsley <matthltc@us.ibm.com>
cc: "Kirill A. Shutsemov" <kirill@shutemov.name>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH, v7] cgroups: introduce timer slack controller
In-Reply-To: <20110303074609.GL14893@count0.beaverton.ibm.com>
Message-ID: <alpine.LFD.2.00.1103030918390.2701@localhost6.localdomain6>
References: <1299084001-3916-1-git-send-email-kirill@shutemov.name> <1299084001-3916-2-git-send-email-kirill@shutemov.name> <alpine.LFD.2.00.1103021912090.2701@localhost6.localdomain6> <20110303074609.GL14893@count0.beaverton.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, Matt Helsley wrote:

> On Wed, Mar 02, 2011 at 07:40:01PM +0100, Thomas Gleixner wrote:
> > On Wed, 2 Mar 2011, Kirill A. Shutsemov wrote:
> 
> <snip>
> 
> > > +		if (val > child->min_slack_ns)
> > > +			tslack_write_min(cur, cft, val);
> > > +	}
> > 
> > So, we can increase the value and propagate it through the groups
> > children, but decreasing it requires to go through all child groups
> > seperately. 
> 
> One goal is to restrict shrinking timer slacks so that they
> cannot be less than the parent cgroup's.

Right, but that's not what the code is doing.
 
> > 
> > When I'm trying to optimize something during runtime and chose a too
> > high value I need to go through hoops and loops to make it smaller
> > again.
> > 
> > Asymetric behaviour sucks always.
> 
> Well, in this case I think the asymmetry is less sucky because I don't
> see any point in imposing the same restrictions on raising the timer
> slack *except* this symmetry argument. But I haven't played much with
> timer slacks so I don't know: Is there any case where raising the timer
> slack would be harmful?

Well, the slack can delay your timer expiry by slack ns. So chosing a
too large slack value can affect the functionality of an application.

Now imagine you are tuning your system and typo the slack value by an
order of magnitude, which makes your apps unhappy. Then you definitely
want to be able to undo that w/o going through loops and circles.

> Would making the values additive solve the symmetry problem? In other words,
> the "minimum" you see in a cgroups min_slack_ns file is the minimum in
> addition to the minimum timer slack of its parent. Then, so long as negative
> values are disallowed, you can't possibly write values that violate this
> restriction. We could re-evaluate the resulting minimum timer slack internally
> during writes to the file so functions using timer slack won't have to walk
> the cgroup parents to calculate it but it couldn't result in EPERM...

That would work, but that wants some interface to read out the
effective slack value for a group.

Thanks,

	tglx
