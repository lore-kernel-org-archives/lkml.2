Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab2CVHbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 03:31:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab2CVHbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 03:31:24 -0400
Date: Thu, 22 Mar 2012 09:31:11 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        minyard@acm.org, Jan Kiszka <jan.kiszka@siemens.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Corey Minyard <tcminyard@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Qemu-devel] [PATCH 0/2 v3] kvm: notify host when guest panicked
Message-ID: <20120322073111.GY22368@redhat.com>
References: <4F58664D.1070800@cn.fujitsu.com>
 <4F66E14F.3040809@cn.fujitsu.com>
 <4F6854F4.3060703@cn.fujitsu.com>
 <20120320154517.GG27928@redhat.com>
 <4F692723.8050904@cn.fujitsu.com>
 <20120321091127.GO22368@redhat.com>
 <4F69FF48.3010200@acm.org>
 <4F6A00EC.3060706@redhat.com>
 <4F6A29C6.2070708@redhat.com>
 <4F6A7AC8.5080604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6A7AC8.5080604@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 09:05:12AM +0800, Wen Congyang wrote:
> At 03/22/2012 03:19 AM, Anthony Liguori Wrote:
> > On 03/21/2012 11:25 AM, Avi Kivity wrote:
> >> On 03/21/2012 06:18 PM, Corey Minyard wrote:
> >>>
> >>>> Look at drivers/char/ipmi/ipmi_msghandler.c. It has code to send panic
> >>>> event over IMPI. The code is pretty complex. Of course if we a going to
> >>>> implement something more complex than simple hypercall for panic
> >>>> notification we better do something more interesting with it than just
> >>>> saying "panic happened", like sending stack traces on all cpus for
> >>>> instance.
> >>>
> >>> I doubt that's the best example, unfortunately.  The IPMI event log
> >>> has limited space and it has to be send a little piece at a time since
> >>> each log entry is 14 bytes.  It just prints the panic string, nothing
> >>> else.  Not that it isn't useful, it has saved my butt before.
> >>>
> >>> You have lots of interesting options with paravirtualization.  You
> >>> could, for instance, create a console driver that delivered all
> >>> console output efficiently through a hypercall.  That would be really
> >>> easy.  Or, as you mention, a custom way to deliver panic information.
> >>> Collecting information like stack traces would be harder to
> >>> accomplish, as I don't think there is currently a way to get it except
> >>> by sending it to printk.
> >>
> >> That already exists; virtio-console (or serial console emulation) can do
> >> the job.
> > 
> > I think the use case here is pretty straight forward: if the guest finds
> > itself in bad place, it wants to indicate that to the host.
> > 
> > We shouldn't rely on any device drivers or complex code.  It should be
> > as close to a single instruction as possible that can run even if
> > interrupts are disabled.
> > 
> > An out instruction fits this very well.  I think a simple protocol like:
> 
> This solution is more simple than using virtio-serial.
> 
> > 
> > inl PORT -> returns a magic number indicating the presence of qemucalls
> 
> I donot understantd this instruction's purpose.
> 
> > inl PORT+1 -> returns a bitmap of supported features
> 
> Hmm, we can execute this instruction when guest starts. If the userspace
> does not process panicked event, there is no need to notify it.
> 
> > 
> > outl PORT+1 -> data reg1
> > outl PORT+2 -> data reg2
> > outl PORT+N -> data regN
> 
> We can get the register value from vmcs. So there is no need to tell
> the register value to the host.
> 
No device should examine register value. Ideally QEMU would read
registers only during migration.

> If we decide to avoid touching hypervisor, I agree with this solution.
> 
> Thanks
> Wen Congyang
> > 
> > outl PORT -> qemucall of index value with arguments 1..N
> > 
> > Regards,
> > 
> > Anthony Liguori
> > 
> >>
> >> In fact the feature can be implemented 100% host side by searching for a
> >> panic string signature in the console logs.
> >>
> > 
> > -- 
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 

--
			Gleb.
