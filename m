Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1AUPzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:55:23 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:39490 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752369Ab1AUPzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:55:22 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: XbIPJWMVM1lQwaSZh5xwbKslOydfciLNnRgcCQaJPI3Kv4t
 vT8CKY9Ts7GH2Y_acr2Pr96Izr99fRRQ4UqwGr0fqwOMrJyuJSeqcBaqhOd6
 j.rrRF5RZ78Hg.FJwLQbCJLy.MF_GaJrc9Uclk8I_2NJ9PwWL5tFdX6mlqLT
 wAPwZ6ucuGUPI.3oy3c2GFTgqeme91wnX2qfZ4OBR_0yrbKUcQLp2gwjYtm9
 pV70dgZwod1T_6NC3osM.FYUgLjPUUSbMEskbRdlbxTRS4hZ2c3X5AU8Ak67
 fWxeMPYYeMM69ZEvLXiCdty2fL..tTAIGgTVgbNgyh5FB4Rs-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 21 Jan 2011 09:55:17 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [REPOST] [PATCH 3/3] Provide control over unmapped pages (v3)
In-Reply-To: <20110121072315.GL2897@balbir.in.ibm.com>
Message-ID: <alpine.DEB.2.00.1101210947270.13881@router.home>
References: <20110120123039.30481.81151.stgit@localhost6.localdomain6> <20110120123649.30481.93286.stgit@localhost6.localdomain6> <alpine.DEB.2.00.1101200856310.10695@router.home> <20110121072315.GL2897@balbir.in.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Balbir Singh wrote:

> * Christoph Lameter <cl@linux.com> [2011-01-20 09:00:09]:
>
> > On Thu, 20 Jan 2011, Balbir Singh wrote:
> >
> > > +	unmapped_page_control
> > > +			[KNL] Available if CONFIG_UNMAPPED_PAGECACHE_CONTROL
> > > +			is enabled. It controls the amount of unmapped memory
> > > +			that is present in the system. This boot option plus
> > > +			vm.min_unmapped_ratio (sysctl) provide granular control
> >
> > min_unmapped_ratio is there to guarantee that zone reclaim does not
> > reclaim all unmapped pages.
> >
> > What you want here is a max_unmapped_ratio.
> >
>
> I thought about that, the logic for reusing min_unmapped_ratio was to
> keep a limit beyond which unmapped page cache shrinking should stop.

Right. That is the role of it. Its a minimum to leave. You want a maximum
size of the pagte cache.

> I think you are suggesting max_unmapped_ratio as the point at which
> shrinking should begin, right?

The role of min_unmapped_ratio is to never reclaim more pagecache if we
reach that ratio even if we have to go off node for an allocation.

AFAICT What you propose is a maximum size of the page cache. If the number
of page cache pages goes beyond that then you trim the page cache in
background reclaim.

> > > +			reclaim_unmapped_pages(priority, zone, &sc);
> > > +
> > >  			if (!zone_watermark_ok_safe(zone, order,
> >
> > Hmmmm. Okay that means background reclaim does it. If so then we also want
> > zone reclaim to be able to work in the background I think.
>
> Anything specific you had in mind, works for me in testing, but is
> there anything specific that stands out in your mind that needs to be
> done?

Hmmm. So this would also work in a NUMA configuration, right. Limiting the
sizes of the page cache would avoid zone reclaim through these limit. Page
cache size would be limited by the max_unmapped_ratio.

zone_reclaim only would come into play if other allocations make the
memory on the node so tight that we would have to evict more page
cache pages in direct reclaim.
Then zone_reclaim could go down to shrink the page cache size to
min_unmapped_ratio.



