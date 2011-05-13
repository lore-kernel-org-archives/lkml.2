Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab1EMS1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:27:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:62773 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab1EMS1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:27:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,365,1301900400"; 
   d="scan'208";a="1395378"
Date: Fri, 13 May 2011 20:27:32 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, linux-kernel@vger.kernel.org,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        a.zummo@towertech.it, khali@linux-fr.org, ben-linux@fluff.org
Subject: Re: [PATCH 3/6] mfd: 88pm860x: enhance lock on i2c transaction
Message-ID: <20110513182731.GX8970@sortiz-mobl>
References: <1304673685-21324-1-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-2-git-send-email-haojian.zhuang@marvell.com>
 <1304673685-21324-3-git-send-email-haojian.zhuang@marvell.com>
 <20110513142057.GC8970@sortiz-mobl>
 <BANLkTikfh6c_kFom+2MHx+QTuZxVJH0svA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikfh6c_kFom+2MHx+QTuZxVJH0svA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Fri, May 13, 2011 at 11:00:24PM +0800, Haojian Zhuang wrote:
> On Fri, May 13, 2011 at 10:20 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > Hi Haojian,
> >
> > On Fri, May 06, 2011 at 05:21:22PM +0800, Haojian Zhuang wrote:
> >> Accessing test page in 88pm860x is a sequence of read/write on i2c bus.
> >> Bus lock is used in each small i2c transaction. But it may result the
> >> whole sequence interrupted by other i2c client transaction.
> > Sure, but what you mainly want is your MFD i2c IO calls to be serialized, and
> > that's already being taken care of by the current code.
> > Are other i2c clients (non MFD ones) touching the same i2c registers than the
> > MFD ones ?
> >
> Other process may not access the same register. But they may access same i2c
> bus. What I did is used to protect bus operation.
> 
> Even accessing one register in test page is composed by a sequence of accessing
> test page.
> 
> For example, read one byte of 0xbc in test page.
> 1) i2c read zero byte from 0xFA
> 2) i2c read zero byte from 0xFB
> 3) i2c read zero byte from 0xFF
> 4) i2c read one byte from 0xbc (desired operation)
> 5) i2c read zero byte from 0xFC
> 
> Step #1 to #3 is used to enter test page mode. Step 4 is used to read
> desired data.
> Step #5 is used to exit test page mode. If all these five steps are
> using standard
> i2c read operation, bus lock in i2c driver will be held and released
> five times. If another
> process is also accessing i2c bus, it may interrupt the sequence and
> import error to
> pmic.
I see. Wouldn't i2c_transfer() fix your problem then ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
