Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1HWFUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 01:20:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:57791 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab1HWFUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 01:20:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="40839550"
Subject: Re: [PATCH 16/18] dmaengine/amba-pl08x: Add support for sg len
 greater than one for slave transfers
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <4E532B19.6000103@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	 <5d691ab0c4f447c9f324213d8d740ac61d1739a1.1311936524.git.viresh.kumar@st.com>
	 <20110814083618.GE4986@n2100.arm.linux.org.uk> <4E4CCF7B.8060704@st.com>
	 <20110821083306.GA12028@n2100.arm.linux.org.uk>  <4E532B19.6000103@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 10:50:14 +0530
Message-ID: <1314076814.22120.17.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 09:52 +0530, Viresh Kumar wrote:
> On 8/21/2011 2:03 PM, Russell King - ARM Linux wrote:
> >> > I am not sure if i get this completely. In memcpy, we still don't support
> >> > more than one sg. We have created a new member in txd, which keeps track of
> >> > data (addresses, len).
> > Yes, but we shouldn't need to translate it into any kind of scatterlist.
> > 
> 
> Ok. I way out is keeping two separate variables in txd, list for slave transfers,
> and pointer to single element for memcpy. And that looks to be even bad to me.
> Why waste memory, for second variable. Or create union of both.
> 
> One more thing, we can actually have scatter gather in memcpy too in future. This will be
> helpful then also. But surely that's something not implemented currently.
> 
There are few points for consideration:
1) Clients will calls tx_submit() and submit the descriptors, this
should push your descriptor to queued list
2) On issue_pending() you need to push the queued descriptors to dmac.
If your hardware can transfer multiple descriptors, then you should use
this and push all available descriptors to hardware.

This way you ensure optimal performance and give LLI for memcpy even
when you think API is not available.

If there are some use cases where we need scatterlist support for
memcpy, and if above doesn't satisfy, should be okay to add it.


-- 
~Vinod

