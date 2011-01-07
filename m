Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab1AGBmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 20:42:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755060Ab1AGBmb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 20:42:31 -0500
MIME-Version: 1.0
In-Reply-To: <20110107005954.GA18145@void.printf.net>
References: <20110105102534.GA6679@amd> <loom.20110106T030535-794@post.gmane.org>
 <AANLkTikO68RQW0jzeLDOzRw7Hm15Ho0G9=Bp1KobKsrQ@mail.gmail.com> <20110107005954.GA18145@void.printf.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Jan 2011 17:41:39 -0800
Message-ID: <AANLkTimdV1WtdPXeZ8JO40gkC=2dt27bqKxGORuHVyrn@mail.gmail.com>
Subject: Re: [announce] vfs-scale git tree update
To: Chris Ball <cjb@laptop.org>
Cc: Nick Piggin <npiggin@gmail.com>, Jongman Heo <jongman.heo@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 4:59 PM, Chris Ball <cjb@laptop.org> wrote:
>
> In my case, the hang happens when microcode.ko is modprobed and calls
> out for device firmware via request_firmware(), and then udev also calls
> microcode_ctl, which attempts to open(2) /dev/cpu/microcode to write
> microcode into it.  (The request_firmware() interface is the preferred
> one, and opening /dev/cpu/microcode is an older compatibility interface.)

Hmm. That modprobe seems to be hung on 'sysdev_drivers_lock'.

Which in turn seems to be _held_ by the first modprobe, which is
waiting for a request_firmware:

  [  256.980052] modprobe        D 00000000ffff4f88     0   372      1
0x00000000
  [  256.981227]  ffff88022206dc58 0000000000000086 0000000000000292
00000000ffffffff
  [  256.982415]  0000000000013840 0000000000013840 0000000000013840
ffff88022620dc40
  [  256.983692]  0000000000013840 ffff88022206dfd8 0000000000013840
0000000000013840
  [  256.984979] Call Trace:
  [  256.986306]  [<ffffffff81463a41>] schedule_timeout+0x36/0xe3
  [  256.987615]  [<ffffffff8110ad4c>] ? kfree+0xc9/0xd6
  [  256.988893]  [<ffffffff8103d243>] ? need_resched+0x23/0x2d
  [  256.990337]  [<ffffffff81463824>] wait_for_common+0xad/0x102
  [  256.991637]  [<ffffffff8104757f>] ? default_wake_function+0x0/0x14
  [  256.992954]  [<ffffffff81463931>] wait_for_completion+0x1d/0x1f
  [  256.994360]  [<ffffffff812f42df>] _request_firmware+0x2df/0x39a
  [  256.999744]  [<ffffffffa00f6358>] microcode_init_cpu+0xc4/0x115 [microcode]
  [  257.001112]  [<ffffffffa00f6409>] mc_sysdev_add+0x60/0x76 [microcode]
  [  257.002458]  [<ffffffff812e9772>] sysdev_driver_register+0xc0/0x11b

and everybody else is in the open path for the microcode. And that
request_firmware holds the lock, because it's done through the ->add()
function of another sysdev_driver_register().

I'm wondering if this is a previously existing race condition leading
to a deadlock. One that previously would have been serialized enough
by the dcache lock that you'd never have that happen.

It might be interesting to re-run it with mutex debugging and lockdep
enabled, to see if that reports anything. Although it probably won't,
because it's not about a plain lock dependency, but ends up being
deadlocked on the uevent being finished (but you have the modprobe and
the request_firmware ones waiting on each other).

I dunno. I haven't really though that fully through. But we've had
cases roughly like that before, and yes, they can be exposed by some
independent serialization going away - long-standing potential bugs,
that simply never happened in practice before.

                      Linus
