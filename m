Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab2EaTTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:19:36 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:47949 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933068Ab2EaTTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:19:33 -0400
Date: Thu, 31 May 2012 12:19:16 -0700
From: Mike Turquette <mturquette@ti.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] clk: add extension API
Message-ID: <20120531191916.GA19475@gmail.com>
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
 <4FC5E837.30702@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC5E837.30702@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120530-14:58, Rajendra Nayak wrote:
> Hi Peter,
> 
> On Tuesday 29 May 2012 03:28 PM, Peter De Schrijver wrote:
> >Add an extension API for clocks. This allows clocktypes to provide extensions
> >for features which are uncommon and cannot be easily mapped onto normal clock
> >framework concecpts. eg: resetting blocks, configuring clock phase etc.
> 
> I was thinking on similar lines for OMAP wherein I need to control
> 'hardware-auto-gating' bits on clocks which are otherwise just normal
> gates or dividers. We just disable all of them early at boot and
> re-enable them late in the boot process once PM kicks in.
> 

It would be helpful to get an idea of what these different functions
actually do.  This patch exposes a sort of poor man's ioctl/syscall
interface (which may indeed be necessary), but I would first prefer to
pool together everybody's needs and see if some new high-level APIs
should be added to clk.h.

Already a clk_reset/module reset call has been discussed in this thread.
The changelog discusses setting clock phase and Rajendra mentioned
controlling auto-gating behavior.

Do other folks have these same needs?  What about other needs that are
unlisted?  Please add them to the thread so we can get an idea of what
we're up against.

If I merge this patch in as-is then we'll never compare notes on what
could be common and everyone will just hide their code behind this new
clk_ext call ;-)

Regards, Mike

> regards,
> Rajendra
> 
> >
> >Signed-off-by: Peter De Schrijver<pdeschrijver@nvidia.com>
> >---
> >  drivers/clk/clk.c            |    8 ++++++++
> >  include/linux/clk-provider.h |    2 ++
> >  include/linux/clk.h          |    2 ++
> >  3 files changed, 12 insertions(+), 0 deletions(-)
> >
> >diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> >index e5d5dc1..39bc458 100644
> >--- a/drivers/clk/clk.c
> >+++ b/drivers/clk/clk.c
> >@@ -956,6 +956,14 @@ struct clk *clk_get_parent(struct clk *clk)
> >  }
> >  EXPORT_SYMBOL_GPL(clk_get_parent);
> >
> >+int clk_ext(struct clk *clk, unsigned int op, unsigned long param)
> >+{
> >+	if (clk->ops->ext)
> >+		return clk->ops->ext(clk->hw, op, param);
> >+
> >+	return -EINVAL;
> >+}
> >+
> >  /*
> >   * .get_parent is mandatory for clocks with multiple possible parents.  It is
> >   * optional for single-parent clocks.  Always call .get_parent if it is
> >diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> >index 6803fb4..08025d3 100644
> >--- a/include/linux/clk-provider.h
> >+++ b/include/linux/clk-provider.h
> >@@ -109,6 +109,8 @@ struct clk_ops {
> >  	int		(*set_rate)(struct clk_hw *hw, unsigned long,
> >  				    unsigned long);
> >  	void		(*init)(struct clk_hw *hw);
> >+	int		(*ext)(struct clk_hw *hw, unsigned int op,
> >+					unsigned long param);
> >  };
> >
> >  /**
> >diff --git a/include/linux/clk.h b/include/linux/clk.h
> >index 0e078bd..74be656 100644
> >--- a/include/linux/clk.h
> >+++ b/include/linux/clk.h
> >@@ -278,4 +278,6 @@ struct clk *clk_get_sys(const char *dev_id, const char *con_id);
> >  int clk_add_alias(const char *alias, const char *alias_dev_name, char *id,
> >  			struct device *dev);
> >
> >+int clk_ext(struct clk *clk, unsigned int op, unsigned long param);
> >+
> >  #endif
> 
