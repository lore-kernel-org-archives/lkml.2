Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171Ab2D0No4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 09:44:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47574 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab2D0Noz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 09:44:55 -0400
MIME-Version: 1.0
Date: Fri, 27 Apr 2012 17:44:54 +0400
Message-ID: <CADF-jewF126u0ix9e5XoH_a6ndHakTeR=N0JKmPgi1qQFTw7OA@mail.gmail.com>
Subject: percpu embed allocator problem
From: Pavel Panteleev <panteleevp@gmail.com>
To: linux-mm@kvak.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have the following problem with pcpu embed allocator in kernel
2.6.33.1. pcpu_embed_first_chunk() function allocate only size_sum =
(ai->static_size + ai->reserved_size + ai->dyn_size) for an unit in
the group. So, for 4 groups (1 unit in each) and with memory only on
the first node I have the following:

pcpu_embed_first_chunk(): ai->groups[0].base_offset=0x0
pcpu_embed_first_chunk(): ai->groups[1].base_offset=0xa000
pcpu_embed_first_chunk(): ai->groups[2].base_offset=0x14000
pcpu_embed_first_chunk(): ai->groups[3].base_offset=0x1e000

pcpu_embed_first_chunk(): ai->unit_size=0x10000

It means, that for each group memory of size_sum=0xa000 is used only.
So, in the case of memory only on the first node, memory for the
following group will be allocated near the memory of the previous
group. Even though memory of size_sum=0xa000 is used only, but
ai->unit_size=0x10000.

After filling group_offsets and group_sizes in
pcpu_setup_first_chunk() function we have, that (group_offsets[i] +
group_sizes[i]) can be larger than group_offsets[i+1]. But in
pcpu_get_vm_areas() function there is checker, which tell us, that
such situation is impossible:

BUG_ON(start2 >= start && start2 < end);

May be  I should not use embed allocator in such situation?


Best regards,
Pavel V. Panteleev
