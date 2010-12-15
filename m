Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab0LOGba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 01:31:30 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46829 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab0LOGb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 01:31:29 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Jason Lunz <lunz@acm.org>, Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH] mtd: allow mtd and jffs2 when ARCH=um
Date: Wed, 15 Dec 2010 00:31:18 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-19-generic; KDE/4.2.2; x86_64; ; )
Cc: dedekind1@gmail.com,
        "richard -rw- weinberger" <richard.weinberger@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
        atom ota <atomota@sleepyhammer.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org
References: <22c797d00709272118i33d32b9dy93d5f5ec8f8edd30@mail.gmail.com> <201012141849.03926.rob@landley.net> <20101215011904.GA24292@falooley.org>
In-Reply-To: <20101215011904.GA24292@falooley.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012150031.21417.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 December 2010 19:19:05 Jason Lunz wrote:
> On Tue, Dec 14, 2010 at 06:49:02PM -0600, Rob Landley wrote:
> > The problem is that jffs2 is a filesystem, and thus something people
> > would really like to be able to loopback mount, but it's hardwired to
> > assume it's only ever stored on a certain type of hardware, and thus
> > requies incestuous knowledge of the erase granularity of the flash layer
> > in order to function.
>
> I assume you can turn your jffs2 image file into a block dev using
> losetup, then turn the corresponding loop device into an mtd device
> using block2mtd, at which point you ought to be able to mount it with
> jffs2. I've never tried it.

That is awesome and I'm not finding any documentation on it...  Ah:

  http://wiki.maemo.org/Modifying_the_root_image#Block_device_emulating_an_MTD_device

Wow that's awkward.  Let's see, that says...

  mknod /tmp/mtdblock0 b 31 0
  modprobe loop
  losetup /dev/loop0 rootfs.jffs2
  modprobe mtdblock
  modprobe block2mtd
  # Note the ,128KiB is needed (on 2.6.26 at least) to set the
  # eraseblock  size.
  echo "/dev/loop0,128KiB" > /sys/module/block2mtd/parameters/block2mtd
  modprobe jffs2
  mount -t jffs2 /tmp/mtdblock0 /media/jffs2

So the system isn't automatically loading mtdblock, udev isn't creating any 
/dev nodes for it even thought it is for loop, the associations are created by 
writing strings into a filesystem with a _notoriously_ unstable API (and it 
expects a three letter mixed case suffix to specify units), and despite 
"mtdblock0" I have no idea how that echo syntax would specify more than one 
association at a time.

I'm trying to figure out whether creating a shell script for this or trying to 
modify the busybox mount command would be a better approach to beating some 
sort of usability out of doing this.

Hmmm, mkfs.jffs2 is named as a mkfs but acts a a generator ala genext2fs.  How 
about...

  mkdir empty
  mkfs.jffs2 -r empty -o rootfs.jffs2 -e 128 -l -n

And it created an empty (zero byte) file.  That's nice.  If I touch a file in 
"empty" now 116 bytes.  Adding -p makes it one erase block, but adding "-p 
2048" doesn't specify a multiple of the erase block size, it instead rounded 
rounded it _down_ to that many bytes.  But --pad=$((2048*1024*1024)) was 
apparently ignored...?  How do I specify a _size_ for this thing so it has 
empty space I can write into after the fact?  (The man page says pad with 
0xFF.  Am I going to have to do this by hand?)

  mkdir empty
  touch empty/hello
  mkfs.jffs2 -r empty -o temp.jffs2 -e 128 -l -n -p
  python -c "import sys; sys.stdout.write(131072*63*chr(0xff))" >> temp.jffs2
  losetup /dev/loop0 temp.jffs2
  echo "/dev/loop0,128KiB" > /sys/module/block2mtd/parameters/block2mtd
  mount -t jffs2 mtdblock0 empty

Yay!  I have a filesystem!  And df claims it's 8 megabytes.

Woot.

> > What any of this has to do with UML is an open question.  I don't want to
> > require UML to loopback mount a jffs2 image, I want to be able to do it
> > from my host.  From my perspective, you're solving the wrong problem.
>
> There's more than just loopback-mounting jffs2 images. I use this to
> make entire uml+jffs2 virtual machines for testing purposes.

As I said, I'm almost exclusively using qemu/kvm these days, but this is 
fun...

> Jason

Rob
-- 
GPLv3: as worthy a successor as The Phantom Menace, as timely as Duke Nukem 
Forever, and as welcome as New Coke.
