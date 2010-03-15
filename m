Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936394Ab0CON4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:56:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936289Ab0CON4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:56:49 -0400
Date: Mon, 15 Mar 2010 09:55:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Manuel Benitez <rickyb@google.com>
Cc: Chad Talbott <ctalbott@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Nauman Rafique <nauman@google.com>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2 V3] io-controller: Add a new interface
	"weight_device" for IO-Controller
Message-ID: <20100315135526.GC21127@redhat.com>
References: <e98e18941003081139v7a84a979mf8fa49f4744060ea@mail.gmail.com> <20100308230905.GB3614@redhat.com> <4B95A9C6.9060504@cn.fujitsu.com> <20100309190340.GD8663@redhat.com> <4B96E8CC.9080803@cn.fujitsu.com> <20100310153032.GB10738@redhat.com> <1786ab031003100938x19e7c054ieba6c34ebd939ad6@mail.gmail.com> <20100310180336.GC10738@redhat.com> <20100310203155.GA3009@redhat.com> <23904f641003111121i15550251v471ccf2446492ef5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <23904f641003111121i15550251v471ccf2446492ef5@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 11:21:50AM -0800, Manuel Benitez wrote:
> On a closely related topic, I've just recently made a change to one of
> my branches that exposes the blkio.time and blkio.sectors information
> for the root cgroup. These stats would not show because the major and
> minor information for the root blkio_croup structures is zero. This
> information is not available at the when the root blkio_cgroup
> structures are instantiated, so they are left without major and minor
> information.
> 
> I have a simple fix that updates the major and minor information for
> the root structures at a later time. It looks something like this:
> 

Hi Ricky,

I think it is a good idea to export stats for root cgroup also. I also had
noticed this problem of major,minor not being available for root group as
at request queue initialization time it is not available. Checking for
blkg.dev being NULL at group creation time is not the cleanest solution
but at the same time can't think of better thing right now.

Can you please write a separate patch to fix it and post to lkml.

Thanks
Vivek

> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index cd79be0..b34c952 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -956,6 +956,11 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *c
>                 return NULL;;
> 
>         cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
> +       if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
> +               sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
> +               cfqg->blkg.dev = MKDEV(major, minor);
> +               goto done;
> +       }
>         if (cfqg || !create)
>                 goto done;
> 
> If folks think that this would be of interest, I can submit a formal
> patch. If someone can suggest a better way to do it that doesn't
> require extensive changes elsewhere, I'm open to working that up as
> well.
> 
> -Ricky
> 
> On Wed, Mar 10, 2010 at 12:31 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Mar 10, 2010 at 01:03:36PM -0500, Vivek Goyal wrote:
> >> On Wed, Mar 10, 2010 at 09:38:35AM -0800, Chad Talbott wrote:
> >> > On Wed, Mar 10, 2010 at 7:30 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > > This still leaves the issue of reaching a gendisk object from request
> >> > > queue. Looking into it.
> >> >
> >> > It looks like we have that pairing way back in blk_register_queue()
> >> > which takes a gendisk.  Is there any reason we don't hold onto the
> >> > gendisk there?  Eyeballing add_disk() and unlink_gendisk() seems to
> >> > confirm that gendisk lifetime spans request_queue.
> >> >
> >>
> >> Yes, looking at the code, it looks like gendisk and request_queue object's
> >> lifetime is same and probably we can store a pointer to gendisk in
> >> request_queue at blk_register_queue() time. And then use this pointer to
> >> retrieve gendisk->disk_name to report stats.
> >>
> >
> > Well, gendisk and request_queue have little different life span. Following
> > seems to be the sequence a block driver follows.
> >
> >        blk_init_queue()
> >        alloc_disk() and add_disk()
> >        device_removed
> >        del_gendisk()
> >        blk_cleanup_queue()
> >
> > So first we cleaup the gendisk structure and later driver calls to cleanup
> > the request queue.
> >
> >> > Nauman and I were also wondering why blkio_group and blkio_policy_node
> >> > store a dev_t, rather than a direct pointer to gendisk.  dev_t seems
> >> > more like a userspace<->kernel interface than an inside-the-kernel
> >> > interface.
> >> >
> >>
> >> blkio_policy_node currently can't store a pointer to gendisk because there
> >> is no mechanism to call back into blkio if device is removed. So if we
> >> implement something so that once device is removed, blkio layer gets a
> >> callback and we cleanup any state/rules associated with that device, then
> >> I think we should be able to store the pointer to gendisk.
> >>
> >> I am still trying to figure out how elevator/ioscheduler state is cleaned
> >> up if a device is removed while some IO is happening to it.
> >>
> >
> > So blk_cleanup_queue() will do this. That means few things.
> >
> > - We can't store pointers to gendisk in blkio_policy_node or blkio_group
> >  because gendisk might have gone away but request queue is still there.
> >  May be one can try saving a pointer and taking a reference, but I guess
> >  that becomes littles complicated.
> >
> > - If we are using disk name for rules and reporting stats, then we also
> >  need to make sure that these rules are cleared from cgroups once device
> >  has disappeared. Otherwise, following might happen.
> >
> >        - Create a rule for sda (x,y) for cgroup test1. x,y are major and
> >          minor numbers.
> >        - sda goes away. Rules still remains in blkio cgroup.
> >        - Another device gets plugged in and i guess following can happen.
> >                - device name is different but dev_t is same as sda.
> >                - device name is same (sda) but device number is
> >                  different.
> >
> >                In both the cases a user will be confused with stale rules
> >                in cgroups.
> >
> >  Cleaning up cgroups rules can get little complicated. I guess we need to
> >  create a function in blkio-cgroup.c to traverse through all the cgroups
> >  and cleanup any blkio_policy_nodes belonging to device going away.
> >
> > In a nutshell, it probably is doable. You are welcome to write a patch. At
> > the same time I am not against deivce major/minor number based interface,
> > because it keeps things little simple.
> >
> > Thanks
> > Vivek
> >
> > -
> >> OTOH, Gui, may be one can use blk_lookup_devt() to lookup the dev_t of a
> >> device using the disk name (sda). I just noticed it while reading the
> >> code.
> >>
> >> Thanks
> >> Vivek
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
