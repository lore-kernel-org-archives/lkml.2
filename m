Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab1G1OgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 10:36:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46099 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab1G1OgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 10:36:17 -0400
From: Liu Yuan <namei.unix@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block device
Date: Thu, 28 Jul 2011 22:29:04 +0800
Message-Id: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[design idea]

        The vhost-blk uses two kernel threads to handle the guests' requests. One is tosubmit them via Linux kernel's internal AIO structs, and the other is signal the guests the completion of the IO requests.

        The current qemu-kvm's native AIO in the user mode acctually just uses one io-thread to submitting and signalling. One more nuance is that qemu-kvm AIO signals the completion of the requests one by one.

        Like vhost-net, the in-kernel vhost-blk module reduces the number of the system calls during the requests handling and the code path is shorter than the implementation of the qemu-kvm.

[performance]

        Currently, the fio benchmarking number is rather promising. The seq read is imporved as much as 16% for throughput and the latency is dropped up to 14%. For seq write, 13.5% and 13% respectively.

sequential read:
+-------------+-------------+---------------+---------------+
| iodepth     | 1           |   2           |   3           |
+-------------+-------------+---------------+----------------
| virtio-blk  | 4116(214)   |   7814(222)   |   8867(306)   |
+-------------+-------------+---------------+---------------+
| vhost-blk   | 4755(183)   |   8645(202)   |   10084(266)  |
+-------------+-------------+---------------+---------------+

4116(214) means 4116 IOPS/s, the it is completion latency is 214 us.

seqeuential write:
+-------------+-------------+----------------+--------------+
| iodepth     |  1          |    2           |  3           |
+-------------+-------------+----------------+--------------+
| virtio-blk  | 3848(228)   |   6505(275)    |  9335(291)   |
+-------------+-------------+----------------+--------------+
| vhost-blk   | 4370(198)   |   7009(249)    |  9938(264)   |
+-------------+-------------+----------------+--------------+

the fio command for sequential read:

sudo fio -name iops -readonly -rw=read -runtime=120 -iodepth 1 -filename /dev/vda -ioengine libaio -direct=1 -bs=512

and config file for sequential write is:

dev@taobao:~$ cat rw.fio
-------------------------
[test]

rw=rw
size=200M
directory=/home/dev/data
ioengine=libaio
iodepth=1
direct=1
bs=512
-------------------------

        These numbers are collected on my laptop with Intel Core i5 CPU, 2.67GHz, SATA harddisk with 7200 RPM. Both guest and host use Linux 3.0-rc6 kernel with ext4 filesystem.

        I setup the Guest by:

        sudo x86_64-softmmu/qemu-system-x86_64 -cpu host -m 512 -drive file=/dev/sda6,if=virtio,cache=none,aio=native -nographic


        The patchset is very primitive and need much further improvement for both funtionality and performance.

        Inputs and suggestions are more than welcome.

Yuan
--
 drivers/vhost/Makefile |    3 +
 drivers/vhost/blk.c    |  568 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/vhost/vhost.h  |   11 +
 fs/aio.c               |   44 ++---
 fs/eventfd.c           |    1 +
 include/linux/aio.h    |   31 +++
 6 files changed, 631 insertions(+), 27 deletions(-)
--
 Makefile.target |    2 +-
 hw/vhost_blk.c  |   84 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 hw/vhost_blk.h  |   44 ++++++++++++++++++++++++++++
 hw/virtio-blk.c |   74 ++++++++++++++++++++++++++++++++++++++----------
 hw/virtio-blk.h |   15 ++++++++++
 hw/virtio-pci.c |   12 ++++++-
 6 files changed, 213 insertions(+), 18 deletions(-)
                                                                                                                      

In-Reply-To: 

