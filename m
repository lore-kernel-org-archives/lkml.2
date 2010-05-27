Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935049Ab0E0SfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:35:09 -0400
Received: from lo.gmane.org ([80.91.229.12]:45758 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941Ab0E0SfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:35:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: Bernhard Schmidt <berni@birkenwald.de>
Subject: Re: Clock jumps
Date: Thu, 27 May 2010 18:32:53 +0000 (UTC)
Message-ID: <htmdsk$9kn$1@dough.gmane.org>
References: <loom.20100524T171038-56@post.gmane.org>
 <20100525062100.GP22163@redhat.com> <4BFD5616.6070302@cora.nwra.com>
 <4D7E210A-4694-4B6E-B721-6024CE96ABC0@suse.de>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: ppp-88-217-27-146.dynamic.mnet-online.de
User-Agent: slrn/pre1.0.0-18 (Linux)
Cc: kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Graf <agraf@suse.de> wrote:

Hi,

> Do you have ntpd running inside the guest? I have a bug report lying
> around about 2.6.33 with kvm-clock jumping in time when ntpd is used:
> https://bugzilla.novell.com/show_bug.cgi?id=582260

I want to chime in here, I have a very similar problem, but not with
ntpd in the guest.

The host was a HP ProLiant DL320 G5p with a Dualcore Xeon3075. System
was a Debian Lenny with a custom 2.6.33 host kernel and a custom
qemu-kvm 0.11.0 .deb ported from Ubuntu. The host is synced with ntpd.

The guests are various Debian Lenny/Squeeze VMs, with a custom kernel
(2.6.33 at the moment) with kvm-clock. Exclusively amd64 guest
kernels, but one system has i386 userland.

With this setup once in a while (maybe every other week) one VM would
have a sudden clock jump, 6-12 hours into the future. No kernel messages
or other log entries than applications complaining about the clock jump
after the fact. Other VMs were unaffected.

Yesterday I did an upgrade to Debian Squeeze. This involved a new
qemu-kvm (0.12.4), but not a new host kernel. I also upgraded the guest
kernels from 2.6.33 to 2.6.33.4.

First of all, after the reboot the host clock was totally unreliable. I
had a constant skew of up to five seconds per minute in the host clock,
which of course affected the VMs as well.  This problem went away when I
changed from tsc into hpet on the host. The host does CPU frequency
scaling which is, as far as I know, known to affect TSC stability. I
think I remember messages about tsc being unstable in earlier boots,
maybe the detection did just not work this time.

Worse, the clock jump issues in the guest appeared much more often than
before. The higher loaded VMs did not survive ten minutes without
jumping several hours ahead. 

Situation has stabilized after setting clocksource hpet in the guest
immediately after boot. So it seems kvm-clock has some issues here.

I've seen a preliminary patch floating around on the ML by Zachary
Amsden, but I haven't tried it yet. It talks of backward warps, but so
far I've only seen forward warps (the VM time suddenly jumps into the 
future), so it might be unrelated.

Bernhard

