Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559Ab1FBLmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:42:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57988 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933513Ab1FBLmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:42:21 -0400
Subject: Re: bdi_min_ratio never shrinks, ultimately preventing valid
 setting of min_ratio
From: Peter Zijlstra <peterz@infradead.org>
To: lkml@pengaru.com
Cc: linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>,
        miklos <miklos@szeredi.hu>
In-Reply-To: <20110601002854.GV5753@shells.gnugeneration.com>
References: <20110601002854.GV5753@shells.gnugeneration.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 13:43:31 +0200
Message-ID: <1307015011.2497.633.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It really helps if you CC the relevant people.

On Tue, 2011-05-31 at 19:28 -0500, lkml@pengaru.com wrote:
> mm/page-writeback.c
> There is a static global bdi_min_ratio used for policing the setting of
> per-bdi min_ratio's, to ensure the sum doesn't cross 100.
> 
> There is no place in this listing where the value is decremented by the
> respective bdi's min_ratio when a bdi is torn down. 

There is, adding a negative number is equal to a subtraction.

                min_ratio -= bdi->min_ratio;
                if (bdi_min_ratio + min_ratio < 100) {
                        bdi_min_ratio += min_ratio;
                        bdi->min_ratio += min_ratio;
                }

is the relevant piece, note that bdi->min_ratio is the current setting,
this makes min_ratio the difference between the new and old setting, and
adding this to both bdi_min_ratio (the global sum) and bdi->min_ratio
dtrt regardless if the new value is larger or smaller than the old
value.

>  This looks like a bug
> to me, and I have a situation where I'm unable to set a min_ratio to 1
> where the sum of /sys/class/bdi/*/min_ratio does not add up to 100, which
> is what triggered this investigation.

Which of the two -EINVAL cases is triggered?

