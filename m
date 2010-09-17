Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab0IQXBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 19:01:52 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51895 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934Ab0IQXBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 19:01:51 -0400
X-Sasl-enc: jJ+lyjRdEPpKqOY6WkjNMNsgPmozjCo5qsIpyTWKiJ/A 1284764510
Date: Sat, 18 Sep 2010 09:01:48 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Christoph Lameter <cl@linux.com>
Cc: Bron Gondwana <brong@fastmail.fm>, Robert Mueller <robm@fastmail.fm>,
        Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad for
 file/email/web servers
Message-ID: <20100917230148.GA10636@brong.net>
References: <1284349152.15254.1394658481@webmail.messagingengine.com>
 <20100916184240.3BC9.A69D9226@jp.fujitsu.com>
 <alpine.DEB.2.00.1009161153210.22849@router.home>
 <1284684653.10161.1395434085@webmail.messagingengine.com>
 <1284703264.3408.1.camel@sli10-conroe.sh.intel.com>
 <1284708756.2702.1395472601@webmail.messagingengine.com>
 <alpine.DEB.2.00.1009170851200.11900@router.home>
 <20100917140916.GA8474@brong.net>
 <alpine.DEB.2.00.1009170916130.11900@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1009170916130.11900@router.home>
Organization: brong.net
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 09:22:00AM -0500, Christoph Lameter wrote:
> On Sat, 18 Sep 2010, Bron Gondwana wrote:
> 
> > > From the first look that seems to be the problem. You do not need to be
> > > bound to a particular cpu, the scheduler will just leave a single process
> > > on the same cpu by default. If you then allocate all memory only from this
> > > process then you get the scenario that you described.
> >
> > Huh?  Which bit of forking server makes you think one process is allocating
> > lots of memory?  They're opening and reading from files.  Unless you're
> > calling the kernel a "single process".
> 
> I have no idea what your app does. 

Ok - Cyrus IMAPd has been around for ages.  It's an open source email
server built on a very traditional single-process model.

* a master process which reads config files and manages the other process
* multiple imapd processes, one per connection
* multiple pop3d processes, one per connection
* multiple lmtpd processes, one per connection
* periodical "cleanup" processes.

Each of these is started by the lightweight master forking and then
execing the appropriate daemon.

In our configuration we run 20 separate "master" processes, each
managing a single disk partition's worth of email.  The reason
for this is reduced locking contention for the central mailboxes
database, and also better replication concurrency, because each
instance runs a single replication process - so replication is
sequential.

> The data that I glanced over looks as
> if most allocations happen for a particular memory node

Sorry, which data?

> and since the
> memory is optimized to be local to that node other memory is not used
> intensively. This can occur because of allocations through one process /
> thread that is always running on the same cpu and therefore always
> allocates from the memory node local to that cpu.

As Rob said, there are thousands of independent processes, each opening
a single mailbox (3 separate metadata files plus possibly hundreds of
individual email files).  It's likely that diffenent processes will open
the same mailbox over time - for example an email client opening multiple
concurrent connections, and at the same time an lmtpd connecting and
delivering new emails to the mailbox.

> It can also happen f.e. if a driver always allocates memory local to the
> I/O bus that it is using.

None of what we're doing is super weird advanced stuff, it's a vanilla
forking daemon where a single process run and does stuff on behalf of
a user.  The only slightly interesting things:

1) each "service" has a single lock file, and all the idle processes of
   that type (i.e. imapd) block on that lock while they're waiting for
   a connection.  This is to avoid thundering herd on operating systems
   which aren't nice about it.  The winner does the accept and handles
   the connection.
2) once it's finished processing a request, the process will wait for
   another connection rather than closing.

Nothing sounds like what you're talking about (one giant process that's
all on one CPU), and I don't know why you keep talking about it.  It's
nothing like what we're running on these machines.

Bron.
