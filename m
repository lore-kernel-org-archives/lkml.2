Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0KODyQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:54:16 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57488 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab0KODyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:54:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=tEcX8f4T+7FepWcM4k26qUkF7MplyshGm8HRCd4Npl27RkXJIRWj9PT0AjfP3KD/4y
         s2lFQcsDkMmKVDBjdP9YtZrcHN5h9gHvO59b7tAn96C/4heILy8pdFbr8STWEXLsHDTN
         anFtQucS3t6lI4oYc102hG6xY9L/9LeL0nb6U=
Subject: Sluggishness on a GEM system due to SELinux's
 sidtab_search_context() as well as get_unmapped_area()
From: r6144 <rainy6144@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="GB2312"
Date: Mon, 15 Nov 2010 11:52:05 +0800
Message-ID: <1289793125.12243.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm noticing significant sluggishness when switching into a workspace
where Evolution is running.

My kernel is Fedora 12's 2.6.32.16-150.fc12.x86_64 (I know it is
old...), and the open source radeon (r600) driver is used.  Oprofile
shows the follows:

CPU: Core 2, speed 2003 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a
unit mask of 0x00 (Unhalted core cycles) count 100000
Counted INST_RETIRED_ANY_P events (number of instructions retired) with
a unit mask of 0x00 (No unit mask) count 100000
samples  %        samples  %        image name               app name
symbol name
126807   31.2201  38744    28.3866  vmlinux                  Xorg
(deleted)           find_vma
48661    11.9804  3474      2.5453  vmlinux                  Xorg
(deleted)           mls_compute_sid
41806    10.2927  5700      4.1762  vmlinux                  Xorg
(deleted)           sidtab_search_context
11888     2.9268  4234      3.1021  Xorg (deleted)           Xorg
(deleted)           /usr/bin/Xorg (deleted)
8660      2.1321  1589      1.1642  drm                      Xorg
(deleted)           /drm
6228      1.5333  6773      4.9624  radeon                   Xorg
(deleted)           /radeon
6214      1.5299  1832      1.3423  libc-2.11.2.so (deleted) Xorg
(deleted)           /lib64/libc-2.11.2.so (deleted)
5542      1.3644  4929      3.6113
libpixman-1.so.0.16.6.#prelink#.3I5wow (deleted) Xorg
(deleted)           /usr/lib64/libpixman-1.so.0.16.6.#prelink#.3I5wow
(deleted)
4149      1.0215  1776      1.3012  libexa.so                Xorg
(deleted)           /usr/lib64/xorg/modules/libexa.so
4140      1.0193  640       0.4689  vmlinux                  oprofiled
mls_compute_sid
3183      0.7837  847       0.6206  vmlinux                  Xorg
(deleted)           arch_get_unmapped_area_topdown
...

Although I haven't looked into it, presumably Evolution is asking the X
server to create and map a lot of TTM objects (pixmaps?).  The creation
of each object uses shmem_file_setup() and thus necessitates SELinux
calls, and since the X process already has a lot of mappings (one
mapping for each XRender glyph it seems, with "wc -l /proc/`pgrep
Xorg`/maps" returning 6766), the mapping part could also be slow.

I think the slowness of find_vma is related to
https://bugzilla.kernel.org/show_bug.cgi?id=17531 .  mls_compute_sid()
did a linear search over the range transition rules and was therefore
slow, but more recent kernels use a hash table so this problem has been
solved.  Another offender is sidtab_search_context() used to convert a
SELinux context back into an sid, which is also a linear search as there
is only a sid => context hash table, and I haven't seen any recent
changes in this area.

Please CC me as I'm not subscribed.

r6144

