Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab2KSF5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:57:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:25920 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab2KSF5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:57:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,276,1352102400"; 
   d="scan'208";a="249244938"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mmc,sdio: Fix the panic due to devname NULL when
 calling pm_runtime_set_active()
Thread-Topic: [PATCH] mmc,sdio: Fix the panic due to devname NULL when
 calling pm_runtime_set_active()
Thread-Index: AQHNxDFVJrZjQ1aFo024SlNNYqkBGJfwqf9g
Date: Mon, 19 Nov 2012 05:57:48 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1D4191@SHSMSX101.ccr.corp.intel.com>
References: <1353070447.15558.1681.camel@cliu38-desktop-build>
 <CAK=WgbYiKFpSeyKZU3OWvbq4VDKRMFQvxwPbyxsBbEYJGQU1sA@mail.gmail.com>
In-Reply-To: <CAK=WgbYiKFpSeyKZU3OWvbq4VDKRMFQvxwPbyxsBbEYJGQU1sA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Ohad Ben-Cohen [mailto:ohad@wizery.com]
> Sent: Saturday, November 17, 2012 3:33 AM
> To: Liu, Chuansheng
> Cc: Chris Ball; linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] mmc,sdio: Fix the panic due to devname NULL when
> calling pm_runtime_set_active()
> 
> Hi Liu,
> 
> On Fri, Nov 16, 2012 at 2:54 PM, Chuansheng Liu
> <chuansheng.liu@intel.com> wrote:
> > So when calling pm_runtime_set_active(), it will hit the strlen(devname==0)
> > which trigger the panic.
> 
> Can you please point to the exact line of code that triggers this panic ?
    The call trace is as below:
    mmc_rescan
    -> mmc_rescan_try_freq
    -> mmc_attach_sdio
    -> pm_runtime_set_active
    -> __pm_runtime_set_status
    -> __update_runtime_status
    -> trace_runtime_pm_status
      This function is corresponding to the below code in trace/events/power.h:
    TRACE_EVENT(runtime_pm_status,
    
        TP_PROTO(struct device *dev, int status),
    
        TP_ARGS(dev, status),
    
        TP_STRUCT__entry(
                __string(devname, dev_name(dev))

Rechecked these codes, the trace event runtime_pm_status is added newly, this is different with vanilla
Linux. But it is just a new trace event.

So I still think that calling pm_runtime_set_active is not safe when dev_name is NULL.
If you agree this point, I can refine the code that moving "init the dev_name " from mmc_add_card
to mmc_sdio_init_card. Thanks.

> 
> > Here before calling pm_runtime_set_active(), set the dev name, although
> > it is duplicated with mmc_add_card(), but it do not break the original
> > design(commit 81968561b).
> 
> Normally we'd like to avoid such a solution, so let's first make sure
> we understand the problem.
> 
> Have you tried thinking how come this shows up only now - has any of
> the relevant code been changed lately ? Are you using a vanilla Linux
> tree ?
> 
> Thanks,
> Ohad.
