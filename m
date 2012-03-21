Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964815Ab2CUJLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:11:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756979Ab2CUJLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:11:39 -0400
Date: Wed, 21 Mar 2012 11:11:27 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
Message-ID: <20120321091127.GO22368@redhat.com>
References: <4F58664D.1070800@cn.fujitsu.com>
 <4F66E14F.3040809@cn.fujitsu.com>
 <4F6854F4.3060703@cn.fujitsu.com>
 <20120320154517.GG27928@redhat.com>
 <4F692723.8050904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F692723.8050904@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 08:56:03AM +0800, Wen Congyang wrote:
> At 03/20/2012 11:45 PM, Gleb Natapov Wrote:
> > On Tue, Mar 20, 2012 at 05:59:16PM +0800, Wen Congyang wrote:
> >> At 03/19/2012 03:33 PM, Wen Congyang Wrote:
> >>> At 03/08/2012 03:57 PM, Wen Congyang Wrote:
> >>>> We can know the guest is paniced when the guest runs on xen.
> >>>> But we do not have such feature on kvm.
> >>>>
> >>>> Another purpose of this feature is: management app(for example:
> >>>> libvirt) can do auto dump when the guest is crashed. If management
> >>>> app does not do auto dump, the guest's user can do dump by hand if
> >>>> he sees the guest is paniced.
> >>>>
> >>>> I touch the hypervisor instead of using virtio-serial, because
> >>>> 1. it is simple
> >>>> 2. the virtio-serial is an optional device, and the guest may
> >>>>    not have such device.
> >>>>
> >>>> Changes from v2 to v3:
> >>>> 1. correct spelling
> >>>>
> >>>> Changes from v1 to v2:
> >>>> 1. split up host and guest-side changes
> >>>> 2. introduce new request flag to avoid changing return values.
> >>>> --
> >>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >>>> the body of a message to majordomo@vger.kernel.org
> >>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>> Please read the FAQ at  http://www.tux.org/lkml/
> >>>>
> >>>
> >>>
> >>> Hi all:
> >>>
> >>> we neet this feature, but we don't decide how to implement it.
> >>> We have two solution:
> >>> 1. use vmcall
> >>> 2. use virtio-serial.
> >>>
> >>> I will not change this patch set before we decide how to do it.
> >>> Can we make a decision recent days?
> >>
> >> Anybody can decide which solution to use?
> >>
> > To make an informed decision we need to have at least raw idea how
> > virtio-serial variant will look.
> 
> Hmm, I think we can do this:
> 1. reset the virtio-serial device or reset the port we use to notice
>    the host that guest is panicked.
> 2. write some specific messages to the port
> 
> So the port should have fixed name. If this port is opened by the userspace
> before the guest is paniced, I am not sure whether we can use it(because a
> port only can be opened once at the same time).
Yes, IMO we should dedicate one virtio-serial port for panic
notifications. Just like we dedicate one for a console.

> We cannot call any function in the module, so we may need to write a simple
> driver for virtio-serial(like diskdump's disk driver).
> 
netconsole uses standard NIC drivers in polling mode to send OOPSes
over the network and it mostly works. So I think using virtio-serial
driver is not out of question, but with IRQ disabled of course.

> I donot know how to implement it now. But I guess that it may be complicated.
> 
Look at drivers/char/ipmi/ipmi_msghandler.c. It has code to send panic
event over IMPI. The code is pretty complex. Of course if we a going to
implement something more complex than simple hypercall for panic
notification we better do something more interesting with it than just
saying "panic happened", like sending stack traces on all cpus for
instance.

--
			Gleb.
