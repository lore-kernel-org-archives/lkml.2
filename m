Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab1COPTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 11:19:13 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:34876 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666Ab1COPTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 11:19:12 -0400
Date: Tue, 15 Mar 2011 16:17:48 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: Daniel Kiper <dkiper@net-space.pl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andi.kleen@intel.com" <andi.kleen@intel.com>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        "v.tolstov@selfip.ru" <v.tolstov@selfip.ru>,
        "pasik@iki.fi" <pasik@iki.fi>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        "wdauchy@gmail.com" <wdauchy@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH R4 4/7] xen/balloon: Protect against CPU exhaust by event/x process
Message-ID: <20110315151748.GC12730@router-fw-old.local.net-space.pl>
References: <20110308214824.GE27331@router-fw-old.local.net-space.pl> <1300115089.17339.2183.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300115089.17339.2183.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 03:04:49PM +0000, Ian Campbell wrote:
> On Tue, 2011-03-08 at 21:48 +0000, Daniel Kiper wrote:
> > Protect against CPU exhaust by event/x process during
> > errors by adding some delays in scheduling next event
> > and retry count limit.
>
> The addition of a default retry count limit reverses the change made in
> bc2c0303226ec716854d3c208c7f84fe7aa35cd7. That change was made to allow
> system wide ballooning daemons to work as expected and I don't think a
> strong argument has been made for undoing it here.

It is possible to restore original balloon driver behavior by setting
balloon_stats.max_retry_count = 0 and balloon_stats.max_schedule_delay = 1
using sysfs.

> We are talking about polling at most once a second (backing off pretty
> quickly to once every 32s with this patch) -- is that really enough to
> "exhaust" the CPU running event/x?

OK, it is not precise. I will change that to:

xen/balloon: Reduce CPU utilization by event/x process

> Also this patch seems to make the driver quite chatty:
>
> > +	pr_info("xen_balloon: Retry count: %lu/%lu\n", balloon_stats.retry_count,
> > +			balloon_stats.max_retry_count);
>
> Not needed. The balloon driver is a best effort background thing, it
> doesn't need to be spamming the system logs each time something doesn't
> go quite right first time, it should just continue on silently in the
> background. It should only be logging if something goes catastrophically
> wrong (in which case pr_info isn't really sufficient).

Here http://lists.xensource.com/archives/html/xen-devel/2011-02/msg00649.html
Kondrad suggested to add some printk() to inform user what is going on.
I agree with him. However, If balloon driver is controlled by external
process it could pollute logs to some extent. I think that issue could
be easliy resolved by adding quiet flag.

Additionally, I think that errors which are sent to logs by balloon
driver are not critical one. That is why I decided to use pr_info(),
however, I cosidered using pr_warn(). If you think that pr_warn()
is better I could change that part of code.

Daniel
