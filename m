Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2JYFPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 01:15:07 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57389 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab2JYFPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 01:15:05 -0400
Date: Thu, 25 Oct 2012 01:14:45 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Vladislav Bolkhovitin <vvvvvst@gmail.com>
Cc: =?utf-8?B?5p2o6IuP56uL?= Yang Su Li <suli@cs.wisc.edu>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
Message-ID: <20121025051445.GA9860@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Vladislav Bolkhovitin <vvvvvst@gmail.com>,
	=?utf-8?B?5p2o6IuP56uL?= Yang Su Li <suli@cs.wisc.edu>,
	General Discussion of SQLite Database <sqlite-users@sqlite.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	drh@hwaci.com
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
 <m2fw5mtffg.fsf_-_@firstfloor.org>
 <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
 <5086F5A7.9090406@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5086F5A7.9090406@vlnb.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 03:53:11PM -0400, Vladislav Bolkhovitin wrote:
> Yes, SCSI has full support for ordered/simple commands designed
> exactly for that task: to have steady flow of commands even in case
> when some of them are ordered.....

SCSI does, yes --- *if* the device actually implements Tagged Command
Queuing (TCQ).  Not all devices do.

More importantly, SATA drives do *not* have this capability, and when
you compare the price of SATA drives to uber-expensive "enterprise
drives", it's not surprising that most people don't actually use
SCSI/SAS drives that have implemented TCQ.  SATA's Native Command
Queuing (NCQ) is not equivalent; this allows the drive to reorder
requests (in particular read requests) so they can be serviced more
efficiently, but it does *not* allow the OS to specify a partial,
relative ordering of requests.

Yes, you can turn off writeback caching, but that has pretty huge
performance costs; and there is the FUA bit, but that's just an
unconditional high priority bypass of the writeback cache, which is
useful in some cases, but which again, does not give the ability for
the OS to specify a partial order, while letting the drive reorder
other requests for efficiency/performance's sake, since the drive has
a lot more information about the optimal way to reorder requests based
on the current location of the drive head and where certain blocks may
have been remapped due to bad block sparing, etc.

> Hopefully, eventually the storage developers will realize the value
> behind ordered commands and learn corresponding SCSI facilities to
> deal with them.

Eventually, drive manufacturers will realize that trying to price
guage people who want advanced features such as TCQ, DIF/DIX, is the
best way to gaurantee that most people won't bother to purchase them,
and hence the features will remain largely unused....

    	      	       	    	   	   - Ted
