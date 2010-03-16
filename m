Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab0CPWWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 18:22:39 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:50877 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab0CPWWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 18:22:37 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALChn0urR7Ht/2dsb2JhbACbBHOhY5h0hHYEgxo
X-IronPort-AV: E=Sophos;i="4.49,653,1262563200"; 
   d="scan'208";a="497709337"
From: Roland Dreier <rdreier@cisco.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: bug list: range checking issues 2.6.34-rc1
References: <201003151002.18928.toralf.foerster@gmx.de>
	<20100315101146.GL18181@bicker>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 16 Mar 2010 15:22:33 -0700
In-Reply-To: <20100315101146.GL18181@bicker> (Dan Carpenter's message of "Mon,
	15 Mar 2010 13:45:23 +0300")
Message-ID: <adar5nj9aae.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > drivers/infiniband/core/user_mad.c +646 ib_umad_reg_agent() 'umm' 4 <= 6
 >    641                          u32 *umm = (u32 *) ureq.method_mask;
 >    642                          int i;
 >    643  
 >    644                          for (i = 0; i < BITS_TO_LONGS(IB_MGMT_MAX_METHODS); ++i)
 >    645                                  req.method_mask[i] =
 >    646                                          umm[i * 2] | ((u64) umm[i * 2 + 1] << 32);
 > "umm" points to a array with 4 elements.
 > i can be 0 to 3, so "i * 2" goes up to 6
 > And 4 <= 6 so it's a problem.
 > Smatch also complained about "i * 2 + 1" but I didn't include that. 

It's a bit tricky, but I believe this is a false positive.  The code in
question is compatibility handling for 32-bit userspace on a 64-bit
kernel.  In that case the range of i will be 0 to 1 (IB_MGMT_MAX_METHODS
is 128, so BITS_TO_LONGS on that is 2), and so we will only access
elements 0, 1, 2, and 3 of umm[], which is OK.

(Not sure how easily a static checker could find this; the code in
question is guarded by test of compat_method_mask, which can only be 1
if ib_umad_reg_agent() is called from ib_umad_compat_ioctl(), which will
only be built with CONFIG_COMPAT set, which can only happen on a 64-bit
architecture -- but it seems a bit hard for a checker to follow all that)
-- 
Roland Dreier  <rolandd@cisco.com>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
