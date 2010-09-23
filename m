Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab0IWMRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 08:17:10 -0400
Received: from relay2.sgi.com ([192.48.179.30]:55037 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754697Ab0IWMRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:17:08 -0400
Date: Thu, 23 Sep 2010 07:17:04 -0500
From: Robin Holt <holt@sgi.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Benjamin LaHaise <bcrl@kvack.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Miklos Szeredi <mszeredi@suse.cz>, Mingming Cao <cmm@us.ibm.com>,
        Nick Piggin <npiggin@kernel.dk>, Pavel Emelyanov <xemul@openvz.org>
Cc: holt@sgi.com, linux-kernel@vger.kernel.org
Subject: When booting a 16TB system, unix_create1 fails due to integer
 overflow.
Message-ID: <20100923121704.GR14064@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I do not know which direction to take, but here is the summary of the
problem.

We recently started trying to boot a customer's two new machines which
are configured with 384GB short of 16TB of memory.

We were seeing a failure which prevented boot.  The kernel was incapable
of creating either a named pipe or unix domain socket.  This comes down
to a common kernel function called unix_create1() which does:

	atomic_inc(&unix_nr_socks);
	if (atomic_read(&unix_nr_socks) > 2 * get_max_files())
		goto out;

The function get_max_files() is a simple return of files_stat.max_files.
files_stat.max_files is a signed integer and is computed in
fs/file_table.c's files_init().

	n = (mempages * (PAGE_SIZE / 1024)) / 10;
	files_stat.max_files = n;

In our case, mempages (total_ram_pages) is approx 3,758,096,384
(0xe0000000).  That leaves max_files at approximately 1,503,238,553.
This causes 2 * get_max_files() to integer overflow.

We came up with a few possible solutions:

Our first response was to limit max_files to (INT_MAX / 2)  This at
least got us past the problem and seemed reasonable.

We could also have changed the 2 * get_max_files() to 2UL *
get_max_files() and gotten past this point in boot.  That was not tested.

We could also have changed the definition of max_files to at least an
unsigned int instead of an int and gotten past the problem, but again,
not tested.


Any suggestions for a direction would be appreciated.

Thank you,
Robin Holt
