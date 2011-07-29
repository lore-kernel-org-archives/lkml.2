Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1G2Esv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 00:48:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46898 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab1G2Esu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 00:48:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
	<CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>
Date: Fri, 29 Jul 2011 05:48:48 +0100
Message-ID: <CAJSP0QVH8RgwdtVRtowbkJ0KHiDs8np=mcfP8LWX6=NdDsAJcQ@mail.gmail.com>
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block device
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khoa Huynh <khoa@us.ibm.com>, Badari Pulavarty <pbadari@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 4:44 PM, Stefan Hajnoczi <stefanha@gmail.com> wrote:
> On Thu, Jul 28, 2011 at 3:29 PM, Liu Yuan <namei.unix@gmail.com> wrote:
>
> Did you investigate userspace virtio-blk performance?  If so, what
> issues did you find?
>
> I have a hacked up world here that basically implements vhost-blk in userspace:
> http://repo.or.cz/w/qemu/stefanha.git/blob/refs/heads/virtio-blk-data-plane:/hw/virtio-blk.c
>
>  * A dedicated virtqueue thread sleeps on ioeventfd
>  * Guest memory is pre-mapped and accessed directly (not using QEMU's
> usually memory access functions)
>  * Linux AIO is used, the QEMU block layer is bypassed
>  * Completion interrupts are injected from the virtqueue thread using ioctl
>
> I will try to rebase onto qemu-kvm.git/master (this work is several
> months old).  Then we can compare to see how much of the benefit can
> be gotten in userspace.

Here is the rebased virtio-blk-data-plane tree:
http://repo.or.cz/w/qemu-kvm/stefanha.git/shortlog/refs/heads/virtio-blk-data-plane

When I run it on my laptop with an Intel X-25M G2 SSD I see a latency
reduction compared to mainline userspace virtio-blk.  I'm not posting
results because I did quick fio runs without ensuring a quiet
benchmarking environment.

There are a couple of things that could be modified:
 * I/O request merging is done to mimic bdrv_aio_multiwrite() - but
vhost-blk does not do this.  Try turning it off?
 * epoll(2) is used but perhaps select(2)/poll(2) have lower latency
for this use case.  Try another event mechanism.

Let's see how it compares to vhost-blk first.  I can tweak it if we
want to investigate further.

Yuan: Do you want to try the virtio-blk-data-plane tree?  You don't
need to change the qemu-kvm command-line options.

Stefan
