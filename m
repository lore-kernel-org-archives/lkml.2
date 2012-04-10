Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2DJJaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 05:30:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38570 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab2DJJaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 05:30:08 -0400
MIME-Version: 1.0
Date: Tue, 10 Apr 2012 13:30:07 +0400
Message-ID: <CACf55T4rmUn3XvEv5vFpAk2ZVX_5NMp5MucM9mOa4G1aL+5bPw@mail.gmail.com>
Subject: kpagecount/kpageflags possible implementation problem
From: Dmitry Smirnov <divis1969@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to work with /proc/kpagecount and /proc/kpageflags to
figure out what is causing fragmentation of the  kernel memory.

I see some problems with these files. For example, the length of the
files is 2617344 (i.e. 327168 pages).
But when I try to map the pages of the process (/proc/PID/pagemap), I
see that process can have a pfn greater than 327168.

On my mind this is due to the memory model used in my target. It is
"sparse", and I can see that there is a Normal zone only which starts
at pfn 512 and spannes 327168 pages (see /proc/zoneinfo at the end).
But fs/proc/page.c honors only max_pfn, which is exaclty 327168 and
which limits the length of the kpagemap and kpagekount files.

Also, I suppose that pages 0-512 should be treated as non-existent and
should be reported with KPF_NOPAGE, but in fact, they are reported
with some valid flags (KPF_MMAP). I also suspect that some other pages
are not reported correctly too: the target has 114436 present pages
(in 3 blocks: 60MB 141MB 256MB) but I can count 130560 "valid" pages
(i.e. which are not marked with KPF_NOPAGE).

I would like to fix this, but have small experience with kernel memory
implementation. So, any suggestions are welcome.

Target is running 2.6.32 kernel (thought, I see that latest master'
page.c does not change a lot).

Node 0, zone   Normal
  pages free     2140
        min      676
        low      845
        high     1014
        scanned  0
        spanned  327168
        present  114436
    nr_free_pages 2140
    nr_inactive_anon 15028
    nr_active_anon 32194
    nr_inactive_file 8551
    nr_active_file 14977
    nr_unevictable 4655
    nr_mlock     4493
    nr_anon_pages 47074
    nr_mapped    22067
    nr_file_pages 28338
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 1306
    nr_slab_unreclaimable 2405
    nr_page_table_pages 2003
    nr_kernel_stack 708
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     4647
        protection: (0, 0)
  pagesets
    cpu: 0
              count: 131
              high:  186
              batch: 31
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         512
  inactive_ratio:    1

WBR,
Dmitry
