Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0EaMZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 08:25:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab0EaMZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 08:25:52 -0400
Date: Mon, 31 May 2010 15:20:56 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCHv2-RFC 0/2] virtio: put last seen used index into ring
	itself
Message-ID: <20100531122055.GB1704@redhat.com>
References: <cover.1274903328.git.mst@redhat.com> <201005311716.43573.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005311716.43573.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 05:16:42PM +0930, Rusty Russell wrote:
> On Thu, 27 May 2010 05:20:35 am Michael S. Tsirkin wrote:
> > Here's a rewrite of the original patch with a new layout.
> > I haven't tested it yet so no idea how this performs, but
> > I think this addresses the cache bounce issue raised by Avi.
> > Posting for early flames/comments.
> 
> Sorry, not without some evidence that it'll actually reduce cacheline
> bouncing.  I *think* it will, but it's not obvious: the host may keep
> looking at avail_idx as we're updating last_seen.  Or does qemu always
> look at both together anyway?
> Can someone convince me this is a win?
> Rusty.

What really happens is host looks at flags and last_seen together.
And flags happens to be in the same cache line with avail idx.
So to get an obvious win, we should put flags and last_seen
in a separate cache line from avail, which us easy - just add some padding.

And I'll relax the requirement from guest to only require it to update
last_seen when interrupts are enabled. This way flags and
last_seen are written together and read together.

Makes sense?
-- 
MST
