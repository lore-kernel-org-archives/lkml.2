Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1LSPAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 10:00:42 -0500
Received: from smtp.infotech.no ([82.134.31.41]:47022 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab1LSPAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 10:00:40 -0500
Message-ID: <4EEF5192.50201@interlog.com>
Date: Mon, 19 Dec 2011 10:00:34 -0500
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v3 1/2] virtio-scsi: first version
References: <1324296188-3426-1-git-send-email-pbonzini@redhat.com> <1324296188-3426-2-git-send-email-pbonzini@redhat.com> <4EEF2C86.6010003@suse.de> <4EEF380E.6040101@redhat.com>
In-Reply-To: <4EEF380E.6040101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-19 08:11 AM, Paolo Bonzini wrote:
> On 12/19/2011 01:22 PM, Hannes Reinecke wrote:
>>> + case VIRTIO_SCSI_S_UNDERRUN:
>>> + set_host_byte(sc, DID_ERROR);
>>> + break;
>> Hmm. Not sure this is correct.
>> UNDERRUN could be a valid state, eg it is quite common to send
>> an INQUIRY with a length of 255 bytes. And only evaluate the
>> bytes which are actually send back.
>
> This happens when you send an INQUIRY with a sglist of 255 bytes and an
> ALLOCATION LENGTH of 300 bytes. The spec says "VIRTIO_SCSI_S_UNDERRUN [is
> returned] if the content of the CDB requires transferring more data than is
> available in the data buffers".

Overrun! That is overrun.

Underrun conventionally refers to the data-in buffer
containing less data than the transport has allowed
for. It is detected at the completion of a SCSI command
and is used to report to the application client that
bytes beyond a certain position in the data-in buffer
are not valid (i.e. ignore them).

A mismatch between the allocation length field inside a
SCSI command (a difficult and dangerous area to snoop in)
and the data-in buffer length indicated by sglist should be
called something else. Arguably it should not be treated
as an error until an overrun occurs.

I think the 'case VIRTIO_SCSI_S_UNDERRUN:' line deserves a
comment due to its misleading use of the word "underrun".
It is reporting a potential or actual _overrun_.

Doug Gilbert

