Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab2IJXHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 19:07:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39365 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab2IJXG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 19:06:58 -0400
Date: Mon, 10 Sep 2012 16:06:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        drbd-dev@lists.linbit.com, Kent Overstreet <koverstreet@google.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [Drbd-dev] FLUSH/FUA documentation & code discrepancy
Message-ID: <20120910230654.GF7677@google.com>
References: <8439412.RChiDciQdh@fat-tyre>
 <20120904224620.GB9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <3029802.oqG0dEY71l@fat-tyre>
 <20120905084915.GF3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120905100724.GA27527@soda.linbit>
 <20120906212952.GP29092@google.com>
 <20120907084221.GD7028@soda.linbit>
 <20120910225442.GE7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910225442.GE7677@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

cc'ing Kent and Vivek.  The original thread is at

  http://thread.gmane.org/gmane.linux.network.drbd.devel/2130

On Mon, Sep 10, 2012 at 03:54:42PM -0700, Tejun Heo wrote:
> > We can possibly work around that by introducing an additional submitter thread,
> > or at least our own list where we queue assembled bios until the lower
> > level device queue drains.
> > 
> > But we'd rather have the elevator see the FLUSH/FUA,
> > and treat them as at least a soft barrier/reorder boundary.
> > 
> > I may be wrong here, but all the necessary bits for this seem to be in
> > place already, if the information would even reach the elevator in one
> > way or other, and not be completely stripped away early.
> > 
> > What would you rather see, the elevator recognizing reorder boundaries?
> > Or additional higher level queueing and extra thread/work queue/whatever?
> > 
> > Both are fine with me, I'm just asking for an opinion.
> 
> First of all, using FLUSH/FUA for such purpose is an error-prone
> abuse.  You're trying to exploit an implementation detail which may
> change at any time.  I think what you want is to be able to specify
> REQ_SOFTBARRIER on bio submission, which shouldn't be too hard but I'm
> still lost why this is necessary.  Can you please explain it a bit
> more?

The problem with exposing REQ_SOFTBARRIER at bio submission is that it
would require block layer not to reorder bios while passing through
stacked adrivers until it reaches a rq-based driver.  I *suspect* this
has been true until now but Kent's pending patch to fix possible
deadlock issue breaks that.

  http://thread.gmane.org/gmane.linux.kernel.bcache.devel/1017/focus=1356250

As for what the resolution should be, urgh... I don't know. :(

Thanks.

-- 
tejun
