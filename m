Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965685Ab0GPOQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 10:16:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965654Ab0GPOQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 10:16:49 -0400
Date: Fri, 16 Jul 2010 15:15:49 +0100
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nauman Rafique <nauman@google.com>,
        Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, linux-kernel@vger.kernel.org,
        Ryo Tsuruta <ryov@valinux.co.jp>, taka@valinux.co.jp,
        Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
Message-ID: <20100716141549.GI19587@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <20100709134546.GC3672@redhat.com> <4C37BC1A.20102@ds.jp.nec.com> <AANLkTikECHfrksrk3QnD3X07pmgXdpo5-fv7hDLm2Zxw@mail.gmail.com> <20100710132417.GA2752@redhat.com> <20100712092004.3b27e13e.kamezawa.hiroyu@jp.fujitsu.com> <20100712131805.GA12918@redhat.com> <20100713133636.73367cae.kamezawa.hiroyu@jp.fujitsu.com> <20100714142919.GA31449@redhat.com> <20100715090048.0b0120a0.kamezawa.hiroyu@jp.fujitsu.com> <20100716134353.GA15382@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100716134353.GA15382@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 09:43:53AM -0400, Vivek Goyal wrote:
> On Thu, Jul 15, 2010 at 09:00:48AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Wed, 14 Jul 2010 10:29:19 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > 
> > > > Cgroup's feature as mounting several subsystems at a mount point at once
> > > > is very useful in many case.
> > > 
> > > I agree that it is useful but if some controllers are not supporting
> > > hierarchy, it just adds to more confusion. And later when hierarchy
> > > support comes in, there will be additional issue of keeping this file
> > > "use_hierarchy" like memory controller.
> > > 
> > > So at this point of time , I am not too inclined towards allowing hierarchical
> > > cgroup creation but treating them as flat in CFQ. I think it adds to the
> > > confusion and user space should handle this situation.
> > > 
> > 
> > Hmm. 
> > 
> > Could you fix error code in create blkio cgroup ? It returns -EINVAL now.
> > IIUC, mkdir(2) doesn't return -EINVAL as error code (from man.)
> > Then, it's very confusing. I think -EPERM or -ENOMEM will be much better.
> 
> Hm..., Probably -EPERM is somewhat close to what we are doing. File system
> does supoort creation of directories but not after certain level.
> 
> I will trace more instances of mkdir error values.
> 
> > 
> > Anyway, I need to see source code of blk-cgroup.c to know why libvirt fails
> > to create cgroup.
> 
> [CCing daniel berrange]
> 
> AFAIK, libvirt does not have support for blkio controller yet. Are you 
> trying to introduce that? 
> 
> libvirt creates a direcotry tree. I think /cgroup/libvirt/qemu/kvm-dirs.
> So actual virtual machine directors are 2-3 level below and that would
> explain that if you try to use blkio controller with libvirt, it will fail
> because it will not be able to create directories at that level.

Yes, we use a hierarchy to deal with namespace uniqueness. The
first step is to determine where libvirtd process is placed. This
may be the root cgroup, but it may already be one or more levels
down due to the init system (sysv-init, upstart, systemd etc)
startup policy. Once that's determined we create a 'libvirt' 
cgroup which acts as container for everything run by libvirtd.
At the next level is the driver name (qemu, lxc, uml). This allows
confinement of all guests for a particular driver and gives us
a unique namespace for the next level where we have a directory
per guest. This last level is where libvirt actually sets tunables
normally. The higher levels are for administrator use.

  $ROOT  (where libvirtd process is, not the root mount point)
   |
   +- libvirt
       |
       +- qemu
       |   |
       |   +- guest1
       |   +- guest2
       |   +- guest3
       |   ...
       |
       +- lxc
           +- guest1
           +- guest2
           +- guest3
           ...


> I think libvirt need to special case blkio here to create directories in 
> top level. It is odd but really there are no easy answeres. Will we not
> support a controller in libvirt till controller support hierarchy.

We explicitly avoided creating anything at the top level. We always
detect where the libvirtd process has been placed & only ever create
stuff below that point. This ensures the host admin can set overall
limits for virt on a host, and not have libvirt side-step these limits
by jumping back upto the root cgroup.

> > Where is the user-visible information (in RHEL or Fedora)
> > about "you can't use blkio-cgroup via libvirt or libcgroup" ?
> 
> [CCing balbir]
> 
> I think with libcgroup you can use blkio controller. I know somebody
> who was using cgexec command to launch some jobs in blkio cgroups. AFAIK,
> libcgroup does not have too much controller specific state and should
> not require any modifications for blkio controller. 
> 
> Balbir can tell us more.
> 
> libvirt will require modification to support blkio controller. I also 
> noticed that libvirt by default puts every virtual machine into its
> own cgroup. I think it might not be a very good strategy for blkio
> controller because putting every virtual machine in its own cgroup
> will kill overall throughput if each virtual machine is not driving
> enough IO.

A requirement todo everything in the top level and not use a hiearchy
for blkio makes this a pretty unfriendly controller to use. It seriously
limits flexibility of what libvirt and host administrators can do and
means we can't effectively split poilicy between them. It also means
that if the blkio contorller were ever mounted at same point as another
controller, you'd loose the hierarchy support for that other controller
IMHO use of the cgroups hiearchy is key to making cgroups managable for
applications. We can't have many different applications on a system
all having to create many directories at the top level.

> I am also trying to come up with some additional logic of letting go 
> fairness if a group is not doing sufficient IO.
> 
> Daniel, do you know where is the documentation which says what controllers
> are currently supported by libvirt.

We use cpu, cpuacct, cpuset, memory, devices & freezer currently. 

Daniel
-- 
|: Red Hat, Engineering, London    -o-   http://people.redhat.com/berrange/ :|
|: http://libvirt.org -o- http://virt-manager.org -o- http://deltacloud.org :|
|: http://autobuild.org        -o-         http://search.cpan.org/~danberr/ :|
|: GnuPG: 7D3B9505  -o-   F3C9 553F A1DA 4AC2 5648 23C1 B3DF F742 7D3B 9505 :|
