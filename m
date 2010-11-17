Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934610Ab0KQLnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 06:43:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45433 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934163Ab0KQLnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 06:43:43 -0500
From: Andi Kleen <andi@firstfloor.org>
To: r6144 <rainy6144@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        sds@tycho.nsa.gov, linux-mm@kvack.org, jmorris@namei.org
Subject: Re: Sluggishness on a GEM system due to SELinux's sidtab_search_context() as well as get_unmapped_area()
References: <1289793125.12243.18.camel@localhost.localdomain>
Date: Wed, 17 Nov 2010 12:43:41 +0100
In-Reply-To: <1289793125.12243.18.camel@localhost.localdomain>
	(rainy6144@gmail.com's message of "Mon, 15 Nov 2010 11:52:05 +0800")
Message-ID: <87tyjgqioi.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

r6144 <rainy6144@gmail.com> writes:


> Hello,
>
> I'm noticing significant sluggishness when switching into a workspace
> where Evolution is running.


Interesting result. Adding some relevant ccs with full-quote.
I guess graphics really should do less mmaps, but the underlying
performance problems should be investigated too.

-Andi

>
> My kernel is Fedora 12's 2.6.32.16-150.fc12.x86_64 (I know it is
> old...), and the open source radeon (r600) driver is used.  Oprofile
> shows the follows:
>
> CPU: Core 2, speed 2003 MHz (estimated)
> Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a
> unit mask of 0x00 (Unhalted core cycles) count 100000
> Counted INST_RETIRED_ANY_P events (number of instructions retired) with
> a unit mask of 0x00 (No unit mask) count 100000
> samples  %        samples  %        image name               app name
> symbol name
> 126807   31.2201  38744    28.3866  vmlinux                  Xorg
> (deleted)           find_vma
> 48661    11.9804  3474      2.5453  vmlinux                  Xorg
> (deleted)           mls_compute_sid
> 41806    10.2927  5700      4.1762  vmlinux                  Xorg
> (deleted)           sidtab_search_context
> 11888     2.9268  4234      3.1021  Xorg (deleted)           Xorg
> (deleted)           /usr/bin/Xorg (deleted)
> 8660      2.1321  1589      1.1642  drm                      Xorg
> (deleted)           /drm
> 6228      1.5333  6773      4.9624  radeon                   Xorg
> (deleted)           /radeon
> 6214      1.5299  1832      1.3423  libc-2.11.2.so (deleted) Xorg
> (deleted)           /lib64/libc-2.11.2.so (deleted)
> 5542      1.3644  4929      3.6113
> libpixman-1.so.0.16.6.#prelink#.3I5wow (deleted) Xorg
> (deleted)           /usr/lib64/libpixman-1.so.0.16.6.#prelink#.3I5wow
> (deleted)
> 4149      1.0215  1776      1.3012  libexa.so                Xorg
> (deleted)           /usr/lib64/xorg/modules/libexa.so
> 4140      1.0193  640       0.4689  vmlinux                  oprofiled
> mls_compute_sid
> 3183      0.7837  847       0.6206  vmlinux                  Xorg
> (deleted)           arch_get_unmapped_area_topdown
> ...
>
> Although I haven't looked into it, presumably Evolution is asking the X
> server to create and map a lot of TTM objects (pixmaps?).  The creation
> of each object uses shmem_file_setup() and thus necessitates SELinux
> calls, and since the X process already has a lot of mappings (one
> mapping for each XRender glyph it seems, with "wc -l /proc/`pgrep
> Xorg`/maps" returning 6766), the mapping part could also be slow.
>
> I think the slowness of find_vma is related to
> https://bugzilla.kernel.org/show_bug.cgi?id=17531 .  mls_compute_sid()
> did a linear search over the range transition rules and was therefore
> slow, but more recent kernels use a hash table so this problem has been
> solved.  Another offender is sidtab_search_context() used to convert a
> SELinux context back into an sid, which is also a linear search as there
> is only a sid => context hash table, and I haven't seen any recent
> changes in this area.
>
> Please CC me as I'm not subscribed.
>
> r6144
>

-- 
ak@linux.intel.com -- Speaking for myself only.
