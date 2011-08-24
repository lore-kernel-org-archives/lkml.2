Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab1HXI0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:26:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab1HXI0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:26:35 -0400
Message-ID: <4E54B590.9040408@redhat.com>
Date: Wed, 24 Aug 2011 11:25:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] KVM: Add wrapper script around Qemu to test kernels
References: <1314137806-5747-1-git-send-email-agraf@suse.de>
In-Reply-To: <1314137806-5747-1-git-send-email-agraf@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 01:16 AM, Alexander Graf wrote:
> On LinuxCon I had a nice chat with Linus on what he thinks kvm-tool
> would be doing and what he expects from it. Basically he wants a
> small and simple tool he and other developers can run to try out and
> see if the kernel they just built actually works.
>
> Fortunately, Qemu can do that today already! The only piece that was
> missing was the "simple" piece of the equation, so here is a script
> that wraps around Qemu and executes a kernel you just built.
>
> If you do have KVM around and are not cross-compiling, it will use
> KVM. But if you don't, you can still fall back to emulation mode and
> at least check if your kernel still does what you expect. I only
> implemented support for s390x and ppc there, but it's easily extensible
> to more platforms, as Qemu can emulate (and virtualize) pretty much
> any platform out there.
>
> If you don't have qemu installed, please do so before using this script. Your
> distro should provide a package for it (might even call it "kvm"). If not,
> just compile it from source - it's not hard!
>
> To quickly get going, just execute the following as user:
>
>      $ ./Documentation/run-qemu.sh -r / -a init=/bin/bash
>
> This will drop you into a shell on your rootfs.
>
> Happy hacking!
>
> +
> +function has_config() {
> +	grep "CONFIG_$1=y" .config
> +}

grep -q ?

> +	case "$1" in
> +	-a|--append)
> +		KERNEL_APPEND2="$2"

Might want to append to KERNEL_APPEND2, so you could have multiple -a args.

> +echo "
> +	################# Linux Qemu launcher #################
> +
> +This script executes your currently built Linux kernel using Qemu. If KVM is
> +available, it will also use KVM for fast virtualization of your guest.
> +
> +The intent is to make it very easy to run your kernel. If you need to do more
> +advanced things, such as passing through real devices, please take the command
> +line shown below and modify it to your needs. This tool is for simplicity, not
> +world dominating functionality coverage.

Device assignment could be useful for driver developers, yes.

> +"
> +echo "\
> +Your guest is bound to the current foreground shell. To quit the guest,
> +please use Ctrl-A x"
> +echo "  Executing: $QEMU_BIN $QEMU_OPTIONS -append \"$KERNEL_APPEND\" -smp $SMP"
> +echo
> +
> +exec $QEMU_BIN $QEMU_OPTIONS -append "$KERNEL_APPEND -smp $SMP"

Would be nice to support launching gdb in a separate terminal with 
vmlinux already loaded, and already attached to qemu.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

