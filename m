Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab1EaPNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:13:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35899 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1EaPNr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:13:47 -0400
MIME-Version: 1.0
Message-ID: <f1ad0ca7-bf36-46e7-a15a-0ebe9754336f@default>
Date: Tue, 31 May 2011 08:13:19 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Steven Whitehouse <swhiteho@redhat.com>, Joel Becker <jlbec@evilplan.org>
Cc: linux-kernel@vger.kernel.org, Sunil Mushran <sunil.mushran@oracle.com>
Subject: RE: Cleancache and shared filesystems
References: <1306504300.2857.14.camel@menhir>
 <6f0e746a-d3d1-4708-9e16-3d02ddeab824@default>
 <1306513179.2857.38.camel@menhir>
 <20110527233331.GC30232@noexit.corp.google.com
 1306832306.2816.3.camel@menhir>
In-Reply-To: <1306832306.2816.3.camel@menhir>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090202.4DE505A4.0086:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Steven Whitehouse [mailto:swhiteho@redhat.com]
> Sent: Tuesday, May 31, 2011 2:58 AM
> To: Joel Becker
> Cc: Dan Magenheimer; linux-kernel@vger.kernel.org; Sunil Mushran
> Subject: Re: Cleancache and shared filesystems
> 
> Hi,
> 
> On Fri, 2011-05-27 at 16:33 -0700, Joel Becker wrote:
> > On Fri, May 27, 2011 at 05:19:39PM +0100, Steven Whitehouse wrote:
> > > +	if (ls->ls_ops == &gfs2_dlm_ops) {
> > > +		if (gfs2_uuid_valid(sb->s_uuid))
> > > +			cleancache_init_shared_fs(sb->s_uuid, sb);
> > > +	} else {
> > > +		cleancache_init_fs(sb);
> > > +	}
> >
> > Hey Dan,
> > 	Steven makes a good point here.  ocfs2 could also take advantage
> > of local filesystem behavior when running in local mode.
> >
> > Joel
> >
> 
> There is a further issue as well - cleancache will only work when all
> nodes can see the same shared cache, so we will need a mount option to
> disable cleancache in the case we have (for example) a cluster of
> virtual machines split over multiple physical hosts.
> 
> In fact, I think from the principle of least surprise this had better
> default to off and be enabled explicitly. Otherwise I can see that
> people will shoot themselves in the foot which will be very easy since
> there is no automatic way that I can see to verify that all nodes are
> looking at the same cache,

Though it's been nearly two years now since I thought
through this, I remember being concerned about that issue
too. But, for ocfs2 at least, cleancache hooks are embedded
in all the right places in VFS that the ocfs2 code that
cross-invalidates stale page cache pages on different
nodes also ensures coherence of cleancache and it
all just worked, whether VMs are split across hosts or not.

This may or may not be true for GFS2... for example, btrfs
required one cleancache hook outside of VFS to function
correctly.

Again, I am pretty ignorant about shared filesystems
so please correct me if I am missing anything important.

Also, I checked and Xen tmem (the only current user of
cleancache for which cluster-sharing makes sense) uses
128-bit -1 as its internal "don't share" indicator.
So you are correct that multiple non-shared VMs using
uuid==0 could potentially cause data corruption
if they share a physical machine and your code snippet
above is needed (assuming gfs2_uuid_valid returns
false for uuid==0?).


Dan
---
Thanks... for the memory!
I really could use more / my throughput's on the floor
The balloon is flat / my swap disk's fat / I've OOM's in store
Overcommitted so much
(with apologies to Bob Hope)

