Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761714Ab2C3WIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:08:32 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33875 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761689Ab2C3WIZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 18:08:25 -0400
MIME-Version: 1.0
In-Reply-To: <201203301850.22784.arnd@arndb.de>
References: <201203301744.16762.arnd@arndb.de>
	<201203301850.22784.arnd@arndb.de>
Date: Fri, 30 Mar 2012 17:08:23 -0500
Message-ID: <CAJN=5gDBQJc_KXUadqtzmxPqPF71PDcToGo_T-agNey9eN2MQA@mail.gmail.com>
Subject: Re: swap on eMMC and other flash
From: Zach Pfeffer <zach.pfeffer@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-kernel@lists.linaro.org, linux-mm@kvack.org,
        Alex Lemberg <alex.lemberg@sandisk.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Hyojin Jeong <syr.jeong@samsung.com>,
        "Luca Porzio (lporzio)" <lporzio@micron.com>, kernel-team@android.com,
        Yejin Moon <yejin.moon@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 March 2012 13:50, Arnd Bergmann <arnd@arndb.de> wrote:
> (sorry for the duplicated email, this corrects the address of the android
> kernel team, please reply here)
>
> On Friday 30 March 2012, Arnd Bergmann wrote:
>
>  We've had a discussion in the Linaro storage team (Saugata, Venkat and me,
>  with Luca joining in on the discussion) about swapping to flash based media
>  such as eMMC. This is a summary of what we found and what we think should
>  be done. If people agree that this is a good idea, we can start working
>  on it.
>
>  The basic problem is that Linux without swap is sort of crippled and some
>  things either don't work at all (hibernate) or not as efficient as they
>  should (e.g. tmpfs). At the same time, the swap code seems to be rather
>  inappropriate for the algorithms used in most flash media today, causing
>  system performance to suffer drastically, and wearing out the flash hardware
>  much faster than necessary. In order to change that, we would be
>  implementing the following changes:
>
>  1) Try to swap out multiple pages at once, in a single write request. My
>  reading of the current code is that we always send pages one by one to
>  the swap device, while most flash devices have an optimum write size of
>  32 or 64 kb and some require an alignment of more than a page. Ideally
>  we would try to write an aligned 64 kb block all the time. Writing aligned
>  64 kb chunks often gives us ten times the throughput of linear 4kb writes,
>  and going beyond 64 kb usually does not give any better performance.

Last I read Transparent Huge Pages are still paged in and out a page
at a time, is this or was this ever the case? If it is the case should
the paging system be extended to support THP which would take care of
the big block issues with flash media?

>  2) Make variable sized swap clusters. Right now, the swap space is
>  organized in clusters of 256 pages (1MB), which is less than the typical
>  erase block size of 4 or 8 MB. We should try to make the swap cluster
>  aligned to erase blocks and have the size match to avoid garbage collection
>  in the drive. The cluster size would typically be set by mkswap as a new
>  option and interpreted at swapon time.
>
>  3) As Luca points out, some eMMC media would benefit significantly from
>  having discard requests issued for every page that gets freed from
>  the swap cache, rather than at the time just before we reuse a swap
>  cluster. This would probably have to become a configurable option
>  as well, to avoid the overhead of sending the discard requests on
>  media that don't benefit from this.
>
>  Does this all sound appropriate for the Linux memory management people?
>
>  Also, does this sound useful to the Android developers? Would you
>  start using swap if we make it perform well and not destroy the drives?
>
>  Finally, does this plan match up with the capabilities of the
>  various eMMC devices? I know more about SD and USB devices and
>  I'm quite convinced that it would help there, but eMMC can be
>  more like an SSD in some ways, and the current code should be fine
>  for real SSDs.
>
>        Arnd
>
>
>
> _______________________________________________
> linaro-kernel mailing list
> linaro-kernel@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-kernel



-- 
Zach Pfeffer
Android Platform Team Lead, Linaro Platform Teams
Linaro.org | Open source software for ARM SoCs
Follow Linaro: http://www.facebook.com/pages/Linaro
http://twitter.com/#!/linaroorg - http://www.linaro.org/linaro-blog
