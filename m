Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab0L3Ej3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 23:39:29 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58503 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab0L3Ej2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 23:39:28 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6211"; a="68493155"
Message-ID: <4D1C0CFE.5010008@codeaurora.org>
Date: Wed, 29 Dec 2010 20:39:26 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean Delvare <khali@linux-fr.org>, Rajendra Nayak <rnayak@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Vishwanath BS <vishwanath.bs@ti.com>, Partha Basak <p-basak2@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: i2c runtime suspend and system wide suspend
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c-core driver mixes runtime suspend and system wide suspend, in 
that, during a system wide suspend, it skips calling ->suspend if the 
device is runtime suspended.

I have an interrupt controller running over the i2c bus and that driver 
is oblivious of the runtime pm framework, IOW, it doesn't do any runtime 
pm calls. CONFIG_RUNTIME_PM is enabled however (for some other bus 
drivers). The issue I am facing is that all such i2c devices are assumed 
runtime suspended and the ->suspend for these devices is not invoked 
during systemwide suspend.

Looking around in pci and platform busses, they don't skip calling the 
->suspend callback, actually, they dont check if the device is runtime 
suspended.

The question is, why do we have this special check in i2c bus driver?

Pasted below is the relevant commit.

commit 2f60ba706bd9af84c4eab704243b262e69556f2e

     i2c: Fix bus-level power management callbacks

     There are three issues with the i2c bus type's power management
     callbacks at the moment.  ....
     ....
     ....
     ....  Finally, the system sleep PM
     (ie. suspend/resume) callbacks don't check if the device has been
     already suspended at run time, in which case they should skip
     suspending it.  Also, it looks like the i2c bus type can use the
     generic subsystem-level runtime PM callbacks.

     For these reasons, rework the system sleep PM callbacks provided by
     the i2c bus type to handle hibernation correctly and to invoke the
     "legacy" callbacks for drivers that provide them.  In addition to
     that make the i2c bus type use the generic subsystem-level runtime
     PM callbacks.

Thanks,
Abhijeet

--
Sent by an employee of Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of Code Aurora Forum.


