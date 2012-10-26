Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab2JZQzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 12:55:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:25591 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab2JZQzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 12:55:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,654,1344236400"; 
   d="scan'208";a="209763099"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: "Kleen, Andi" <andi.kleen@intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Akira Fujita <a-fujita@rs.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: RE: [PATCH 2/3] ext4: introduce ext4_error_remove_page
Thread-Topic: [PATCH 2/3] ext4: introduce ext4_error_remove_page
Thread-Index: AQHNssNn60IFoxEWWkW+xJzYf95sNpfLkXcAgAA0tFA=
Date: Fri, 26 Oct 2012 16:55:01 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D5A13B@ORSMSX108.amr.corp.intel.com>
References: <1351177969-893-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1351177969-893-3-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20121026061206.GA31139@thunk.org>
In-Reply-To: <20121026061206.GA31139@thunk.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If we go back to first principles, what do we want to do?  We want the
> system administrator to know that a file might be potentially
> corrupted.  And perhaps, if a program tries to read from that file, it
> should get an error.  If we have a program that has that file mmap'ed
> at the time of the error, perhaps we should kill the program with some
> kind of signal.  But to force a reboot of the entire system?  Or to
> remounte the file system read-only?  That seems to be completely
> disproportionate for what might be 2 or 3 bits getting flipped in a
> page cache for a file.

I think that we know that the file *is* corrupted, not just "potentially".
We probably know the location of the corruption to cache-line granularity.
Perhaps better on systems where we have access to ecc syndrome bits,
perhaps worse ... we do have some errors where the low bits of the address
are not known.

I'm in total agreement that forcing a reboot or fsck is unhelpful here.

But what should we do?  We don't want to let the error be propagated. That
could cause a cascade of more failures as applications make bad decisions
based on the corrupted data.

Perhaps we could ask the filesystem to move the file to a top-level
"corrupted" directory (analogous to "lost+found") with some attached
metadata to help recovery tools know where the file came from, and the
range of corrupted bytes in the file? We'd also need to invalidate existing
open file descriptors (or less damaging - flag them to avoid the corrupted
area??). Whatever we do, it needs to be persistent across a reboot ... the
lost bits are not going to magically heal themselves.

We already have code to send SIGBUS to applications that have the
corrupted page mmap(2)'d (see mm/memory-failure.c).

Other ideas?

-Tony
