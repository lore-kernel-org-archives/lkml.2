Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab2JYE3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 00:29:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:22987 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab2JYE3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 00:29:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,643,1344236400"; 
   d="scan'208";a="239951972"
Date: Thu, 25 Oct 2012 10:58:26 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ni zhan Chen <nizhan.chen@gmail.com>
Cc: YingHang Zhu <casualfisher@gmail.com>, Dave Chinner <david@fromorbit.com>,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: readahead: remove redundant ra_pages in file_ra_state
Message-ID: <20121025025826.GB23462@localhost>
References: <1350996411-5425-1-git-send-email-casualfisher@gmail.com>
 <20121023224706.GR4291@dastard>
 <CAA9v8mGjdi9Kj7p-yeLJx-nr8C+u4M=QcP5+WcA+5iDs6-thGw@mail.gmail.com>
 <20121024201921.GX4291@dastard>
 <CAA9v8mExDX1TYgCrRfYuh82SnNmNkqC4HjkmczSnz3Ca4zT_qw@mail.gmail.com>
 <20121025015014.GC29378@dastard>
 <CAA9v8mEULAEHn8qSsFokEue3c0hy8pK8bkYB+6xOtz_Tgbp0vw@mail.gmail.com>
 <50889FF1.9030107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50889FF1.9030107@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

> But how can bdi related ra_pages reflect different files' readahead
> window? Maybe these different files are sequential read, random read
> and so on.

It's simple: sequential reads will get ra_pages readahead size while
random reads will not get readahead at all.

Talking about the below chunk, it might hurt someone that explicitly
takes advantage of the behavior, however the ra_pages*2 seems more
like a hack than general solution to me: if the user will need
POSIX_FADV_SEQUENTIAL to double the max readahead window size for
improving IO performance, then why not just increase bdi->ra_pages and
benefit all reads? One may argue that it offers some differential
behavior to specific applications, however it may also present as a
counter-optimization: if the root already tuned bdi->ra_pages to the
optimal size, the doubled readahead size will only cost more memory
and perhaps IO latency.

--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -87,7 +86,6 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
                spin_unlock(&file->f_lock);
                break;
        case POSIX_FADV_SEQUENTIAL:
-               file->f_ra.ra_pages = bdi->ra_pages * 2;
                spin_lock(&file->f_lock);
                file->f_mode &= ~FMODE_RANDOM;
                spin_unlock(&file->f_lock);

Thanks,
Fengguang
