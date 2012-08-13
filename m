Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab2HMUZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:25:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010Ab2HMUZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:25:48 -0400
Date: Mon, 13 Aug 2012 17:24:52 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Eric Blake <eblake@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, Gleb Natapov <gleb@redhat.com>,
        kvm list <kvm@vger.kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Qemu-devel] [PATCH v8] kvm: notify host when the guest is
 panicked
Message-ID: <20120813202452.GA10321@amt.cnet>
References: <5021D235.4050800@cn.fujitsu.com>
 <20120813182132.GB25268@amt.cnet>
 <50295A17.8010404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50295A17.8010404@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 01:48:39PM -0600, Eric Blake wrote:
> On 08/13/2012 12:21 PM, Marcelo Tosatti wrote:
> > On Wed, Aug 08, 2012 at 10:43:01AM +0800, Wen Congyang wrote:
> >> We can know the guest is panicked when the guest runs on xen.
> >> But we do not have such feature on kvm.
> >>
> >> Another purpose of this feature is: management app(for example:
> >> libvirt) can do auto dump when the guest is panicked. If management
> >> app does not do auto dump, the guest's user can do dump by hand if
> >> he sees the guest is panicked.
> >>
> >> We have three solutions to implement this feature:
> >> 1. use vmcall
> >> 2. use I/O port
> >> 3. use virtio-serial.
> >>
> >> We have decided to avoid touching hypervisor. The reason why I choose
> >> choose the I/O port is:
> >> 1. it is easier to implememt
> >> 2. it does not depend any virtual device
> >> 3. it can work when starting the kernel
> > 
> > How about searching for the "Kernel panic - not syncing" string 
> > in the guests serial output? Say libvirtd could take an action upon
> > that?
> > 
> > Advantages:
> > - It works for all architectures.
> > - It does not depend on any virtual device.
> 
> But it _does_ depend on a serial console,

Which already exists and is supported.

>  and furthermore requires
> libvirt to tee the serial console (right now, libvirt can treat the
> console as an opaque pass-through to the end user, but if you expect
> libvirt to parse the serial console for a particular string, you've lost
> some efficiency).
> 
> > - It works as early as serial console output does (panics before
> > that should be rare).
> > - It allows you to see why the guest panicked.
> 
> I think your arguments for a serial console have already been made and
> refuted in earlier versions of this patch series, which is WHY this
> series is still applicable.

Refuted why, exactly? Efficiency to parse serial console output in
libvirt should not be a major issue surely?

Either way:

The device should be arch independent, as "panic" is not specific 
to a particular architecture. For example virtio which would also work
on S390.

Custom IO port == virtual device, so that depends on virtual
device already.

