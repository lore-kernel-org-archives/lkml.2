Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab1G1PoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:44:17 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44700 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab1G1PoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:44:14 -0400
MIME-Version: 1.0
In-Reply-To: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
Date: Thu, 28 Jul 2011 16:44:06 +0100
Message-ID: <CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>
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

On Thu, Jul 28, 2011 at 3:29 PM, Liu Yuan <namei.unix@gmail.com> wrote:

Did you investigate userspace virtio-blk performance?  If so, what
issues did you find?

I have a hacked up world here that basically implements vhost-blk in userspace:
http://repo.or.cz/w/qemu/stefanha.git/blob/refs/heads/virtio-blk-data-plane:/hw/virtio-blk.c

 * A dedicated virtqueue thread sleeps on ioeventfd
 * Guest memory is pre-mapped and accessed directly (not using QEMU's
usually memory access functions)
 * Linux AIO is used, the QEMU block layer is bypassed
 * Completion interrupts are injected from the virtqueue thread using ioctl

I will try to rebase onto qemu-kvm.git/master (this work is several
months old).  Then we can compare to see how much of the benefit can
be gotten in userspace.

> [performance]
>
>        Currently, the fio benchmarking number is rather promising. The seq read is imporved as much as 16% for throughput and the latency is dropped up to 14%. For seq write, 13.5% and 13% respectively.
>
> sequential read:
> +-------------+-------------+---------------+---------------+
> | iodepth     | 1           |   2           |   3           |
> +-------------+-------------+---------------+----------------
> | virtio-blk  | 4116(214)   |   7814(222)   |   8867(306)   |
> +-------------+-------------+---------------+---------------+
> | vhost-blk   | 4755(183)   |   8645(202)   |   10084(266)  |
> +-------------+-------------+---------------+---------------+
>
> 4116(214) means 4116 IOPS/s, the it is completion latency is 214 us.
>
> seqeuential write:
> +-------------+-------------+----------------+--------------+
> | iodepth     |  1          |    2           |  3           |
> +-------------+-------------+----------------+--------------+
> | virtio-blk  | 3848(228)   |   6505(275)    |  9335(291)   |
> +-------------+-------------+----------------+--------------+
> | vhost-blk   | 4370(198)   |   7009(249)    |  9938(264)   |
> +-------------+-------------+----------------+--------------+
>
> the fio command for sequential read:
>
> sudo fio -name iops -readonly -rw=read -runtime=120 -iodepth 1 -filename /dev/vda -ioengine libaio -direct=1 -bs=512
>
> and config file for sequential write is:
>
> dev@taobao:~$ cat rw.fio
> -------------------------
> [test]
>
> rw=rw
> size=200M
> directory=/home/dev/data
> ioengine=libaio
> iodepth=1
> direct=1
> bs=512
> -------------------------

512 byte blocksize is very small, given that you can expect a file
system to have 4 KB or so block sizes.  It would be interesting to
measure a wider range of block sizes: 4 KB, 64 KB, and 128 KB for
example.

Stefan
