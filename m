Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab2GBIMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:12:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab2GBIMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:12:16 -0400
Message-ID: <4FF157CD.7090001@redhat.com>
Date: Mon, 02 Jul 2012 10:11:57 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: mc@linux.vnet.ibm.com
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        stefanha@linux.vnet.ibm.com, linuxram@us.ibm.com,
        Anthony Liguori <anthony@codemonkey.ws>, senwang@linux.vnet.ibm.com,
        zwanp@cn.ibm.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] virtio-scsi: hotplug suppot for virtio-scsi
References: <1340175333-16803-1-git-send-email-mc@linux.vnet.ibm.com> <4FF04F79.4090304@redhat.com> <20120702032057.Horde.WOVSk5ir309P8UvZ8oq3rUA@imap.linux.ibm.com>
In-Reply-To: <20120702032057.Horde.WOVSk5ir309P8UvZ8oq3rUA@imap.linux.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/07/2012 09:20, mc@linux.vnet.ibm.com ha scritto:
>>> +static void virtscsi_handle_event(struct work_struct *work)
>>> +{
>>> +    struct virtio_scsi_event_node *event_node =
>>> +        container_of(work, struct virtio_scsi_event_node, work);
>>> +    struct virtio_scsi *vscsi = event_node->vscsi;
>>> +    struct virtio_scsi_event *event = &event_node->event;
>>> +
>>> +    switch (event->event) {
>>> +    case VIRTIO_SCSI_T_TRANSPORT_RESET:
>>> +        virtscsi_handle_transport_reset(vscsi, event);
>>> +        break;
>>
>> Please handle VIRTIO_SCSI_T_NO_EVENT too here, and mask out
>> VIRTIO_SCSI_T_EVENTS_MISSED even if you do not handle it by triggering a
>> full rescan.
>>
> Paolo, what's the appropriate action to response VIRTIO_SCSI_T_NO_EVENT
> event? An error message?

No, just do nothing.

> I also have some confusion on VIRTIO_SCSI_T_EVENTS_MISSED:
> Should VIRTIO_SCSI_T_EVENTS_MISSED always be used with other event flag?

Yes.

> For instanse:
> (VIRTIO_SCSI_T_EVENTS_MISSED|VIRTIO_SCSI_T_TRANSPORT_RESET) is used to
> report hotplug event dropped when a buffer available.

The idea in the spec was that QEMU would report VIRTIO_SCSI_T_NO_EVENT |
VIRTIO_SCSI_T_EVENTS_MISSED as soon as a buffer becomes available, but
technically this is indeed possible.  So you need to handle
VIRTIO_SCSI_T_EVENTS_MISSED first, and the other bits separately.

Paolo
