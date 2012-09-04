Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab2IDOan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:30:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757201Ab2IDOal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:30:41 -0400
Message-ID: <5046108B.8030609@redhat.com>
Date: Tue, 04 Sep 2012 16:30:35 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, rusty@rustcorp.com.au, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com> <1346154857-12487-6-git-send-email-pbonzini@redhat.com> <20120904124800.GE9805@redhat.com> <504606F6.4080603@redhat.com> <20120904142154.GL9805@redhat.com>
In-Reply-To: <20120904142154.GL9805@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/09/2012 16:21, Michael S. Tsirkin ha scritto:
> > One reason is that, even though in practice I expect roughly the same
> > number of targets and VCPUs, hotplug means the number of targets is
> > difficult to predict and is usually fixed to 256.
> > 
> > The other reason is that per-target vq didn't give any performance
> > advantage.  The bonus comes from cache locality and less process
> > migrations, more than from the independent virtqueues.
> 
> Okay, and why is per-target worse for cache locality?

Because per-target doesn't have IRQ affinity for a particular CPU.

Assuming that the thread that is sending requests to the device is
I/O-bound, it is likely to be sleeping at the time the ISR is executed,
and thus executing the ISR on the same processor that sent the requests
is cheap.

But if you have many such I/O-bound processes, the kernel will execute
the ISR on a random processor, rather than the one that is sending
requests to the device.

Paolo
