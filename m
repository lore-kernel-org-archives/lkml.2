Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab1JTRrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 13:47:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756126Ab1JTRrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 13:47:41 -0400
Date: Thu, 20 Oct 2011 13:47:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com,
        rni@google.com, containers@lists.linux-foundation.org,
        kay.sievers@vrfy.org
Subject: Re: [PATCH 02/10] block: fix genhd refcounting in
 blkio_policy_parse_and_set()
Message-ID: <20111020174714.GC13685@redhat.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-3-git-send-email-tj@kernel.org>
 <20111019132657.GA1140@redhat.com>
 <20111019162902.GA25124@google.com>
 <20111019165932.GH1140@redhat.com>
 <20111019220553.GQ25124@google.com>
 <20111019220717.GR25124@google.com>
 <20111019235146.GS25124@google.com>
 <20111020134137.GA13685@redhat.com>
 <20111020161123.GW25124@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020161123.GW25124@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 09:11:23AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, Oct 20, 2011 at 09:41:37AM -0400, Vivek Goyal wrote:
> > > Moreover, it doesn't even make the implementation simpler.  blkiocg
> > > currently keeps a separate list of policies so that they don't
> > > disappear along with blkg's.
> > 
> > One reason for keeping rules in blkiocg is that blkg don't get created
> > until and unless IO happens in that cgroup. Rules can be created much
> > before that.
> 
> Yeah, I'd like to change that.  I suppose it's result of evolution but
> it's not like rule addition is hot path or currently doesn't lookup
> bdev anyway.

Some rules like blkio.weight you still have to keep in blkiocg as they
are for all the devices in the system. So in future more devices come
in these will inherit that weight and CFQ will make use of it.

There are some device dependent rules which you shall have to keep in 
blkiocg. For example, per device weights. If you keep them in blkg, you
will lose them once IO scheduler is changed from CFQ to deadline. If
later a user puts CFQ back, they shouldn't have to configure everything
again.

I think the only rules you can easily move into blkg is per device
throttling rules. 

If the only thing you are looking for is removal of rules upon device
deletion, then it does not harm keeping the rules in blkiocg. May be
during blk_throtl_exit() we can just call into associated blkiocg and
get rid of any rule associated with the device (both throttling and
proportional weight rule).

> 
> > > The only way applying rules to dynamic devices can work is doing the
> > > proper dynamic configuration off udev and friends.
> > 
> > Actually it is not exactly a feature at this point of time. It was just
> > for the sake of simplicity that I let the rules be there even if device
> > has gone away and yes it is indeep a shortcoming that if a different
> > device shows up with old device's major and minor, then old rule will
> > get applied to new device.
> > 
> > Having said that, removal of rule upon device removal also might not
> > make much sense.
> > 
> > - Rules are tied to cgroups and not to devices as such. So until cgroup
> >   goes away a user might be surprised that a configured rule for a device
> >   suddenly disappeared.
> 
> Rules are tied to their group-device pair and removal of either part
> should remove the rule.  I mean, you're looking up and rejecting
> creation of new rules if the device isn't there.
> 
> > - Though my examples are not exactly similar, but when a device goes away
> >   we don't try to unmount the filesystem automatically. We don't try to
> >   get rid of /etc/fstab entries and if somebody as put a /etc/fstab entry
> >   based on device name, then they might end up mounting wrong device.
> 
> That is different because the device node the filesystem holds onto is
> decommissioned and essentially put into zombie state for residual
> reference draining.  It is NEVER re-used for any other purpose.  If we
> need that type of ref draining, sure, we can do it, but there is no
> reason to do that for rules at all.
> 
> > So I don't feel strongly to tie rules and device life time together.
> > Making use of udev and friends to automatically add/remove rules as
> > devices show up or go will make sense though.
> 
> I think this is essentially a bug.  If you have something like "dev =
> find_and_get(); put(dev); return dev != NULL;", it's a pretty good
> indication something is pretty screwed there, so unless someone
> screams really loud, I think I'm gonna push for removal of the
> feature.

So you just want device dependent rules to disappear as soon as device
goes away? I am fine with that.

Thanks
Vivek
