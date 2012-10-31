Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab2JaWrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 18:47:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39654 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760923Ab2JaWrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 18:47:01 -0400
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        sjur@brendeland.net, dmitry.tarnyagin@stericsson.com
Subject: [RFC virtio-next 0/4] Introduce CAIF Virtio and reversed Vrings
Date: Wed, 31 Oct 2012 23:46:50 +0100
Message-Id: <1351723614-4145-1-git-send-email-sjur@brendeland.net>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set introduces the CAIF Virtio Link layer. The purpose is to
communicate with a remote processor (a modem) over shared memory. Virtio
is used as the transport mechanism, and the Remoteproc framework provides
configuration and management of the Virtio rings and devices. The modem
and Linux host may be on the same SoC, or connected over a shared memory
interface such as LLI.

Zero-Copy data transport on the modem is primary goal for CAIF Virtio.
In order to achieve Zero-Copy the direction of the Virtio rings are
flipped in the RX direction. So we have implemented the Virtio
access-function similar to what is found in vhost.c.

The connected LTE-modem is a multi-processor system with an advanced
memory allocator on board. In order to provide zero-copy from the modem
to the connected Linux host, the direction of the Virtio rings are
reversed. This allows the modem to allocate data-buffers in RX
direction and pass them to the Linux host, and recycled buffers to be
sent back to the modem.

The option of providing pre-allocated buffers in RX direction has been
considered, but rejected. The allocation of data buffers happens deep
down in the network signaling stack on the LTE modem before it is known
what type of data is received. It may be data that is handled within the
modem and never sent to the Linux host, or IP traffic going to the host.
Pre-allocated Virtio buffers does not fit for this usage. Another issue
is that the network traffic pattern may vary, resulting in variation of
number and size of buffers allocated from the memory allocator. Dynamic
allocation is needed in order to utilize memory properly. Due to this,
we decided we had to implement "reversed" vrings. Reversed vrings allows
us to minimize the impact on the current memory allocator and buffer
handling on the modem. 

In order to implement reversed rings we have added functions for reading
descriptors from the available-ring and adding descriptors to the used-ring.
The internal data-structures in virtio_ring.c are moved into a new header
file so the data-structures can be accessed by caif_virtio.

The data buffers in TX direction are allocated using dma_alloc_coherent().
This allows memory to be allocated from the memory region shared between
the Host and modem.

In TX direction single linearized TX buffers are added to the vring. In
RX direction linearized frames are also used, but multiple descriptors may
be linked. This is done to allow maximum efficiency for the LTE modem.

This patch set is not yet fully tested and does not handle all negative
scenarios correctly. So at this stage we're primarily looking for review
comments related to the structure of the Virtio code. There are several
options on how to structure this, and feedback is welcomed.

Thanks,
Sjur

Sjur Brændeland (4):
  virtio: Move definitions to header file vring.h
  include/vring.h: Add support for reversed vritio rings.
  virtio_ring: Call callback function even when used ring is empty
  caif_virtio: Add CAIF over virtio

 drivers/net/caif/Kconfig               |    9 +
 drivers/net/caif/Makefile              |    3 +
 drivers/net/caif/caif_virtio.c         |  627 ++++++++++++++++++++++++++++++++
 drivers/remoteproc/remoteproc_virtio.c |    2 +-
 drivers/virtio/virtio_ring.c           |  102 +-----
 drivers/virtio/vring.h                 |  124 +++++++
 include/linux/virtio_ring.h            |    8 +-
 include/uapi/linux/virtio_ids.h        |    1 +
 8 files changed, 776 insertions(+), 100 deletions(-)
 create mode 100644 drivers/net/caif/caif_virtio.c
 create mode 100644 drivers/virtio/vring.h

-- 
1.7.9.5

