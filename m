Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab2H2Oje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 10:39:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab2H2Ojc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 10:39:32 -0400
Date: Wed, 29 Aug 2012 15:39:14 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, mpatocka@redhat.com,
        bharrosh@panasas.com, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH v7 9/9] block: Avoid deadlocks with bio
	allocation by stacking drivers
Message-ID: <20120829143913.GA5500@agk-dp.fab.redhat.com>
Mail-Followup-To: Kent Overstreet <koverstreet@google.com>,
	Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, mpatocka@redhat.com,
	bharrosh@panasas.com, Tejun Heo <tj@kernel.org>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com> <1346175456-1572-10-git-send-email-koverstreet@google.com> <20120828204910.GG24608@dhcp-172-17-108-109.mtv.corp.google.com> <20120828222800.GG1048@moria.home.lan> <20120828230108.GI1048@moria.home.lan> <20120829013150.GA9269@redhat.com> <20120829032558.GA22214@moria.home.lan> <20120829125759.GB12504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120829125759.GB12504@redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 08:57:59AM -0400, Vivek Goyal wrote:
> I would say keep all the bio splitting patches and any fixes w.r.t
> deadlocks in a seprate series. As this is little complicated and a lot
> of is just theoritical corner cases. If you limit this series to just
> bio_set related cleanups, it becomes more acceptable for inclusion.
 
Yes, please keep the splitting patches separate.  The current code gets
away with what it does through statistics making the deadlocks very
unlikely.

It's also instructive to remember why the code is the way it is: it used
to process bios for underlying devices immediately, but this sometimes
meant too much recursive stack growth.  If a per-device rescuer thread
is to be made available (as well as the mempool), the option of
reinstating recursion is there too - only punting to workqueue when the
stack actually becomes "too big".  (Also bear in mind that some dm
targets may have dependencies on their own mempools - submission can
block there too.)  I find it helpful only to consider splitting into two
pieces - it must always be possible to process the first piece (i.e.
process it at the next layer down in the stack) and complete it
independently of what happens to the second piece (which might require
further splitting and block until the first piece has completed).

Alasdair

