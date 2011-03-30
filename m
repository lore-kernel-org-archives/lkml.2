Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab1C3OHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:07:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:64250 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812Ab1C3OHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:07:32 -0400
Message-Id: <b7da2f$qtmdi3@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,269,1299484800"; 
   d="scan'208";a="903558723"
Date: Wed, 30 Mar 2011 15:07:28 +0100
To: Jerome Glisse <j.glisse@gmail.com>
Subject: Re: GEM-related desktop sluggishness due to linear-time arch_get_unmapped_area_topdown()
Cc: Dave Airlie <airlied@gmail.com>, r6144 <rainy6144@gmail.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1301310995.5615.92.camel@wangqingchuan> <1301336010.2217.20.camel@workstation> <AANLkTikMJszEyv8-SMMjD-MeykSwmsKf=gmezcMgySoP@mail.gmail.com> <1301409864.5615.98.camel@wangqingchuan> <AANLkTi=fcWBpmQ66a3+vQwgFOXn=0rJAviNzR4a0mfcJ@mail.gmail.com> <1301421664.2151.12.camel@Portable-Work> <AANLkTin_v5h==E0i5mQgK2AEdaZhwViykr3acbz4CW0k@mail.gmail.com> <20110329202608.GA3454@viiv.ffwll.ch> <AANLkTim2AyGPrun8MNq0=TyXpJ+b8i=eyHhLz01F+f2P@mail.gmail.com> <AANLkTi=vFwoKCOsvyGBQA9w01QX_TwGu_GF6mA0grr2o@mail.gmail.com> <849307$c7qtj5@azsmga001.ch.intel.com> <AANLkTinxVznFtHwM2RM3kNm9-eSXuz9L7TgfaMpgu=uZ@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTinxVznFtHwM2RM3kNm9-eSXuz9L7TgfaMpgu=uZ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 09:28:07 -0400, Jerome Glisse <j.glisse@gmail.com> wrote:
> On Wed, Mar 30, 2011 at 3:32 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > On Wed, 30 Mar 2011 07:57:49 +1000, Dave Airlie <airlied@gmail.com> wrote:
> >> On Wed, Mar 30, 2011 at 7:04 AM, Jerome Glisse <j.glisse@gmail.com> wrote:
> >> > What i had in mind was something little bit more advance that pwrite,
> >> > somethings that would take width,height,pitch of userpage and would be
> >> > able to perform proper blit. But yes pwrite in intel is kind of
> >> > limited.
> >>
> >> TTM has support for userpage binding we just don't use it.
> >
> > Yes, and I've been experimenting with the same in GEM to great effect in
> > the DDX. The complication remains in managing the CPU synchronisation,
> > which suggests that it would only be useful for STREAM_DRAW objects (and
> > perhaps the sub-region updates to STATIC_DRAW). (And for readback, if
> > retrieving the data were the actual bottleneck.)
> 
> What do you mean by CPU synchronisation ? In what i had in mind the
> upload/download would block userspace until operation is, this would
> make upload/dowload barrier of course it doesn't play well with
> usecase where you keep uploading/downloading (idea to aleviate that is
> to allow several download/upload in one ioctl call).

Yes, that is the issue: having to control access to the user pages whilst
they are in use by the GPU. A completely synchronous API for performing
a single pwrite with the blitter is too slow, much slower than doing an
uncached write with the CPU and queueing up multiple blits (as we
currently do).

The API I ended up with for the pwrite using the BLT was to specify a 2D
region (addr, width, height, stride, flags etc) and list of clip rects. At
which point I grew disenchanted, and realised that simply creating a bo
for mapping user pages was the far better solution.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
