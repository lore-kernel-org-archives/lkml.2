Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386Ab1LOAd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 19:33:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757905Ab1LOAdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 19:33:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFxEszjub9-MJD0irFs8y3hzGe3Ph=7RqWfkJ-0jKFtCeA@mail.gmail.com>
References: <CA+55aFxEszjub9-MJD0irFs8y3hzGe3Ph=7RqWfkJ-0jKFtCeA@mail.gmail.com> <20111214114016.9441.12006.stgit@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [PATCH] Fix order_base_2(0)
Date: Thu, 15 Dec 2011 00:33:44 +0000
Message-ID: <24657.1323909224@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Does anybody actually *want* order_base_2(0)?

There aren't actually that many users:

| arch/mips/include/asm/mach-powertv/ioremap.h:#define _IOR_OFFSET_WIDTH(n)    (1 << order_base_2(n))

Doesn't look like it should ever be 0.  In fact, this looks like a case for
using roundup_pow_of_two() directly.

| arch/powerpc/platforms/pseries/iommu.c:       len = order_base_2(max_addr);

Not sure.  Doesn't look likely, but can memory_hotplug_max() be 0 if hotplug
is not supported?

| arch/x86/kvm/x86.c:   return hash_32(gfn & 0xffffffff, order_base_2(ASYNC_PF_PER_VCPU));

Constant 64.  Can't be 0.

| fs/ext4/indirect.c:   blk_bits = order_base_2(lblock);

lblock *could* perhaps be 0.  Being negative is checked for, but not for it
being 0.

| fs/ext4/mballoc.c:    int blocksize_bits = order_base_2(size);
| fs/jbd2/journal.c:    int i = order_base_2(size) - 10;

Can't be 0.

| fs/jbd2/journal.c:    int i = order_base_2(size) - 10;

Hmmm...  Can jbd2_alloc() be given a 0 size?  (Or jbd2_free() for that matter)

| mm/percpu-km.c:       pages = alloc_pages(GFP_KERNEL, order_base_2(nr_pages));
| mm/percpu-km.c:               __free_pages(chunk->data, order_base_2(nr_pages));

Can pcpu_group_sizes[0] be less than PAGE_SIZE?

I can't tell from a cursory inspection of pcpu_setup_first_chunk().

In fact, pcpu_create_chunk() could do order_base_2() then subtract PAGE_SHIFT
rather than shifting and then taking the log.

David
