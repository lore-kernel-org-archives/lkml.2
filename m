Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab2BNQ0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:26:44 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59166 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2BNQ0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:26:43 -0500
MIME-Version: 1.0
In-Reply-To: <20120214122205.GA29418@amit.redhat.com>
References: <20120203082748.GB782@amit.redhat.com> <20120214122205.GA29418@amit.redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 14 Feb 2012 08:26:22 -0800
Message-ID: <CALCETrVCzErebXrVk8Bi+k1TjigD3XvJsmZFVZb=ksmSCOTVLg@mail.gmail.com>
Subject: Re: vsyscall=emulate regression
To: Amit Shah <amit.shah@redhat.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 4:22 AM, Amit Shah <amit.shah@redhat.com> wrote:
> On (Fri) 03 Feb 2012 [13:57:48], Amit Shah wrote:
>> Hello,
>>
>> I'm booting some latest kernels on a Fedora 11 (released June 2009)
>> guest.  After the recent change of default to vsyscall=emulate, the
>> guest fails to boot (init segfaults).
>>
>> I also tried vsyscall=none, as suggested by hpa, and that fails as
>> well.  Only vsyscall=native works fine.
>>
>> The commit that introduced the kernel parameter,
>>
>> 3ae36655b97a03fa1decf72f04078ef945647c1a
>>
>> is bad too.
>
> I suggest we revert 2e57ae0515124af45dd889bfbd4840fd40fcc07d till we
> track down and fix the vsyscal=emulate case.

Hi-

Sorry, I lost track of this one.  I can't reproduce it, although I
doubt I've set up the right test environment.  But this is fishy:

init[1]: segfault at ffffffffff600400 ip ffffffffff600400 sp
00007fff9c8ba098 error 5

Error 5, if I'm decoding it correctly, is a userspace read (i.e. not
execute) fault.  The vsyscall emulation changes shouldn't have had any
effect on reads there.

Can you try booting the initramfs here:
http://web.mit.edu/luto/www/linux/vsyscall_initramfs.img
with your kernel image (i.e. qemu-kvm -kernel <whatever> -initrd
vsyscall_initramfs.img -whatever_else) and seeing what happens?  It
works for me.  That image is just a modern static build (i.e. built on
F16) of this code:

#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

typedef time_t (*vsys_time_t)(time_t *);

int main()
{
  vsys_time_t vsys_time = (vsys_time_t)(0xffffffffff600400);
  unsigned char *p = (char*)0xffffffffff600400;
  int i;

  printf("The time is %ld\n", (long)( vsys_time(0) ));

  printf("The first few bytes are:\n");
  for (i = 0; i < 16; i++) {
    unsigned char c = p[i];
    printf("%02x ", (int)c);
  }
  printf("\n");

  printf("All done\n");
  while(1)
    pause();
}

I'm also curious what happens if you run without kvm (i.e. straight
qemu) and what your .config on the guest kernel is.  It sounds like
something's wrong with your fixmap, which makes me wonder if your
qemu/kernel combo is capable of booting even a modern distro
(up-to-date F16, say) -- the vvar page uses identical fixmap flags as
the vsyscall page in vsyscall=emulate and vsyscall=none mode.

What host cpu are you on and what qemu flags do you use?  Maybe
something is wrong with your emulator.

--Andy
