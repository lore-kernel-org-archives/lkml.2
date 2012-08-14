Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2HNPuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:50:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623Ab2HNPus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:50:48 -0400
Date: Tue, 14 Aug 2012 18:50:39 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Eric Blake <eblake@redhat.com>, Wen Congyang <wency@cn.fujitsu.com>,
        kvm list <kvm@vger.kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Qemu-devel] [PATCH v8] kvm: notify host when the guest is
 panicked
Message-ID: <20120814155039.GR11194@redhat.com>
References: <5021D235.4050800@cn.fujitsu.com>
 <20120813182132.GB25268@amt.cnet>
 <50295A17.8010404@redhat.com>
 <20120813202452.GA10321@amt.cnet>
 <20120814074748.GE11194@redhat.com>
 <20120814152938.GC14582@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814152938.GC14582@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 12:29:38PM -0300, Marcelo Tosatti wrote:
> On Tue, Aug 14, 2012 at 10:47:48AM +0300, Gleb Natapov wrote:
> > On Mon, Aug 13, 2012 at 05:24:52PM -0300, Marcelo Tosatti wrote:
> > > On Mon, Aug 13, 2012 at 01:48:39PM -0600, Eric Blake wrote:
> > > > On 08/13/2012 12:21 PM, Marcelo Tosatti wrote:
> > > > > On Wed, Aug 08, 2012 at 10:43:01AM +0800, Wen Congyang wrote:
> > > > >> We can know the guest is panicked when the guest runs on xen.
> > > > >> But we do not have such feature on kvm.
> > > > >>
> > > > >> Another purpose of this feature is: management app(for example:
> > > > >> libvirt) can do auto dump when the guest is panicked. If management
> > > > >> app does not do auto dump, the guest's user can do dump by hand if
> > > > >> he sees the guest is panicked.
> > > > >>
> > > > >> We have three solutions to implement this feature:
> > > > >> 1. use vmcall
> > > > >> 2. use I/O port
> > > > >> 3. use virtio-serial.
> > > > >>
> > > > >> We have decided to avoid touching hypervisor. The reason why I choose
> > > > >> choose the I/O port is:
> > > > >> 1. it is easier to implememt
> > > > >> 2. it does not depend any virtual device
> > > > >> 3. it can work when starting the kernel
> > > > > 
> > > > > How about searching for the "Kernel panic - not syncing" string 
> > > > > in the guests serial output? Say libvirtd could take an action upon
> > > > > that?
> > > > > 
> > > > > Advantages:
> > > > > - It works for all architectures.
> > > > > - It does not depend on any virtual device.
> > > > 
> > > > But it _does_ depend on a serial console,
> > > 
> > > Which already exists and is supported.
> > > 
> > > >  and furthermore requires
> > > > libvirt to tee the serial console (right now, libvirt can treat the
> > > > console as an opaque pass-through to the end user, but if you expect
> > > > libvirt to parse the serial console for a particular string, you've lost
> > > > some efficiency).
> > > > 
> > > > > - It works as early as serial console output does (panics before
> > > > > that should be rare).
> > > > > - It allows you to see why the guest panicked.
> > > > 
> > > > I think your arguments for a serial console have already been made and
> > > > refuted in earlier versions of this patch series, which is WHY this
> > > > series is still applicable.
> > > 
> > > Refuted why, exactly? Efficiency to parse serial console output in
> > > libvirt should not be a major issue surely?
> > > 
> > It is not zero config (guests do not send console output to serial by
> > default). If vm users want to use serial for its working console panic
> > notification will trigger every time user examines dmesg with "Kernel
> > panic - not syncing" in it.
> 
> Ok, then it would have to be a dedicated serial console which starts
> to become funny.
> 
We do have support for many virtio-serial channels.

> Use a simple virtio device, then, it starts early enough (or can be made
> to) during kernel init for most relevant production panics, and works
> for all architectures.
The only downside of using dedicated virtio-serial channel that I can
see is that to catch early panic all of the virtio should be compiled
in.

--
			Gleb.
