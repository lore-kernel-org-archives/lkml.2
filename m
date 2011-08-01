Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab1HAK04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:26:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34444 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab1HAK0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:26:49 -0400
Date: Mon, 1 Aug 2011 11:26:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linus.walleij@linaro.org, pratyush.anand@st.com, rajeev-dlh.kumar@st.com,
        bhupesh.sharma@st.com, shiraz.hashim@st.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 08/20] dmaengine/amba-pl08x: support runtime PM
Message-ID: <20110801102627.GF15578@n2100.arm.linux.org.uk>
References: <cover.1312190881.git.viresh.kumar@st.com> <bc59bbd3709a7af1723d37ab846bf44c6867c00e.1312190881.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc59bbd3709a7af1723d37ab846bf44c6867c00e.1312190881.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 03:07:18PM +0530, Viresh Kumar wrote:
> @@ -1993,6 +2002,8 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
>  	dev_info(&pl08x->adev->dev, "DMA: PL%03x rev%u at 0x%08llx irq %d\n",
>  		 amba_part(adev), amba_rev(adev),
>  		 (unsigned long long)adev->res.start, adev->irq[0]);
> +
> +	pm_runtime_suspend(&adev->dev);

Having read the runtime pm documentation, devices are assumed to be
suspended at probe time, and there should be a call to pm_runtime_enable()
in here.  See Documentation/power/runtime_pm.txt chapter 5.

However, this is complicated by the core managing the peripheral clock,
which starts off in the enabled state.  So there's only one sane solution,
which is to tell the runtime PM that the device is already active.  So
I think a primecell's probe function should look like this:

primecell_probe()
{
	ret = amba_request_regions(adev, NULL);
	if (ret)
		return ret;

	... allocate stuff, don't access primecell though ...

	pm_runtime_set_active(&adev->dev);
	pm_runtime_enable(&adev->dev);

	... get clocks and enable them, do rest of init ...

	pm_runtime_put_sync(&adev->dev);
	return 0;
}
