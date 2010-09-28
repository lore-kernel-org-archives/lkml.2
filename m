Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0I1MfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:35:18 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:33298 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751229Ab0I1MfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:35:17 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 4EHSGC8VM1mIUXGdIjeeuv2KDsPi.m1i3uzkkJqJmSGXisI
 y5c2zEOJcU4bFnP3wsibYG3CRzAc0rzO15uY80y50ngqA4jvJLtB6UWYy_zn
 0WjnkpSY0ckrB9oYFOqzQKohON.bKqzLp5E8nj0GEkK0TwcuJZcZBiKYuvs3
 WGizum8EZtIMUJCrhD3pDSUaVWC1scUejcuWAvmucXtE7pz297a98t0dw20J
 shQ4uSP277et10e4egoiNB6Ev8Iaxr4sqgw--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 28 Sep 2010 07:35:13 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Robert Mueller <robm@fastmail.fm>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        Bron Gondwana <brong@fastmail.fm>, linux-mm <linux-mm@kvack.org>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad forfile/email/web
 servers
In-Reply-To: <1285629420.10278.1397188599@webmail.messagingengine.com>
Message-ID: <alpine.DEB.2.00.1009280727370.4144@router.home>
References: <52C8765522A740A4A5C027E8FDFFDFE3@jem> <20100921090407.GA11439@csn.ul.ie> <20100927110049.6B31.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1009270828510.7000@router.home> <1285629420.10278.1397188599@webmail.messagingengine.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010, Robert Mueller wrote:

> How would the ACPI information actually be changed?

Fix the BIOS SLIT distance tables.

> I ran numactl -H to get the hardware information, and that seems to
> include distances. As mentioned previously, this is a very standard
> Intel server motherboard.
>
> http://www.intel.com/Products/Server/Motherboards/S5520UR/S5520UR-specifications.htm
>
> Intel 5520 chipset with Intel I/O Controller Hub ICH10R
>
> $ numactl -H
> available: 2 nodes (0-1)
> node 0 cpus: 0 2 4 6 8 10 12 14
> node 0 size: 24517 MB
> node 0 free: 1523 MB
> node 1 cpus: 1 3 5 7 9 11 13 15
> node 1 size: 24576 MB
> node 1 free: 39 MB
> node distances:
> node   0   1
>   0:  10  21
>   1:  21  10

21 is larger than REMOTE_DISTANCE on x86 and triggers zone_reclaim

19 would keep it off.


> Since I'm not sure what the "distance" values mean, I have no idea if
> those values large or not?

Distance values represent the additional latency necessary to access
remote memory vs local memory (10)

> > 4. Fix the application to be conscious of the effect of memory
> >    allocations on a NUMA systems. Use the numa memory allocations API
> >    to allocate anonymous memory locally for optimal access and set
> >    interleave for the file backed pages.
>
> The problem we saw was purely with file caching. The application wasn't
> actually allocating much memory itself, but it was reading lots of files
> from disk (via mmap'ed memory mostly), and as most people would, we
> expected that data would be cached in memory to reduce future reads from
> disk. That was not happening.

Obviously and you have stated that numerous times. Problem that the use of
a remote memory will reduced performance of reads so the OS (with
zone_reclaim=1) defaults to the use of local memory and favors reclaim of
local memory over the allocation from the remote node. This is fine if
you have multiple applications running on both nodes because then each
application will get memory local to it and therefore run faster. That
does not work with a single app that only allocates from one node.

Control over memory allocations over the various nodes under NUMA
for a process can occur via the numactl ctl or the libnuma C apis.

F.e.e

numactl --interleave ... command

will address that issue for a specific command that needs to go
