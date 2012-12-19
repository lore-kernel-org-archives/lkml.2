Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab2LSWlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:41:18 -0500
Received: from mail.active-venture.com ([67.228.131.205]:57791 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab2LSWlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:41:13 -0500
X-Originating-IP: 108.223.40.66
Date: Wed, 19 Dec 2012 14:41:22 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Juergen Beisert <jbe@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v2] linux/kernel.h: Fix DIV_ROUND_CLOSEST with unsigned
 divisors
Message-ID: <20121219224122.GA26863@roeck-us.net>
References: <1355928015-26212-1-git-send-email-linux@roeck-us.net>
 <20121219134721.bbde212f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219134721.bbde212f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 01:47:21PM -0800, Andrew Morton wrote:
> On Wed, 19 Dec 2012 06:40:15 -0800
> Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > Commit 263a523 fixes a warning seen with W=1 due to change in
> > DIV_ROUND_CLOSEST. Unfortunately, the C compiler converts divide operations
> > with unsigned divisors to unsigned, even if the dividend is signed and
> > negative (for example, -10 / 5U = 858993457). The C standard says "If one
> > operand has unsigned int type, the other operand is converted to unsigned
> > int", so the compiler is not to blame.
> > As a result, DIV_ROUND_CLOSEST(0, 2U) and similar operations now return
> > bad values, since the automatic conversion of expressions such as "0 - 2U/2"
> > to unsigned was not taken into account.
> > 
> > Fix by checking for the divisor variable type when deciding which operation
> > to perform. This fixes DIV_ROUND_CLOSEST(0, 2U), but still returns bad values
> > for negative dividends divided by unsigned divisors. Mark the latter case as
> > unsupported.
> 
> The changelog didn't describe the end-user visible effects of the bug. 
> Please always include this information.  Because...
> 
One observed effect is that the s2c_hwmon driver reports a value of 4198403
instead of 0 if the ADC reads 0.

Other impact is unpredictable. Problem is seen if the divisor is an unsigned
variable or constant and the dividend is less than (divisor/2).

> The patch is applicable to 3.7.x.  Should we backport it?
> 
Yes. DIV_ROUND_CLOSEST is used throughout the kernel, and impact is
unpredictable.

3.6 needs it as well.
