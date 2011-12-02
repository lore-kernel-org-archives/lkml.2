Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab1LBCP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:15:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:58176 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab1LBCP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:15:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,281,1320652800"; 
   d="scan'208";a="81339759"
Date: Fri, 2 Dec 2011 10:05:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Jeremy Allison <jra@samba.org>
Subject: Re: [PATCH] fs: Make write(2) interruptible by a fatal signal
Message-ID: <20111202020522.GA14528@localhost>
References: <1322735278-17420-1-git-send-email-jack@suse.cz>
 <20111201122425.GA16274@localhost>
 <20111201142704.GT4387@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201142704.GT4387@parisc-linux.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 10:27:05PM +0800, Matthew Wilcox wrote:
> On Thu, Dec 01, 2011 at 08:24:25PM +0800, Wu Fengguang wrote:
> > > This patch makes write interruptible by SIGKILL.
> > 
> > Let me try to summarize the objective impacts of (not) merging this
> > patch, and would like to hear more opinions from experienced users.
> > 
> > - w/o patch
> > 
> > BEHAVIOR:
> > write(2) insists to complete even when the user really wants to stop it.
> > 
> > IMPACT:
> > It could be annoying to experience slow responses to "kill -9" when
> > it's a large write to a slow device, for example,
> > 
> >         dd if=/dev/zero of=/mnt/nokia/zero bs=100M
> 
> Another problem scenario is an NFS mounted file going away while the
> user is writing to it.  The user should be able to kill the stuck process
> without rebooting their machine.

It turns out to eventually block on close().

I just experimented writing to a default mounted NFS:

dd if=/dev/zero of=/fs/zero bs=100M

snb:/nfs/ on /fs type nfs (rw,relatime,vers=3,rsize=262144,wsize=262144,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.1.61,mountvers=3,mountport=42149,mountproto=udp,local_lock=none,addr=192.168.1.61)

At some time stop the NFS server, and do "kill -9 dd" in the client.
Then NFS tries to flush all dirty pages and wait for all writeback
pages on close(), which blocks dd hard:

[80786.103371] dd              D 0000000000000001  3712  4680   4445 0x00000004
[80786.103878]  ffff8800aade5948 0000000000000046 ffffffff81985509 ffffffff81099bb5
[80786.104589]  ffff8800aade4000 00000000001d3280 00000000001d3280 ffff8800b2020000
[80786.105301]  00000000001d3280 ffff8800aade5fd8 00000000001d3280 ffff8800aade5fd8
[80786.106011] Call Trace:
[80786.106265]  [<ffffffff81985509>] ? __schedule+0x313/0x937
[80786.109674]  [<ffffffff81099bb5>] ? local_clock+0x41/0x5a
[80786.110041]  [<ffffffff81094afd>] ? prepare_to_wait+0x6c/0x79
[80786.110421]  [<ffffffff81099bb5>] ? local_clock+0x41/0x5a
[80786.110788]  [<ffffffff810a490c>] ? lock_release_holdtime+0xa3/0xac
[80786.111188]  [<ffffffff81094afd>] ? prepare_to_wait+0x6c/0x79
[80786.111568]  [<ffffffff8103bd68>] ? read_tsc+0x9/0x1b
[80786.111922]  [<ffffffff811003bc>] ? __lock_page+0x6d/0x6d
[80786.112289]  [<ffffffff81985deb>] schedule+0x5a/0x5c
[80786.112639]  [<ffffffff81985e79>] io_schedule+0x8c/0xcf
[80786.113000]  [<ffffffff811003ca>] sleep_on_page+0xe/0x12
[80786.113362]  [<ffffffff81986562>] __wait_on_bit+0x48/0x7b
[80786.113729]  [<ffffffff81100074>] ? find_get_pages_tag+0x133/0x16e
[80786.114127]  [<ffffffff810fff41>] ? generic_file_readonly_mmap+0x22/0x22
[80786.114543]  [<ffffffff811005be>] wait_on_page_bit+0x72/0x79
[80786.114921]  [<ffffffff810948a7>] ? autoremove_wake_function+0x3d/0x3d
[80786.115331]  [<ffffffff8110b1c9>] ? pagevec_lookup_tag+0x25/0x2e
[80786.115722]  [<ffffffff81100bd2>] filemap_fdatawait_range+0x9c/0x163
[80786.116127]  [<ffffffff8110100c>] filemap_write_and_wait_range+0x46/0x59
[80786.116544]  [<ffffffff81246ca1>] nfs_file_fsync+0x61/0xea
[80786.116915]  [<ffffffff81173617>] vfs_fsync_range+0x23/0x25
[80786.117288]  [<ffffffff81173635>] vfs_fsync+0x1c/0x1e
[80786.117641]  [<ffffffff812467f6>] nfs_file_flush+0x67/0x6c
[80786.118012]  [<ffffffff8114bbc1>] filp_close+0x49/0x7e
[80786.118370]  [<ffffffff81077821>] put_files_struct+0xb0/0x142
[80786.118750]  [<ffffffff81077798>] ? put_files_struct+0x27/0x142
[80786.119137]  [<ffffffff81077950>] exit_files+0x4b/0x54
[80786.119495]  [<ffffffff81077ea1>] do_exit+0x27d/0x780
[80786.119847]  [<ffffffff81099bb5>] ? local_clock+0x41/0x5a
[80786.120214]  [<ffffffff810a490c>] ? lock_release_holdtime+0xa3/0xac
[80786.120614]  [<ffffffff81086ab6>] ? get_signal_to_deliver+0x47a/0x50f
[80786.121022]  [<ffffffff8107863b>] do_group_exit+0x88/0xb6
[80786.121389]  [<ffffffff81086b29>] get_signal_to_deliver+0x4ed/0x50f
[80786.121789]  [<ffffffff810a490c>] ? lock_release_holdtime+0xa3/0xac
[80786.122191]  [<ffffffff81035e6e>] do_signal+0x3e/0x641
[80786.122549]  [<ffffffff810364b6>] do_notify_resume+0x2c/0x6e
[80786.122926]  [<ffffffff8140110e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[80786.123333]  [<ffffffff8198fe13>] int_signal+0x12/0x17

> > - w/ patch
> > 
> > BEHAVIOR:
> > write(2) aborts quickly with possible partial write on SIGKILL
> > 
> > IMPACT:
> > The partial write might lead to data corruption somewhere, sometime
> > (the possibility is low but real) and bring trouble to some users.
> 
> Let's examine these cases.  We've already written at least some of the
> data into the page cache (and updated i_size for extending writes in the
> call to ->write_end).  It's just not hit the backing store yet.  That means
> that this state of affairs is already *visible* to another process on the
> same machine, it's just not *durable* (eg in the event of power failure).
> 
> I think in the worst case, we've simply extended the window of opportunity
> for another process to see the partial write.
> 
> So, please add
> 
> Acked-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

OK. Let's try this. I pushed it to linux-next after updating the
changelog on the balance_dirty_pages() part:

commit a50527b19c62c808a7fca022816fff88a50b948d
Author: Jan Kara <jack@suse.cz>
Date:   Fri Dec 2 09:17:02 2011 +0800

    fs: Make write(2) interruptible by a fatal signal
    
    Currently write(2) to a file is not interruptible by any signal.
    Sometimes this is desirable, e.g. when you want to quickly kill a
    process hogging your disk. Also, with commit 499d05ecf990 ("mm: Make
    task in balance_dirty_pages() killable"), it's necessary to abort the
    current write accordingly to avoid it quickly dirtying lots more pages
    at unthrottled rate.
    
    This patch makes write interruptible by SIGKILL. We do not allow write
    to be interruptible by any other signal because that has larger
    potential of screwing some badly written applications.
    
    Reported-by: Kazuya Mio <k-mio@sx.jp.nec.com>
    Tested-by: Kazuya Mio <k-mio@sx.jp.nec.com>
    Acked-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
    Signed-off-by: Jan Kara <jack@suse.cz>
    Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks,
Fengguang
