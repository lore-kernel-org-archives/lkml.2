Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab1F2Jjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:39:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46493 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab1F2Jjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:39:43 -0400
MIME-Version: 1.0
In-Reply-To: <4E0AE36B.9010500@redhat.com>
References: <1504884387.187692.1307716550265.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
	<4DF71E28.6070009@suse.de>
	<4E0AE36B.9010500@redhat.com>
Date: Wed, 29 Jun 2011 10:39:42 +0100
Message-ID: <BANLkTik2AXXkWvV23OP1eDdLirP2N0PC3A@mail.gmail.com>
Subject: Re: virtio scsi host draft specification, v3
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <chellwig@redhat.com>,
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

On Wed, Jun 29, 2011 at 9:33 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 06/14/2011 10:39 AM, Hannes Reinecke wrote:
>> If, however, we decide to expose some details about the backend, we
>> could be using the values from the backend directly.
>> EG we could be forwarding the SCSI target port identifier here
>> (if backed by real hardware) or creating our own SAS-type
>> identifier when backed by qemu block. Then we could just query
>> the backend via a new command on the controlq
>> (eg 'list target ports') and wouldn't have to worry about any protocol
>> specific details here.
>
> Besides the controlq command, which I can certainly add, this is
> actually quite similar to what I had in mind (though my plan likely
> would not have worked because I was expecting hierarchical LUNs used
> uniformly).  So, "list target ports" would return a set of LUN values to
> which you can send REPORT LUNS, or something like that?

I think we're missing a level of addressing.  We need the ability to
talk to multiple target ports in order for "list target ports" to make
sense.  Right now there is one implicit target that handles all
commands.  That means there is one fixed I_T Nexus.

If we introduce "list target ports" we also need a way to say "This
CDB is destined for target port #0".  Then it is possible to enumerate
target ports and address targets independently of the LUN field in the
CDB.

I'm pretty sure this is also how SAS and other transports work.  In
their framing they include the target port.

The question is whether we really need to support multiple targets on
a virtio-scsi adapter or not.  If you are selectively mapping LUNs
that the guest may access, then multiple targets are not necessary.
If we want to do pass-through of the entire SCSI bus then we need
multiple targets but I'm not sure if there are other challenges like
dependencies on the transport (Fibre Channel, SAS, etc) which make it
impossible to pass through bus-level access?

> If I understand it correctly, it should remain possible to use a single
> host for both pass-through and emulated targets.

Yes.

>> Of course, when doing so we would be lose the ability to freely remap
>> LUNs. But then remapping LUNs doesn't gain you much imho.
>> Plus you could always use qemu block backend here if you want
>> to hide the details.
>
> And you could always use the QEMU block backend with scsi-generic if you
> want to remap LUNs, instead of true passthrough via the kernel target.

IIUC the in-kernel target always does remapping.  It passes through
individual LUNs rather than entire targets and you pick LU Numbers to
map to the backing storage (which may or may not be a SCSI
pass-through device).  Nicholas Bellinger can confirm whether this is
correct.

Stefan
