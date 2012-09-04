Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab2IDLSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 07:18:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782Ab2IDLSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 07:18:44 -0400
Message-ID: <5045E387.4030103@redhat.com>
Date: Tue, 04 Sep 2012 13:18:31 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, rusty@rustcorp.com.au, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com> <1346154857-12487-6-git-send-email-pbonzini@redhat.com> <1346725294.4162.79.camel@haakon2.linux-iscsi.org> <5045A3B4.2030101@redhat.com> <20120904084628.GA8437@redhat.com> <5045D6FF.5020801@redhat.com> <20120904110905.GA9119@redhat.com>
In-Reply-To: <20120904110905.GA9119@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/09/2012 13:09, Michael S. Tsirkin ha scritto:
>> >     queuecommand on CPU #0         queuecommand #2 on CPU #1
>> >   --------------------------------------------------------------
>> >     atomic_inc_return(...) == 1
>> >                                    atomic_inc_return(...) == 2
>> >                                    virtscsi_queuecommand to queue #1
>> >     tgt->req_vq = queue #0
>> >     virtscsi_queuecommand to queue #0
>> > 
>> > then two requests are issued to different queues without a quiescent
>> > point in the middle.
> What happens then? Does this break correctness?

Yes, requests to the same target should be processed in FIFO order, or
you have things like a flush issued before the write it was supposed to
flush.  This is why I can only change the queue when there is no request
pending.

Paolo
