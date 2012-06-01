Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab2FAAXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 20:23:46 -0400
Received: from li158-162.members.linode.com ([173.230.148.162]:55295 "EHLO
	strelka.plastictigers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab2FAAXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 20:23:44 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2012 20:23:44 EDT
Date: Thu, 31 May 2012 20:16:17 -0400
From: Marc Butler <marc@plastictigers.com>
To: Sagar Dharia <sdharia@codeaurora.org>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org, kheitke@codeaurora.org,
        gclemson@audience.com, broonie@opensource.wolfsonmicro.com,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rob@landley.net, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        ohad@wizery.com, gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        rusty@rustcorp.com.au, joerg.roedel@amd.com, trenn@suse.de,
        ak@linux.intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20120601001617.GA16311@plastictigers.com>
Mail-Followup-To: Sagar Dharia <sdharia@codeaurora.org>,
	davidb@codeaurora.org, bryanh@codeaurora.org,
	kheitke@codeaurora.org, gclemson@audience.com,
	broonie@opensource.wolfsonmicro.com, linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, rob@landley.net,
	grant.likely@secretlab.ca, rob.herring@calxeda.com, ohad@wizery.com,
	gregkh@linuxfoundation.org, linus.walleij@linaro.org,
	rusty@rustcorp.com.au, joerg.roedel@amd.com, trenn@suse.de,
	ak@linux.intel.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
References: <1338340310-4473-1-git-send-email-sdharia@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338340310-4473-1-git-send-email-sdharia@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 07:11:33PM -0600, Sagar Dharia wrote:
> SLIMbus (Serial Low Power Interchip Media Bus) is a specification
> developed by MIPI (Mobile Industry Processor Interface) alliance.

These are initial comments. A full review of the patch will take some
time. While I am posting this email, this is the result of work both
by myself, and my colleague Greg Clemson (cc'ed).

1. enum slim_ch_proto

The enumeration slim_ch_proto is incorrect. It declares 2 transport
protocols which do not exist in the specification: SLIM_HARD_ISO;
SLIM_AUTO_ISO.

This in turn causes the subsequent values for the other protocols such
as SLIM_PUSH, to be incorrectly coded in the NEXT_DEFINE_CHANNEL
message generated in slim_reconfigure_now(). That is the push protocol
is incorrectly encoded as 3 instead of 2 as per the specification
(Table 47).

I believe a correct definition would be:

enum slim_ch_proto {
        SLIM_ISO,
	SLIM_PUSH,
	SLIM_PULL,
	SLIM_LOCKED,
	SLIM_ASYNC_SMPLX,
	SLIM_ASYNC_HALF_DUP,
	SLIM_EXT_SMPLX,
	SLIM_EXT_HALF_DUP,
	SLIM_USER_DEF1 = 14,
	SLIM_USER_DEF2 = 15
};

However doing so will break the logic in slim_nextdefine_ch().

2. Use of the term elemental address.

Commentary around the use of struct slim_eaddr uses the term
"elemental address". However, the term used in the specification is
"enumeration address". There is no elemental address in the
specification, and using this term may result confusion when referring
to accessing the information and value elements.

I suggest that term "enumeration address" should be used. 

3. Probing sequence for drivers.

The current probing sequence for drivers appears to make some
assumptions, that are problematic.

a) The code assumes that when the controller is registered the bus is
operational (booted). No allowance is made for any problems the active
framer may have synchronizing the bus. 

The drivers really should not be probed until the bus has at least
booted. This can be worked around by only registering the controller
after it has booted the bus. This should be noted in the comments.

b) Similarly to (a) the driver may be probed before the device has
been given a logical address (LA). This makes sense in the case of
driver that turns on the device (say via gpio) once the bus has
booted. However, the driver then needs to sit and poll
slim_get_logical_addr() until the logical address.

A possible alternate solution would be to add a parameter to probe:

enum slim_dev_status {
        SLIM_BUS_READY,
	SLIM_DEV_READY
};

int (*probe)(struct slim_device *sldev, enum slim_dev_status status);

Where SLIM_BUS_READY == bus has booted, and SLIM_DEV_READY == device
has been assigned its logical address.

Alternatively you could have 2 separate probe type callbacks. 

This would make the driver logical simpler.

