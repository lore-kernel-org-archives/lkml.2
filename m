Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab1CUUXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:23:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab1CUUXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:23:49 -0400
Date: Mon, 21 Mar 2011 16:23:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Don't update group weights when on service tree.
Message-ID: <20110321202346.GA9870@redhat.com>
References: <1300374357-30686-1-git-send-email-teravest@google.com>
 <20110321192757.GK2694@redhat.com>
 <AANLkTik9r-5zXQKCHf9+8U9M1-3Y84mv9Aid7GsTaj2R@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik9r-5zXQKCHf9+8U9M1-3Y84mv9Aid7GsTaj2R@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 01:15:33PM -0700, Justin TerAvest wrote:
> On Mon, Mar 21, 2011 at 12:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Mar 17, 2011 at 08:05:57AM -0700, Justin TerAvest wrote:
> >> Version 3 is updated to apply to for-2.6.39/core.
> >>
> >> For version 2, I took Vivek's advice and made sure we update the group
> >> weight from cfq_group_service_tree_add().
> >>
> >> If a weight was updated while a group is on the service tree, the
> >> calculation for the total weight of the service tree can be adjusted
> >> improperly, which either leads to bad service tree weights, or
> >> potentially crashes (if total_weight becomes 0).
> >>
> >> This patch defers updates to the weight until a group is off the service
> >> tree.
> >>
> >> Signed-off-by: Justin TerAvest <teravest@google.com>
> >> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> >> ---
> >>  block/cfq-iosched.c |   53 +++++++++++++++++++++++++++++++++++++++-----------
> >>  1 files changed, 41 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> >> index 89e0d1c..12e380b 100644
> >> --- a/block/cfq-iosched.c
> >> +++ b/block/cfq-iosched.c
> >> @@ -178,6 +178,8 @@ struct cfq_group {
> >>       /* group service_tree key */
> >>       u64 vdisktime;
> >>       unsigned int weight;
> >> +     unsigned int new_weight;
> >> +     bool needs_update;
> >>
> >>       /* number of cfqq currently on this group */
> >>       int nr_cfqq;
> >> @@ -853,7 +855,27 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
> >>  }
> >>
> >>  static void
> >> -cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
> >> +cfq_update_group_weight(struct cfq_group *cfqg)
> >> +{
> >> +     BUG_ON(!RB_EMPTY_NODE(&cfqg->rb_node));
> >> +     if (cfqg->needs_update) {
> >> +             cfqg->weight = cfqg->new_weight;
> >> +             cfqg->needs_update = false;
> >> +     }
> >> +}
> >
> > thinking more about it, looks like this code is still racy. If somebody
> > updates the weights again while we are about to process previous weight
> > change, we might lose the new weight and set needs_update=false. We might
> > have to use xchg() to update cfqg->needs_update.
> 
> I think you're right, Vivek.
> 
> I wish we could just take a lock on blkcg->lock when updating, we
> should expect the weights to be updated that often, right? I'm not
> sure if there's a feasible way to do that, though.
> 

I think taking blkcg->lock while updating cfqg->needs_update in CFQ will
also solve the issue. We should already be holding blkcg->lock in cgroup
updation path.

Do put a comment explaining it well in case you end up taking this path.

Thanks
Vivek

> I'll explore both options, I'd just prefer to not add xchg() code if I
> don't have to, as it requires a bit more thinking.
> 
> Thanks,
> Justin
> 
> 
> >
> > Thanks
> > Vivek
> >
