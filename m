Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030759Ab2CNK5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:57:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653Ab2CNK51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:57:27 -0400
Date: Wed, 14 Mar 2012 10:57:16 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
Message-ID: <20120314105716.GA2315@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <4F58664D.1070800@cn.fujitsu.com>
 <4F58943E.1050402@redhat.com>
 <4F595B31.9090301@cn.fujitsu.com>
 <4F5DBC26.7060204@cn.fujitsu.com>
 <4F5DD0FD.9070904@redhat.com>
 <20120313091843.GB3800@redhat.com>
 <4F5F25BF.7060100@redhat.com>
 <4F6056FE.3020202@cn.fujitsu.com>
 <20120314095114.GA4136@amit.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120314095114.GA4136@amit.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 03:21:14PM +0530, Amit Shah wrote:
> On (Wed) 14 Mar 2012 [16:29:50], Wen Congyang wrote:
> > At 03/13/2012 06:47 PM, Avi Kivity Wrote:
> > > On 03/13/2012 11:18 AM, Daniel P. Berrange wrote:
> > >> On Mon, Mar 12, 2012 at 12:33:33PM +0200, Avi Kivity wrote:
> > >>> On 03/12/2012 11:04 AM, Wen Congyang wrote:
> > >>>> Do you have any other comments about this patch?
> > >>>>
> > >>>
> > >>> Not really, but I'm not 100% convinced the patch is worthwhile.  It's
> > >>> likely to only be used by Linux, which has kexec facilities, and you can
> > >>> put talk to management via virtio-serial and describe the crash in more
> > >>> details than a simple hypercall.
> > >>
> > >> As mentioned before, I don't think virtio-serial is a good fit for this.
> > >> We want something that is simple & guaranteed always available. Using
> > >> virtio-serial requires significant setup work on both the host and guest.
> > > 
> > > So what?  It needs to be done anyway for the guest agent.
> > > 
> > >> Many management application won't know to make a vioserial device available
> > >> to all guests they create. 
> > > 
> > > Then they won't know to deal with the panic event either.
> > > 
> > >> Most administrators won't even configure kexec,
> > >> let alone virtio serial on top of it. 
> > > 
> > > It should be done by the OS vendor, not the individual admin.
> > > 
> > >> The hypercall requires zero host
> > >> side config, and zero guest side config, which IMHO is what we need for
> > >> this feature.
> > > 
> > > If it was this one feature, yes.  But we keep getting more and more
> > > features like that and we bloat the hypervisor.  There's a reason we
> > > have a host-to-guest channel, we should use it.
> > > 
> > 
> > I donot know how to use virtio-serial.
> > 
> > I start vm like this:
> > qemu ...\
> >    -device virtio-serial \
> >   -chardev socket,path=/tmp/foo,server,nowait,id=foo \
> >   -device virtserialport,chardev=foo,name=port1 ...
> 
> This is sufficient.  On the host, you can open /tmp/foo using a custom
> program or nc (nc -U /tmp/foo).  On the guest, you can just open
> /dev/virtio-ports/port1 and read/write into it.
> 
> See the following links for more details.
> 
> https://fedoraproject.org/wiki/Features/VirtioSerial#How_To_Test
> http://www.linux-kvm.org/page/Virtio-serial_API
> 
> > You said that there are too many channels. Does it mean /tmp/foo is a channel?
> 
> You can have several such -device virtserialport.  The -device part
> describes what the guest will see.  The -chardev part ties that to the
> host-side part of the channel.
> 
> /tmp/foo is the host end-point for the channel, in the example above,
> and /dev/virtio-ports/port1 is the guest-side end-point.

If we do choose to use virtio-serial for panics (which I don't think
we should), then we should not expose it in the host filesystem. The
host side should be a virtual chardev backend internal to QEMU, in
the same way that 'spicevmc' is handled.

Regards,
Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
