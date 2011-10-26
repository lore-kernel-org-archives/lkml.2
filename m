Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1JZEku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 00:40:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52935 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab1JZEks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 00:40:48 -0400
MIME-Version: 1.0
Date: Wed, 26 Oct 2011 12:40:47 +0800
Message-ID: <CA+tHM2Hw4jzTNmNtD3ttVpyCFCHnFB9USWK5XsUK6vqGJVmGRg@mail.gmail.com>
Subject: about NPIV with qemu-kvm.
From: ya su <suya94335@gmail.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, hannes:

    I want to use NPIV with qemu-kvm, I issued the following command:

    echo '1111222233334444:5555666677778888' >
/sys/class/fc_host/host0/vport_create

    and it will produce a new host6 and one vport succesfully, but it
does not create any virtual hba pci device. so I don't know how to
assign the virtual host to qemu-kvm.

    from your this mail, does array will first need to assign a lun to
this vport? and through this new created disk, like device /dev/sdf,
then I add qemu-kvm with -drive file=/dev/sdf,if=virtio... arguments?


Regards.

Suya.

2011/6/29, Hannes Reinecke <hare@suse.de>:
> On 06/29/2011 12:07 PM, Christoph Hellwig wrote:
>> On Wed, Jun 29, 2011 at 10:39:42AM +0100, Stefan Hajnoczi wrote:
>>> I think we're missing a level of addressing.  We need the ability to
>>> talk to multiple target ports in order for "list target ports" to make
>>> sense.  Right now there is one implicit target that handles all
>>> commands.  That means there is one fixed I_T Nexus.
>>>
>>> If we introduce "list target ports" we also need a way to say "This
>>> CDB is destined for target port #0".  Then it is possible to enumerate
>>> target ports and address targets independently of the LUN field in the
>>> CDB.
>>>
>>> I'm pretty sure this is also how SAS and other transports work.  In
>>> their framing they include the target port.
>>
>> Yes, exactly.  Hierachial LUNs are a nasty fringe feature that we should
>> avoid as much as possible, that is for everything but IBM vSCSI which is
>> braindead enough to force them.
>>
> Yep.
>
>>> The question is whether we really need to support multiple targets on
>>> a virtio-scsi adapter or not.  If you are selectively mapping LUNs
>>> that the guest may access, then multiple targets are not necessary.
>>> If we want to do pass-through of the entire SCSI bus then we need
>>> multiple targets but I'm not sure if there are other challenges like
>>> dependencies on the transport (Fibre Channel, SAS, etc) which make it
>>> impossible to pass through bus-level access?
>>
>> I don't think bus-level pass through is either easily possible nor
>> desirable.  What multiple targets are useful for is allowing more
>> virtual disks than we have virtual PCI slots.  We could do this by
>> supporting multiple LUNs, but given that many SCSI ressources are
>> target-based doing multiple targets most likely is the more scabale
>> and more logical variant.  E.g. we could much more easily have one
>> virtqueue per target than per LUN.
>>
> The general idea here is that we can support NPIV.
> With NPIV we'll have several scsi_hosts, each of which is assigned a
> different set of LUNs by the array.
> With virtio we need to able to react on LUN remapping on the array
> side, ie we need to be able to issue a 'REPORT LUNS' command and
> add/remove LUNs on the fly. This means we have to expose the
> scsi_host in some way via virtio.
>
> This is impossible with a one-to-one mapping between targets and
> LUNs. The actual bus-level pass-through will be just on the SCSI
> layer, ie 'REPORT LUNS' should be possible. If and how we do a LUN
> remapping internally on the host is a totally different matter.
> Same goes for the transport details; I doubt we will expose all the
> dingy details of the various transports, but rather restrict
> ourselves to an abstract transport.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
