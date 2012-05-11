Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957Ab2EKNnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 09:43:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab2EKNnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 09:43:43 -0400
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4EB6917F.3000507@web.de>
Date: Fri, 11 May 2012 15:42:51 +0200
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Avi Kivity <avi@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <59D7E7EE-13D5-4D0C-B556-013A2897402E@suse.de>
References: <1314221904-28266-1-git-send-email-agraf@suse.de> <4EB6917F.3000507@web.de>
To: Jan Kiszka <jan.kiszka@web.de>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06.11.2011, at 14:54, Jan Kiszka wrote:

> On 2011-08-24 23:38, Alexander Graf wrote:
>> On LinuxCon I had a nice chat with Linus on what he thinks kvm-tool
>> would be doing and what he expects from it. Basically he wants a
>> small and simple tool he and other developers can run to try out and
>> see if the kernel they just built actually works.
>> 
>> Fortunately, QEMU can do that today already! The only piece that was
>> missing was the "simple" piece of the equation, so here is a script
>> that wraps around QEMU and executes a kernel you just built.
>> 
>> If you do have KVM around and are not cross-compiling, it will use
>> KVM. But if you don't, you can still fall back to emulation mode and
>> at least check if your kernel still does what you expect. I only
>> implemented support for s390x and ppc there, but it's easily extensible
>> to more platforms, as QEMU can emulate (and virtualize) pretty much
>> any platform out there.
>> 
>> If you don't have qemu installed, please do so before using this script. Your
>> distro should provide a package for it (might even call it "kvm"). If not,
>> just compile it from source - it's not hard!
>> 
>> To quickly get going, just execute the following as user:
>> 
>>    $ ./Documentation/run-qemu.sh -r / -a init=/bin/bash
>> 
>> This will drop you into a shell on your rootfs.
>> 
>> Happy hacking!
>> 
>> Signed-off-by: Alexander Graf <agraf@suse.de>
>> 
>> ---
>> 
>> v1 -> v2:
>> 
>>  - fix naming of QEMU
>>  - use grep -q for has_config
>>  - support multiple -a args
>>  - spawn gdb on execution
>>  - pass through qemu options
>>  - dont use qemu-system-x86_64 on i386
>>  - add funny sentence to startup text
>>  - more helpful error messages
>> ---
>> scripts/run-qemu.sh |  334 +++++++++++++++++++++++++++++++++++++++++++++++++++
>> 1 files changed, 334 insertions(+), 0 deletions(-)
>> create mode 100755 scripts/run-qemu.sh
>> 
>> diff --git a/scripts/run-qemu.sh b/scripts/run-qemu.sh
>> new file mode 100755
>> index 0000000..5d4e185
>> --- /dev/null
>> +++ b/scripts/run-qemu.sh
>> @@ -0,0 +1,334 @@
>> +#!/bin/bash
>> +#
>> +# QEMU Launcher
>> +#
>> +# This script enables simple use of the KVM and QEMU tool stack for
>> +# easy kernel testing. It allows to pass either a host directory to
>> +# the guest or a disk image. Example usage:
>> +#
>> +# Run the host root fs inside a VM:
>> +#
>> +# $ ./scripts/run-qemu.sh -r /
>> +#
>> +# Run the same with SDL:
>> +#
>> +# $ ./scripts/run-qemu.sh -r / --sdl
>> +# 
>> +# Or with a PPC build:
>> +#
>> +# $ ARCH=ppc ./scripts/run-qemu.sh -r /
>> +# 
>> +# PPC with a mac99 model by passing options to QEMU:
>> +#
>> +# $ ARCH=ppc ./scripts/run-qemu.sh -r / -- -M mac99
>> +#
>> +
>> +USE_SDL=
>> +USE_VNC=
>> +USE_GDB=1
>> +KERNEL_BIN=arch/x86/boot/bzImage
>> +MON_STDIO=
>> +KERNEL_APPEND2=
>> +SERIAL=ttyS0
>> +SERIAL_KCONFIG=SERIAL_8250
>> +BASENAME=$(basename "$0")
>> +
>> +function usage() {
>> +	echo "
>> +$BASENAME allows you to execute a virtual machine with the Linux kernel
>> +that you just built. To only execute a simple VM, you can just run it
>> +on your root fs with \"-r / -a init=/bin/bash\"
>> +
>> +	-a, --append parameters
>> +		Append the given parameters to the kernel command line.
>> +
>> +	-d, --disk image
>> +		Add the image file as disk into the VM.
>> +
>> +	-D, --no-gdb
>> +		Don't run an xterm with gdb attached to the guest.
>> +
>> +	-r, --root directory
>> +		Use the specified directory as root directory inside the guest.
>> +
>> +	-s, --sdl
>> +		Enable SDL graphical output.
>> +
>> +	-S, --smp cpus
>> +		Set number of virtual CPUs.
>> +
>> +	-v, --vnc
>> +		Enable VNC graphical output.
>> +
>> +Examples:
>> +
>> +	Run the host root fs inside a VM:
>> +	$ ./scripts/run-qemu.sh -r /
>> +
>> +	Run the same with SDL:
>> +	$ ./scripts/run-qemu.sh -r / --sdl
>> +	
>> +	Or with a PPC build:
>> +	$ ARCH=ppc ./scripts/run-qemu.sh -r /
>> +	
>> +	PPC with a mac99 model by passing options to QEMU:
>> +	$ ARCH=ppc ./scripts/run-qemu.sh -r / -- -M mac99
>> +"
>> +}
>> +
>> +function require_config() {
>> +	if [ "$(grep CONFIG_$1=y .config)" ]; then
>> +		return
>> +	fi
>> +
>> +	echo "You need to enable CONFIG_$1 for run-qemu to work properly"
>> +	exit 1
>> +}
>> +
>> +function has_config() {
>> +	grep -q "CONFIG_$1=y" .config
>> +}
>> +
>> +function drive_if() {
>> +	if has_config VIRTIO_BLK; then
>> +		echo virtio
>> +	elif has_config ATA_PIIX; then
>> +		echo ide
> 
> + require_config "BLK_DEV_SD"
> 
> Maybe there should also be a warning if no standard FS (ext[34], btrfs,
> xfs etc.) is build into the kernel.
> 
> Another thing, but that's just a recommendation for initrd-free mode:
> DEVTMPFS_MOUNT
> 
>> +	else
>> +		echo "\
>> +Your kernel must have either VIRTIO_BLK or ATA_PIIX
>> +enabled for block device assignment" >&2
>> +		exit 1
>> +	fi
>> +}
>> +
>> +GETOPT=`getopt -o a:d:Dhr:sS:v --long append,disk:,no-gdb,help,root:,sdl,smp:,vnc \
>> +	-n "$(basename \"$0\")" -- "$@"`
>> +
>> +if [ $? != 0 ]; then
>> +	echo "Terminating..." >&2
>> +	exit 1
>> +fi
>> +
>> +eval set -- "$GETOPT"
>> +
>> +while true; do
>> +	case "$1" in
>> +	-a|--append)
>> +		KERNEL_APPEND2="$KERNEL_APPEND2 $KERNEL_APPEND2"
> 
> That should be
> 
> KERNEL_APPEND2="$KERNEL_APPEND2 $2"
> 
>> +		shift
>> +		;;
>> +	-d|--disk)
>> +		QEMU_OPTIONS="$QEMU_OPTIONS -drive \
>> +			file=$2,if=$(drive_if),cache=unsafe"
> 
> 		if [ $? != 0 ]; then
> 			exit $?
> 		fi

Not sure I understand this one. There's no program executing here...


Alex

