Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab2ARXVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 18:21:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2ARXVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 18:21:33 -0500
Date: Wed, 18 Jan 2012 15:21:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: adjust rss counters for migration entiries
Message-Id: <20120118152131.45a47966.akpm@linux-foundation.org>
In-Reply-To: <20120111174126.f35e708a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120106173827.11700.74305.stgit@zurg>
	<20120106173856.11700.98858.stgit@zurg>
	<20120111144125.0c61f35f.kamezawa.hiroyu@jp.fujitsu.com>
	<4F0D46EF.4060705@openvz.org>
	<20120111174126.f35e708a.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012 17:41:26 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 11 Jan 2012 12:23:11 +0400
> Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:
> 
> > KAMEZAWA Hiroyuki wrote:
> > > On Fri, 06 Jan 2012 21:38:56 +0400
> > > Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
> > >
> > >> Memory migration fill pte with migration entry and it didn't update rss counters.
> > >> Then it replace migration entry with new page (or old one if migration was failed).
> > >> But between this two passes this pte can be unmaped, or task can fork child and
> > >> it will get copy of this migration entry. Nobody account this into rss counters.
> > >>
> > >> This patch properly adjust rss counters for migration entries in zap_pte_range()
> > >> and copy_one_pte(). Thus we avoid extra atomic operations on migration fast-path.
> > >>
> > >> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> > >
> > > It's better to show wheter this is a bug-fix or not in changelog.
> > >
> > > IIUC, the bug-fix is the 1st harf of this patch + patch [2/3].
> > > Your new bug-check code is in patch[1/3] and 2nd half of this patch.
> > >
> > 
> > No, there only one new bug-check in 1st patch, this is non-fatal warning.
> > I didn't hide this check under CONFIG_VM_DEBUG because it rather small and
> > rss counters covers whole page-table management, this is very good invariant.
> > Currently I can trigger this warning only on this rare race -- extremely loaded
> > memory compaction catches this every several seconds.
> > 
> > 1/3 bug-check
> > 2/3 fix preparation
> > 3/3 bugfix in two places:
> >      do rss++ in copy_one_pte()
> >      do rss-- in zap_pte_range()
> > 
> 
> Hmm, ok, I read wrong.
> 
> So, I think you should post the patch with [BUGFIX] and
> report 'what happens' and 'what is the bug' , 'what you fixed' explicitly.
> 
> As...
> ==
>   This patch series fixes per-mm rss counter accounting bug. When pages are
>   heavily migrated, the rss counters will go wrong by fork() and unmap()
>   because they ignores migration_pte_entries.
>   This rarelly happens but will make rss counter incorrect.
> 
>   This seires of patches will fix the issue by adding proper accounting of
>   migration_pte_entries in unmap() and fork(). This series includes
>   bug check code, too.

Putting "fix" in the patch title text is a good way of handling this.

I renamed [3/3] to "mm: fix rss count leakage during migration" and
shall queue it for 3.3.  If people think we should also backport it
into -stable then please let me know.

I reordered the patches and worked the chagnelogs quite a bit.  I now
have:

: From: Konstantin Khlebnikov <khlebnikov@openvz.org>
: Subject: mm: fix rss count leakage during migration
: 
: Memory migration fills a pte with a migration entry and it doesn't update
: the rss counters.  Then it replaces the migration entry with the new page
: (or the old one if migration failed).  But between these two passes this
: pte can be unmaped, or a task can fork a child and it will get a copy of
: this migration entry.  Nobody accounts for this in the rss counters.
: 
: This patch properly adjust rss counters for migration entries in
: zap_pte_range() and copy_one_pte().  Thus we avoid extra atomic operations
: on the migration fast-path.
: 
: Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
: Cc: Hugh Dickins <hughd@google.com>
: Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

and

: From: Konstantin Khlebnikov <khlebnikov@openvz.org>
: Subject: mm: add rss counters consistency check
: 
: Warn about non-zero rss counters at final mmdrop.
: 
: This check will prevent reoccurences of bugs such as that fixed in "mm:
: fix rss count leakage during migration".
: 
: I didn't hide this check under CONFIG_VM_DEBUG because it rather small and
: rss counters cover whole page-table management, so this is a good
: invariant.
: 
: Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
: Cc: Hugh Dickins <hughd@google.com>
: Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

and

: From: Konstantin Khlebnikov <khlebnikov@openvz.org>
: Subject: mm: postpone migrated page mapping reset
: 
: Postpone resetting page->mapping until the final remove_migration_ptes(). 
: Otherwise the expression PageAnon(migration_entry_to_page(entry)) does not
: work.
: 
: Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
: Cc: Hugh Dickins <hughd@google.com>
: Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

