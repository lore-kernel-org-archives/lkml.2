Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab1F2KH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:07:59 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39828
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753857Ab1F2KH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:07:57 -0400
Date: Wed, 29 Jun 2011 06:07:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <chellwig@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: virtio scsi host draft specification, v3
Message-ID: <20110629100752.GA27744@infradead.org>
References: <1504884387.187692.1307716550265.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
 <4DF71E28.6070009@suse.de>
 <4E0AE36B.9010500@redhat.com>
 <BANLkTik2AXXkWvV23OP1eDdLirP2N0PC3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTik2AXXkWvV23OP1eDdLirP2N0PC3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 10:39:42AM +0100, Stefan Hajnoczi wrote:
> I think we're missing a level of addressing.  We need the ability to
> talk to multiple target ports in order for "list target ports" to make
> sense.  Right now there is one implicit target that handles all
> commands.  That means there is one fixed I_T Nexus.
> 
> If we introduce "list target ports" we also need a way to say "This
> CDB is destined for target port #0".  Then it is possible to enumerate
> target ports and address targets independently of the LUN field in the
> CDB.
> 
> I'm pretty sure this is also how SAS and other transports work.  In
> their framing they include the target port.

Yes, exactly.  Hierachial LUNs are a nasty fringe feature that we should
avoid as much as possible, that is for everything but IBM vSCSI which is
braindead enough to force them.

> The question is whether we really need to support multiple targets on
> a virtio-scsi adapter or not.  If you are selectively mapping LUNs
> that the guest may access, then multiple targets are not necessary.
> If we want to do pass-through of the entire SCSI bus then we need
> multiple targets but I'm not sure if there are other challenges like
> dependencies on the transport (Fibre Channel, SAS, etc) which make it
> impossible to pass through bus-level access?

I don't think bus-level pass through is either easily possible nor
desirable.  What multiple targets are useful for is allowing more
virtual disks than we have virtual PCI slots.  We could do this by
supporting multiple LUNs, but given that many SCSI ressources are
target-based doing multiple targets most likely is the more scabale
and more logical variant.  E.g. we could much more easily have one
virtqueue per target than per LUN.

