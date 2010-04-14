Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab0DNQgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:36:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50470 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab0DNQgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:36:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC][PATCH v3 1/3] A device for zero-copy based on KVM virtio-net.
Date: Wed, 14 Apr 2010 18:35:57 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, davem@davemloft.net,
       jdike@linux.intel.com
References: <1270805865-16901-1-git-send-email-xiaohui.xin@intel.com> <201004141757.54829.arnd@arndb.de> <20100414161610.GA10897@redhat.com>
In-Reply-To: <20100414161610.GA10897@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004141835.57673.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+oaoW3W1IVgses5m7Rq0rxGRf918g26MvA3ff
 rXx5SAR2RQCUqBMWeUYkF1NgH5oiO3QRF82Fez4OHvyetWMWgt
 wkYWMLllThe9DsiK2naxw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 April 2010, Michael S. Tsirkin wrote:
> > > 
> > > qemu needs the ability to inject raw packets into device
> > > from userspace, bypassing vhost/virtio (for live migration).
> > 
> > Ok, but since there is only a write callback and no read, it won't
> > actually be able to do this with the current code, right?
> 
> I think it'll work as is, with vhost qemu only ever writes,
> never reads from device. We'll also never need GSO etc
> which is a large part of what tap does (and macvtap will
> have to do).

Ah, I see. I didn't realize that qemu needs to write to the
device even if vhost is used. But for the case of migration to
another machine without vhost, wouldn't qemu also need to read?

> > Moreover, it seems weird to have a new type of interface here that
> > duplicates tap/macvtap with less functionality. Coming back
> > to your original comment, this means that while mpassthru is currently
> > not duplicating the actual code from macvtap, it would need to do
> > exactly that to get the qemu interface right!
> > 
> I don't think so, see above. anyway, both can reuse tun.c :)

There is one significant difference between macvtap/mpassthru and
tun/tap in that the directions are reversed. While macvtap and
mpassthru forward data from write into dev_queue_xmit and from
skb_receive into read, tun/tap forwards data from write into
skb_receive and from start_xmit into read.

Also, I'm not really objecting to duplicating code between
macvtap and mpassthru, as the implementation can always be merged.
My main objection is instead to having two different _user_interfaces_
for doing the same thing.

	Arnd
