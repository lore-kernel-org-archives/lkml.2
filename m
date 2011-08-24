Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab1HXRlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:41:03 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61802 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab1HXRlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:41:00 -0400
MIME-Version: 1.0
In-Reply-To: <1314137806-5747-1-git-send-email-agraf@suse.de>
References: <1314137806-5747-1-git-send-email-agraf@suse.de>
From: Blue Swirl <blauwirbel@gmail.com>
Date: Wed, 24 Aug 2011 17:40:38 +0000
Message-ID: <CAAu8pHucQ1RMiuZZEXhAnECX__SJZyutO26azwO4QYU4RZ7ZRA@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around Qemu to test kernels
To: Alexander Graf <agraf@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 10:16 PM, Alexander Graf <agraf@suse.de> wrote:
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
>    $ ./Documentation/run-qemu.sh -r / -a init=/bin/bash
>
> This will drop you into a shell on your rootfs.
>
> Happy hacking!
>
> Signed-off-by: Alexander Graf <agraf@suse.de>
> ---
>  Documentation/run-qemu.sh |  284 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 284 insertions(+), 0 deletions(-)
>  create mode 100755 Documentation/run-qemu.sh
>
> diff --git a/Documentation/run-qemu.sh b/Documentation/run-qemu.sh
> new file mode 100755
> index 0000000..0bac924
> --- /dev/null
> +++ b/Documentation/run-qemu.sh
> @@ -0,0 +1,284 @@
> +#!/bin/bash
> +#
> +# QEMU Launcher
> +#
> +# This script enables simple use of the KVM and Qemu tool stack for

QEMU

> +# easy kernel testing. It allows to pass either a host directory to
> +# the guest or a disk image. Example usage:
> +#
> +# Run the host root fs inside a VM:
> +#
> +# $ ./Documentation/run-qemu.sh -r /
> +#
> +# Run the same with SDL:
> +#
> +# $ ./Documentation/run-qemu.sh -r / --sdl
> +#
> +# Or with a PPC build:
> +#
> +# $ ARCH=ppc ./Documentation/run-qemu.sh -r /
> +#
> +#
> +
> +USE_SDL=
> +USE_VNC=
> +KERNEL_BIN=arch/x86/boot/bzImage
> +MON_STDIO=
> +KERNEL_APPEND2=
> +SERIAL=ttyS0
> +SERIAL_KCONFIG=SERIAL_8250
> +
> +function usage() {
> +       echo "
> +Run-Qemu allows you to execute a virtual machine with the Linux kernel

run-qemu.sh or $0

> +that you just built. To only execute a simple VM, you can just run it
> +on your root fs with \"-r / -a init=/bin/bash\"
> +
> +       -a, --append parameters
> +               Append the given parameters to the kernel command line
> +
> +       -d, --disk image
> +               Add the image file as disk into the VM
> +
> +       -r, --root directory
> +               Use the specified directory as root directory inside the guest.
> +
> +       -s, --sdl
> +               Enable SDL graphical output.
> +
> +       -S, --smp cpus
> +               Set number of virtual CPUs
> +
> +       -v, --vnc
> +               Enable VNC graphical output.
> +
> +Examples:
> +
> +       Run the host root fs inside a VM:
> +       $ ./Documentation/run-qemu.sh -r /
> +
> +       Run the same with SDL:
> +       $ ./Documentation/run-qemu.sh -r / --sdl
> +
> +       Or with a PPC build:
> +       $ ARCH=ppc ./Documentation/run-qemu.sh -r /
> +"
> +}
> +
> +function require_config() {
> +       if [ "$(grep CONFIG_$1=y .config)" ]; then
> +               return
> +       fi
> +
> +       echo "You need to enable CONFIG_$1 for run-qemu to work properly"
> +       exit 1
> +}
> +
> +function has_config() {
> +       grep "CONFIG_$1=y" .config
> +}
> +
> +function drive_if() {
> +       if [ "$(has_config VIRTIO_BLK)" ]; then
> +               echo virtio
> +       elif [ "$(has_config ATA_PIIX)" ]; then
> +               echo ide
> +       else
> +               echo "\
> +Your kernel must have either VIRTIO_BLK or ATA_PIIX
> +enabled for block device assignment" >&2
> +               exit 1
> +       fi
> +}
> +
> +GETOPT=`getopt -o a:d:hr:sS:v --long append,disk:,help,root:,sdl,smp:,vnc \
> +       -n "$(basename \"$0\")" -- "$@"`
> +
> +if [ $? != 0 ]; then
> +       echo "Terminating..." >&2
> +       exit 1
> +fi
> +
> +eval set -- "$GETOPT"
> +
> +while true; do
> +       case "$1" in
> +       -a|--append)
> +               KERNEL_APPEND2="$2"
> +               shift 2
> +               ;;
> +       -d|--disk)
> +               QEMU_OPTIONS="$QEMU_OPTIONS -drive \
> +                       file=$2,if=$(drive_if),cache=unsafe"
> +               USE_DISK=1
> +               shift 2
> +               ;;
> +       -h|--help)
> +               usage
> +               exit 0
> +               ;;
> +       -r|--root)
> +               ROOTFS="$2"
> +               shift 2
> +               ;;
> +       -s|--sdl)
> +               USE_SDL=1
> +               shift
> +               ;;
> +       -S|--smp)
> +               SMP="$2"
> +               shift 2
> +               ;;
> +       -v|--vnc)
> +               USE_VNC=1
> +               shift
> +               ;;
> +       --)
> +               shift
> +               break
> +               ;;
> +       *)
> +               echo "Could not parse option: $1" >&2
> +               exit 1
> +               ;;
> +       esac
> +done
> +
> +if [ ! "$ROOTFS" -a ! "$USE_DISK" ]; then
> +       echo "\
> +Error: Please specify at least -r or -d with a target \
> +FS to run off of" >&2
> +       exit 1
> +fi
> +
> +# Try to find the KVM accelerated Qemu binary
> +
> +[ "$ARCH" ] || ARCH=$(uname -m)
> +case $ARCH in
> +i*86|x86_64)
> +       KERNEL_BIN=arch/x86/boot/bzImage
> +       # SUSE and Red Hat call the binary qemu-kvm
> +       [ "$QEMU_BIN" ] || QEMU_BIN=$(which qemu-kvm 2>/dev/null)
> +
> +       # Debian and Gentoo call it kvm
> +       [ "$QEMU_BIN" ] || QEMU_BIN=$(which kvm 2>/dev/null)
> +
> +       # Qemu's own build system calls it qemu-system-x86_64
> +       [ "$QEMU_BIN" ] || QEMU_BIN=$(which qemu-system-x86_64 2>/dev/null)

If you run qemu-system-x86_64 on an i386 host, will it use kvm at all?
If testing kvm  is not needed, then why don't you just grab the target
CPU from .config and use qemu-system-$CPU?

> +
> +       # i386 version of Qemu
> +       if [ ! "$(has_config X86_64)" ]; then
> +               [ "$QEMU_BIN" ] || QEMU_BIN=$(which qemu 2>/dev/null)

I'd just make a separate case for i386, even if the first two checks
are duplicated.

> +       fi
> +       ;;
> +s390*)
> +       KERNEL_BIN=arch/s390/boot/image
> +       [ "$QEMU_BIN" ] || QEMU_BIN=$(which qemu-system-s390x 2>/dev/null)
> +       ;;
> +ppc*)
> +       KERNEL_BIN=vmlinux
> +
> +       IS_64BIT=
> +       [ "$(has_config PPC64)" ] && IS_64BIT=64
> +       if [ "$(has_config PPC_85xx)" ]; then
> +               QEMU_OPTIONS="$QEMU_OPTIONS -M mpc8544ds"
> +       elif [ "$(has_config PPC_PSERIES)" ]; then
> +               QEMU_OPTIONS="$QEMU_OPTIONS -M pseries"
> +               SERIAL=hvc0
> +               SERIAL_KCONFIG=HVC_CONSOLE
> +       elif [ "$(has_config PPC_PMAC)" ]; then
> +               [ "$(has_config SERIAL_PMACZILOG_TTYS)" ] || SERIAL=ttyPZ0
> +               SERIAL_KCONFIG=SERIAL_PMACZILOG
> +       else
> +               echo "Unknown PPC board" >&2
> +               exit 1
> +       fi
> +
> +       [ "$QEMU_BIN" ] || QEMU_BIN=$(which qemu-system-ppc${IS_64BIT} 2>/dev/null)
> +       ;;
> +esac
> +
> +if [ ! "$QEMU_BIN" ]; then
> +       echo "\
> +Could not find a usable Qemu binary. Please install one from \
> +your distro or from source code." >&2
> +       exit 1
> +fi
> +
> +# The binaries without kvm in their name can be too old to support KVM, so
> +# check for that before the user gets confused
> +if [ ! "$(echo $QEMU_BIN | grep kvm)" -a \
> +     ! "$($QEMU_BIN --help | egrep '^-machine')" ]; then
> +       echo "Your Qemu binary is too old, please update to at least 0.15." >&2
> +       exit 1
> +fi
> +QEMU_OPTIONS="$QEMU_OPTIONS -machine accel=kvm:tcg"
> +
> +# We need to check some .config variables to make sure we actually work
> +# on the respective kernel.
> +if [ ! -e .config ]; then
> +       echo "\
> +Please run this script on a fully compiled and configured
> +Linux kernel build directory" >&2
> +       exit 1
> +fi
> +
> +if [ ! -e "$KERNEL_BIN" ]; then
> +       echo "Could not find kernel binary: $KERNEL_BIN" >&2
> +       exit 1
> +fi
> +
> +QEMU_OPTIONS="$QEMU_OPTIONS -kernel $KERNEL_BIN"
> +
> +if [ "$USE_SDL" ]; then
> +       # SDL is the default, so nothing to do
> +       :
> +elif [ "$USE_VNC" ]; then
> +       QEMU_OPTIONS="$QEMU_OPTIONS -vnc :5"
> +else
> +       # When emulating a serial console, tell the kernel to use it as well
> +       QEMU_OPTIONS="$QEMU_OPTIONS -nographic"
> +       KERNEL_APPEND="$KERNEL_APPEND console=$SERIAL earlyprintk=serial"
> +       MON_STDIO=1
> +       require_config "$SERIAL_KCONFIG"
> +fi
> +
> +if [ "$ROOTFS" ]; then
> +       # Using rootfs with 9p
> +       require_config "NET_9P_VIRTIO"
> +       KERNEL_APPEND="$KERNEL_APPEND \
> +root=/dev/root rootflags=rw,trans=virtio,version=9p2000.L rootfstype=9p"
> +
> +#Usage: -virtfs fstype,path=/share_path/,security_model=[mapped|passthrough|none],mount_tag=tag.
> +
> +
> +       QEMU_OPTIONS="$QEMU_OPTIONS \
> +-virtfs local,id=root,path=$ROOTFS,mount_tag=root,security_model=passthrough \
> +-device virtio-9p-pci,fsdev=root,mount_tag=/dev/root"
> +fi
> +
> +[ "$SMP" ] || SMP=1
> +
> +# User append args come last
> +KERNEL_APPEND="$KERNEL_APPEND $KERNEL_APPEND2"
> +
> +############### Execution #################
> +
> +echo "
> +       ################# Linux Qemu launcher #################
> +
> +This script executes your currently built Linux kernel using Qemu. If KVM is
> +available, it will also use KVM for fast virtualization of your guest.
> +
> +The intent is to make it very easy to run your kernel. If you need to do more
> +advanced things, such as passing through real devices, please take the command
> +line shown below and modify it to your needs. This tool is for simplicity, not
> +world dominating functionality coverage.

Please add this:
(just a hobby, won't be big and professional like libvirt)

Though usually Unix tools should be terse unless the user specifies -v.

> +"
> +echo "\
> +Your guest is bound to the current foreground shell. To quit the guest,
> +please use Ctrl-A x"
> +echo "  Executing: $QEMU_BIN $QEMU_OPTIONS -append \"$KERNEL_APPEND\" -smp $SMP"
> +echo
> +
> +exec $QEMU_BIN $QEMU_OPTIONS -append "$KERNEL_APPEND -smp $SMP"

How about something like this (modulo quoting to allow compiling the
kernel in C:\Documents and Settings\agraf\):
CMD="$QEMU_BIN $QEMU_OPTIONS -append $KERNEL_APPEND -smp $SMP"
echo "  Executing: $CMD"
exec $CMD
