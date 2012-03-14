Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab2CNLRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:17:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab2CNLRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:17:16 -0400
Date: Wed, 14 Mar 2012 11:17:03 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Amit Shah <amit.shah@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
Message-ID: <20120314111703.GC2315@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <4F5F25BF.7060100@redhat.com>
 <4F6056FE.3020202@cn.fujitsu.com>
 <4F6063C8.8010005@redhat.com>
 <4F606A7C.9090900@cn.fujitsu.com>
 <20120314103755.GD2708@amit.redhat.com>
 <4F607857.50402@cn.fujitsu.com>
 <4F60788A.2070608@redhat.com>
 <4F6079E7.7010608@cn.fujitsu.com>
 <20120314105914.GB2315@redhat.com>
 <4F607BCA.5090506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F607BCA.5090506@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 07:06:50PM +0800, Wen Congyang wrote:
> At 03/14/2012 06:59 PM, Daniel P. Berrange Wrote:
> > On Wed, Mar 14, 2012 at 06:58:47PM +0800, Wen Congyang wrote:
> >> At 03/14/2012 06:52 PM, Avi Kivity Wrote:
> >>> On 03/14/2012 12:52 PM, Wen Congyang wrote:
> >>>>>
> >>>>>> If so, is this channel visible to guest userspace? If the channle is visible to guest
> >>>>>> userspace, the program running in userspace may write the same message to the channel.
> >>>>>
> >>>>> Access control is via permissions.  You can have udev scripts assign
> >>>>> whatever uid and gid to the port of your interest.  By default, all
> >>>>> ports are only accessible to the root user.
> >>>>
> >>>> We should also prevent root user writing message to this channel if it is
> >>>> used for panicked notification.
> >>>>
> >>>
> >>> Why?  root can easily cause a panic.
> >>>
> >>
> >> root user can write the same message to virtio-serial while the guest is running...
> > 
> > Unless you are running a MAC policy which strictly confines the root
> > account, root can cause a kernel panic regardless of virtio-serial
> > permissions in the guest:
> > 
> >   echo c > /proc/sysrq-trigger
> 
> Yes, root user can cause a kernel panic. But if he writes the same message to virtio-serial,
> the host will see the guest is panicked while the guest is not panicked. The host is cheated.

The host mgmt layer must *ALWAYS* expect that any information originating
from the guest is bogus. It must never trust the guest info. So regardless
of the implementation, you have to expect that the guest might have lied
to you about it being crashed. The same is true even of Xen's panic notifier.

So if an application is automatically triggering core dumps based on this
panic notification, it needs to be aware that the guest can lie and take
steps to avoid the guest causing a DOS attack on the host. Most likely
by rate limiting the frequency of core dumps per guest, and/or setting a
max core dump storage quota per guest.

Regards,
Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
