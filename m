Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0HXJzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:55:38 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:43400 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab0HXJzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:55:36 -0400
Date: Tue, 24 Aug 2010 10:55:35 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [REGRESSION, BISECTED, i915]: Periodic stalls with 2.6.36-rc2
Message-ID: <20100824095535.GA14020@sucs.org>
References: <20100823233551.GA31920@sucs.org> <89kc63$hrmse5@fmsmga002.fm.intel.com> <20100824075741.GA11000@sucs.org> <8u3s8d$jcg467@orsmga001.jf.intel.com> <20100824084902.GA27569@sucs.org> <89kc63$hrqoho@fmsmga002.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89kc63$hrqoho@fmsmga002.fm.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 10:00:47AM +0100, Chris Wilson wrote:
> 
> I was hoping that git would be more intelligent than that. Is there a
> way to simply bisect down one side of a merge?

Seemingly not...

> The slow boot is probably fixed by 4936a3b90d79dd8775c6ac23c2cf2dcebe29abde.
> A trivial patch you can apply on each step is:

Thanks that patch got it booting at normal speeds. Bisecting has now
narrowed the flickering/corruption with a newer X userspace down to
this:

commit 9d0498a2bf7455159b317f19531a3e5db2ecc9c4
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Wed Aug 18 13:20:54 2010 -0700

    drm/i915: wait for actual vblank, not just 20ms
    
    Waiting for a hard coded 20ms isn't always enough to make sure a vblank
    period has actually occurred, so add code to make sure we really have
    passed through a vblank period (or that the pipe is off when disabling).
    
    This prevents problems with mode setting and link training, and seems to
    fix a bug like https://bugs.freedesktop.org/show_bug.cgi?id=29278, but
    on an HP 8440p instead.  Hopefully also fixes
    https://bugs.freedesktop.org/show_bug.cgi?id=29141.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

Reverting the above against HEAD seems to have fixed the misdetection of
displays and hangcheck warnings don't appear (although plenty of FIFO
warnings still). I notice that this commit also seemed to be the cause
of problems for Ivan and Pekka in http://lkml.org/lkml/2010/8/23/452 ...

-- 
Sitsofe | http://sucs.org/~sits/
