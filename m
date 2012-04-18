Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab2DROvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:51:05 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58464 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750887Ab2DROvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:51:03 -0400
MIME-Version: 1.0
Date: Wed, 18 Apr 2012 10:51:01 -0400
Message-ID: <CAJoZ4U2tOsOCCn5qwRmBUytWei7gM+O3rTZch788DGOFe0apMQ@mail.gmail.com>
Subject: MMU notifier callbacks and forking
From: Kyle Hubert <khubert@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm writing a driver that pins user memory and stores it in a page
table so the device's own IOMMU can translate into host physical
addresses. I built up the MMU notifier callbacks (invalidate_page and
invalidate_range_start) to unpin the pages when the VM state changes.
This works as I expect for mmap/munmap. However, when fork() occurs,
copy_page_range will call invalidate_range_[start|end] if the range is
a COW mapping. I think it makes sense because the page range of both
the parent and child will be changed to remove VM_MAYWRITE. If anyone
tries to write, we take a page fault, then copy and mark the page as
VM_MAYWRITE in both MMs. Do I understand this correctly?

My problem is, in my callbacks I can't distinguish between
invalidate_range_start indicating the page should be freed or the
pages permissions are changing. Is it sufficient to set the VM flags
to VM_SHARED? What is the API to do this (or is it just find_vma and
modify the vm_flags while holding the mmap_sem)? If I understand the
code, this will prevent invalidate_range_[start|end] from being called
when forking. Are there other side effects when setting this?

Thanks for your help,
-Kyle Hubert
