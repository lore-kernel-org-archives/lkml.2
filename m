Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab0GJOzL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 10:55:11 -0400
Received: from serv04.lahn.de ([213.239.197.57]:52125 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab0GJOzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 10:55:09 -0400
Date: Sat, 10 Jul 2010 16:52:08 +0200
From: Michael Leun <lkml20100708@newton.leun.net>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sysfs bug when using tun with network namespaces
Message-ID: <20100710165208.59272ae6@xenia.leun.net>
In-Reply-To: <20100710140800.GA20424@kroah.com>
References: <loom.20100708T183152-326@post.gmane.org>
	<20100709235744.GA12752@kroah.com>
	<20100710101540.2799c9ef@xenia.leun.net>
	<20100710140800.GA20424@kroah.com>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.6; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jul 2010 07:08:00 -0700
Greg KH <greg@kroah.com> wrote:

> On Sat, Jul 10, 2010 at 10:15:40AM +0200, Michael Leun wrote:
> > Hi,
> > 
> > On Fri, 9 Jul 2010 16:57:44 -0700
> > Greg KH <greg@kroah.com> wrote:
> > 
> > > On Thu, Jul 08, 2010 at 04:40:09PM +0000, Michael Leun wrote:
> > > > Hello,
> > > > 
> > > > > # tunctl -u ml -t tap1
> > > > 
> > > > works as expected, but
> > > > 
> > > > > # unshare -n /bin/bash
> > > > > # tunctl -u ml -t tap1
> > > > 
> > > > Jul  8 18:03:59 doris kernel: ------------[ cut
> > > > here ]------------ Jul  8 18:03:59 doris kernel: kernel BUG at
> > > > fs/sysfs/file.c:540! Jul  8 18:03:59 doris kernel: invalid
> > > > opcode: 0000 [#1] PREEMPT SMP Jul  8 18:03:59 doris kernel:
> > > > last sysfs file: /sys/devices/virtual/misc/tun/dev Jul  8
> > > > 18:03:59 doris kernel: Modules linked in: tun snd_pcm_oss
> > > > snd_mixer_oss snd_seq snd_seq_device vboxnetadp vboxnetflt
> > > > vboxdrv ipv6 cpufreq_conservative cpufreq_ondemand
> > > > cpufreq_userspace cpufreq_powersave acpi_cpufreq speedstep_lib
> > > > freq_table ipt_REJECT ipt_LOG xt_limit xt_recent xt_state
> > > > xt_tcpudp iptable_mangle iptable_nat iptable_filter nf_nat_ftp
> > > > nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp
> > > > nf_conntrack ip_tables x_tables fuse nls_utf8 loop
> > > > snd_hda_codec_realtek arc4 snd_hda_intel ecb snd_hda_codec
> > > > iwlagn snd_pcm iwlcore snd_timer mac80211 snd cfg80211
> > > > soundcore intel_agp video usb_storage agpgart i2c_i801 rfkill
> > > > snd_page_alloc output button battery ac joydev sg evdev tg3 edd
> > > > ext4 jbd2 crc16 sha256_generic aes_i586 aes_generic cbc
> > > > dm_crypt linear rtc_cmos uhci_hcd rtc_core rtc_lib sd_mod
> > > > crc_t10dif ehci_hcd usbcore dm_snapshot dm_mod fan processor
> > > > thermal [last unloaded: tun] Jul  8 18:03:59 doris kernel: Jul
> > > > 8 18:03:59 doris kernel: Pid: 4320, comm: tunctl Not tainted
> > > > 2.6.34.1 #3 Kuril                           /40684JG         
> > > 
> > > Network namespaces didn't go in until 2.6.35-rc, how is this
> > > working on ..34.1?
> > 
> > Huh? Network namespaces were there for quite some time - just for
> > fun I grabbed a random older kernel (got 2.6.27.48) to check.
> > CONFIG NET_NS was also in there (but was defined in net/Kconfig and
> > had a depency on !SYSFS).
> 
> Ah, yeah, but everyone used SYSFS so it probably was never used :)
> 
> > In 2.6.34 it is defined in init/Kconfig (and has no depency on
> > SYSFS at all).
> > 
> > I think I started actually using that somewhere between .30 and .32.

...and knowing now, that basic sysfs support for netns was missing all
the time it works surprisingly well most time.

One point might be, that I never used interfaces with same name in
different network namespaces.

> > > Can you verify this works properly in .35-rc4?
> > 
> > Indeed, it works there.
> > 
> > There are several differencies between 2.6.34.1 and 2.6.35-rc4 in
> > fs/sysfs/* stuff as well as in e.g. net/core/net_namespaces.c.
> > 
> > I'll bisect that (but not on this atom netbook I used so far ;-) ).

git bisect seems to have a somewhat pessimistic nature - it only wants
to help find out when something got broken, not when something got
fixed (good rev cannot be greater then bad rev).

So I had to do some manual mumbo jumbo to find out that
a1b3f594dc5faab91d3a218c7019e9b5edd9fe1a seems to be the one finally
fixing it, but of course depending on a zillion other ones, most
notably the ones adding sysfs support for namespaces at all...

I think I'll manage to understand that they will not fit in a stabile
patch ;-)

> I'd not recommend using it until .35-rc because of the sysfs changes
> required.

A I said, I'm using it quite a while now and it works surprisingly
(when knowing what is missing) well in scenarios I used so far.

Thank you very much for your support.

-- 
MfG,

Michael Leun

