Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab2CWBSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 21:18:01 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51148 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab2CWBSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 21:18:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6657"; a="172712389"
Message-ID: <4F6BCF47.4090200@codeaurora.org>
Date: Thu, 22 Mar 2012 18:17:59 -0700
From: Michael Bohan <mbohan@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: rnayak@ti.com, broonie@opensource.wolfsonmicro.com, lrg@ti.com
CC: LKML <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org
Subject: Regulator supplies when using Device Tree
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm curious if there was a reason we didn't standardize on a binding 
name for regulator supplies when using Device Tree. This appears to 
cause duplicated code for regulator drivers that support devices that 
may or may not have supplies specified.

For example, if one were to set rdesc->supply_name to a chosen supply 
name "parent" and that particular device does not exist in the Device 
Tree topology, then regulator_register() will fail. So in the driver, we 
have to first use of_get_property() to verify that "parent-supply" is 
defined. Only then do we set rdesc->supply_name. Since I have multiple 
regulator drivers that may or may not have supplies, each has to 
duplicate this check.

But it seems like if we agreed on a standardized supply name for 
regulators, then we could move that complexity to 
of_get_regulator_init_data(). Having multiple supply names sure makes 
sense for consumers, but for supplies, there can ever only be one.

I guess another alternative is to have the driver unconditionally assign 
rdesc->supply_name, but change the framework to not fail the 
regulator_register() if the supply is not specified in the topology. If 
it is specified but fails either a phandle lookup or the targeted supply 
regulator is not valid, then fail only in those cases.

Also, I'm curious why we need two pointers for the supply name. There's 
currently regulator_desc->supply_name, recently added for Device Tree, 
and then the old init_data->supply_regulator. Is there a need for both?

Thanks,
Mike

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

