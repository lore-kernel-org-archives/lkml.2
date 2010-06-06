Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab0FFOxO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:53:14 -0400
Received: from smtp.nokia.com ([192.100.105.134]:18180 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab0FFOxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:13 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCHv5 00/16] kill unnecessary SB sync wake-ups + cleanups
Date: Sun,  6 Jun 2010 17:50:13 +0300
Message-Id: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
X-OriginalArrivalTime: 06 Jun 2010 14:53:07.0200 (UTC) FILETIME=[F954D000:01CB0587]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is the v5 of the SB sync wakups killing patches, the v4 submission can be
found here: http://marc.info/?l=linux-fsdevel&m=127479544728442&w=2

Changes since v4:

- use 'sb_mark_dirty()', 'sb_mark_clean()' and 'sb_is_dirty()' names as
  per Andrew's request
- use lighter locking scheme requested by Al and Andrew and provided by
  Nick Piggin
- various clean-ups as a result of validation of 's_dirt' usage in FSes
  as was requested by Al. To be frank, my energy ended at some point, and
  I did not really validate reiserfs, sysv, UDF and UFS. The former is very
  sub-standard, and the latter are ancient code and I dared not touching it.

The structure of the patch series
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. The first patch introduces s_dirt wrappers and makes all FSes use them.
   Previously I submitted per-FS patches, but now I've folded them all into
   one.
2. Patch 3 implements the whole logic which prevents unnecessary wake-ups.

Then go various clean-ups which I have to do to get upstreamed :-) Note, the
changes described below do not go in exactly this order in the patch series.

3. I've cleaned up AFFS and tested it.
4. Removed unneeded (IMO) code from BFS and tested.
5. Due to races between ->write_super and entities which modify the SB, it
   is possible to end up with a modified SB, but nevertheless marked as clean.
   So I added some more memory barriers and fixed AFFS, exofs, ext2, ext4,
   and HFS. Tested only AFFS.
6. Ancient FSes disrespect the wait flag in ->sync_fs(). They also do not
   wait for the buffers in ->put_super(), which is wrong AFAIU, because we
   are being unmounted, so we have to make sure the stuff was submitted
   to the HW. I fix this in AFFS, HFS, and HFSPLUS.

It looks like sysv, UFS and UDF also do not wait for the buffers in
->put_super, but I did not dare modifying them... I already made too man
modifications in the code I do not know well enough.

Please, review the cleanups - I tested only AFFS and BFS (the rest is only
compile-tested), and I am not really sure the 'wait for buffers' changes are
correct.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
