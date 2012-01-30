Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2A3SuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:50:05 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33690 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab2A3SuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:50:04 -0500
Date: Mon, 30 Jan 2012 10:49:39 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: PINTU KUMAR <pintu_agarwal@yahoo.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [Help] : RSS/PSS showing 0 during smaps for Xorg
In-Reply-To: <1327912964.12941.YahooMailNeo@web162006.mail.bf1.yahoo.com>
Message-ID: <alpine.LSU.2.00.1201301034100.1884@eggly.anvils>
References: <1327310360.96918.YahooMailNeo@web162003.mail.bf1.yahoo.com> <1327313719.76517.YahooMailNeo@web162002.mail.bf1.yahoo.com> <alpine.LSU.2.00.1201231125200.1677@eggly.anvils> <1327468926.52380.YahooMailNeo@web162002.mail.bf1.yahoo.com>
 <alpine.LSU.2.00.1201251623340.2141@eggly.anvils> <1327912964.12941.YahooMailNeo@web162006.mail.bf1.yahoo.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1200577600-1327949391=:1884"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1200577600-1327949391=:1884
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 30 Jan 2012, PINTU KUMAR wrote:
> =A0
> >If these are ordinary pages with struct pages, then you could probably
> >use a loop of vm_insert_page()s to insert them at mmap time, or a fault
> >routine to insert them on fault.=A0 But as I said, I don't know if this
> >memory is part of the ordinary page pool or not.
> =A0
> You suggestion about using vm_insert_page() instead of remap_pfn_range wo=
rked for me and I got the Rss/Pss information for my driver.

Oh, I'm glad that happened to work for you.

> But still there is one problem related to page fault.=20
> If I remove remap_pfn_range then I get a page fault in the beginning.=20
> I tried to use the same vm_insert_page() during page_fault_handler for ea=
ch vmf->virtual_address but it did not work.
> So for time being I remove the page fault handler from my vm_operations.
> But with these my menu screen(LCD screen) is not behaving properly (I get=
 colorful lines on my LCD).
> So I need to handle the page fault properly.
> =A0
> But I am not sure what is that I need to do inside page fault handler. Do=
 you have any example or references or suggestions?

Sounds like you're not using vm_insert_page() properly: I would not expect
you to get a page fault there once you've set up the area with a loop of
vm_insert_page()s.

Check the comments above it in mm/memory.c ("Your vma protection will
have to be set up correctly" might be relevant).

Compare how you're using it with other users of vm_insert_page() in
the kernel tree.  Sorry, I don't have time to do your debugging.

> =A0
> >Really, the question has to be, why do you need to see non-0s there?
> I want Rss/Pss value to account for how much video memory is used by the =
driver for the menu-screen,Xorg processes.

So, userspace does an mmap for a large-enough window, but only some part of
that is filled by the driver (whether by remap_pfn_range or vm_insert_pages=
),
and you'd like to communicate back how much via the Rss, instead of adding
some ioctl or sysfs interface to the driver?  Fair enough.

I expect userspace could also work it out by touching pages of the area
until it gets a SIGBUS, but that might be too dirty a way of finding out.

Hmm, SIGBUS: maybe that's related to the faults that are puzzling you:
perhaps you're mapping less than you need to.

Hugh
--8323584-1200577600-1327949391=:1884--
