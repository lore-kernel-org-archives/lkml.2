Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab2GSRCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:02:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4875 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2GSRCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:02:49 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=CmeNAOXY6qYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=ckaoIN6O010iaX0XwFAA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342717366.12353.48.camel@gandalf.stny.rr.com>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration
 for distro issues
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Pekka Enberg <penberg@kernel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>
Date: Thu, 19 Jul 2012 13:02:46 -0400
In-Reply-To: <20120719164807.GD23393@aftab.osrc.amd.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
	 <1342212885.25704.4.camel@lade.trondhjem.org>
	 <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
	 <20120714103716.GD26559@liondog.tnic>
	 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
	 <20120714124332.GA4093@moon> <20120714174827.GA13319@aftab.osrc.amd.com>
	 <20120719144217.GC16873@home.goodmis.org>
	 <20120719164807.GD23393@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 18:48 +0200, Borislav Petkov wrote:

> > Also, if you are building on another box than what the kernel is for,
> > you can go to that box and run 'lsmod > /tmp/lsmod'. Copy that file to
> > the build machine (into /tmp/lsmod), and then run
> > 'make LSMOD=/tmp/lsmod localmodconfig', and this will remove the modules
> > not used by the target box.
> 
> Seriously, this helps only in the cases where the stuff the distro
> actually needs is in modules. So, there probably are obscure situations
> where you need to enable stuff which is bool and not M. Hopefully those
> cases are seldom enough so thanks for this, I'll try that the next time.
> 

This is why I created the make-min-config in ktest. It keeps on
disabling configs to see what the machine needs to boot (and optionally
run some test), and what configs it can disable. It does not touch the
multi options though.

It creates two configs. One that has the configs that it can't turn off
(still enabled with a make allnoconfig, or selected by something that it
must have), and a config that just has the configs that 'if I disable
this, the box doesn't boot'.

Here's an example:

For my min-config files with the configs that couldn't be turned off:

$ wc -l config-min*
  117 config-min
  139 config-min-net

The config-min will get the box to boot (no network). The -net, adds
enough to ssh to the box.

$ wc -l config-skip*
 11 config-skip
 14 config-skip-net

The above are the configs that ktest found if it disabled, would not
boot (or ssh).

$ cat config-skip-net
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SATA_AHCI=y
CONFIG_E1000=y
CONFIG_QUOTA=y
CONFIG_ATA=y
CONFIG_UNIX=y
CONFIG_INET=y
CONFIG_DEVTMPFS=y
CONFIG_EXT4_FS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_SERIAL_8250=y
CONFIG_BLK_DEV_SD=y
CONFIG_NET=y
CONFIG_NETDEVICES=y

I can pass the above to a allnoconfig, and the box will boot and allow
ssh. Note, the reason for the serial config, is that this ktest run uses
a serial port to see if the box booted. If the serial isn't there, then
it thinks it failed.

-- Steve


