Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab0IPRGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:06:43 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:32875 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752475Ab0IPRGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:06:42 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 2bpqh9AVM1lnrjOFScvaLZoa_3JqVzVmF54j0IAVNk1VqN6
 WCSbOFM5q8I9cBTQBRAoDdAWIkAJ6zVLdFJTTQcbfYJedBkf7sb1fMGgETtn
 v6MJjd9ZeQ4HCgo.W649AX3ZM.9V.1f_OuyX6zemX4VSWPn4NR9jIZ7HB_Le
 Ng9v9Rk2R7uK2LJLsVRffGb_Rp0UQqnrj3ItZh7QL6P4en8mx2r1hgBP6Yoi
 dvsEWLGuP6WLUEHjYI1j.482lPNAk
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 16 Sep 2010 12:06:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: robm@fastmail.fm, linux-kernel@vger.kernel.org,
        Bron Gondwana <brong@fastmail.fm>, linux-mm <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad for
 file/email/web servers
In-Reply-To: <20100916184240.3BC9.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1009161153210.22849@router.home>
References: <1284349152.15254.1394658481@webmail.messagingengine.com> <20100916184240.3BC9.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010, KOSAKI Motohiro wrote:

> > So over the last couple of weeks, I've noticed that our shiny new IMAP
> > servers (Dual Xeon E5520 + Intel S5520UR MB) with 48G of RAM haven't
> > been performing as well as expected, and there were some big oddities.
> > Namely two things stuck out:
> >
> > 1. There was free memory. There's 20T of data on these machines. The
> >    kernel should have used lots of memory for caching, but for some
> >    reason, it wasn't. cache ~ 2G, buffers ~ 25G, unused ~ 5G

This means that that the memory allocations did only occur on a single
processor? And with zone reclaim it only used one node since the page
cache was reclaimed?

> > Having very little knowledge of what this actually does, I'd just
> > like to point out that from a users point of view, it's really
> > annoying for your machine to be crippled by a default kernel setting
> > that's pretty obscure.

Thats an issue of the NUMA BIOS information. Kernel defaults to zone
reclaim if the cost of accessing remote memory vs local memory crosses
a certain threshhold which usually impacts performance.

> Yes, sadly intel motherboard turn on zone_reclaim_mode by default. and
> current zone_reclaim_mode doesn't fit file/web server usecase ;-)

Or one could also say that the web servers are not designed to properly
distribute the load on a complex NUMA based memory architecture of todays
Intel machines.

> So, I've created new proof concept patch. This doesn't disable zone_reclaim
> at all. Instead, distinguish for file cache and for anon allocation and
> only file cache doesn't use zone-reclaim.

zone reclaim was intended to only be applicable to unmapped file cache in
order to be low impact.  Now you just want to apply it to anonymous pages?

> That said, high-end hpc user often turn on cpuset.memory_spread_page and
> they avoid this issue. But, why don't we consider avoid it by default?

Well as you say setting memory spreading on would avoid the issue.

So would enabling memory interleave in the BIOS to get the machine to not
consider the memory distances but average out the NUMA effects.


