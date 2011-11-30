Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab1K3QhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 11:37:06 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58891 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746Ab1K3QhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 11:37:02 -0500
Message-ID: <4ED65BA4.3000003@redhat.com>
Date: Wed, 30 Nov 2011 17:36:52 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.virtualization,gmane.linux.kernel
To: Hannes Reinecke <hare@suse.de>
CC: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: virtio-scsi spec (was Re: [PATCH] Add virtio-scsi to the virtio
 spec)
References: <1322661042-28191-1-git-send-email-pbonzini@redhat.com> <1322661042-28191-2-git-send-email-pbonzini@redhat.com> <4ED63AE1.8090105@suse.de>
In-Reply-To: <4ED63AE1.8090105@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2011 03:17 PM, Hannes Reinecke wrote:
>>   seg_max is the maximum number of segments that can be in a
>>     command. A bidirectional command can include seg_max input
>>     segments and seg_max output segments.
>>
> I would like to have the other request_queue limitations exposed
> here, too.
> Most notably we're missing the maximum size of an individual segment
> and the maximum size of the overall I/O request.

The virtio transport does not put any limit, as far as I know.

> As this is the host specification I really would like to see an host
> identifier somewhere in there.
> Otherwise we won't be able to reliably identify a virtio SCSI host.

I thought about it, but I couldn't figure out exactly how to use it. If 
it's just allocating 64 bits in the configuration space (with the 
stipulation that they could be zero), let's do it now. Otherwise a 
controlq command is indeed better, and it can come later.

But even if it's just a 64-bit value, then: 1) where would you place it 
in sysfs for userspace?  I can make up a random name, but existing user 
tools won't find it and that's against the design of virtio-scsi.  2) 
How would it be encoded as a transport ID?  Is it FC, or firewire, or 
SAS, or what?

> Plus you can't calculate the ITL nexus information, making
> Persistent Reservations impossible.

They are not impossible, only some features such as SPEC_I_PT.  If you 
use NPIV or iSCSI in the host, then the persistent reservations will 
already get the correct initiator port.  If not, much more work is needed.

> We should be adding
>
> VIRTIO_SCSI_S_BUSY
>
> for a temporary failure, indicating that a command retry
> might be sufficient to clear this situation.
> Equivalent to VIRTIO_SCSI_S_NEXUS_FAILURE, but issuing a retry on
> the same path.

... and equivalent to DID_BUS_BUSY.  Assuming no other major objections, 
I will add and resubmit in a few days.

Paolo

