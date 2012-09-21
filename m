Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124Ab2IUTET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:04:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38230 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab2IUTEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:04:16 -0400
Date: Fri, 21 Sep 2012 14:52:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andres Lagar-Cavilla <andreslc@gridcentric.ca>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Andres Lagar-Cavilla <andres@lagarcavilla.org>,
        xen-devel <xen-devel@lists.xen.org>,
        David Vrabel <david.vrabel@citrix.com>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] Xen backend support for paged out grant targets V4.
Message-ID: <20120921185258.GA4931@phenom.dumpdata.com>
References: <1347632819-13684-1-git-send-email-andres@lagarcavilla.org>
 <1347869865.14977.15.camel@zakaz.uk.xensource.com>
 <5B5132A4-93B2-41D0-B1A6-048810565DB5@gridcentric.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5B5132A4-93B2-41D0-B1A6-048810565DB5@gridcentric.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 05:29:24AM -0400, Andres Lagar-Cavilla wrote:
> On Sep 17, 2012, at 4:17 AM, Ian Campbell wrote:
> 
> > (I think I forgot to hit send on this on Friday, sorry. Also
> > s/xen.lists.org/lists.xen.org in the CC line…)
> I'm on a roll here…
> 
> > 
> > On Fri, 2012-09-14 at 15:26 +0100, Andres Lagar-Cavilla wrote:
> >> Since Xen-4.2, hvm domains may have portions of their memory paged out. When a
> >> foreign domain (such as dom0) attempts to map these frames, the map will
> >> initially fail. The hypervisor returns a suitable errno, and kicks an
> >> asynchronous page-in operation carried out by a helper. The foreign domain is
> >> expected to retry the mapping operation until it eventually succeeds. The
> >> foreign domain is not put to sleep because itself could be the one running the
> >> pager assist (typical scenario for dom0).
> >> 
> >> This patch adds support for this mechanism for backend drivers using grant
> >> mapping and copying operations. Specifically, this covers the blkback and
> >> gntdev drivers (which map foregin grants), and the netback driver (which copies
> > 
> >                           foreign
> > 
> >> foreign grants).
> >> 
> >> * Add a retry method for grants that fail with GNTST_eagain (i.e. because the
> >>  target foregin frame is paged out).
> > 
> >          foreign
> > 
> >> * Insert hooks with appropriate wrappers in the aforementioned drivers.
> >> 
> >> The retry loop is only invoked if the grant operation status is GNTST_eagain.
> >> It guarantees to leave a new status code different from GNTST_eagain. Any other
> >> status code results in identical code execution as before.
> >> 
> >> The retry loop performs 256 attempts with increasing time intervals through a
> >> 32 second period. It uses msleep to yield while waiting for the next retry.
> > [...]
> >> Signed-off-by: Andres Lagar-Cavilla <andres@lagarcavilla.org>
> > 
> > Acked-by: Ian Campbell <ian.campbell@citrix.com>
> > 
> > Since this is more about grant tables than netback this should probably
> > go via Konrad rather than Dave, is that OK with you Dave?
> 
> If that is the case hopefully Konrad can deal with the two typos? Otherwise happy to re-spin the patch.

So with this patch when I launch an PVHVM guest on Xen 4.1 I get this
in the initial domain and the guest is crashed:

[  261.927218] privcmd_fault: vma=ffff88002a31dce8 7f4edc095000-7f4edc195000, pgoff=c8, uv=00007f4edc15d000

guest config:
> more /mnt/lab/latest/hvm.xm 
kernel = "/usr/lib/xen/boot/hvmloader"
builder='hvm'
memory=1024
#maxmem=1024
maxvcpus = 2
serial='pty'
vcpus = 2
disk = [ 'file:/mnt/lab/latest/root_image.iso,hdc:cdrom,r']
boot="dn"
#vif = [ 'type=ioemu,model=e1000,mac=00:0F:4B:00:00:71, bridge=switch' ]
vif = [ 'type=netfront, bridge=switch' ]
#vfb = [ 'vnc=1, vnclisten=0.0.0.0 ,vncunused=1']
vnc=1
vnclisten="0.0.0.0"
usb=1
xen_platform_pci=1


