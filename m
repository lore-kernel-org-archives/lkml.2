Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab2ITWbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:31:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:7804 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111Ab2ITWbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:31:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,455,1344236400"; 
   d="scan'208";a="224645883"
Date: Fri, 21 Sep 2012 06:31:06 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        riel@redhat.com, peterz@infradead.org, aarcange@redhat.com,
        daniel.santos@pobox.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Dave Jones <davej@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 6/7] mm: add CONFIG_DEBUG_VM_RB build option
Message-ID: <20120920223106.GA10967@localhost>
References: <20120920213938.GA7959@localhost>
 <alpine.LSU.2.00.1209201520410.15904@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1209201520410.15904@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 03:27:11PM -0700, Hugh Dickins wrote:
> On Fri, 21 Sep 2012, Fengguang Wu wrote:
> > On Sat, Sep 15, 2012 at 11:26:23AM +0200, Sasha Levin wrote:
> > > On 09/15/2012 02:00 AM, Michel Lespinasse wrote:
> > > > All right. Hugh managed to reproduce the issue on his suse laptop, and
> > > > I came up with a fix.
> > > >
> > > > The problem was that in mremap, the new vma's vm_{start,end,pgoff}
> > > > fields need to be updated before calling anon_vma_clone() so that the
> > > > new vma will be properly indexed.
> > > >
> > > > Patch attached. I expect this should also explain Jiri's reported
> > > > failure involving splitting THP pages during mremap(), even though we
> > > > did not manage to reproduce that one.
> > >
> > > Initially I've stumbled on it by running trinity inside a KVM tools guest. fwiw,
> > > the guest is pretty custom and isn't based on suse.
> > >
> > > I re-ran tests with patch applied and looks like it fixed the issue, I haven't
> > > seen the warnings even though it runs for quite a while now.
> > 
> > Not sure if it's the same problem you are talking about, but I got the
> > below warning and it's still happening in linux-next 20120920:
> 
> It is (almost certainly) the same problem, for which Michel provided
> the fix earlier in this thread (some of us find we have to delete a
> " {" from the context at the end to get it to apply).
> 
> That fix has gone into akpm's tree, but linux-next is still using an
> older rollup of akpm's tree.

Got it, thank you for the quick information!

Thanks,
Fengguang

> > [   38.482925] scsi_nl_rcv_msg: discarding partial skb
> > [   62.679879] ------------[ cut here ]------------
> > [   62.680380] WARNING: at /c/kernel-tests/src/linux/mm/interval_tree.c:109 anon_vma_interval_tree_verify+0x33/0x80()
> > [   62.681356] Pid: 195, comm: trinity-child0 Not tainted 3.6.0-rc6-next-20120918-08732-g3de9d1a #1
> > [   62.682130] Call Trace:
> > [   62.682356]  [<ffffffff810c249f>] ? anon_vma_interval_tree_verify+0x33/0x80
> > [   62.682968]  [<ffffffff81044356>] warn_slowpath_common+0x5d/0x74
> > [   62.683577]  [<ffffffff81044424>] warn_slowpath_null+0x15/0x19
> > [   62.684098]  [<ffffffff810c249f>] anon_vma_interval_tree_verify+0x33/0x80
> > [   62.684714]  [<ffffffff810ca57c>] validate_mm+0x32/0x15b
> > [   62.685202]  [<ffffffff810ca767>] vma_link+0x95/0xa4
> > [   62.685637]  [<ffffffff810cbc31>] copy_vma+0x1c7/0x1fe
> > [   62.686168]  [<ffffffff810cdd50>] move_vma+0x90/0x1ef
> > [   62.686614]  [<ffffffff810ce250>] sys_mremap+0x3a1/0x429
> > [   62.687094]  [<ffffffff813caafe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> > [   62.687670]  [<ffffffff81b505b9>] system_call_fastpath+0x16/0x1b
> > 
> > Bisected down to 
> > 
> > commit cb58d445d2ec3a06f313e29d6f6af5bef6c9e43c
> > Author: Michel Lespinasse <walken@google.com>
> > Date:   Thu Sep 13 10:58:56 2012 +1000
> > 
> >     mm: add CONFIG_DEBUG_VM_RB build option
> > 
> > Thanks,
> > Fengguang
