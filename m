Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab2KFCAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 21:00:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:15419 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab2KFCAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 21:00:00 -0500
X-IronPort-AV: E=Sophos;i="4.80,719,1344182400"; 
   d="scan'208";a="6143337"
Date: Tue, 6 Nov 2012 09:58:35 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Subject: Re: [PATCH v11] kvm: notify host when the guest is panicked
Message-ID: <20121106015835.GA11971@localhost.localdomain>
References: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com>
 <20121031011256.GC12325@amt.cnet>
 <50908354.5070608@cn.fujitsu.com>
 <CA+1xoqdcaeAm05_=rx3h9KHph+j7Ab8vRG_w9yUk7jtn+wHuBg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CA+1xoqdcaeAm05_=rx3h9KHph+j7Ab8vRG_w9yUk7jtn+wHuBg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/06 09:57:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/06 09:57:42,
	Serialize complete at 2012/11/06 09:57:42
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 10:30:02PM -0400, Sasha Levin wrote:
> On Tue, Oct 30, 2012 at 9:48 PM, Wen Congyang <wency@cn.fujitsu.com> wrote:
> > At 10/31/2012 09:12 AM, Marcelo Tosatti Wrote:
> >> It has been asked earlier why a simple virtio device is not usable
> >> for this (with no response IIRC).
> >
> > 1. We can't use virtio device when the kernel is booting.
> 
> So the issue here is the small window between the point the guest
> becomes "self aware" and to the point virtio drivers are loaded,
> right?
> 
> I agree that if something happens during that interval, a
> "virtio-notifier" driver won't catch that, but anything beyond that is
> better done with a virtio driver, so how is the generic infrastructure
> added in this patch useful to anything beyond detecting panics in that
> initial interval?

Another point is dependency. To make panic notification more reliable,
we have to reduce its dependency on other parts of kernel as possible as
we can.

> 
> > 2. The virtio's driver can be built as a module, and if it is not loaded
> >    and the kernel is panicked, there is no way to notify the host.
> 
> Even if the suggested virtio-notifier driver is built as a module, it
> would get auto-loaded when the guest is booting, so I'm not sure about
> this point?
> 
> > 3. I/O port is more reliable than virtio device.
> >    If virtio's driver has some bug, and it cause kernel panicked, we can't
> >    use it. The I/O port is more reliable because it only depends on notifier
> >    chain(If we use virtio device, it also depends on notifier chain).
> 
> This is like suggesting that we let KVM emulate virtio-blk on it's
> own, parallel to the virtio implementation, so that even if there's a
> problem with virtio-blk, KVM can emulate a virtio-blk on it's own.

Not the same. On virtio-blk, if we can make use of virtio, why not? If
there is a problem of virtio-blk but caused by virtio itself, just fix
it in virtio.

But in the case of panic notification, more dependency means more
chances of failure of panic notification. Say, if we use a virtio device
to do panic notification, then we will fail if: virtio itself has
problems, virtio for some reason can't be deployed(neither built-in or
as a module), or guest doesn't support virtio, etc.

We choose IO because compared to virtio device, it is not that heavy and
less problematic.

> 
> Furthermore, why stop at virtio? What if the KVM code has a bug and it
> doesn't pass IO properly? Or the x86 code? we still want panic
> notifications if that happens...

Better ideas are welcome.

-- 
Thanks,
Hu Tao
