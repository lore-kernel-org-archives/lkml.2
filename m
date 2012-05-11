Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155Ab2EKOPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:15:13 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:56705 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab2EKOPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:15:10 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 May 2012 10:15:09 EDT
Message-ID: <4FAD1C97.5080803@web.de>
Date: Fri, 11 May 2012 11:05:11 -0300
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <1314221904-28266-1-git-send-email-agraf@suse.de> <4EB6917F.3000507@web.de> <59D7E7EE-13D5-4D0C-B556-013A2897402E@suse.de>
In-Reply-To: <59D7E7EE-13D5-4D0C-B556-013A2897402E@suse.de>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFD5DC776DCEE5B39D1CB4D75"
X-Provags-ID: V02:K0:YFrzu6v5Q+LpeWSeJUK/Ojy2aDNvUA7oUH3/8Hd8c8I
 smBk3PvBtmS2Lj3iBiMoczfGg7AoGoHb+8cVhZOB+I2euAjM+G
 bugzduYmcwTL91Nyz9TfwArMcKzQqGK32zaSEbm53Bh5sZ0BBw
 yagSON8XRuFaU4/n9rDtTkYf7zX7uONnvx/mzg7JVEGwTQOh1t
 eEQgLF1kdi4BdYzqbyheg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFD5DC776DCEE5B39D1CB4D75
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-05-11 10:42, Alexander Graf wrote:
>=20
> On 06.11.2011, at 14:54, Jan Kiszka wrote:
>=20
>> On 2011-08-24 23:38, Alexander Graf wrote:
>>> On LinuxCon I had a nice chat with Linus on what he thinks kvm-tool
>>> would be doing and what he expects from it. Basically he wants a
>>> small and simple tool he and other developers can run to try out and
>>> see if the kernel they just built actually works.
>>>
>>> Fortunately, QEMU can do that today already! The only piece that was
>>> missing was the "simple" piece of the equation, so here is a script
>>> that wraps around QEMU and executes a kernel you just built.
>>>
>>> If you do have KVM around and are not cross-compiling, it will use
>>> KVM. But if you don't, you can still fall back to emulation mode and
>>> at least check if your kernel still does what you expect. I only
>>> implemented support for s390x and ppc there, but it's easily extensib=
le
>>> to more platforms, as QEMU can emulate (and virtualize) pretty much
>>> any platform out there.
>>>
>>> If you don't have qemu installed, please do so before using this scri=
pt. Your
>>> distro should provide a package for it (might even call it "kvm"). If=
 not,
>>> just compile it from source - it's not hard!
>>>
>>> To quickly get going, just execute the following as user:
>>>
>>>    $ ./Documentation/run-qemu.sh -r / -a init=3D/bin/bash
>>>
>>> This will drop you into a shell on your rootfs.
>>>
>>> Happy hacking!
>>>
>>> Signed-off-by: Alexander Graf <agraf@suse.de>
>>>
>>> ---
>>>
>>> v1 -> v2:
>>>
>>>  - fix naming of QEMU
>>>  - use grep -q for has_config
>>>  - support multiple -a args
>>>  - spawn gdb on execution
>>>  - pass through qemu options
>>>  - dont use qemu-system-x86_64 on i386
>>>  - add funny sentence to startup text
>>>  - more helpful error messages
>>> ---
>>> scripts/run-qemu.sh |  334 ++++++++++++++++++++++++++++++++++++++++++=
+++++++++
>>> 1 files changed, 334 insertions(+), 0 deletions(-)
>>> create mode 100755 scripts/run-qemu.sh
>>>
>>> diff --git a/scripts/run-qemu.sh b/scripts/run-qemu.sh
>>> new file mode 100755
>>> index 0000000..5d4e185
>>> --- /dev/null
>>> +++ b/scripts/run-qemu.sh
>>> @@ -0,0 +1,334 @@
>>> +#!/bin/bash
>>> +#
>>> +# QEMU Launcher
>>> +#
>>> +# This script enables simple use of the KVM and QEMU tool stack for
>>> +# easy kernel testing. It allows to pass either a host directory to
>>> +# the guest or a disk image. Example usage:
>>> +#
>>> +# Run the host root fs inside a VM:
>>> +#
>>> +# $ ./scripts/run-qemu.sh -r /
>>> +#
>>> +# Run the same with SDL:
>>> +#
>>> +# $ ./scripts/run-qemu.sh -r / --sdl
>>> +#=20
>>> +# Or with a PPC build:
>>> +#
>>> +# $ ARCH=3Dppc ./scripts/run-qemu.sh -r /
>>> +#=20
>>> +# PPC with a mac99 model by passing options to QEMU:
>>> +#
>>> +# $ ARCH=3Dppc ./scripts/run-qemu.sh -r / -- -M mac99
>>> +#
>>> +
>>> +USE_SDL=3D
>>> +USE_VNC=3D
>>> +USE_GDB=3D1
>>> +KERNEL_BIN=3Darch/x86/boot/bzImage
>>> +MON_STDIO=3D
>>> +KERNEL_APPEND2=3D
>>> +SERIAL=3DttyS0
>>> +SERIAL_KCONFIG=3DSERIAL_8250
>>> +BASENAME=3D$(basename "$0")
>>> +
>>> +function usage() {
>>> +	echo "
>>> +$BASENAME allows you to execute a virtual machine with the Linux ker=
nel
>>> +that you just built. To only execute a simple VM, you can just run i=
t
>>> +on your root fs with \"-r / -a init=3D/bin/bash\"
>>> +
>>> +	-a, --append parameters
>>> +		Append the given parameters to the kernel command line.
>>> +
>>> +	-d, --disk image
>>> +		Add the image file as disk into the VM.
>>> +
>>> +	-D, --no-gdb
>>> +		Don't run an xterm with gdb attached to the guest.
>>> +
>>> +	-r, --root directory
>>> +		Use the specified directory as root directory inside the guest.
>>> +
>>> +	-s, --sdl
>>> +		Enable SDL graphical output.
>>> +
>>> +	-S, --smp cpus
>>> +		Set number of virtual CPUs.
>>> +
>>> +	-v, --vnc
>>> +		Enable VNC graphical output.
>>> +
>>> +Examples:
>>> +
>>> +	Run the host root fs inside a VM:
>>> +	$ ./scripts/run-qemu.sh -r /
>>> +
>>> +	Run the same with SDL:
>>> +	$ ./scripts/run-qemu.sh -r / --sdl
>>> +=09
>>> +	Or with a PPC build:
>>> +	$ ARCH=3Dppc ./scripts/run-qemu.sh -r /
>>> +=09
>>> +	PPC with a mac99 model by passing options to QEMU:
>>> +	$ ARCH=3Dppc ./scripts/run-qemu.sh -r / -- -M mac99
>>> +"
>>> +}
>>> +
>>> +function require_config() {
>>> +	if [ "$(grep CONFIG_$1=3Dy .config)" ]; then
>>> +		return
>>> +	fi
>>> +
>>> +	echo "You need to enable CONFIG_$1 for run-qemu to work properly"
>>> +	exit 1
>>> +}
>>> +
>>> +function has_config() {
>>> +	grep -q "CONFIG_$1=3Dy" .config
>>> +}
>>> +
>>> +function drive_if() {
>>> +	if has_config VIRTIO_BLK; then
>>> +		echo virtio
>>> +	elif has_config ATA_PIIX; then
>>> +		echo ide
>>
>> + require_config "BLK_DEV_SD"
>>
>> Maybe there should also be a warning if no standard FS (ext[34], btrfs=
,
>> xfs etc.) is build into the kernel.
>>
>> Another thing, but that's just a recommendation for initrd-free mode:
>> DEVTMPFS_MOUNT
>>
>>> +	else
>>> +		echo "\
>>> +Your kernel must have either VIRTIO_BLK or ATA_PIIX
>>> +enabled for block device assignment" >&2
>>> +		exit 1
>>> +	fi
>>> +}
>>> +
>>> +GETOPT=3D`getopt -o a:d:Dhr:sS:v --long append,disk:,no-gdb,help,roo=
t:,sdl,smp:,vnc \
>>> +	-n "$(basename \"$0\")" -- "$@"`
>>> +
>>> +if [ $? !=3D 0 ]; then
>>> +	echo "Terminating..." >&2
>>> +	exit 1
>>> +fi
>>> +
>>> +eval set -- "$GETOPT"
>>> +
>>> +while true; do
>>> +	case "$1" in
>>> +	-a|--append)
>>> +		KERNEL_APPEND2=3D"$KERNEL_APPEND2 $KERNEL_APPEND2"
>>
>> That should be
>>
>> KERNEL_APPEND2=3D"$KERNEL_APPEND2 $2"
>>
>>> +		shift
>>> +		;;
>>> +	-d|--disk)
>>> +		QEMU_OPTIONS=3D"$QEMU_OPTIONS -drive \
>>> +			file=3D$2,if=3D$(drive_if),cache=3Dunsafe"
>>
>> 		if [ $? !=3D 0 ]; then
>> 			exit $?
>> 		fi
>=20
> Not sure I understand this one. There's no program executing here...

Not sure either. Does drive_if exit the complete script when it fails?
Maybe it was related to this, give it a try again.

Jan


--------------enigFD5DC776DCEE5B39D1CB4D75
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+tHJwACgkQitSsb3rl5xSNagCgvCmRyBcPzWicjIf1Llkaq+fc
FFcAnRGo4miWy288FuENiWIiyGKDQkHD
=JE2W
-----END PGP SIGNATURE-----

--------------enigFD5DC776DCEE5B39D1CB4D75--
