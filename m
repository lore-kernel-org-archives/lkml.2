Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab0IQN5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:57:36 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:49093 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751124Ab0IQN5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:57:35 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: j3iRyj0VM1lv_A_M.2VzqnF5WgHzpb.1aCxwxWmroRiPWKo
 uLxqred9fqC_br3LZRsaFDCjaVTVs3cMvZp1.qbfoRtz4ridadeiPYdMZlOH
 nQBUJJfSFyX2pq033XHWcRwMoZMT5jFzr4eROblmLJvdhuHeECgbHGwtO4AT
 Aaih5rgTmLQE985xY5l9Iftf9Sjnt9wHMcfyOAME9NfKOssp_hPU8fqCsbrI
 I
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 17 Sep 2010 08:56:06 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Robert Mueller <robm@fastmail.fm>
cc: Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bron Gondwana <brong@fastmail.fm>, linux-mm <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad for
 file/email/web servers
In-Reply-To: <1284708756.2702.1395472601@webmail.messagingengine.com>
Message-ID: <alpine.DEB.2.00.1009170851200.11900@router.home>
References: <1284349152.15254.1394658481@webmail.messagingengine.com> <20100916184240.3BC9.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1009161153210.22849@router.home> <1284684653.10161.1395434085@webmail.messagingengine.com> <1284703264.3408.1.camel@sli10-conroe.sh.intel.com>
 <1284708756.2702.1395472601@webmail.messagingengine.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Sep 2010, Robert Mueller wrote:

> > > I don't think this is any fault of how the software works. It's a
> > > *very* standard "pre-fork child processes, allocate incoming
> > > connections to a child process, open and mmap one or more files to
> > > read data from them". That's not exactly a weird programming model,
> > > and it's bad that the kernel is handling that case very badly with
> > > everything default.
> >
> > maybe you incoming connection always happen on one CPU and you do the
> > page allocation in that cpu, so some nodes use out of memory but
> > others have a lot free. Try bind the child process to different nodes
> > might help.
>
> There's are 5000+ child processes (it's a cyrus IMAP server). Neither
> the parent of any of the children are bound to any particular CPU. It
> uses a standard fcntl lock to make sure only one spare child at a time
> calls accept(). I don't think that's the problem.

>From the first look that seems to be the problem. You do not need to be
bound to a particular cpu, the scheduler will just leave a single process
on the same cpu by default. If you then allocate all memory only from this
process then you get the scenario that you described.

There should be multiple processes allocating memory from all processors
to take full advantage of fast local memory. If you cannot do that then
the only choice is to reduce performance by some sort of interleaving
either at the Bios or OS level. OS level interleaving only for this
particular application would be best because then the OS can at least
allocate its own data in memory local to the processors.


