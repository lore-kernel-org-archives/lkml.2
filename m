Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab2ESUqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 16:46:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41258 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab2ESUqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 16:46:18 -0400
Date: Sat, 19 May 2012 13:45:57 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sam Portolla <samportolla@yahoo.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>
Subject: Re: exit_mmap BUG_ON in 2.6.23
In-Reply-To: <1337406674.48432.YahooMailNeo@web121303.mail.ne1.yahoo.com>
Message-ID: <alpine.LSU.2.00.1205191301430.10539@eggly.anvils>
References: <1337406674.48432.YahooMailNeo@web121303.mail.ne1.yahoo.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1553049524-1337460364=:10539"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1553049524-1337460364=:10539
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 18 May 2012, Sam Portolla wrote:
> [please cc samPortolla@yahoo.com on your replies, not subscribed to the l=
inux-kernel mailer]
>=20
> Hi, I have read the thread on same issue in 3.1:
> but this is happening on earlier GNU linux version 2.6.23 for x86_64,
> which does not have THP (I believe), nor it has huge_memory.c.
> Is there a fix one of you experts could supply?=A0 Issue is not reproduci=
ble
> so far, but happened on a customer site. Some info below.
>=20
> kernel BUG at .../bfc/linux/kernel-2.6.x/mm/mmap.c:2049!
>=20
> Line 2049 is in exit_mmap():
>=20
> BUG_ON(mm->nr_ptes > (FIRST_USER_ADDRESS+PMD_SIZE-1)>>PMD_SHIFT);
>=20
> =A0RIP: 0010:[<ffffffff80277840>]  [<ffffffff80277840>] exit_mmap+0xf0/0x=
100=20
> [snip]
> =A0Call Trace:
>  [<ffffffff8022ee14>] mmput+0x44/0xd0
>  [<ffffffff802340a1>] exit_mm+0x91/0x100
>  [<ffffffff802347ea>] do_exit+0x17a/0x960
>  [<ffffffff8023c4bc>] __dequeue_signal+0xec/0x1b0
>  [<ffffffff80235048>] do_group_exit+0x38/0x90
>  [<ffffffff8023e3c6>] get_signal_to_deliver+0x2d6/0x4b0
>  [<ffffffff8020b69a>] do_notify_resume+0xaa/0x760
>  [<ffffffff8020c818>] retint_signal+0x3d/0x85

I've checked back through old ChangeLogs, and (apart from a UserModeLinux
case) I don't see any fix for a BUG_ON(nr_ptes) issue in between 2.6.19
and the much later THP issue, which you're right to think cannot be yours.

But the 2.6.19 case, and one which a video driver writer had more recently,
were both caused by unrelated code zeroing beyond what it had allocated:
happening to zero part of a higher-level page table, making it impossible
for task exit to locate all the page tables (and pages) it had to free.

Though I can't be sure, these BUG_ON(nr_ptes) reports do seem perhaps
too infrequent to be caused by bad logic in mm itself: I suspect memory
corruption in your case too.

There's no clue here as to what the cause might be, I'm afraid.
Rebuilding your kernel with CONFIG_DEBUG_PAGEALLOC=3Dy, and slab debugging
on, might shed more light: but that's probably not something you want to
get into on a customer site, for a problem only seen once or twice.

The best I can suggest is for you to change that BUG_ON to a WARN_ON,
so at least the kernel doesn't crash there, and you might gather more
information from each time it happens; but you'll probably leak pages,
and may very well crash soon for other reasons (e.g. when evicting an
inode cannot locate all the maps of its pages).

Hugh
--8323584-1553049524-1337460364=:10539--
