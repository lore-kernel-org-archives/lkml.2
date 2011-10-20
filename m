Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1JTNmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:42:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab1JTNmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:42:03 -0400
Date: Thu, 20 Oct 2011 09:41:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com,
        rni@google.com, containers@lists.linux-foundation.org,
        kay.sievers@vrfy.org
Subject: Re: [PATCH 02/10] block: fix genhd refcounting in
 blkio_policy_parse_and_set()
Message-ID: <20111020134137.GA13685@redhat.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-3-git-send-email-tj@kernel.org>
 <20111019132657.GA1140@redhat.com>
 <20111019162902.GA25124@google.com>
 <20111019165932.GH1140@redhat.com>
 <20111019220553.GQ25124@google.com>
 <20111019220717.GR25124@google.com>
 <20111019235146.GS25124@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019235146.GS25124@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 04:51:46PM -0700, Tejun Heo wrote:
> Hello, again.
> 
> (cc'ing containers list and Kay)
> 
> The original thread is at
> 
>   http://thread.gmane.org/gmane.linux.kernel/1205150/focus=1205160
> 
> and it's about retaining blkiocg rules across device destruction.
> 
> On Wed, Oct 19, 2011 at 03:07:17PM -0700, Tejun Heo wrote:
> > On Wed, Oct 19, 2011 at 03:05:53PM -0700, Tejun Heo wrote:
> > > Hmmm.... I don't know.  If we're gonna bind rule existence to that of
> > 
> > Heh, I meant to say, "if those two are unbound,"
> > 
> > > device, wouldn't it be better to simply not check whether the device
> > > exists?  The current behavior seems pretty confusing to me.
> 
> I've been thinking about it and the more I think about it, the current
> behavior seems just wrong.  Device node # doesn't mean anything before
> a device actually appears there.  There is no way userland can know
> deterministically how the device node allocation would end up.
> 
> For example, sd allocates minors according to internal ida allocation
> which is freed on scsi_disk_release() - ie. when all *kernel*
> references go away which the userland has no way to find out until
> after new device comes up with a different devt.
> 
> For EXT_DEVT devices, this becomes even less meaingful.  There is
> absolutely no guarantee what devno would mean what.  devno which is
> currently assigned to the whole disk now can be reassigned to a
> partition.  There absolutely is no rule regarding who gets what
> numbers.  ie. This can end up with rules pointing to partitions.
> 
> Moreover, it doesn't even make the implementation simpler.  blkiocg
> currently keeps a separate list of policies so that they don't
> disappear along with blkg's.

One reason for keeping rules in blkiocg is that blkg don't get created
until and unless IO happens in that cgroup. Rules can be created much
before that.

> 
> The only way applying rules to dynamic devices can work is doing the
> proper dynamic configuration off udev and friends.

Actually it is not exactly a feature at this point of time. It was just
for the sake of simplicity that I let the rules be there even if device
has gone away and yes it is indeep a shortcoming that if a different
device shows up with old device's major and minor, then old rule will
get applied to new device.

Having said that, removal of rule upon device removal also might not
make much sense.

- Rules are tied to cgroups and not to devices as such. So until cgroup
  goes away a user might be surprised that a configured rule for a device
  suddenly disappeared.

- Though my examples are not exactly similar, but when a device goes away
  we don't try to unmount the filesystem automatically. We don't try to
  get rid of /etc/fstab entries and if somebody as put a /etc/fstab entry
  based on device name, then they might end up mounting wrong device.

So I don't feel strongly to tie rules and device life time together.
Making use of udev and friends to automatically add/remove rules as
devices show up or go will make sense though.

Thanks
Vivek
