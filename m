Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab0CRIzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 04:55:18 -0400
Received: from mail-bw0-f212.google.com ([209.85.218.212]:56263 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab0CRIzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 04:55:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ulxDTVnTWrOmqcS/QAbfOdPPG5+ObSkYY11O1HPu/fnmx/oyontj8+bRkhE/ldfejL
         izlUWUm2zhMPcxzTMM33eHP2fSTKgRq4GJJiLmRUDltZU79HBVy+I5vG4rFtlbbuml90
         9nUWQVWQt6fyU6v6akzLrX8BS6hP5OxYfR4vA=
Date: Thu, 18 Mar 2010 11:55:04 +0300
From: Dan Carpenter <error27@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: bug list: range checking issues 2.6.34-rc1
Message-ID: <20100318085504.GL5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Roland Dreier <rdreier@cisco.com>,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <201003151002.18928.toralf.foerster@gmx.de> <20100315101146.GL18181@bicker> <adar5nj9aae.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adar5nj9aae.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 03:22:33PM -0700, Roland Dreier wrote:
>  > > drivers/infiniband/core/user_mad.c +646 ib_umad_reg_agent() 'umm' 4 <= 6
>  >    641                          u32 *umm = (u32 *) ureq.method_mask;
>  >    642                          int i;
>  >    643  
>  >    644                          for (i = 0; i < BITS_TO_LONGS(IB_MGMT_MAX_METHODS); ++i)
>  >    645                                  req.method_mask[i] =
>  >    646                                          umm[i * 2] | ((u64) umm[i * 2 + 1] << 32);
>  > "umm" points to a array with 4 elements.
>  > i can be 0 to 3, so "i * 2" goes up to 6
>  > And 4 <= 6 so it's a problem.
>  > Smatch also complained about "i * 2 + 1" but I didn't include that. 
> 
> It's a bit tricky, but I believe this is a false positive.  The code in
> question is compatibility handling for 32-bit userspace on a 64-bit
> kernel.  In that case the range of i will be 0 to 1 (IB_MGMT_MAX_METHODS
> is 128, so BITS_TO_LONGS on that is 2), and so we will only access
> elements 0, 1, 2, and 3 of umm[], which is OK.
> 
> (Not sure how easily a static checker could find this; the code in
> question is guarded by test of compat_method_mask, which can only be 1
> if ib_umad_reg_agent() is called from ib_umad_compat_ioctl(), which will
> only be built with CONFIG_COMPAT set, which can only happen on a 64-bit
> architecture -- but it seems a bit hard for a checker to follow all that)

Smatch doesn't handle anything between functions yet.  Once it does you
could do something like:

compat_method_mask = get_possible_range(this parameter);
That would only be zero, because the other code is #ifdefed out.
Then the rest is simple enough.

It will take some months to get the inter-function stuff working though.

regards,
dan carpenter

> -- 
> Roland Dreier  <rolandd@cisco.com>
> For corporate legal information go to:
> http://www.cisco.com/web/about/doing_business/legal/cri/index.html
