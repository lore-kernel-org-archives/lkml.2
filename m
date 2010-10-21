Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab0JUQVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 12:21:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37986 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab0JUQVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 12:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=mOBl1v8/BWzUk2CqLKKEuny2Xd3y0Vm+qZOuWI8dAkyNLhPBq4O5UtDCOdf9dHqr9Z
         7RfnLIIM4hjzroIgQl/yvCUDE6gKMf+CqQ//wLdsNgtAE2TFDAnMdVLWC6Zgfz00ZlnN
         BM5O+QYP278cRingKLsQ7Q0WIhR7ZLEu7Fzh8=
MIME-Version: 1.0
Date: Thu, 21 Oct 2010 12:21:15 -0400
Message-ID: <AANLkTikKFnVOFr70u_2Hdtz0mXuAEckWWUy885m_ut--@mail.gmail.com>
Subject: Disable L1/L2/L3 cache and MTRR
From: Andev <debiandev@gmail.com>
To: linux kernel <kernelnewbies@nl.linux.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

You need to set the 30th bit of CR0 register to disable the cache.
I've tried disabling the L1/L2/L3 cache in an intel processor as follows.

#include <linux/init.h>
#include <linux/module.h>
MODULE_LICENSE("Dual BSD/GPL");
static int hello_init(void)
{
        printk(KERN_ALERT "Hello, world\n");
        __asm__("push   %rax\n\t"
                "mov    %cr0,%rax;\n\t"
                "or     $(1 << 30),%rax;\n\t"
                "mov    %rax,%cr0;\n\t"
                "wbinvd\n\t"
                "pop    %rax"
);
        return 0;
}
static void hello_exit(void)
{
        printk(KERN_ALERT "Goodbye, cruel world\n");
        __asm__("push   %rax\n\t"
                "mov    %cr0,%rax;\n\t"
                "and     $~(1 << 30),%rax;\n\t"
                "mov    %rax,%cr0;\n\t"
                "pop    %rax"
);
}
module_init(hello_init);
module_exit(hello_exit);

When I try to remove this module, the system hangs! Any help?

In Intel software developers manual, it is mentioned that apart from the
above you need to disable MTRR. I did that using the following command:

echo "disable=00" >| /proc/mtrr

Now when I run some sample benchmarks they show a slowdown of almost 1000x!!

This is not reasonable since the max. The slowdown I was expecting is 200x
considering that it will take 200 cycles to read from DRAM.

Thanks,
Andev.
