Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab1KVIgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 03:36:35 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:55419 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab1KVIgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 03:36:33 -0500
Date: Tue, 22 Nov 2011 09:36:30 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, tj@kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
Message-ID: <20111122083630.GA1672@x4.trippels.de>
References: <1321836285.30341.554.camel@debian>
 <20111121080554.GB1625@x4.trippels.de>
 <20111121082445.GD1625@x4.trippels.de>
 <1321866988.2552.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20111121131531.GA1679@x4.trippels.de>
 <1321884966.10470.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20111121153621.GA1678@x4.trippels.de>
 <1321890510.10470.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20111121161036.GA1679@x4.trippels.de>
 <20111121163459.GA1679@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111121163459.GA1679@x4.trippels.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.11.21 at 17:34 +0100, Markus Trippelsdorf wrote:
> On 2011.11.21 at 17:10 +0100, Markus Trippelsdorf wrote:
> > On 2011.11.21 at 16:48 +0100, Eric Dumazet wrote:
> > > Le lundi 21 novembre 2011 à 16:36 +0100, Markus Trippelsdorf a écrit :
> > > > On 2011.11.21 at 15:16 +0100, Eric Dumazet wrote:
> > > > > Le lundi 21 novembre 2011 à 14:15 +0100, Markus Trippelsdorf a écrit :
> > > > > 
> > > > > > I've enabled CONFIG_SLUB_DEBUG_ON and this is what happend:
> > > > > > 
> > > > > 
> > > > > Thanks
> > > > > 
> > > > > Please continue to provide more samples.
> > > > > 
> > > > > There is something wrong somewhere, but where exactly, its hard to say.
> > > > 
> > > > New sample. This one points to lib/idr.c:
> > > > 
> > > > =============================================================================
> > > > BUG idr_layer_cache: Poison overwritten
> > > > -----------------------------------------------------------------------------
> > > 
> > > Thanks, could you now add "CONFIG_DEBUG_PAGEALLOC=y" in your config as
> > > well ?
> > 
> > Sure. This one happend with CONFIG_DEBUG_PAGEALLOC=y:
> > 
> > =============================================================================
> > BUG task_struct: Poison overwritten
> > -----------------------------------------------------------------------------
> 
> And sometimes this one that I've reported earlier already:
> 
> (see: http://thread.gmane.org/gmane.linux.kernel/1215023 )
> 
>  ------------[ cut here ]------------
>  WARNING: at fs/sysfs/sysfs.h:195 sysfs_get_inode+0x136/0x140()
>  Hardware name: System Product Name
>  Pid: 1876, comm: slabinfo Not tainted 3.2.0-rc2-00274-g6fe4c6d #72
>  Call Trace:
>  [<ffffffff8106cac5>] warn_slowpath_common+0x75/0xb0
>  [<ffffffff8106cbc5>] warn_slowpath_null+0x15/0x20
>  [<ffffffff81163236>] sysfs_get_inode+0x136/0x140
>  [<ffffffff81164cef>] sysfs_lookup+0x6f/0x110
>  [<ffffffff811173f9>] d_alloc_and_lookup+0x39/0x80
>  [<ffffffff81118774>] do_lookup+0x294/0x3a0
>  [<ffffffff8111798a>] ? inode_permission+0x7a/0xb0
>  [<ffffffff8111a3f7>] do_last.isra.46+0x137/0x7f0
>  [<ffffffff8111ab76>] path_openat+0xc6/0x370
>  [<ffffffff81117606>] ? getname_flags+0x36/0x230
>  [<ffffffff810ec852>] ? handle_mm_fault+0x192/0x290
>  [<ffffffff8111ae5c>] do_filp_open+0x3c/0x90
>  [<ffffffff81127c8c>] ? alloc_fd+0xdc/0x120
>  [<ffffffff8110ce77>] do_sys_open+0xe7/0x1c0
>  [<ffffffff8110cf6b>] sys_open+0x1b/0x20
>  [<ffffffff814ccb7b>] system_call_fastpath+0x16/0x1b
>  ---[ end trace b1377eb8b131d37d ]---

Hm, the "sysfs: use rb-tree" thing hit again during boot. Could this be
the root cause of this all?

I wrote down the following:

RIP : rb_next

Trace:
 sysfs_dir_pos
 sysfs_readdir
 ? sys_ioctl
 vfs_readdir
 sys_getdents

-- 
Markus
