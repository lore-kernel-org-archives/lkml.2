Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1BOABG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 19:01:06 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:46619 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab1BOABC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 19:01:02 -0500
Date: Mon, 14 Feb 2011 16:00:55 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matt Helsley <matthltc@us.ibm.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH, v6 3/3] cgroups: introduce timer slack controller
Message-ID: <20110215000055.GR16432@count0.beaverton.ibm.com>
References: <1297688787-3592-1-git-send-email-kirill@shutemov.name>
 <1297688787-3592-4-git-send-email-kirill@shutemov.name>
 <20110214135926.GO16432@count0.beaverton.ibm.com>
 <20110214225940.GB6230@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214225940.GB6230@shutemov.name>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 12:59:40AM +0200, Kirill A. Shutemov wrote:
> On Mon, Feb 14, 2011 at 05:59:26AM -0800, Matt Helsley wrote:
> > On Mon, Feb 14, 2011 at 03:06:27PM +0200, Kirill A. Shutsemov wrote:
> > > From: Kirill A. Shutemov <kirill@shutemov.name>

<snip>

> > > +	list_for_each_entry(cur, &cgroup->children, sibling) {
> > > +		child = cgroup_to_tslack_cgroup(cur);
> > > +		if (type == TIMER_SLACK_MIN && val > child->min_slack_ns)
> > > +			return -EBUSY;
> > > +		if (type == TIMER_SLACK_MAX && val < child->max_slack_ns)
> > > +			return -EBUSY;
> > > +	}
> > 
> > This doesn't look right. Child cgroups should not constrain their
> > parents. Instead you should allow the change and propagate the
> > constraint to the children.
> 
> See discussion with Thomas.

<OK, shifting this topic to that thread>
<snip>

> > > +static struct cftype files[] = {
> > > +	{
> > > +		.name = "set_slack_ns",
> > > +		.write_u64 = tslack_write_set_slack_ns,
> > > +	},
> > > +	{
> > > +		.name = "min_slack_ns",
> > > +		.private = TIMER_SLACK_MIN,
> > > +		.read_u64 = tslack_read_range,
> > > +		.write_u64 = tslack_write_range,
> > > +	},
> > > +	{
> > > +		.name = "max_slack_ns",
> > > +		.private = TIMER_SLACK_MAX,
> > > +		.read_u64 = tslack_read_range,
> > > +		.write_u64 = tslack_write_range,
> > > +	},
> > 
> > I didn't get a reply on how a max_slack_ns is useful. It seems
> > prudent to add as little interface as possible and only when
> > we clearly see the utility of it.
> 
> For example, you can create two groups (excluding root cgroup):
> 
> default - timer slack range 50000-50000
> relaxed - timer slack range 500000-unlimited.
> 
> Now you can drag tasks between these group without need to reset value on
> relaxed -> default transition.

Perhaps you misunderstood my point.

Yes, I can see that a maximum allows you to do counter-productive/pointless
little tricks like "setting" the timer slack when you move the task. I
just don't get the point of it. Why is setting a maximum timer slack useful?
If anything it seems like it would be quite counterproductive or pointless
*at best* because limiting the amount of timer slack would not improve
the wakeup situation -- it could easily make it worse. Are there
*any* negative consequences to allowing timer slacks as large as
userspace requests -- perhaps even up to ULLONG_MAX? If there are none then
why should we bother providing userspace a knob to set and enforce such a
limit?

Cheers,
	-Matt Helsley
