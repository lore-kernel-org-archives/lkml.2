Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1LTOnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 09:43:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab1LTOnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 09:43:33 -0500
Date: Tue, 20 Dec 2011 15:43:18 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        users@rt2x00.serialmonkey.com,
        Andreas Hartmann <andihartmann@01019freenet.de>
Subject: Re: [rt2x00-users] Poor performance and lockup with rt2800usb and
 Asus USB-N13 adapter
Message-ID: <20111220144317.GA6027@redhat.com>
References: <4ED43A5C.9000102@gmail.com>
 <20111129114603.GB7299@redhat.com>
 <CADLC3L2QpEtPiBg+yvaxir1LpU6j5YMpDG4g0+ezs06g745zcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADLC3L2QpEtPiBg+yvaxir1LpU6j5YMpDG4g0+ezs06g745zcg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 08:21:49PM -0600, Robert Hancock wrote:
> On Tue, Nov 29, 2011 at 5:46 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > On Mon, Nov 28, 2011 at 07:50:20PM -0600, Robert Hancock wrote:
> >> I recently got an Asus USB-N13 USB Wireless-N adapter which
> >> apparently uses a Ralink RT3072 chip. I'm using it with an Asus
> >> RT-N16 access point running TomatoUSB. When running Windows the
> >> performance is reasonable (about 80 Mbps in both directions).
> >> However under Fedora 16 (currently kernel 3.1.2) the performance is
> >> abysmal (10 Mbps or less with lots of packet loss). I'll post some
> >> debug information below.
> > rt2800usb needs fixing. I'm able to reproduce these performance
> > problems locally. They are quite hard to debug, and need some
> > experiments. But I hope I will provide patches soon or leter.
> 
> Do you have any leads on what is going wrong? I'm not sure if the
> issue is with the higher MCS rates not working as well as they should,
> or with the rate control trying to use them even though they're not
> working well.

I just discovered that at least some problems are related with power
save. After "iwconfig wlanX power off" I have pretty short ping times
and good throughput, both comparable with vendor driver. But I did not
check that on all adapters that I have yet.

Looking a bit more at that seem we stop and wake queues several times
between sending each frame. Looks like that thing need to be optimized
in mac80211, or some parameters have to be setup properly by rt2x00 ...

Also rt2800 PCI and SOC have PS disabled by default ...
 
> I tried with the Fedora kernel-debug kernel and didn't see much
> additional output. The stack trace might have a bit more detail:
> 
> rt2x00queue_index_inc
> rt2x00lib_dmadone
> rt2x00usb_kick_rx_entry
> rt2x00usb_clear_entry
> rt2x00lib_rxdone
> rt2x00usb_work_rxdone
> process_one_work
> worker_thread
> kthread
> kernel_thread_helper
> 
> Seems like something that happens on rmmod with the device connected
> causes these rxdone/txdone functions to go into a tight loop somehow.

I'm not able to reproduce this, perhaps this is related with debugfs
or sysfs files you ware opening?

Thanks
Stanislaw
