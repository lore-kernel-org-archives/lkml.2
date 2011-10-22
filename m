Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab1JVRGJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 13:06:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51408 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1JVRGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 13:06:07 -0400
MIME-Version: 1.0
Date: Sat, 22 Oct 2011 13:06:06 -0400
Message-ID: <CALKntY3Xo6R2zLs8oM=+=-VPdFXeLsdGi_YbMiA_1085xhMOQw@mail.gmail.com>
Subject: copy_*_user
From: Xin Tong <xerox.time.tech@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am investigating copy_from_user  and copy_to_user in linux under
i386. These two function both take a pointer with virtual address and
a pointer with physical address.

copy_from_user calls __copy_from_user_ll and copy_to_user  calls
__copy_to_user_ll. It make sense to me that __copy_to_user_ll converts
the virtual address to physical address using the current process's
page table.


unsigned long __copy_to_user_ll(void __user *to, const void *from,
unsigned long n)
{
   ...
    retval = get_user_pages(current, current->mm,
                                        (unsigned long)to, 1, 1, 0, &pg, NULL);

                        if (retval == -ENOMEM && is_global_init(current)) {
                                up_read(&current->mm->mmap_sem);
                                congestion_wait(BLK_RW_ASYNC, HZ/50);
                                goto survive;
                        }

                        if (retval != 1) {
                                up_read(&current->mm->mmap_sem);
                                break;
                        }

       maddr = kmap_atomic(pg, KM_USER0);
       memcpy(maddr + offset, from, len);
     ...
}

But it seems to be that __copy_from_user_ll  is not converted the
address at all before attempting to copy. Can someone help explain to
me why ?


Thanks
