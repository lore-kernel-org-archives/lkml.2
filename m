Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab2KTVeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:34:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab2KTVeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:34:21 -0500
Date: Tue, 20 Nov 2012 19:33:49 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Hu Tao <hutao@cn.fujitsu.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Wen Congyang <wency@cn.fujitsu.com>,
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
Message-ID: <20121120213349.GA31355@amt.cnet>
References: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com>
 <20121031011256.GC12325@amt.cnet>
 <50908354.5070608@cn.fujitsu.com>
 <CA+1xoqdcaeAm05_=rx3h9KHph+j7Ab8vRG_w9yUk7jtn+wHuBg@mail.gmail.com>
 <20121106015835.GA11971@localhost.localdomain>
 <CA+1xoqd60YihExEuSU2qzsyFRXLS=XaeeX9AaMLhPHggfM6V3A@mail.gmail.com>
 <20121113021908.GA8176@amt.cnet>
 <20121120100948.GB17311@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120100948.GB17311@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 06:09:48PM +0800, Hu Tao wrote:
> Hi Marcelo,
> 
> On Tue, Nov 13, 2012 at 12:19:08AM -0200, Marcelo Tosatti wrote:
> > On Fri, Nov 09, 2012 at 03:17:39PM -0500, Sasha Levin wrote:
> > > On Mon, Nov 5, 2012 at 8:58 PM, Hu Tao <hutao@cn.fujitsu.com> wrote:
> > > > But in the case of panic notification, more dependency means more
> > > > chances of failure of panic notification. Say, if we use a virtio device
> > > > to do panic notification, then we will fail if: virtio itself has
> > > > problems, virtio for some reason can't be deployed(neither built-in or
> > > > as a module), or guest doesn't support virtio, etc.
> > > 
> > > Add polling to your virtio device. If it didn't notify of a panic but
> > > taking more than 20 sec to answer your poll request you can assume
> > > it's dead.
> > > 
> > > Actually, just use virtio-serial and something in userspace on the guest.
> > 
> > They want the guest to stop, so a memory dump can be taken by management
> > interface.
> > 
> > Hu Tao, lets assume port I/O is the preferred method for communication.
> 
> Okey.
> 
> > Now, the following comments have still not been addressed:
> > 
> > 1) Lifecycle of the stopped guest and interaction with other stopped
> > states in QEMU.
> 
> Patch 3 already deals with run state transitions. But in case I'm
> missing something, could you be more specific?

- What are the possibilities during migration? Say:
	- migration starts.
	- guest panics.
	- migration starts vm on other side?
- Guest stopped due to EIO.
	- guest vcpuN panics, VMEXIT but still outside QEMU.
	- QEMU EIO error, stop vm.
	- guest vcpuN completes, processes IO exit.
        - system_reset due to panic.
- Add all possibilities that should be verified (that is, interaction 
of this feature with other stopped states in QEMU).

---

- What happens if the guest has reboot-on-panic configured? Does it take
precedence over hypervisor notification?



Out of curiosity, does kexec support memory dumping?

> > 2) Format of the interface for other architectures (you can choose
> > a different KVM supported architecture and write an example).
> > 
> > 3) Clear/documented management interface for the feature.
> 
> It is documented in patch 0: Documentation/virtual/kvm/pv_event.txt.
> Does it need to be improved?

This is documentation for the host<->guest interface. There is no 
documentation on the interface for management.
