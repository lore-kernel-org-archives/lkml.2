Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059Ab0E1RmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:42:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33636 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932949Ab0E1RmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:42:03 -0400
Date: Fri, 28 May 2010 10:40:20 -0700
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, ngupta@vflare.org, JBeulich@novell.com,
       chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, akpm@linux-foundation.org,
       riel@redhat.com, avi@redhat.com, pavel@ucw.cz, konrad.wilk@oracle.com,
       dan.magenheimer@oracle.com
Subject: [PATCH V2 0/4] Frontswap (was Transcendent Memory): overview
Message-ID: <20100528174020.GA28150@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4C000035.0083:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH V2 0/4] Frontswap (was Transcendent Memory): overview

Changes since V1:
- Rebased to 2.6.34 (no functional changes)
- Convert to sane types (per Al Viro comment in cleancache thread)
- Define some raw constants (Konrad Wilk)
- Performance analysis shows significant advantage for frontswap's
  synchronous page-at-a-time design (vs batched asynchronous speculated
  as an alternative design).  See http://lkml.org/lkml/2010/5/20/314

In previous patch postings, frontswap was part of the Transcendent
Memory ("tmem") patchset.  This patchset refocuses not on the underlying
technology (tmem) but instead on the useful functionality provided for Linux,
and provides a clean API so that frontswap can provide this very useful
functionality via a Xen tmem driver OR completely independent of tmem.
For example: an in-kernel compression "backend" for frontswap can be
implemented and some believe frontswap will be a very nice interface
for building RAM-like functionality for pseudo-RAM devices such as
on-memory-bus SSD or phase-change memory; and a Pune University team
is looking at a backend for virtio (see OLS'2010).

A more complete description of frontswap can be found in the introductory
comment in mm/frontswap.c (in PATCH 2/4) which is included below
for convenience.

Note that an earlier version of this patch is now shipping in OpenSuSE 11.2
and will soon ship in a release of Oracle Enterprise Linux.  Underlying
tmem technology is now shipping in Oracle VM 2.2 and was just released
in Xen 4.0 on April 15, 2010.  (Search news.google.com for Transcendent
Memory)

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Reviewed-by: Jeremy Fitzhardinge <jeremy@goop.org>

 include/linux/frontswap.h |   98 ++++++++++++++
 include/linux/swap.h      |    2 
 include/linux/swapfile.h  |   13 +
 mm/Kconfig                |   16 ++
 mm/Makefile               |    1 
 mm/frontswap.c            |  301 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/page_io.c              |   10 +
 mm/swapfile.c             |   59 +++++++--
 8 files changed, 491 insertions(+), 9 deletions(-)

Frontswap is so named because it can be thought of as the opposite of
a "backing" store for a swap device.  The storage is assumed to be
a synchronous concurrency-safe page-oriented pseudo-RAM device (such as
Xen's Transcendent Memory, aka "tmem", or in-kernel compressed memory,
aka "zmem", or other RAM-like devices) which is not directly accessible
or addressable by the kernel and is of unknown and possibly time-varying
size.  This pseudo-RAM device links itself to frontswap by setting the
frontswap_ops pointer appropriately and the functions it provides must
conform to certain policies as follows:

An "init" prepares the pseudo-RAM to receive frontswap pages and returns
a non-negative pool id, used for all swap device numbers (aka "type").
A "put_page" will copy the page to pseudo-RAM and associate it with
the type and offset associated with the page. A "get_page" will copy the
page, if found, from pseudo-RAM into kernel memory, but will NOT remove
the page from pseudo-RAM.  A "flush_page" will remove the page from
pseudo-RAM and a "flush_area" will remove ALL pages associated with the
swap type (e.g., like swapoff) and notify the pseudo-RAM device to refuse
further puts with that swap type.

Once a page is successfully put, a matching get on the page will always
succeed.  So when the kernel finds itself in a situation where it needs
to swap out a page, it first attempts to use frontswap.  If the put returns
non-zero, the data has been successfully saved to pseudo-RAM and
a disk write and, if the data is later read back, a disk read are avoided.
If a put returns zero, pseudo-RAM has rejected the data, and the page can
be written to swap as usual.

Note that if a page is put and the page already exists in pseudo-RAM
(a "duplicate" put), either the put succeeds and the data is overwritten,
or the put fails AND the page is flushed.  This ensures stale data may
never be obtained from pseudo-RAM.
