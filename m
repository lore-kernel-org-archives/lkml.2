Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761021Ab2C3Sud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:50:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63834 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760130Ab2C3Sua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:50:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org, linux-mm@kvack.org
Subject: Re: swap on eMMC and other flash
Date: Fri, 30 Mar 2012 18:50:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: "Luca Porzio (lporzio)" <lporzio@micron.com>,
        Alex Lemberg <alex.lemberg@sandisk.com>, linux-kernel@vger.kernel.org,
        Saugata Das <saugata.das@linaro.org>,
        Venkatraman S <venkat@linaro.org>, Yejin Moon <yejin.moon@samsung.com>,
        Hyojin Jeong <syr.jeong@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        kernel-team@android.com
References: <201203301744.16762.arnd@arndb.de>
In-Reply-To: <201203301744.16762.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203301850.22784.arnd@arndb.de>
X-Provags-ID: V02:K0:LqCf/nB7+NYIFK0TdcGK8NIfIk+iejXzQJtMw7i4pLC
 d+3NA0JAxFi3CsaQiSiFe/koc0tjH+e/hnBgNpnXrsBP1W4Jx+
 j0jplOardd/Gxbx0hnZT+MmLn0trVpLC4YAfbjySkIuMrYVpDM
 aePjzB6Oqc9YjyEmVqw0MLiHtCnGgZdb144QkXfMotQuVP/4pT
 3jm1roXMbDDBxwIR3GahCObwpTqx7jrhnICj//V0huNZygkt/J
 8GRkvyYiCD8ZE47ND3QHwhhoR54kZlSfYpd0ExPK/EGKQGNAYK
 C8cOWgwoaYVsBTwyHu+gX32XVQVLYEJwwMLCnW6dPbrb8IWU3R
 i+iB2XbbVF9ig2+kTack=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry for the duplicated email, this corrects the address of the android
kernel team, please reply here)

On Friday 30 March 2012, Arnd Bergmann wrote:

 We've had a discussion in the Linaro storage team (Saugata, Venkat and me,
 with Luca joining in on the discussion) about swapping to flash based media
 such as eMMC. This is a summary of what we found and what we think should
 be done. If people agree that this is a good idea, we can start working
 on it.
 
 The basic problem is that Linux without swap is sort of crippled and some
 things either don't work at all (hibernate) or not as efficient as they
 should (e.g. tmpfs). At the same time, the swap code seems to be rather
 inappropriate for the algorithms used in most flash media today, causing
 system performance to suffer drastically, and wearing out the flash hardware
 much faster than necessary. In order to change that, we would be
 implementing the following changes:
 
 1) Try to swap out multiple pages at once, in a single write request. My
 reading of the current code is that we always send pages one by one to
 the swap device, while most flash devices have an optimum write size of
 32 or 64 kb and some require an alignment of more than a page. Ideally
 we would try to write an aligned 64 kb block all the time. Writing aligned
 64 kb chunks often gives us ten times the throughput of linear 4kb writes,
 and going beyond 64 kb usually does not give any better performance.
 
 2) Make variable sized swap clusters. Right now, the swap space is
 organized in clusters of 256 pages (1MB), which is less than the typical
 erase block size of 4 or 8 MB. We should try to make the swap cluster
 aligned to erase blocks and have the size match to avoid garbage collection
 in the drive. The cluster size would typically be set by mkswap as a new
 option and interpreted at swapon time.
 
 3) As Luca points out, some eMMC media would benefit significantly from
 having discard requests issued for every page that gets freed from
 the swap cache, rather than at the time just before we reuse a swap
 cluster. This would probably have to become a configurable option
 as well, to avoid the overhead of sending the discard requests on
 media that don't benefit from this.
 
 Does this all sound appropriate for the Linux memory management people?
 
 Also, does this sound useful to the Android developers? Would you
 start using swap if we make it perform well and not destroy the drives?
 
 Finally, does this plan match up with the capabilities of the
 various eMMC devices? I know more about SD and USB devices and
 I'm quite convinced that it would help there, but eMMC can be
 more like an SSD in some ways, and the current code should be fine
 for real SSDs.
 
 	Arnd
 

