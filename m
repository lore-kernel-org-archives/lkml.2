Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab1AYAf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:35:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:18920 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab1AYAf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:35:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,372,1291622400"; 
   d="scan'208";a="700179406"
Subject: more dput lock contentions in 2.6.38-rc?
From: Shaohua Li <shaohua.li@intel.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@kernel.dk>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 08:35:25 +0800
Message-ID: <1295915725.1949.967.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
we are testing dbench benchmark and see big drop of 2.6.38-rc compared
to 2.6.37 in several machines with 2 sockets or 4 sockets. We have 12
disks mount to /mnt/stp/dbenchdata/sd*/ and dbench runs against data of
the disks. According to perf, we saw more lock contentions:
In 2.6.37: 13.00%        dbench  [kernel.kallsyms]   [k] _raw_spin_lock
In 2.6.38-rc: 69.45%        dbench  [kernel.kallsyms]   [k]_raw_spin_lock
-     69.45%        dbench  [kernel.kallsyms]   [k] _raw_spin_lock
   - _raw_spin_lock
      - 48.41% dput
         - 61.17% path_put
            - 60.47% do_path_lookup
               + 53.18% user_path_at
               + 42.13% do_filp_open
               + 4.69% user_path_parent
            - 35.56% d_path
                 seq_path
                 show_vfsmnt
                 seq_read
                 vfs_read
                 sys_read
                 system_call_fastpath
                 __GI___libc_read
            + 2.17% do_filp_open
            + 1.72% mounts_release
         + 38.69% link_path_walk
      + 30.21% path_get
      + 19.08% nameidata_drop_rcu
      + 0.83% __d_lookup
it appears there are heavy lock contention when dput release '/', 'mnt',
'stp', 'dbenchdata' and 'proc' when dbench is running.

Thanks,
Shaohua

