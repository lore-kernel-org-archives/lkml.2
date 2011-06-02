Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab1FBScp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:32:45 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:51515 "HELO
	shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752198Ab1FBSco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:32:44 -0400
Date: Thu, 2 Jun 2011 13:32:44 -0500
From: lkml@pengaru.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>,
        miklos <miklos@szeredi.hu>
Subject: Re: bdi_min_ratio never shrinks, ultimately preventing valid setting of min_ratio
Message-ID: <20110602183244.GB5753@shells.gnugeneration.com>
References: <20110601002854.GV5753@shells.gnugeneration.com> <1307015011.2497.633.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307015011.2497.633.camel@laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 01:43:31PM +0200, Peter Zijlstra wrote:
> It really helps if you CC the relevant people.
> 
> On Tue, 2011-05-31 at 19:28 -0500, lkml@pengaru.com wrote:
> > mm/page-writeback.c
> > There is a static global bdi_min_ratio used for policing the setting of
> > per-bdi min_ratio's, to ensure the sum doesn't cross 100.
> > 
> > There is no place in this listing where the value is decremented by the
> > respective bdi's min_ratio when a bdi is torn down. 
> 
> There is, adding a negative number is equal to a subtraction.
> 
>                 min_ratio -= bdi->min_ratio;
>                 if (bdi_min_ratio + min_ratio < 100) {
>                         bdi_min_ratio += min_ratio;
>                         bdi->min_ratio += min_ratio;
>                 }
> 
> is the relevant piece, note that bdi->min_ratio is the current setting,
> this makes min_ratio the difference between the new and old setting, and
> adding this to both bdi_min_ratio (the global sum) and bdi->min_ratio
> dtrt regardless if the new value is larger or smaller than the old
> value.

This accounts for the repeated setting of min_ratio on the same bdi.  But
does bdi_set_min_ratio() get entered with a min_ratio of 0 on bdi removal?
If not, we leak the non-zero min_ratio of a removed bdi.

> 
> >  This looks like a bug
> > to me, and I have a situation where I'm unable to set a min_ratio to 1
> > where the sum of /sys/class/bdi/*/min_ratio does not add up to 100, which
> > is what triggered this investigation.
> 
> Which of the two -EINVAL cases is triggered?

It's the bdi_min_ratio + min_ratio >= 100 case.

The system has many usb disks coming and going day to day, with their
respective bdi's having min_ratio set to 1 when inserted.  It works for
some time until eventually min_ratio can no longer be set, even when the
active set of bdi's seen in /sys/class/bdi/*/min_ratio doesn't add up to
anywhere near 100.

This then leads to an unrelated starvation problem caused by write-heavy
fuse mounts being used atop the usb disks, a problem the min_ratio
setting at the underlying devices bdi effectively prevents.

Regards,
Vito Caputo
