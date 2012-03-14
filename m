Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964872Ab2CNKmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:42:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab2CNKmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:42:13 -0400
Date: Wed, 14 Mar 2012 12:42:03 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
Message-ID: <20120314104203.GT2304@redhat.com>
References: <4F58943E.1050402@redhat.com>
 <4F595B31.9090301@cn.fujitsu.com>
 <4F5DBC26.7060204@cn.fujitsu.com>
 <4F5DD0FD.9070904@redhat.com>
 <20120313091843.GB3800@redhat.com>
 <4F5F25BF.7060100@redhat.com>
 <4F6056FE.3020202@cn.fujitsu.com>
 <20120314095114.GA4136@amit.redhat.com>
 <4F606D38.2070107@cn.fujitsu.com>
 <20120314104004.GE2708@amit.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314104004.GE2708@amit.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 04:10:04PM +0530, Amit Shah wrote:
> On (Wed) 14 Mar 2012 [18:04:40], Wen Congyang wrote:
> > At 03/14/2012 05:51 PM, Amit Shah Wrote:
> > > On (Wed) 14 Mar 2012 [16:29:50], Wen Congyang wrote:
> > >> At 03/13/2012 06:47 PM, Avi Kivity Wrote:
> > >>> On 03/13/2012 11:18 AM, Daniel P. Berrange wrote:
> > >>>> On Mon, Mar 12, 2012 at 12:33:33PM +0200, Avi Kivity wrote:
> > >>>>> On 03/12/2012 11:04 AM, Wen Congyang wrote:
> > >>>>>> Do you have any other comments about this patch?
> > >>>>>>
> > >>>>>
> > >>>>> Not really, but I'm not 100% convinced the patch is worthwhile.  It's
> > >>>>> likely to only be used by Linux, which has kexec facilities, and you can
> > >>>>> put talk to management via virtio-serial and describe the crash in more
> > >>>>> details than a simple hypercall.
> > >>>>
> > >>>> As mentioned before, I don't think virtio-serial is a good fit for this.
> > >>>> We want something that is simple & guaranteed always available. Using
> > >>>> virtio-serial requires significant setup work on both the host and guest.
> > >>>
> > >>> So what?  It needs to be done anyway for the guest agent.
> > >>>
> > >>>> Many management application won't know to make a vioserial device available
> > >>>> to all guests they create. 
> > >>>
> > >>> Then they won't know to deal with the panic event either.
> > >>>
> > >>>> Most administrators won't even configure kexec,
> > >>>> let alone virtio serial on top of it. 
> > >>>
> > >>> It should be done by the OS vendor, not the individual admin.
> > >>>
> > >>>> The hypercall requires zero host
> > >>>> side config, and zero guest side config, which IMHO is what we need for
> > >>>> this feature.
> > >>>
> > >>> If it was this one feature, yes.  But we keep getting more and more
> > >>> features like that and we bloat the hypervisor.  There's a reason we
> > >>> have a host-to-guest channel, we should use it.
> > >>>
> > >>
> > >> I donot know how to use virtio-serial.
> > >>
> > >> I start vm like this:
> > >> qemu ...\
> > >>    -device virtio-serial \
> > >>   -chardev socket,path=/tmp/foo,server,nowait,id=foo \
> > >>   -device virtserialport,chardev=foo,name=port1 ...
> > > 
> > > This is sufficient.  On the host, you can open /tmp/foo using a custom
> > > program or nc (nc -U /tmp/foo).  On the guest, you can just open
> > > /dev/virtio-ports/port1 and read/write into it.
> > 
> > I have two questions:
> > 1. does it OK to open this device when the guest is panicked?
> 
> Depends on what kind of panic it is.  If the guest can continue
> operations inspite of the panic, it will be possible to write out the
> data.
> 
> > 2. how to prevent the userspace's program using this device?
> 
> Mentioned in previous reply.
> 
> BTW: an in-kernel API for reading/writing to ports isn't implemented
> yet, because there's no user for it as of now.  If you want to write
> from the kernel to the host, there are trivial additions to the code
> necessary.
> 
> (However, I think it's better to do the writing from userspace instead
> from the kernel itself).
> 
In case of panic notifier this is out of question.

--
			Gleb.
