Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab2LDATW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 19:19:22 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:29405 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2LDATU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 19:19:20 -0500
Message-ID: <1354579848.21585.54.camel@misato.fc.hp.com>
Subject: Re: [RFC PATCH v3 0/3] acpi: Introduce prepare_remove device
 operation
From: Toshi Kani <toshi.kani@hp.com>
To: Hanjun Guo <guohanjun@huawei.com>
Cc: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>,
        linux-acpi@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, rjw@sisk.pl, lenb@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Tang Chen <tangchen@cn.fujitsu.com>,
        Liujiang <jiang.liu@huawei.com>, Huxinwei <huxinwei@huawei.com>
Date: Mon, 03 Dec 2012 17:10:48 -0700
In-Reply-To: <50BC29C6.6050706@huawei.com>
References: <1353693037-21704-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
	   <50B5EFE9.3040206@huawei.com>
	  <1354128096.26955.276.camel@misato.fc.hp.com>
	 <50B6E936.2080308@huawei.com> <1354228028.7776.56.camel@misato.fc.hp.com>
	 <50BC29C6.6050706@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-03 at 12:25 +0800, Hanjun Guo wrote:
> On 2012/11/30 6:27, Toshi Kani wrote:
> > On Thu, 2012-11-29 at 12:48 +0800, Hanjun Guo wrote:
> >> On 2012/11/29 2:41, Toshi Kani wrote:
> >>> On Wed, 2012-11-28 at 19:05 +0800, Hanjun Guo wrote:
> >>>> On 2012/11/24 1:50, Vasilis Liaskovitis wrote:
> >>>> As you may know, the ACPI based hotplug framework we are working on already addressed
> >>>> this problem, and the way we slove this problem is a bit like yours.
> >>>>
> >>>> We introduce hp_ops in struct acpi_device_ops:
> >>>> struct acpi_device_ops {
> >>>> 	acpi_op_add add;
> >>>> 	acpi_op_remove remove;
> >>>> 	acpi_op_start start;
> >>>> 	acpi_op_bind bind;
> >>>> 	acpi_op_unbind unbind;
> >>>> 	acpi_op_notify notify;
> >>>> #ifdef	CONFIG_ACPI_HOTPLUG
> >>>> 	struct acpihp_dev_ops *hp_ops;
> >>>> #endif	/* CONFIG_ACPI_HOTPLUG */
> >>>> };
> >>>>
> >>>> in hp_ops, we divide the prepare_remove into six small steps, that is:
> >>>> 1) pre_release(): optional step to mark device going to be removed/busy
> >>>> 2) release(): reclaim device from running system
> >>>> 3) post_release(): rollback if cancelled by user or error happened
> >>>> 4) pre_unconfigure(): optional step to solve possible dependency issue
> >>>> 5) unconfigure(): remove devices from running system
> >>>> 6) post_unconfigure(): free resources used by devices
> >>>>
> >>>> In this way, we can easily rollback if error happens.
> >>>> How do you think of this solution, any suggestion ? I think we can achieve
> >>>> a better way for sharing ideas. :)
> >>>
> >>> Yes, sharing idea is good. :)  I do not know if we need all 6 steps (I
> >>> have not looked at all your changes yet..), but in my mind, a hot-plug
> >>> operation should be composed with the following 3 phases.
> >>
> >> Good idea ! we also implement a hot-plug operation in 3 phases:
> >> 1) acpihp_drv_pre_execute
> >> 2) acpihp_drv_execute
> >> 3) acpihp_drv_post_execute
> >> you may refer to :
> >> https://lkml.org/lkml/2012/11/4/79
> > 
> > Great.  Yes, I will take a look.
> 
> Thanks, any comments are welcomed :)

If I read the code right, the framework calls ACPI drivers differently
at boot-time and hot-add as follows.  That is, the new entry points are
called at hot-add only, but .add() is called at both cases.  This
requires .add() to work differently.

Boot    : .add()
Hot-Add : .add(), .pre_configure(), configure(), etc.

I think the boot-time and hot-add initialization should be done
consistently.  While there is difficulty with the current boot sequence,
the framework should be designed to allow them consistent, not make them
diverged.

> >>> 1. Validate phase - Verify if the request is a supported operation.  All
> >>> known restrictions are verified at this phase.  For instance, if a
> >>> hot-remove request involves kernel memory, it is failed in this phase.
> >>> Since this phase makes no change, no rollback is necessary to fail. 
> >>
> >> Yes, we have done this in acpihp_drv_pre_execute, and check following things:
> >>
> >> 1) Hot-plugble or not. the instance kernel memory you mentioned is also checked
> >>    when memory device remove;
> > 
> > Agreed.
> > 
> >> 2) Dependency check involved. For instance, if hot-add a memory device,
> >>    processor should be added first, otherwise it's not valid to this operation.
> > 
> > I think FW should be the one that assures such dependency.  That is,
> > when a memory device object is marked as present/enabled/functioning, it
> > should be ready for the OS to use.
> 
> Yes, BIOS should do something for the dependency, because BIOS knows the
> actual hardware topology. 

Right.

> The ACPI specification provides _EDL method to
> tell OS the eject device list, but still has no method to tell OS the add device
> list now.

Yes, but I do not think the OS needs special handling for add...

> For some cases, OS should analyze the dependency in the validate phase. For example,
> when hot remove a node (container device), OS should analyze the dependency to get
> the remove order as following:
> 1) Host bridge;
> 2) Memory devices;
> 3) Processor devices;
> 4) Container device itself;

This may be off-topic, but how do you plan to delete I/O devices under a
node?  Are you planning to delete all I/O devices along with the node?

On other OS, we made a separate step called I/O chassis delete, which
off-lines all I/O devices under the node, and is required before a node
hot-remove.  It basically triggers PCIe hot-remove to detach drivers
from all devices.  It does not eject the devices so that they do not
have to be on hot-plug slots.  This step runs user-space scripts to
verify if the devices can be off-lined without disrupting user's
applications, and provides comprehensive reports if any of them are in
use.  Not sure if Linux's PCI hot-remove has such check, but I thought
I'd mention it. :)

> In this way, we can check that all the devices are hot-plugble or not under the
> container device before execute phase, and further more, we can remove devices
> in order to avoid some crash problems.

Yes, we should check if all the resources under the node can be
off-lined at validate phase.  (note, all the devices do not have to have
_EJ0 if that's what you meant by hot-pluggable.)
 
> >> 3) Race condition check. if the device and its dependent device is in hot-plug
> >>    process, another request will be denied.
> > 
> > I agree that hot-plug operation should be serialized.  I think another
> > request should be either queued or denied based on the caller's intent
> > (i.e. wait-ok or no-wait). 
> > 
> >> No rollback is needed for the above checks.
> > 
> > Great.
> > 
> >>> 2. Execute phase - Perform hot-add / hot-remove operation that can be
> >>> rolled-back in case of error or cancel.
> >>
> >> In this phase, we introduce a state machine for the hot-plugble device,
> >> please refer to:
> >> https://lkml.org/lkml/2012/11/4/79
> >>
> >> I think we have the same idea for the major framework, but the ACPI based
> >> hot-plug framework implement it differently in detail, right ?
> > 
> > Yes, I am surprised with the similarity.  What I described is something
> > we had implemented for other OS.  I am still studying how best we can
> > improve the Linux hotplug code. :)
> 
> Great! your experience is very appreciable for me. I think we can share ideas
> to achieve a better solution for Linux hotplug code. :)

Sounds great.

Thanks,
-Toshi

