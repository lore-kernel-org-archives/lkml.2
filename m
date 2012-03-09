Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab2CIW0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 17:26:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab2CIWZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 17:25:59 -0500
Date: Fri, 9 Mar 2012 19:22:56 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Wen Congyang <wency@cn.fujitsu.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [RESEND][PATCH 2/2 v3] deal with guest panicked event
Message-ID: <20120309222256.GA24975@amt.cnet>
References: <4F58664D.1070800@cn.fujitsu.com>
 <4F5868C4.2090509@cn.fujitsu.com>
 <4F5886C4.7040100@cn.fujitsu.com>
 <4F5897F8.6090503@redhat.com>
 <20120308113607.GC25529@redhat.com>
 <4F589D8D.4030105@redhat.com>
 <20120308115656.GD25529@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308115656.GD25529@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 11:56:56AM +0000, Daniel P. Berrange wrote:
> On Thu, Mar 08, 2012 at 01:52:45PM +0200, Avi Kivity wrote:
> > On 03/08/2012 01:36 PM, Daniel P. Berrange wrote:
> > > On Thu, Mar 08, 2012 at 01:28:56PM +0200, Avi Kivity wrote:
> > > > On 03/08/2012 12:15 PM, Wen Congyang wrote:
> > > > > When the host knows the guest is panicked, it will set
> > > > > exit_reason to KVM_EXIT_GUEST_PANICKED. So if qemu receive
> > > > > this exit_reason, we can send a event to tell management
> > > > > application that the guest is panicked and set the guest
> > > > > status to RUN_STATE_PANICKED.
> > > > >
> > > > > Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> > > > > ---
> > > > >  kvm-all.c        |    5 +++++
> > > > >  monitor.c        |    3 +++
> > > > >  monitor.h        |    1 +
> > > > >  qapi-schema.json |    2 +-
> > > > >  qmp.c            |    3 ++-
> > > > >  vl.c             |    1 +
> > > > >  6 files changed, 13 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/kvm-all.c b/kvm-all.c
> > > > > index 77eadf6..b3c9a83 100644
> > > > > --- a/kvm-all.c
> > > > > +++ b/kvm-all.c
> > > > > @@ -1290,6 +1290,11 @@ int kvm_cpu_exec(CPUState *env)
> > > > >                      (uint64_t)run->hw.hardware_exit_reason);
> > > > >              ret = -1;
> > > > >              break;
> > > > > +        case KVM_EXIT_GUEST_PANICKED:
> > > > > +            monitor_protocol_event(QEVENT_GUEST_PANICKED, NULL);
> > > > > +            vm_stop(RUN_STATE_PANICKED);
> > > > > +            ret = -1;
> > > > > +            break;
> > > > >
> > > > 
> > > > If the management application is not aware of this event, then it will
> > > > never resume the guest, so it will appear hung.
> > >
> > > Even if the mgmt app doesn't know about the QEVENT_GUEST_PANICKED, it should
> > > still see a QEVENT_STOP event emitted by vm_stop() surely ? So it will
> > > know the guest CPUs have been stopped, even if it isn't aware of the
> > > reason why, which seems fine to me.
> > 
> > No.  The guest is stopped, and there's no reason to suppose that the
> > management app will restart it.  Behaviour has changed.
> > 
> > Suppose the guest has reboot_on_panic set; now the behaviour change is
> > even more visible - service will stop completely instead of being
> > interrupted for a bit while the guest reboots.
> 
> Hmm, so this calls for a new command line argument to control behaviour,
> similar to what we do for disk werror, eg something like
> 
>   --onpanic "report|pause|stop|..."
> 
> where
> 
>  report - emit QEVENT_GUEST_PANICKED only

Should be the default.

>  pause  - emit QEVENT_GUEST_PANICKED and pause VM
>  stop   - emit QEVENT_GUEST_PANICKED and quit VM

"quit" is a better name than "stop".

> This would map fairly well into libvirt, where we already have config
> parameters for controlling what todo with a guest when it panics.
> 
> Regards,
> Daniel
