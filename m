Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab1GAIgC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:36:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab1GAIgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:36:00 -0400
Message-ID: <4E0D86E0.1020406@redhat.com>
Date: Fri, 01 Jul 2011 10:35:44 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>
CC: Stefan Hajnoczi <stefanha@gmail.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: virtio scsi host draft specification, v3
References: <1504884387.187692.1307716550265.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>	<4DF71E28.6070009@suse.de>	<4E0AE36B.9010500@redhat.com> <BANLkTik2AXXkWvV23OP1eDdLirP2N0PC3A@mail.gmail.com> <4E0D6C08.1040201@redhat.com> <4E0D73C4.5090608@suse.de>
In-Reply-To: <4E0D73C4.5090608@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2011 09:14 AM, Hannes Reinecke wrote:
> Actually, the kernel does _not_ do a LUN remapping.

Not the kernel, the in-kernel target.  The in-kernel target can and will
map hardware LUNs (target_lun in drivers/target/*) to arbitrary LUNs
(mapped_lun).

>> Put in another way: the virtio-scsi device is itself a SCSI
>> target,
>
> Argl. No way. The virtio-scsi device has to map to a single LUN.

I think we are talking about different things. By "virtio-scsi device"
I meant the "virtio-scsi HBA".  When I referred to a LUN as seen by the
guest, I was calling it a "virtual SCSI device".  So yes, we were
calling things with different names.  Perhaps from now on
we can call them virtio-scsi {initiator,target,LUN} and have no
ambiguity?  I'll also modify the spec in this sense.

> The SCSI spec itself only deals with LUNs, so anything you'll read in
> there obviously will only handle the interaction between the
> initiator (read: host) and the LUN itself. However, the actual
> command is send via an intermediat target, hence you'll always see
> the reference to the ITL (initiator-target-lun) nexus.

Yes, this I understand.

> The SCSI spec details discovery of the individual LUNs presented by a
> given target, it does _NOT_ detail the discovery of the targets
> themselves.  That is being delegated to the underlying transport

And in fact I have this in virtio-scsi too, since virtio-scsi _is_ a
transport:

     When VIRTIO_SCSI_EVT_RESET_REMOVED or VIRTIO_SCSI_EVT_RESET_RESCAN
     is sent for LUN 0, the driver should ask the initiator to rescan
     the target, in order to detect the case when an entire target has
     appeared or disappeared.

     [If the device fails] to report an event due to missing buffers,
     [...] the driver should poll the logical units for unit attention
     conditions, and/or do whatever form of bus scan is appropriate for
     the guest operating system.

> In the case of NPIV it would make sense to map the virtual SCSI host
>  to the backend, so that all devices presented to the virtual SCSI
> host will be presented to the backend, too. However, when doing so
> these devices will normally be referenced by their original LUN, as
> these will be presented to the guest via eg 'REPORT LUNS'.

Right.

> The above thread now tries to figure out if we should remap those LUN
> numbers or just expose them as they are. If we decide on remapping,
> we have to emulate _all_ commands referring explicitely to those LUN
> numbers (persistent reservations, anyone?).

But it seems to me that commands referring explicitly to LUN numbers
most likely have to be reimplemented anyway for virtualization.  I'm
thinking exactly of persistent reservations.  If two guests on the same
host try a persistent reservation, they should conflict with each other.
If reservation commands were just passed through, they would be seen
as coming from the same initiator (the HBA driver or iSCSI initiator in
the host OS).

etc.

> If we don't, we would expose some hardware detail to the guest, but
> would save us _a lot_ of processing.

But can we afford it?  And would the architecture allow that at all?

Paolo
