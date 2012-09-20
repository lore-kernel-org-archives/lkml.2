Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab2ITVPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:15:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23034 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2ITVPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:15:08 -0400
Date: Thu, 20 Sep 2012 17:14:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: 3.6rc6 slab corruption.
Message-ID: <20120920211443.GA27312@konrad-lan.dumpdata.com>
References: <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com>
 <20120918192338.GA25845@phenom.dumpdata.com>
 <CA+55aFy6=1vW4CN0_g8BgSKKdxZNZj9Yd2WG=0BFKjish=Vw=g@mail.gmail.com>
 <20120918203713.GB19300@phenom.dumpdata.com>
 <CA+55aFzZvFeCLF8fw=NYFN7C_8ObwJMeK13bN8xRodKQ0QJkTQ@mail.gmail.com>
 <20120919191652.GA14631@phenom.dumpdata.com>
 <alpine.DEB.2.00.1209191427460.6273@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1209191438200.21378@chino.kir.corp.google.com>
 <CA+55aFzU1S6cybghVv4Bg2K8X1NC2pX2XebSrEgn0pKtgyCfRw@mail.gmail.com>
 <alpine.DEB.2.00.1209191608160.17867@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209191608160.17867@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 04:20:25PM -0700, David Rientjes wrote:
> On Wed, 19 Sep 2012, Linus Torvalds wrote:
> 
> > That does look simpler, and avoiding the lock is a good idea. Since we
> > don't support lseek() (or pread/pwrite) on that thing anyway, there's
> > no way to keep the fd open and just re-use it to read the data over
> > and over, so populating it at open time sounds like a good solution
> > with no real downsides.
> > 
> 
> Yeah, my patch is functionally the same as what we currently have with the 
> only exception being that it isn't racy.  I'm wondering if that's what we 
> really want, though, since the data read from the file will remain 
> persistent as long as it is opened.  That obviously happens in my patch 
> because we allocate and copy the buffer at open(), but also happens 
> implicitly with the old code precisely because it's a non-seekable file 
> and *ppos == 0 only once (when not racy).
> 
> So if the API for these xen files is to remain persistent after open() as 
> it currently does, then my patch solves the issue.  However, if the API 

Nah. It was initially a debug option to see how contended the spinlocks
are. Nobody but developers should look at it - and they can deal with
open/close cycle. Thought we should probably provide a nice little
comment in the file mentioning the reason for stale data.

> wants to allow to only open() once and then read the spinlock_stats data 
> continuously, then we'll need the mutex: allocate the file->private_data 
> buffer once at open() for the maximum allowable size and then copy to the 
> buffer from xen's spinlock_stats under the protection of the mutex to 
> read().
> 
> Konrad?

Your patch is way simpler and it does the job better than mine.
