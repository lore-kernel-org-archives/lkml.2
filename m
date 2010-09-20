Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab0ITNDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 09:03:35 -0400
Received: from verein.lst.de ([213.95.11.210]:53162 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206Ab0ITNDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 09:03:34 -0400
Date: Mon, 20 Sep 2010 15:03:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: vgoyal@redhat.com
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Subject: cgq vs bdi names, was "cfq-iosched: fix a kernel OOPs when usb key is inserted"
Message-ID: <20100920130318.GA29565@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek, hi Jens,

where was http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff_plain;h=44c74d6292e97f8bd9adfa6b0df3cb4f3c42a6dc posted  on the mailinglist?

I can't find it in my lkml or fsdevel inboxes.  Either way I don't think
just papering over the underlying issue like this is a good idea.  

The big issue is that cfq tries to scanf the textual representation of
the dev_t from the request_queue by abusing the bdi.  But the reason why
we don't have a dev_t in the request_queue is that it's still not
unique.  If it was we could easily add a dev_t into the request_queue
and be done with it.

So the fix is either to get rid of the last remaining users of shared
request_queues (IIRC the various floppy drivers) and just add a dev_t
in the request_queue for the bdi, tracing and cfq, or add a dev_t into
the request_queue and add a flag for shared request queues that the
floppy driver and whoever needs it set and let the bdi sysfs code, cfq
and blocktrace ignore theis request_queue.  This will also allow to
get rid of the crap about ignoring failures due to already register
or prematurely unregistered bdis and actually add real error handling
to that code.
