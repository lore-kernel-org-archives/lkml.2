Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1HJJdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:33:00 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:58882 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752822Ab1HJJc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:32:59 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Aug 2011 05:32:58 EDT
Subject: Re: [PATCH 2.6.38-10-generic] device driver: fix oops in radeon
 driver due to incorrect value from hardware
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Mayank Rungta <mr.mynk@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        yakui.zhao@intel.com, "A.R Karthick" <a.r.karthick@gmail.com>,
        karthick.linuxdreamer@gmail.com
Date: Wed, 10 Aug 2011 11:24:31 +0200
In-Reply-To: <4E417AF8.7090202@gmail.com>
References: <4E417AF8.7090202@gmail.com>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA
	R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.0- 
Message-ID: <1312968271.14630.189.camel@thor.local>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2011-08-09 at 23:52 +0530, Mayank Rungta wrote: 
> Added a check for the radeon ring buffer write index in r600.c which 
> reads 0xffffffff on resume. This results in an Oops during 
> radeon_ring_write. Masking the value averts this.
> 
> This problem is not seen to be fixed in 3.0 r600.c as well.
> 
> Detailed analysis of the problem can be found at -
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/820746/
> 
> ---
> 
> BUG: unable to handle kernel paging request at fa501ffc - Oops at 
> r600_cp_start+0x48/0x380 in r600_cp_resume+0x345/0x580 [radeon]
> 
> drivers/gpu/drm/radeon/r600.c
> 
> 
> 
> --- linux-2.6.38/drivers/gpu/drm/radeon/r600.c.orig    2011-08-05 
> 15:39:40.824612700 +0530
> +++ linux-2.6.38/drivers/gpu/drm/radeon/r600.c    2011-08-08 
> 05:29:21.744417857 +0530
> @@ -2218,6 +2218,8 @@ int r600_cp_resume(struct radeon_device
> 
>       rdev->cp.rptr = RREG32(CP_RB_RPTR);
>       rdev->cp.wptr = RREG32(CP_RB_WPTR);
> +    /* protect against crazy HW on resume */
> +    rdev->cp.wptr &= rdev->cp.ptr_mask;

The indentation of the lines you're adding doesn't match the surrounding
lines.


Although the same workaround is already in r100.c, I wonder if we
shouldn't rather try and eliminate all reads from the CP_RB_WPTR
register, at least other than for debugging purposes. Alex, what do you
think?

Otherwise, this should probably be added in evergreen.c as well.


>          Developer's Certificate of Origin 1.1
> 
>          [...]

No need to include all this text, just the *-by: tags are enough.


-- 
Earthling Michel Dänzer           |                   http://www.amd.com
Libre software enthusiast         |          Debian, X and DRI developer
