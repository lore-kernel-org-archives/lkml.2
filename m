Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab1GDNiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 09:38:54 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:38541 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab1GDNiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 09:38:52 -0400
Message-ID: <4E11C263.3010003@linux.vnet.ibm.com>
Date: Mon, 04 Jul 2011 21:38:43 +0800
From: "Hai Dong,Li" <haidongl@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Hannes Reinecke <hare@suse.de>, Stefan Hajnoczi <stefanha@gmail.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: virtio scsi host draft specification, v3
References: <1504884387.187692.1307716550265.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>	<4DF71E28.6070009@suse.de>	<4E0AE36B.9010500@redhat.com> <BANLkTik2AXXkWvV23OP1eDdLirP2N0PC3A@mail.gmail.com> <4E0D6C08.1040201@redhat.com> <4E0D73C4.5090608@suse.de> <4E0D86E0.1020406@redhat.com>
In-Reply-To: <4E0D86E0.1020406@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2011 09:14 AM, Hannes Reinecke wrote:
>> Actually, the kernel does _not_ do a LUN remapping.
>
> Not the kernel, the in-kernel target.  The in-kernel target can and will
> map hardware LUNs (target_lun in drivers/target/*) to arbitrary LUNs
> (mapped_lun).
>
>>> Put in another way: the virtio-scsi device is itself a SCSI
>>> target,
>>
>> Argl. No way. The virtio-scsi device has to map to a single LUN.
>
> I think we are talking about different things. By "virtio-scsi device"
> I meant the "virtio-scsi HBA".  When I referred to a LUN as seen by the
> guest, I was calling it a "virtual SCSI device".  So yes, we were
> calling things with different names.  Perhaps from now on
> we can call them virtio-scsi {initiator,target,LUN} and have no
> ambiguity?  I'll also modify the spec in this sense.
>
>> The SCSI spec itself only deals with LUNs, so anything you'll read in
>> there obviously will only handle the interaction between the
>> initiator (read: host) and the LUN itself. However, the actual
>> command is send via an intermediat target, hence you'll always see
>> the reference to the ITL (initiator-target-lun) nexus.
>
> Yes, this I understand.
>
>> The SCSI spec details discovery of the individual LUNs presented by a
>> given target, it does _NOT_ detail the discovery of the targets
>> themselves.  That is being delegated to the underlying transport
>
> And in fact I have this in virtio-scsi too, since virtio-scsi _is_ a
> transport:
Oh, here I catch up. I was wondering why there're ordering issues when 
talking
about virtio-scsi, since in SAM3, the third and the last paragraph of 
section
4.6.3 Request/Response ordering clearly describe it:

The manner in which ordering constraints are established is vendor 
specific. An
implementation may delegate this responsibility to the application client
(e.g., the device driver). In-order delivery may be an intrinsic property of
the service delivery subsystem or a requirement established by the SCSI
transport protocol standard.

To simplify the description of behavior, the SCSI architecture model assumes
in-order delivery of requests or responses to be a property of the service
delivery subsystem. This assumption does not constitute a requirement.  The
SCSI architecture model makes no assumption about and places no 
requirement on
the ordering of requests or responses for different I_T nexuses.

So if I understand correctly, virtio-scsi looks like an SCSI tranport 
protocol,
such as iSCSI, FCP and SRP which use tcp/ip, FC and Infiniband RDMA
respectively as the transfer media while virtio-scsi uses virtio, an 
virtual IO
channel, as the transfer media?

>
>     When VIRTIO_SCSI_EVT_RESET_REMOVED or VIRTIO_SCSI_EVT_RESET_RESCAN
>     is sent for LUN 0, the driver should ask the initiator to rescan
>     the target, in order to detect the case when an entire target has
>     appeared or disappeared.
>
>     [If the device fails] to report an event due to missing buffers,
>     [...] the driver should poll the logical units for unit attention
>     conditions, and/or do whatever form of bus scan is appropriate for
>     the guest operating system.
>
>> In the case of NPIV it would make sense to map the virtual SCSI host
>>  to the backend, so that all devices presented to the virtual SCSI
>> host will be presented to the backend, too. However, when doing so
>> these devices will normally be referenced by their original LUN, as
>> these will be presented to the guest via eg 'REPORT LUNS'.
>
> Right.
>
>> The above thread now tries to figure out if we should remap those LUN
>> numbers or just expose them as they are. If we decide on remapping,
>> we have to emulate _all_ commands referring explicitely to those LUN
>> numbers (persistent reservations, anyone?).
>
> But it seems to me that commands referring explicitly to LUN numbers
> most likely have to be reimplemented anyway for virtualization.  I'm
> thinking exactly of persistent reservations.  If two guests on the same
> host try a persistent reservation, they should conflict with each other.
> If reservation commands were just passed through, they would be seen
> as coming from the same initiator (the HBA driver or iSCSI initiator in
> the host OS).
>
> etc.
>
>> If we don't, we would expose some hardware detail to the guest, but
>> would save us _a lot_ of processing.
>
> But can we afford it?  And would the architecture allow that at all?
>
> Paolo
> -- 
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


