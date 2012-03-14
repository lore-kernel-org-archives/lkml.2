Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822Ab2CNKwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:52:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab2CNKwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:52:44 -0400
Date: Wed, 14 Mar 2012 12:52:34 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: Amit Shah <amit.shah@redhat.com>, Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
Message-ID: <20120314105234.GV2304@redhat.com>
References: <4F595B31.9090301@cn.fujitsu.com>
 <4F5DBC26.7060204@cn.fujitsu.com>
 <4F5DD0FD.9070904@redhat.com>
 <20120313091843.GB3800@redhat.com>
 <4F5F25BF.7060100@redhat.com>
 <4F6056FE.3020202@cn.fujitsu.com>
 <4F6063C8.8010005@redhat.com>
 <4F606A7C.9090900@cn.fujitsu.com>
 <20120314103755.GD2708@amit.redhat.com>
 <4F607857.50402@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F607857.50402@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 06:52:07PM +0800, Wen Congyang wrote:
> At 03/14/2012 06:37 PM, Amit Shah Wrote:
> > On (Wed) 14 Mar 2012 [17:53:00], Wen Congyang wrote:
> >> At 03/14/2012 05:24 PM, Avi Kivity Wrote:
> >>> On 03/14/2012 10:29 AM, Wen Congyang wrote:
> >>>> At 03/13/2012 06:47 PM, Avi Kivity Wrote:
> >>>>> On 03/13/2012 11:18 AM, Daniel P. Berrange wrote:
> >>>>>> On Mon, Mar 12, 2012 at 12:33:33PM +0200, Avi Kivity wrote:
> >>>>>>> On 03/12/2012 11:04 AM, Wen Congyang wrote:
> >>>>>>>> Do you have any other comments about this patch?
> >>>>>>>>
> >>>>>>>
> >>>>>>> Not really, but I'm not 100% convinced the patch is worthwhile.  It's
> >>>>>>> likely to only be used by Linux, which has kexec facilities, and you can
> >>>>>>> put talk to management via virtio-serial and describe the crash in more
> >>>>>>> details than a simple hypercall.
> >>>>>>
> >>>>>> As mentioned before, I don't think virtio-serial is a good fit for this.
> >>>>>> We want something that is simple & guaranteed always available. Using
> >>>>>> virtio-serial requires significant setup work on both the host and guest.
> >>>>>
> >>>>> So what?  It needs to be done anyway for the guest agent.
> >>>>>
> >>>>>> Many management application won't know to make a vioserial device available
> >>>>>> to all guests they create. 
> >>>>>
> >>>>> Then they won't know to deal with the panic event either.
> >>>>>
> >>>>>> Most administrators won't even configure kexec,
> >>>>>> let alone virtio serial on top of it. 
> >>>>>
> >>>>> It should be done by the OS vendor, not the individual admin.
> >>>>>
> >>>>>> The hypercall requires zero host
> >>>>>> side config, and zero guest side config, which IMHO is what we need for
> >>>>>> this feature.
> >>>>>
> >>>>> If it was this one feature, yes.  But we keep getting more and more
> >>>>> features like that and we bloat the hypervisor.  There's a reason we
> >>>>> have a host-to-guest channel, we should use it.
> >>>>>
> >>>>
> >>>> I donot know how to use virtio-serial.
> >>>
> >>> I don't either, copying Amit.
> >>>
> >>>> I start vm like this:
> >>>> qemu ...\
> >>>>    -device virtio-serial \
> >>>>   -chardev socket,path=/tmp/foo,server,nowait,id=foo \
> >>>>   -device virtserialport,chardev=foo,name=port1 ...
> >>>>
> >>>> You said that there are too many channels. Does it mean /tmp/foo is a channel?
> >>>
> >>> Probably.
> >>
> >> Hmm, if we use virtio-serial, the guest kernel writes something into the channel when
> >> the os is panicked. Is it right?
> > 
> > Depends on how you want to use it.  It could be the kernel, or it
> > could be a userspace program which monitors syslogs for panic
> > information and passes on that info to the virtio-serial channel.
> 
> When the kernel is panicked, we cannot use userspace program.
> 
> > 
> >> If so, is this channel visible to guest userspace? If the channle is visible to guest
> >> userspace, the program running in userspace may write the same message to the channel.
> > 
> > Access control is via permissions.  You can have udev scripts assign
> > whatever uid and gid to the port of your interest.  By default, all
> > ports are only accessible to the root user.
> 
> We should also prevent root user writing message to this channel if it is
> used for panicked notification.
> 
Why? Root user can also call panic hypercall if he wishes so.

--
			Gleb.
