Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab2IDNtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 09:49:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757089Ab2IDNts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 09:49:48 -0400
Message-ID: <504606F6.4080603@redhat.com>
Date: Tue, 04 Sep 2012 15:49:42 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, rusty@rustcorp.com.au, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com> <1346154857-12487-6-git-send-email-pbonzini@redhat.com> <20120904124800.GE9805@redhat.com>
In-Reply-To: <20120904124800.GE9805@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/09/2012 14:48, Michael S. Tsirkin ha scritto:
>> > This patch adds queue steering to virtio-scsi.  When a target is sent
>> > multiple requests, we always drive them to the same queue so that FIFO
>> > processing order is kept.  However, if a target was idle, we can choose
>> > a queue arbitrarily.  In this case the queue is chosen according to the
>> > current VCPU, so the driver expects the number of request queues to be
>> > equal to the number of VCPUs.  This makes it easy and fast to select
>> > the queue, and also lets the driver optimize the IRQ affinity for the
>> > virtqueues (each virtqueue's affinity is set to the CPU that "owns"
>> > the queue).
>> > 
>> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> I guess an alternative is a per-target vq.
> Is the reason you avoid this that you expect more targets
> than cpus? If yes this is something you might want to
> mention in the log.

One reason is that, even though in practice I expect roughly the same
number of targets and VCPUs, hotplug means the number of targets is
difficult to predict and is usually fixed to 256.

The other reason is that per-target vq didn't give any performance
advantage.  The bonus comes from cache locality and less process
migrations, more than from the independent virtqueues.

Paolo
