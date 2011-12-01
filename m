Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab1LAILF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:11:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab1LAILD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:11:03 -0500
Date: Thu, 1 Dec 2011 10:12:37 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
Message-ID: <20111201081236.GB5479@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
 <20111129131110.GC19157@redhat.com>
 <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
 <20111129151958.GA31789@redhat.com>
 <CAK=WgbZ5aBFNro3XC0cN+Ao4ZWrBHwwd3d__CSHA=n56gKmKXw@mail.gmail.com>
 <20111130145004.GD21413@redhat.com>
 <CAK=WgbY59n9N_-2_TZ9wNBNcTMV1DCrz65e-Ae=xamcg6A0dOA@mail.gmail.com>
 <20111130231306.GD30031@redhat.com>
 <87zkfdrpn8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zkfdrpn8.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 12:58:59PM +1030, Rusty Russell wrote:
> On Thu, 1 Dec 2011 01:13:07 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > For x86, stores into memory are ordered. So I think that yes, smp_XXX
> > can be selected at compile time.
> > 
> > So let's forget the virtio strangeness for a minute,
> 
> Hmm, we got away with light barriers because we knew we were not
> *really* talking to a device.  But now with virtio-mmio, turns out we
> are :)

You think virtio-mmio this issue too?  It's reported on remoteproc...

> I'm really tempted to revert d57ed95 for 3.2, and we can revisit this
> optimization later if it proves worthwhile.
> 
> Thoughts?
> Rusty. 

Generally it does seem the best we can do for 3.2.

Given it's rc3, I'd be a bit wary of introducing regressions - I'll try
to find some real setups (as in - not my laptop) to run some benchmarks
on, to verify there's no major problem.
I hope I can report on this in about a week from now - want to hold onto this meanwhile?

Further, if we do revert, need to remember to apply the following
beforehand, to avoid breaking virtio tool:

tools/virtio: implement mandatory barriers for x86

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
index 68b8b8d..1bf0e80 100644
--- a/tools/virtio/linux/virtio.h
+++ b/tools/virtio/linux/virtio.h
@@ -172,11 +172,18 @@ struct virtqueue {
 #define MODULE_LICENSE(__MODULE_LICENSE_value) \
 	const char *__MODULE_LICENSE_name = __MODULE_LICENSE_value
 
 #define CONFIG_SMP
 
 #if defined(__i386__) || defined(__x86_64__)
 #define barrier() asm volatile("" ::: "memory")
 #define mb() __sync_synchronize()
+#if defined(__i386__)
+#define wmb() mb()
+#define rmb() mb()
+#else
+#define wmb() asm volatile("sfence" ::: "memory")
+#define rmb() asm volatile("lfence" ::: "memory")
+#endif
 
 #define smp_mb()	mb()
 # define smp_rmb()	barrier()

-- 
MST
