Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030208Ab2HWHwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:52:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45073 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab2HWHw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:52:26 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-3b-5035e138152a
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Hiroshi Doyu'" <hdoyu@nvidia.com>
Cc: pullip.cho@samsung.com, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com, arnd@arndb.de,
        linux@arm.linux.org.uk, chunsang.jeong@linaro.org,
        "'Krishna Reddy'" <vdumpa@nvidia.com>, konrad.wilk@oracle.com,
        subashrp@gmail.com, minchan@kernel.org
References: <1345630830-9586-1-git-send-email-hdoyu@nvidia.com>
 <1345630830-9586-3-git-send-email-hdoyu@nvidia.com>
 <CAHQjnOOF7Ca-Dz8K_zcS=gxQsJvKYaWA3tqUeK1RSd-wLYZ44w@mail.gmail.com>
 <20120822.163648.3800987367886904.hdoyu@nvidia.com>
 <012401cd80f4$59727020$0c575060$%szyprowski@samsung.com>
 <20120823091519.804aeae4ba93bcfe011e787c@nvidia.com>
In-reply-to: <20120823091519.804aeae4ba93bcfe011e787c@nvidia.com>
Subject: RE: [RFC 2/4] ARM: dma-mapping: IOMMU allocates pages from pool with
 GFP_ATOMIC
Date: Thu, 23 Aug 2012 09:52:07 +0200
Organization: SPRC
Message-id: <014501cd8104$35a8ce40$a0fa6ac0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2A9v9424aRo/HsRP+UPIS0bLlkOQADPung
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jQV2Lh6YBBlN2W1pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MMzufMhXs4ql42/6MsYHxBmcXIyeHhICJxIZ/75khbDGJC/fW
	s3UxcnEICUxnlPi7exGUM4tJ4sO990wgVWwChhJdb7uAEhwcIgKqEk/nMoLUMAvcY5Jo+7qE
	BaLhCZPE5KnfWUEaOAUcJT5vWADWICwQJXF/aihImAWot+vTelaQML+AkMTEWQogYV4BF4n9
	G7exQtiCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZpFVCQF3i0V9dkLCIgJHEpunzGCFKRCTu
	NjxnncAoPAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLD+5n0
	DsZVDRaHGAU4GJV4eAPumQYIsSaWFVfmHmKU4GBWEuENnwcU4k1JrKxKLcqPLyrNSS0+xCjN
	waIkzsvfZxggJJCeWJKanZpakFoEk2Xi4JRqYNy8J+O7/BzmfT/WP5+jbpvWKXL+eMmd950b
	29+aOm+dqRYxt+ji/S2LwnawX5hu98bndhezht7M+v2tfmknX7olJVrseyH899/xvoVl1VL2
	K3a9MvxxfW3R3k8ammKnzi3/5bl720GFy32vdL4nHhKeviROZ+lZLqO5ZlcnJ+gw3T9yKW13
	3A8+JZbijERDLeai4kQAiiFL1WsCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hiroshi,

On Thursday, August 23, 2012 8:15 AM Hiroshi Doyu wrote:

> On Thu, 23 Aug 2012 07:58:34 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
> > Hello,
> >
> > On Wednesday, August 22, 2012 3:37 PM Hiroshi Doyu wrote:
> >
> > > KyongHo Cho <pullip.cho@samsung.com> wrote @ Wed, 22 Aug 2012 14:47:00 +0200:
> > >
> > > > vzalloc() call in __iommu_alloc_buffer() also causes BUG() in atomic context.
> > >
> > > Right.
> > >
> > > I've been thinking that kzalloc() may be enough here, since
> > > vzalloc() was introduced to avoid allocation failure for big chunk of
> > > memory, but I think that it's unlikely that the number of page array
> > > can be so big. So I propose to drop vzalloc() here, and just simply to
> > > use kzalloc only as below(*1).
> >
> > We already had a discussion about this, so I don't think it makes much sense to
> > change it back to kzalloc. This vmalloc() call won't hurt anyone. It should not
> > be considered a problem for atomic allocations, because no sane driver will try
> > to allocate buffers larger than a dozen KiB with GFP_ATOMIC flag. I would call
> > such try a serious bug, which we should not care here.
> 
> Ok, I've already sent v2 just now, where, instead of changing it back,
> just with GFP_ATOMIC, kzalloc() would be selected, just in case. I guess
> that this would be ok(a bit safer?)

I've posted some comments to v2. If you agree with my suggestion, no changes around
those vmalloc() calls will be needed.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



