Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab0G0OEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 10:04:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab0G0OEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 10:04:39 -0400
Date: Tue, 27 Jul 2010 10:03:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Daniel P. Berrange" <berrange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nauman Rafique <nauman@google.com>,
        Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, linux-kernel@vger.kernel.org,
        Ryo Tsuruta <ryov@valinux.co.jp>, taka@valinux.co.jp,
        Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
Message-ID: <20100727140345.GC7347@redhat.com>
References: <20100712131805.GA12918@redhat.com>
 <20100713133636.73367cae.kamezawa.hiroyu@jp.fujitsu.com>
 <20100714142919.GA31449@redhat.com>
 <20100715090048.0b0120a0.kamezawa.hiroyu@jp.fujitsu.com>
 <20100716134353.GA15382@redhat.com>
 <20100716141549.GI19587@redhat.com>
 <20100716143536.GE15382@redhat.com>
 <20100716145309.GJ19587@redhat.com>
 <20100716151234.GG15382@redhat.com>
 <20100727104037.GA22347@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727104037.GA22347@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 11:40:37AM +0100, Daniel P. Berrange wrote:
> On Fri, Jul 16, 2010 at 11:12:34AM -0400, Vivek Goyal wrote:
> > On Fri, Jul 16, 2010 at 03:53:09PM +0100, Daniel P. Berrange wrote:
> > > On Fri, Jul 16, 2010 at 10:35:36AM -0400, Vivek Goyal wrote:
> > > > On Fri, Jul 16, 2010 at 03:15:49PM +0100, Daniel P. Berrange wrote:
> > > > Secondly, just because some controller allows creation of hierarchy does
> > > > not mean that hierarchy is being enforced. For example, memory controller.
> > > > IIUC, one needs to explicitly set "use_hierarchy" to enforce hierarchy
> > > > otherwise effectively it is flat. So if libvirt is creating groups and
> > > > putting machines in child groups thinking that we are not interfering
> > > > with admin's policy, is not entirely correct.
> > > 
> > > That is true, but that 'use_hierarchy' at least provides admins
> > > the mechanism required to implement the neccessary policy
> > > 
> > > > So how do we make progress here. I really want to see blkio controller
> > > > integrated with libvirt.
> > > > 
> > > > About the issue of hierarchy, I can probably travel down the path of allowing
> > > > creation of hierarchy but CFQ will treat it as flat. Though I don't like it
> > > > because it will force me to introduce variables like "use_hierarchy" once
> > > > real hierarchical support comes in but I guess I can live with that.
> > > > (Anyway memory controller is already doing it.).
> > > > 
> > > > There is another issue though and that is by default every virtual
> > > > machine going into a group of its own. As of today, it can have
> > > > severe performance penalties (depending on workload) if group is not
> > > > driving doing enough IO. (Especially with group_isolation=1).
> > > > 
> > > > I was thinking of a model where an admin moves out the bad virtual
> > > > machines in separate group and limit their IO.
> > > 
> > > In the simple / normal case I imagine all guests VMs will be running
> > > unrestricted I/O initially. Thus instead of creating the cgroup at time
> > > of VM startup, we could create the cgroup only when the admin actually
> > > sets an I/O limit.
> > 
> > That makes sense. Run all the virtual machines by default in root group
> > and move out a virtual machine to a separate group of either low weight
> > (if virtual machine is a bad one and driving lot of IO) or of higher weight
> > (if we want to give more IO bw to this machine).
> > 
> > > IIUC, this should maintain the one cgroup per guest
> > > model, while avoiding the performance penalty in normal use. The caveat
> > > of course is that this would require blkio controller to have a dedicated
> > > mount point, not shared with other controller.
> > 
> > Yes. Because for other controllers we seem to be putting virtual machines
> > in separate cgroups by default at startup time. So it seems we will
> > require a separate mount point here for blkio controller.
> > 
> > >  I think we might also
> > > want this kind of model for net I/O, since we probably don't want to 
> > > creating TC classes + net_cls groups for every VM the moment it starts
> > > unless the admin has actually set a net I/O limit.
> > 
> > Looks like. So good, then network controller and blkio controller can
> > share the this new mount point. 
> 
> After thinking about this some more there are a couple of problems with
> this plan. For QEMU the 'vhostnet' (the in kernel virtio network backend)
> requires that QEMU be in the cgroup at time of startup, otherwise the
> vhost kernel thread won't end up in the right cgroup.

Not sure why this limitation is there in vhostnet.

> For libvirt's LXC
> container driver, moving the container in & out of the cgroups at runtime
> is pretty difficult because there are an arbitrary number of processes
> running in the container.

So once a container is created, we don't have the capability to move
it around cgroups? One needs to shutdown the container and relaunch it
in desired container.

> It would require moving all the container
> processes between two cgroups in a race free manner. So on second thoughts
> I'm more inclined to stick with our current approach of putting all guests
> into the appropriate cgroups at guest/container startup, even for blkio
> and netcls. 

In the current code form, it is a bad idea from "blkio" perspective. Very
often, a virtual machine might not be driving enough IO and we will see
overall decreased throughput. That's why I was preferring to move out
the virtual machine out of cgroup only if required.

I was also thinking of implementing a new tunable in CFQ, something like
"min_queue_depth". It would mean that don't idle on groups if we are not
driving a min_queue_depth. Higher the "min_queue_depth", lower the isolation
between groups. But this will take effect only if slice_idle=0 and that
would be done only on higher end storage.

IOW, I am experimenting with above bits, but I certainly would not
recommend putting virtual machines/containers in their own blkio cgroup
by default. 

How about not comounting blkio and net_cls. So for network, you can
continue to put virtual machine in a cgroup of its own and that should
take care of vhostnet issue. For blkio, we will continue to put virtual
machines in common root group.

For container driver issue, we need to figure out how to move around
containers in cgroups. Not sure how hard that is though.

Thanks
Vivek
