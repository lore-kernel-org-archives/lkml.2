Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab2KIT4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 14:56:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:38542 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab2KIT4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 14:56:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,747,1344236400"; 
   d="scan'208";a="246650036"
Date: Fri, 9 Nov 2012 12:56:18 -0700
From: Jon Mason <jon.mason@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spear-devel@list.st.com" <spear-devel@list.st.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Deepak Sikri <deepak.sikri@st.com>,
        "dave.jiang@intel.com" <dave.jiang@intel.com>
Subject: Re: [PATCH] dmaengine/dmatest: terminate transfers only in case of
 errors
Message-ID: <20121109195617.GB25358@jonmason-lab>
References: <1f83c56ebbe66c00acc7901613da1dc6fdba4a6b.1352474736.git.viresh.kumar@linaro.org>
 <84A937D219C2B44EB8EA44831ACA1E49166B9A82@SC-MBX01-3.TheFacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84A937D219C2B44EB8EA44831ACA1E49166B9A82@SC-MBX01-3.TheFacebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 06:44:18PM +0000, Dan Williams wrote:
> 
> 
> On 11/9/12 7:26 AM, "Viresh Kumar" <viresh.kumar@linaro.org> wrote:
> 
> >From: Shiraz Hashim <shiraz.hashim@st.com>
> >
> >dmatest erroneously terminated transfers in normal cases also leading to
> >test failures for multiple threads over a channel. Fix this and
> >terminate transfers only in case of errors.
> >
> >Signed-off-by: Shiraz Hashim <shiraz.hashim@st.com>
> >Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
> >---
> > drivers/dma/dmatest.c | 4 +++-
> > 1 file changed, 3 insertions(+), 1 deletion(-)
> >
> >diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> >index 8f130d4e..ce58b8e 100644
> >--- a/drivers/dma/dmatest.c
> >+++ b/drivers/dma/dmatest.c
> >@@ -509,7 +509,9 @@ err_srcs:
> > 			thread_name, total_tests, failed_tests, ret);
> > 
> > 	/* terminate all transfers on specified channels */
> >-	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
> >+	if (ret)
> >+		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
> >+
> 
> This and commit 9704efa "dmaengine/dmatest: Terminate transfers on all
> channels in case of error or exit" are broken for channels that don't
> implement the optional ->device_control.  Care to fix that up?

I think the best way is to call dmaengine_terminate_all() and have a
sanity check in dmaengine_device_control() that checks for a NULL
device_control.  I have a patch that does this and fixes the NULL
pointer error I am seeing on IOAT.  I will send it out shortly.

Thanks,
Jon

> 
> 
> --
> Dan
> 
