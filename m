Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0ISTSb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 15:18:31 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:36564 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966Ab0ISTSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 15:18:30 -0400
Subject: Re: [PATCH] drm/edid: Don't repeatedly log hex dumps of bad EDIDs
 by default
From: Andy Walls <awalls@md.metrocast.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
In-Reply-To: <AANLkTimVNDwD61TgRDCnL--gu6QV7VVQsK8UqchryUdk@mail.gmail.com>
References: <1284764006.13604.21.camel@morgan.silverblock.net>
	 <20100918115043.GB2953@joi.lan>
	 <AANLkTimVNDwD61TgRDCnL--gu6QV7VVQsK8UqchryUdk@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 15:18:19 -0400
Message-ID: <1284923899.2079.95.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-19_05:2010-09-18,2010-09-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009190111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-19 at 20:39 +0200, Rafał Miłecki wrote:
> 2010/9/18 Marcin Slusarz <marcin.slusarz@gmail.com>:
> > On Fri, Sep 17, 2010 at 06:53:26PM -0400, Andy Walls wrote:
> >> On my system, every 10 seconds drm_edid_block_valid() gets called 4
> >> times by radeon_dvi_detect().  This results in 4 instances of a
> >> multi-line hex dump of the same EDID (non-)data being logged every 10
> >> seconds.
> >>
> >> Silence the hex dump from drm_edid_block_valid() unless a drm_debug
> >> module parameter flag is set.
> >>
> >> Signed-of-by: Andy Walls <awalls@md.metrocast.net>
> >>
> >> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> >> index dce5c4a..33a748c 100644
> >> --- a/drivers/gpu/drm/drm_edid.c
> >> +++ b/drivers/gpu/drm/drm_edid.c
> >> @@ -173,9 +173,12 @@ drm_edid_block_valid(u8 *raw_edid)
> >>
> >>  bad:
> >>         if (raw_edid) {
> >> -               DRM_ERROR("Raw EDID:\n");
> >> -               print_hex_dump_bytes(KERN_ERR, DUMP_PREFIX_NONE, raw_edid, EDID_LENGTH);
> >> -               printk("\n");
> >> +               DRM_DEBUG("Raw EDID:\n");
> >> +               if (drm_debug & DRM_UT_CORE) {
> >> +                       print_hex_dump_bytes(KERN_ERR, DUMP_PREFIX_NONE,
> >> +                                            raw_edid, EDID_LENGTH);
> >> +                       printk("\n");
> >> +               }
> >>         }
> >>         return 0;
> >>  }
> >>
> >
> > Why not print it only once on original error level?
> > Something like:
> > static bool printed = false;
> > if (!printed) {
> >        ...
> >        printed = true;
> > }
> >
> > It has the same effect for you (no spamming by default) and it's still provide some information.
> 
> Should be per-monitor or per-output I think.

Yes, something like that.  I thought about that after my reply.

My perpetual log spam is related to my DVI-D-1 "connector" for my radeon
graphics chip.  So per connector, per graphics chip.

With the patch as provided, the hex dump messages can be turned on and
off using something like:

	echo 1 > /sys/module/drm/parameters/debug
	echo 0 > /sys/module/drm/parameters/debug

once the user has a shell prompt.

Regards,
Andy

