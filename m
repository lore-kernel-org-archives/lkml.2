Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab2EGPy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:54:27 -0400
Received: from edge2.cs.stonybrook.edu ([130.245.9.211]:6341 "EHLO
	edge2.cs.stonybrook.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab2EGPy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:54:26 -0400
Message-ID: <4FA7F013.8020002@cs.stonybrook.edu>
Date: Mon, 7 May 2012 11:53:55 -0400
From: Richard Yao <ryao@cs.stonybrook.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120430 Thunderbird/10.0.4
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: I need tips on how to debug a deadlock involving swap
X-Enigmail-Version: 1.3.5
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigFA3C53B1FE332E0F9AAD6E5D"
X-Originating-IP: [108.46.203.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigFA3C53B1FE332E0F9AAD6E5D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have a deadlock that occurs when I swap to a virtual block device. The
driver is out-of-tree and it processes IO requests in worker threads.
Setting PF_MEMALLOC will prevent the deadlock, but it has the side
effect of grabbing pages from ZONE_DMA, which is bad.

I believe that direct reclaim is being triggered when swap occurs,
causing swap operations holding locks to depend on swap operations that
require those locks, but I am having trouble identifying how that happens=
=2E

The deadlock occurs in the IO worker threads, but the hung task timeout
provides a backtrace for the thread that triggered the IO request, which
is not helpful:

[  218.252066] INFO: task python2.7:7027 blocked for more than 15 seconds=
=2E
[  218.252070] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  218.252073] python2.7       D ffffffff814051e0     0  7027   7022
0x00000000
[  218.252079]  ffff8801b4c73798 0000000000000086 ffff8801b4c73758
ffff8801b4c73758
[  218.252085]  ffff880224b84a40 ffff8801b4c73fd8 ffff8801b4c73fd8
ffff8801b4c73fd8
[  218.252091]  ffff8802268aca40 ffff880224b84a40 ffff8801b4c73768
ffff88022fc91738
[  218.252097] Call Trace:
[  218.252105]  [<ffffffff810b8300>] ? __lock_page+0x70/0x70
[  218.252111]  [<ffffffff8133241a>] schedule+0x3a/0x50
[  218.252114]  [<ffffffff813324ba>] io_schedule+0x8a/0xd0
[  218.252118]  [<ffffffff810b8309>] sleep_on_page+0x9/0x10
[  218.252121]  [<ffffffff81330547>] __wait_on_bit+0x57/0x80
[  218.252131]  [<ffffffff810c097e>] ? account_page_writeback+0xe/0x10
[  218.252134]  [<ffffffff810b84e0>] wait_on_page_bit+0x70/0x80
[  218.252137]  [<ffffffff81052da0>] ? autoremove_wake_function+0x40/0x40=

[  218.252141]  [<ffffffff810c7245>] shrink_page_list+0x465/0x8f0
[  218.252144]  [<ffffffff810c7cf9>] shrink_inactive_list+0x379/0x470
[  218.252147]  [<ffffffff81336c2d>] ? sub_preempt_count+0x9d/0xd0
[  218.252150]  [<ffffffff810c8261>] shrink_mem_cgroup_zone+0x471/0x570
[  218.252153]  [<ffffffff810c8e0b>] do_try_to_free_pages+0xfb/0x420
[  218.252156]  [<ffffffff810c9251>] try_to_free_pages+0x71/0x80
[  218.252159]  [<ffffffff810c04f9>] __alloc_pages_nodemask+0x469/0x7a0
[  218.252162]  [<ffffffff810c3750>] ? __put_single_page+0x30/0x30
[  218.252166]  [<ffffffff810fa36c>] do_huge_pmd_anonymous_page+0x14c/0x3=
50
[  218.252170]  [<ffffffff810d69cf>] handle_mm_fault+0x13f/0x2f0
[  218.252172]  [<ffffffff8133662e>] do_page_fault+0x14e/0x590
[  218.252176]  [<ffffffff81061739>] ? set_next_entity+0x39/0x80
[  218.252179]  [<ffffffff81062a8b>] ? pick_next_task_fair+0x6b/0x150
[  218.252181]  [<ffffffff8105dcf1>] ? get_parent_ip+0x11/0x50
[  218.252184]  [<ffffffff81336c2d>] ? sub_preempt_count+0x9d/0xd0
[  218.252186]  [<ffffffff81331fb8>] ? __schedule+0x2f8/0x6c0
[  218.252189]  [<ffffffff81333a75>] page_fault+0x25/0x30

Is there any way that I can ask the kernel to print stack traces of the
worker threads on demand?


--------------enigFA3C53B1FE332E0F9AAD6E5D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPp/AeAAoJELFAT5FmjZuE04QQAIuSJcycEArn/DEiTskxA3xr
huOyTjQ9NXGxIfFVzcgr1q2ffPjbZtLVWbQ55i5fy4SwdBdjza7fo97E8zfI4mIo
wZ2jhdDrZTWhT9Rdx3QElA5RYXHOYIGmrfKd9pgx7QbroE9TIxEWdd5ahCg70hXZ
a4/QQ65ix1LbAVEomgUYta3+rLUJfiV0IskUBK94XI6GPqRpO7dwrZumln/NouQ0
9+PTNKXdotn2G1SR51M0xQajv8XLu6s8h6C3E4swSFZHGaZ81yor20WNRoKk2xrI
OLjkzuSq9h7sWh937cSSE9EGggw+zqYx+++MC7qRLgPW5LY+q+L7fzwTEwsT7l5u
DXVmHN/5XsjDiR8T5CIhztFbLqoAiCdWX9xmnCKWWOghW5JP2A3O/Ufgud7TvQyE
bysTM/iuTySCJ+vIujQBuWUUKyoLjUj4jSDzRSc8/IctstIBy4jwdcnud1Zvlssb
wnDMnaIMBVjoYAfcOZujKn5rnS8BrFt4dYhLCc0u5xZmC5XXbDY1uYHSjNliyRoP
JtWbZP9MwN+9E6+aQfbZTI+2y+GqkRHQ6cZy72mXquZW6u880H8H24BDBCeykBjr
OnmxOmPb3I5XgDB/NGAik+YGYDltn/gB/boU32CCWgu0L+zXYpDYfMdhIlptwDli
8IRjgisdGpnZWHS7H0BC
=hLY+
-----END PGP SIGNATURE-----

--------------enigFA3C53B1FE332E0F9AAD6E5D--
