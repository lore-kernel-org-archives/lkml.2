Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab1HNIhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 04:37:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52943 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab1HNIhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 04:37:16 -0400
Date: Sun, 14 Aug 2011 09:36:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linus.walleij@linaro.org, pratyush.anand@st.com, rajeev-dlh.kumar@st.com,
        bhupesh.sharma@st.com, shiraz.hashim@st.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 16/18] dmaengine/amba-pl08x: Add support for sg len
	greater than one for slave transfers
Message-ID: <20110814083618.GE4986@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com> <5d691ab0c4f447c9f324213d8d740ac61d1739a1.1311936524.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d691ab0c4f447c9f324213d8d740ac61d1739a1.1311936524.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 04:19:26PM +0530, Viresh Kumar wrote:
> Untill now, sg_len greater than one is not supported. This patch adds support to
> do that.

I'm not sure that this is the correct approach.  memcpy()s can only be
used with one single buffer, so the sg stuff for that (and the unmapping
support) doesn't make sense at all.

The only place where this makes sense is the slave sg stuff.  I wonder
whether we can better deal with that by having the LLI setup code deal
with one SG list entry at a time, and chain each together.

Something I've also been pondering which is related to this is linking
together DMA operations using the LLI chaining when interrupts and
callbacks aren't required.  It's a very similar problem.  Other DMA
engine drivers do this.

Finally, note that some of the PL08x code assumes that for any TXD,
the LLI list is a contiguous array.  See the first part of
pl08x_getbytes_chan(). That needs fixing as soon as we start going to
more than one SG list entry.
