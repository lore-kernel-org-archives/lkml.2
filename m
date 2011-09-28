Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1I1NS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:18:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39322 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab1I1NS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:18:27 -0400
Date: Wed, 28 Sep 2011 15:18:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?utf-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlA==?= =?utf-8?B?5aSNOg==?=
 3.1-rc6+ rtl8192se issue
Message-ID: <20110928131823.GA2693@gere.osrc.amd.com>
References: <4E721871.7040901@lwfinger.net>
 <20110916180323.GA1988@gere.osrc.amd.com>
 <CD4D8CF16C39438E82FE8241C9AF80F4@realsil.com.cn>
 <20110921185816.GA2036@gere.osrc.amd.com>
 <791179BCE62F4954AB936E6CAC9CA977@realsil.com.cn>
 <4E7AAB8B.40900@lwfinger.net>
 <20110922075115.GA17640@liondog.tnic>
 <6452E68488784D0EA32E4BDF1B941EFB@realsil.com.cn>
 <20110923103339.GA26078@gere.osrc.amd.com>
 <4E7CB504.4060904@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E7CB504.4060904@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 11:34:12AM -0500, Larry Finger wrote:
> On 09/23/2011 05:33 AM, Borislav Petkov wrote:
> >On Fri, Sep 23, 2011 at 06:21:07PM +0800, 李朝明 wrote:
> >>Please set ips =0 and try again..
> >
> >What does that mean?
> >
> >I can trigger the grinding-to-a-halt reliably with "ips=0" - it only
> >takes a couple of hours of network traffic. Also, I don't want to try
> >the driver you sent me because the version in the kernel needs fixing
> >not some out-of-tree codebase.
> 
> I got a chance to review the rtl8192se part of the changes in that
> 08/16/2011 version. Attached is a patch to update the kernel
> version.
> 
> A prerequisite is:
> 
> commit da3ba88a9996cd64c6768bed5727e02da81e2c8d
> Author: Larry Finger <Larry.Finger@lwfinger.net>
> Date:   Mon Sep 19 14:34:10 2011 -0500
> 
>     rtlwifi: Combine instances of RTL_HAL_IS_CCK_RATE macros.
> 
>     Three drivers, rtl8192ce, rtl8192cu and rtl8192de, use the same macro
>     to check if a particular rate is in the CCK set. This common code is
>     relocated to a common header file. A distinct macro used by rtl8192se
>     with the same name is renamed.
> 
>     Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>

Ok, here's what I did.

* merge 'master' branch of
git://git.infradead.org/users/linville/wireless-next.git with -rc8 in
order to get da3ba88a9996.

* apply your attached patch with the Realsil facelift:

patching file drivers/net/wireless/rtlwifi/rtl8192se/hw.c
patching file drivers/net/wireless/rtlwifi/rtl8192se/reg.h
patching file drivers/net/wireless/rtlwifi/rtl8192se/sw.c
patching file drivers/net/wireless/rtlwifi/rtl8192se/trx.c
Hunk #6 FAILED at 540.
1 out of 6 hunks FAILED -- saving rejects to file drivers/net/wireless/rtlwifi/rtl8192se/trx.c.rej
patching file drivers/net/wireless/rtlwifi/wifi.h
Hunk #1 succeeded at 1328 (offset 3 lines).

(had to apply hunk #6 by hand though)

* build

drivers/net/wireless/rtlwifi/rtl8192se/sw.c:307:8: error: `EFUSE_OOB_PROTECT_BYTES_LEN' undeclared here (not in a function)
drivers/net/wireless/rtlwifi/rtl8192se/sw.c:307:2: error: array index in initializer not of integer type
drivers/net/wireless/rtlwifi/rtl8192se/sw.c:307:2: error: (near initialization for `rtl92se_hal_cfg.maps')
make[5]: *** [drivers/net/wireless/rtlwifi/rtl8192se/sw.o] Error 1
make[4]: *** [drivers/net/wireless/rtlwifi/rtl8192se] Error 2
make[3]: *** [drivers/net/wireless/rtlwifi] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....

fix with

diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 615f6b4..55428f2 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -450,6 +450,7 @@ enum rtl_var_map {
        EFUSE_HWSET_MAX_SIZE,
        EFUSE_MAX_SECTION_MAP,
        EFUSE_REAL_CONTENT_SIZE,
+       EFUSE_OOB_PROTECT_BYTES_LEN,
 
        /*CAM map */
        RWCAM,

> I have run the new version for a couple of hours without problems.
> Perhaps it will cure your difficulty, but I am not optimistic.

Yeah, I'm sorry to confirm that your pessimism turned into realism :-).
It froze in under 20 mins. Ran the driver with default module parameters
though.

Looks like I'll have to test the Realsil tarball after all. Question, do
I simply overwrite the subtree under drivers/net/wireless/rtlwifi/ with
the files from the tarball?

Also, any preferred module parameters settings you want me to test?

Thanks.

-- 
Regards/Gruss,
Boris.
