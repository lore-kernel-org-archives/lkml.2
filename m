Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab1CCHqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:46:18 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41469 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab1CCHqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:46:17 -0500
Date: Wed, 2 Mar 2011 23:46:09 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Kirill A. Shutsemov" <kirill@shutemov.name>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH, v7] cgroups: introduce timer slack controller
Message-ID: <20110303074609.GL14893@count0.beaverton.ibm.com>
References: <1299084001-3916-1-git-send-email-kirill@shutemov.name>
 <1299084001-3916-2-git-send-email-kirill@shutemov.name>
 <alpine.LFD.2.00.1103021912090.2701@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103021912090.2701@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 07:40:01PM +0100, Thomas Gleixner wrote:
> On Wed, 2 Mar 2011, Kirill A. Shutsemov wrote:

<snip>

> > +		if (val > child->min_slack_ns)
> > +			tslack_write_min(cur, cft, val);
> > +	}
> 
> So, we can increase the value and propagate it through the groups
> children, but decreasing it requires to go through all child groups
> seperately. 

One goal is to restrict shrinking timer slacks so that they
cannot be less than the parent cgroup's.

> 
> When I'm trying to optimize something during runtime and chose a too
> high value I need to go through hoops and loops to make it smaller
> again.
> 
> Asymetric behaviour sucks always.

Well, in this case I think the asymmetry is less sucky because I don't
see any point in imposing the same restrictions on raising the timer
slack *except* this symmetry argument. But I haven't played much with
timer slacks so I don't know: Is there any case where raising the timer
slack would be harmful?

Would making the values additive solve the symmetry problem? In other words,
the "minimum" you see in a cgroups min_slack_ns file is the minimum in
addition to the minimum timer slack of its parent. Then, so long as negative
values are disallowed, you can't possibly write values that violate this
restriction. We could re-evaluate the resulting minimum timer slack internally
during writes to the file so functions using timer slack won't have to walk
the cgroup parents to calculate it but it couldn't result in EPERM...

Cheers,
	-Matt Helsley
