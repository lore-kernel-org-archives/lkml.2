Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab2IKIZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 04:25:11 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:50508 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2IKIZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 04:25:05 -0400
Date: Tue, 11 Sep 2012 10:25:01 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: NeilBrown <neilb@suse.de>
Cc: Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Vivek Goyal <vgoyal@redhat.com>,
        drbd-dev@lists.linbit.com
Subject: Re: [Drbd-dev] FLUSH/FUA documentation & code discrepancy
Message-ID: <20120911082501.GH7028@soda.linbit>
Mail-Followup-To: NeilBrown <neilb@suse.de>,
	Kent Overstreet <koverstreet@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Vivek Goyal <vgoyal@redhat.com>,
	drbd-dev@lists.linbit.com
References: <20120904224620.GB9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <3029802.oqG0dEY71l@fat-tyre>
 <20120905084915.GF3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120905100724.GA27527@soda.linbit>
 <20120906212952.GP29092@google.com>
 <20120907084221.GD7028@soda.linbit>
 <20120910225442.GE7677@google.com>
 <20120910230654.GF7677@google.com>
 <20120910233159.GE19739@google.com>
 <20120911155820.74f1f918@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911155820.74f1f918@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 03:58:20PM +1000, NeilBrown wrote:
> On Mon, 10 Sep 2012 16:31:59 -0700 Kent Overstreet <koverstreet@google.com>
> wrote:
> 
> > cc'ing Neil
> > 
> > On Mon, Sep 10, 2012 at 04:06:54PM -0700, Tejun Heo wrote:
> > > Hello, again.
> > > 
> > > cc'ing Kent and Vivek.  The original thread is at
> > > 
> > >   http://thread.gmane.org/gmane.linux.network.drbd.devel/2130
> > > 
> > > On Mon, Sep 10, 2012 at 03:54:42PM -0700, Tejun Heo wrote:
> > > > > We can possibly work around that by introducing an additional submitter thread,
> > > > > or at least our own list where we queue assembled bios until the lower
> > > > > level device queue drains.
> > > > > 
> > > > > But we'd rather have the elevator see the FLUSH/FUA,
> > > > > and treat them as at least a soft barrier/reorder boundary.
> > > > > 
> > > > > I may be wrong here, but all the necessary bits for this seem to be in
> > > > > place already, if the information would even reach the elevator in one
> > > > > way or other, and not be completely stripped away early.
> > > > > 
> > > > > What would you rather see, the elevator recognizing reorder boundaries?
> > > > > Or additional higher level queueing and extra thread/work queue/whatever?
> > > > > 
> > > > > Both are fine with me, I'm just asking for an opinion.
> > > > 
> > > > First of all, using FLUSH/FUA for such purpose is an error-prone
> > > > abuse.  You're trying to exploit an implementation detail which may
> > > > change at any time.  I think what you want is to be able to specify
> > > > REQ_SOFTBARRIER on bio submission, which shouldn't be too hard but I'm
> > > > still lost why this is necessary.  Can you please explain it a bit
> > > > more?
> > > 
> > > The problem with exposing REQ_SOFTBARRIER at bio submission is that it
> > > would require block layer not to reorder bios while passing through
> > > stacked adrivers until it reaches a rq-based driver.  I *suspect* this
> > > has been true until now but Kent's pending patch to fix possible
> > > deadlock issue breaks that.
> > 
> > Yeah, you might be right about that. I think Neil Brown would know
> > better than I if this ordering was ever explicitly broken.
> 
> While don't deliberately re-order bios just for the fun of it, there is no
> real effort to keep the bios "in order" (assuming that even means something
> in a multi-processor environment).  The old barrier code did impose ordering
> but thankfully we don't have that any more.
> 
> RAID5 can certainly re-order write bios as it tries to assemble complete
> stripes.  RAID1/4/5/6/10 can certainly re-order things if there is an error
> that needs to be handled.
> 
> The only way to ensure one request completes before another is to not submit
> the other until the one has completed.

That settles it, then.
Thank you for the clear wording.

Should this be in Documentation/block/writeback_cache_control.txt,
even though I realize that that is about hardware,
and not the stack above it?

Or do we have a better place to document write ordering requirements?

"To enforce write-after-write dependencies, you *have* to drain the
queue (do we have a generic interface available for that?),
or at least wait for the completion of all the requests you
(potentially) depend upon, before even submitting the dependent request.

Additionally, to avoid integrity issues due to volatile caches,
you need to use FLUSH/FUA as appropriate."

(please rephrase as you see fit, no native speaker here ...)


	Lars

