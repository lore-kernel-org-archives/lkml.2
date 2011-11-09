Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab1KIRAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 12:00:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab1KIRAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 12:00:30 -0500
Date: Wed, 9 Nov 2011 18:00:27 +0100
From: Jan Kara <jack@suse.cz>
To: Andy Isaacson <adi@hexapodia.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org, mgorman@suse.de,
        aarcange@redhat.com
Subject: Re: long sleep_on_page delays writing to slow storage
Message-ID: <20111109170027.GB7495@quack.suse.cz>
References: <20111107045928.GK8927@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107045928.GK8927@hexapodia.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  I've added to CC some mm developers who know much more about transparent
hugepages than I do because that is what seems to cause your problems...

On Sun 06-11-11 20:59:28, Andy Isaacson wrote:
> I am running 1a67a573b (3.1.0-09125 plus a small local patch) on a Core
> i7, 8 GB RAM, writing a few GB of data to a slow SD card attached via
> usb-storage with vfat.  I mounted without specifying any options,
> 
> /dev/sdb1 /mnt/usb vfat rw,nosuid,nodev,noexec,relatime,uid=22448,gid=22448,fmask=0022,dmask=0022,codepage=cp437,iocharset=utf8,shortname=mixed,errors=remount-ro 0 0
> 
> and I'm using rsync to write the data.
> 
> We end up in a fairly steady state with a half GB dirty:
> 
> Dirty:            612280 kB
> 
> The dirty count stays high despite running sync(1) in another xterm.
> 
> The bug is,
> 
> Firefox (iceweasel 7.0.1-4) hangs at random intervals.  One thread is
> stuck in sleep_on_page
> 
> [<ffffffff810c50da>] sleep_on_page+0xe/0x12
> [<ffffffff810c525b>] wait_on_page_bit+0x72/0x74
> [<ffffffff811030f9>] migrate_pages+0x17c/0x36f
> [<ffffffff810fa24a>] compact_zone+0x467/0x68b
> [<ffffffff810fa6a7>] try_to_compact_pages+0x14c/0x1b3
> [<ffffffff810cbda1>] __alloc_pages_direct_compact+0xa7/0x15a
> [<ffffffff810cc4ec>] __alloc_pages_nodemask+0x698/0x71d
> [<ffffffff810f89c2>] alloc_pages_vma+0xf5/0xfa
> [<ffffffff8110683f>] do_huge_pmd_anonymous_page+0xbe/0x227
> [<ffffffff810e2bf4>] handle_mm_fault+0x113/0x1ce
> [<ffffffff8102fe3d>] do_page_fault+0x2d7/0x31e
> [<ffffffff812fe535>] page_fault+0x25/0x30
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> And it stays stuck there for long enough for me to find the thread and
> attach strace.  Apparently it was stuck in
> 
> 1320640739.201474 munmap(0x7f5c06b00000, 2097152) = 0
> 
> for something between 20 and 60 seconds.
  That's not nice. Apparently you are using transparent hugepages and the
stuck application tried to allocate a hugepage. But to allocate a hugepage
you need a physically continguous set of pages and try_to_compact_pages()
is trying to achieve exactly that. But some of the pages that need moving
around are stuck for a long time - likely are being submitted to your USB
stick for writing. So all in all I'm not *that* surprised you see what you
see.

> There's no reason to let a 6MB/sec high latency device lock up 600 MB of
> dirty pages.  I'll have to wait a hundred seconds after my app exits
> before the system will return to usability.
> 
> And there's no way, AFAICS, for me to work around this behavior in
> userland.
  There is - you can use /sys/block/<device>/bdi/max_ratio to tune how much
of dirty cache that device can take. Dirty cache is set to 20% of your
total memory by default so that amounts to ~1.6 GB. So if you tune
max_ratio to say 5, you will get at most 80 MB of dirty pages agains your
USB stick which should be about appropriate. You can even create a udev
rule so that when an USB stick is inserted, it automatically sets
max_ratio for it to 5...

> And I don't understand how this compact_zone thing is intended to work
> in this situation.
> 
> edited but nearly full dmesg at
> http://web.hexapodia.org/~adi/snow/dmesg-3.1.0-09126-g4730284.txt

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
