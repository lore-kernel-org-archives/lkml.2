Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab0JHN5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:57:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:60266 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab0JHN5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:57:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,302,1283756400"; 
   d="scan'208";a="614684771"
Date: Fri, 8 Oct 2010 21:57:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        "Wu, Xia" <xia.wu@intel.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] bdi: use deferable timer for sync_supers task
Message-ID: <20101008135704.GB25439@localhost>
References: <20101008083514.GA12402@ywang-moblin2.bj.intel.com>
 <20101008092520.GB5426@lst.de>
 <A24AE1FFE7AEC5489F83450EE98351BF227AB58D43@shsmsx502.ccr.corp.intel.com>
 <1286532586.2095.55.camel@localhost>
 <A24AE1FFE7AEC5489F83450EE98351BF227AB58D51@shsmsx502.ccr.corp.intel.com>
 <1286533687.2095.58.camel@localhost>
 <20101008102709.GA12682@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008102709.GA12682@ywang-moblin2.bj.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 06:27:09PM +0800, Yong Wang wrote:
> On Fri, Oct 08, 2010 at 01:28:07PM +0300, Artem Bityutskiy wrote:
> > On Fri, 2010-10-08 at 18:27 +0800, Wu, Xia wrote:
> > > > However, when the next wake-up interrupt happens is not defined. It can
> > > > happen 1ms after, or 1 minute after, or 1 hour after. What Christoph
> > > > says is that there should be some guarantee that sb writeout starts,
> > > > say, within 5 to 10 seconds interval. Deferrable timers do not guarantee
> > > > this. But take a look at the range hrtimers - they do exactly this.
> > > 
> > > If the system is in sleep state, is there any data which should be written?
> > 
> > May be yes, may be no.
> > 
> 
> Thanks for the quick response, Artem. May I know what might need to be
> written out when system is really idle?

system idle != no dirty inodes

Imagine an application dirties 100MB data and quits. The system then
goes quiet for very long time. In this case we still want the flusher
thread to wake up within 30 seconds to flush the 100MB dirty data.
It's a contract that dirty data will be synced to disk after 30s
(which is the default value of /proc/sys/vm/dirty_expire_centisecs).

Note that 30s is not an exact value. A dirty page may be synced to
disk when it's been dirtied for 35s. The 5s error comes from the
flusher wakeup interval (/proc/sys/vm/dirty_writeback_centisecs).

Thanks,
Fengguang
