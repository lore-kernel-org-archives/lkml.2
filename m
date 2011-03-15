Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab1COPr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 11:47:27 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:49824 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755Ab1COPrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 11:47:25 -0400
X-IronPort-AV: E=Sophos;i="4.62,322,1297036800"; 
   d="scan'208";a="4800747"
Subject: Re: [PATCH R4 4/7] xen/balloon: Protect against CPU exhaust by
 event/x process
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Daniel Kiper <dkiper@net-space.pl>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andi.kleen@intel.com" <andi.kleen@intel.com>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Dan Magenheimer" <dan.magenheimer@oracle.com>,
        "v.tolstov@selfip.ru" <v.tolstov@selfip.ru>,
        "pasik@iki.fi" <pasik@iki.fi>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        "wdauchy@gmail.com" <wdauchy@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20110315151748.GC12730@router-fw-old.local.net-space.pl>
References: <20110308214824.GE27331@router-fw-old.local.net-space.pl>
	 <1300115089.17339.2183.camel@zakaz.uk.xensource.com>
	 <20110315151748.GC12730@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 15 Mar 2011 15:47:23 +0000
Message-ID: <1300204043.17339.2280.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 15:17 +0000, Daniel Kiper wrote:
> On Mon, Mar 14, 2011 at 03:04:49PM +0000, Ian Campbell wrote:
> > On Tue, 2011-03-08 at 21:48 +0000, Daniel Kiper wrote:
> > > Protect against CPU exhaust by event/x process during
> > > errors by adding some delays in scheduling next event
> > > and retry count limit.
> >
> > The addition of a default retry count limit reverses the change made in
> > bc2c0303226ec716854d3c208c7f84fe7aa35cd7. That change was made to allow
> > system wide ballooning daemons to work as expected and I don't think a
> > strong argument has been made for undoing it here.
> 
> It is possible to restore original balloon driver behavior by setting
> balloon_stats.max_retry_count = 0 and balloon_stats.max_schedule_delay = 1
> using sysfs.

If max_retry_count continues to exist at all then the default should be
0, you can't just change an interface which users (in this case host
toolstacks) rely on in this manner.

In any case there is no reason for the guest to arbitrarily stop trying
to reach the limit which it has been asked to shoot for (at least not by
default). The guest should never be asked a guest to aim for a
completely unrealistic target which it can never reach (that would be a
toolstack bug) but it is reasonable to assume that the guest will keep
trying to reach its target across any transient memory pressure.

Allowing the guest to back off (max_schedule_delay > 1) makes sense to
me though, although I think 32s is a pretty large default maximum.

> > Also this patch seems to make the driver quite chatty:
> >
> > > +	pr_info("xen_balloon: Retry count: %lu/%lu\n", balloon_stats.retry_count,
> > > +			balloon_stats.max_retry_count);
> >
> > Not needed. The balloon driver is a best effort background thing, it
> > doesn't need to be spamming the system logs each time something doesn't
> > go quite right first time, it should just continue on silently in the
> > background. It should only be logging if something goes catastrophically
> > wrong (in which case pr_info isn't really sufficient).
> 
> Here http://lists.xensource.com/archives/html/xen-devel/2011-02/msg00649.html
> Kondrad suggested to add some printk() to inform user what is going on.

> I agree with him. However, If balloon driver is controlled by external
> process it could pollute logs to some extent. I think that issue could
> be easliy resolved by adding quiet flag.
> 
> Additionally, I think that errors which are sent to logs by balloon
> driver are not critical one. That is why I decided to use pr_info(),
> however, I cosidered using pr_warn(). If you think that pr_warn()
> is better I could change that part of code.

Only the important messages should be logged and those should, by
definition, be via pr_warn (if not higher). However most of the messages
you add needn't be logged at all -- allocation failures and retries are
simply part of the normal behaviour of the balloon driver.

Perhaps some interesting statistics could be exported via sysfs, e.g.
total number of failed allocations, number of allocation failures trying
to reach the current target, how long the balloon driver has been trying
to meet its current target etc, but these don't belong in the system
logs.

The message you quoted above might be acceptable if it wasn't printed
for every retry (a first retry is not going to be all that uncommon) but
rather only periodically after some initial threshold is met without
progress being made. Note that retries without making progress is an
important distinction from just retries, since if the driver is making
some progress there is no need to say anything.

Ian.

