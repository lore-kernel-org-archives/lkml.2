Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1FJILo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:11:44 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59601 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab1FJILl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:11:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D/Az6jPegybfSGw2WoWBzIRoHDIaWhFBJyaV360jZpAotUlUhY/JSaN8efoCfMz0cO
         RKRsxdDrGzcyObipFNHnuLAUiWQAF8Tr4czpn7icikTEqcd0FAZJ2RA/ic8FX5IfoV8j
         4YTHR/VF0ZIhQtH/Qd20uy+wS/dGLWb8zqb3A=
MIME-Version: 1.0
In-Reply-To: <20110609155630.0f734351.akpm@linux-foundation.org>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com>
	<1307642718-22257-1-git-send-email-minipli@googlemail.com>
	<20110609155630.0f734351.akpm@linux-foundation.org>
Date: Fri, 10 Jun 2011 10:11:39 +0200
Message-ID: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
Subject: Re: [PATCH] init: use KERNEL_DS when trying to start init process
From: Mathias Krause <minipli@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 12:56 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu,  9 Jun 2011 20:05:18 +0200
> Mathias Krause <minipli@googlemail.com> wrote:
>
>> Subject: [PATCH] exec: delay address limit change until point of no return
>>
>> Unconditionally changing the address limit to USER_DS and not restoring
>> it to its old value in the error path is wrong because it prevents us
>> using kernel memory on repeated calls to this function. This, in fact,
>> breaks the fallback of hard coded paths to the init program from being
>> ever successful if the first candidate fails to load.
>>
>> With this patch applied switching to USER_DS is delayed until the point
>> of no return is reached which makes it possible to have a multi-arch
>> rootfs with one arch specific init binary for each of the (hard coded)
>> probed paths.
>>
>> Since the address limit is already set to USER_DS when start_thread()
>> will be invoked, this redundancy can be safely removed.
>
> A couple of things here, please.
>
> The description doesn't describe the user-visible symptoms of the bug.

For current users there is no visible symptom. Current kernels will
just fail to start init when you try to rely on the fallback mechanism
of the kernel searching for init in different paths when building a
multi-arch rootfs. It just won't work if the first init binary fails
to start.

Maybe related, the bugzilla entry:
https://bugzilla.kernel.org/show_bug.cgi?id=36692

> This makes it hard for the -stable maintainers to work out whether they
> should accept the patch and it makes it hard for random distro
> maintainers to determine whether your patch might fix a user bug report
> which they're working on.

I think the first paragraph should have made clear what is wrong with
current kernels and the second one should have pointed out the
possibilities one has with this bug being fixed. It's broken since the
very beginning (Linus pointed to some 2.4.3 kernel) and personally I
would like to have it in the .32 longterm kernel, too.

> Secondly, I understand that we have identified changes which other arch
> maintainers should make and test.  Please describe those changes to
> make it easy for them and please also describe a way in which they can
> test that change.

The changes for the other architectures are more of a cleanup than a
bug fix. They're calling set_fs(USER_DS) either in flush_thread() or
start_thread() which is unnecessary because they're already running
under USER_DS. But they did so even before my patch, so no "visible
changes" here. I've some follow up patches in the making to remove
those set_fs() calls but fall asleep last night so didn't finish them,
yet. Maybe later the day.

> Both these things could be addressed using a description of some
> testcase.

That's true -- I owe you a test case, so here it is:

Assume you want to build a multi-arch rootfs, e.g. combined 32 and 64
bit x86 (without CONFIG_IA32_EMULATION) or x86 + ARM + SPARC to have
one rootfs usable on a couple of different machines just by using a
different kernel. You could do this by providing a statically linked
init binary for each architecture and place them under /sbin/init,
/etc/init, /bin/init and /bin/sh. The kernel will fail to start
binaries not made for its native architecture but it should be able to
start the init binary build for its architecture. This is what is
currently broken and can be verified with the following test (assuming
a x86-64 environment):

cat<<EOT >hello.c
#include <unistd.h>
#include <stdio.h>

int main(void) {
    printf("Hello %s world!\n", sizeof(int) == sizeof(long) ? "32" : "64");
    pause();

    return 0;
}
EOT

mkdir -p rootfs/etc rootfs/bin
gcc -static -m64 hello.c -o rootfs/etc/init
gcc -static -m32 hello.c -o rootfs/bin/init

cat<<EOT | gen_init_cpio - | gzip > initfs.gz
dir  /dev                        0755 0 0
nod  /dev/console                0600 0 0 c 5 1
file /init      /dev/null        0644 0 0
dir  /sbin                       0755 0 0
file /sbin/init /dev/null        0755 0 0
dir  /etc                        0755 0 0
file /etc/init  rootfs/etc/init  0755 0 0
dir  /bin                        0755 0 0
file /bin/init  rootfs/bin/init  0755 0 0
EOT

This generates an initramfs that won't boot on a current kernel
(3.0-rc2) but will, with the above patch applied.

Just some notes regarding the rootfs layout:
* The dummy /init file is needed, so the kernel won't call
prepare_namespace(). Otherwise it won't accept the initramfs as its
rootfs.
* The empty (but executable!) file /sbin/init should be the binary for
the "wrong" architecture, so won't execute. This should make the
kernel go ahead and try /etc/init.
* If you're running a 64 bit kernel /etc/init should start and print
out "Hello 64 bit world!", otherwise the kernel should fail to start
this binary and go ahead to /bin/init.
* Finally, if /etc/init failed, /bin/init should start and print out
"Hello 32 bit world!".

To use this test case for other architectures then x86 just skip the
etc/init file and remove the -m32 compiler switch. The dummy file
/sbin/init should make current kernels fail and kernels with the patch
applied succeed.

Mathias
