Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1JSXvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:51:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42566 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1JSXvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:51:52 -0400
Date: Wed, 19 Oct 2011 16:51:46 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com,
        rni@google.com, containers@lists.linux-foundation.org,
        kay.sievers@vrfy.org
Subject: Re: [PATCH 02/10] block: fix genhd refcounting in
 blkio_policy_parse_and_set()
Message-ID: <20111019235146.GS25124@google.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-3-git-send-email-tj@kernel.org>
 <20111019132657.GA1140@redhat.com>
 <20111019162902.GA25124@google.com>
 <20111019165932.GH1140@redhat.com>
 <20111019220553.GQ25124@google.com>
 <20111019220717.GR25124@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019220717.GR25124@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

(cc'ing containers list and Kay)

The original thread is at

  http://thread.gmane.org/gmane.linux.kernel/1205150/focus=1205160

and it's about retaining blkiocg rules across device destruction.

On Wed, Oct 19, 2011 at 03:07:17PM -0700, Tejun Heo wrote:
> On Wed, Oct 19, 2011 at 03:05:53PM -0700, Tejun Heo wrote:
> > Hmmm.... I don't know.  If we're gonna bind rule existence to that of
> 
> Heh, I meant to say, "if those two are unbound,"
> 
> > device, wouldn't it be better to simply not check whether the device
> > exists?  The current behavior seems pretty confusing to me.

I've been thinking about it and the more I think about it, the current
behavior seems just wrong.  Device node # doesn't mean anything before
a device actually appears there.  There is no way userland can know
deterministically how the device node allocation would end up.

For example, sd allocates minors according to internal ida allocation
which is freed on scsi_disk_release() - ie. when all *kernel*
references go away which the userland has no way to find out until
after new device comes up with a different devt.

For EXT_DEVT devices, this becomes even less meaingful.  There is
absolutely no guarantee what devno would mean what.  devno which is
currently assigned to the whole disk now can be reassigned to a
partition.  There absolutely is no rule regarding who gets what
numbers.  ie. This can end up with rules pointing to partitions.

Moreover, it doesn't even make the implementation simpler.  blkiocg
currently keeps a separate list of policies so that they don't
disappear along with blkg's.

The only way applying rules to dynamic devices can work is doing the
proper dynamic configuration off udev and friends.

Can we *please* get rid of this misfeature?

Thank you.

-- 
tejun
