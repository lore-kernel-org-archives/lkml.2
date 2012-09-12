Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184Ab2ILPhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:37:46 -0400
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:34889 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758856Ab2ILPhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:37:20 -0400
Message-ID: <5050AC2E.3050408@akamai.com>
Date: Wed, 12 Sep 2012 10:37:18 -0500
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
References: <1347403947-20187-1-git-send-email-johunt@akamai.com> <504FC2E9.4010708@akamai.com> <20120912085140.GA12277@aftab.osrc.amd.com> <5050824B.9050006@akamai.com> <5050857F.5060207@akamai.com> <20120912153016.GA12103@aftab.osrc.amd.com>
In-Reply-To: <20120912153016.GA12103@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 10:30 AM, Borislav Petkov wrote:
> Yes, you're basically right. Here's what I see from here:
>
> In 2009 I added
>
> commit 603adaf6b3e37450235f0ddb5986b961b3146a79
> Author: Borislav Petkov <borislav.petkov@amd.com>
> Date:   Mon Dec 21 14:52:53 2009 +0100
>
>      amd64_edac: fix K8 chip select reporting
>
>      Fix the case when amd64_debug_display_dimm_sizes() reports only half the
>      amount of DRAM on it because it doesn't account for when the single DCT
>      operates in 128-bit mode and merges chip selects from different DIMMs.
>
> which was supposed to fix a bug-report of DRAM chip selects being halved
> in reporting.
>
> But,
>
> commit 41d8bfaba70311c2fa0666554ef160ea8ffc9daf
> Author: Borislav Petkov <borislav.petkov@amd.com>
> Date:   Tue Jan 18 19:16:08 2011 +0100
>
>      amd64_edac: Improve DRAM address mapping
>
>      Drop static tables which map the bits in F2x80 to a chip select size in
>      favor of functions doing the mapping with some bit fiddling. Also, add
>      F15 support.
>
>
> two years later reworked the whole DBAM to chip select sizes mapping for
> all families. But it left in the clumsy workaround above for K8 only,
> thus the double shifting.
>
> So, long story short, reverting 603adaf6b3e37450235f0ddb5986b961b3146a79
> should probably fix the issue since it is not needed anymore.
>
> Let me run it here to make sure I'm not missing anything else.
>
> Thanks.
>

Well from what I see 603ad... would only fix the case of printing the 
values correctly on boot, by removing the factor=1 shift. However, that 
is merely cosmetic as it does not affect the actual calculation of 
nr_pages. I guess maybe I wasn't completely clear before, but I see the 
doubling of the amount of memory both on boot via dmesg, but also in 
/sys/devices/system/edac/mc/mc0/size_mb and all of the csrow* subdirs 
therein.

Josh
