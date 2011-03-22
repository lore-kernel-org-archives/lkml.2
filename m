Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab1CVWCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:02:05 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60770 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab1CVWCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:02:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6293"; a="81261755"
Message-ID: <4D891C59.1030009@codeaurora.org>
Date: Tue, 22 Mar 2011 15:02:01 -0700
From: David Collins <collinsd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Deadlock scenario in regulator core
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liam and Mark,

I was analyzing the mutex lock usage in drivers/regulator/core.c and found
at least one way to reach deadlock: regulator_enable is called for a
regulator at the same time that regulator_disable is called for that
regulator's supply.  Consider this simple example.  There are two
regulators: S1 and L2, as well as two consumers: A and B.  They are
connected as follows:

S1 --> L2 --> B
|
|--> A

Assume that A has already called regulator_enable for S1 some time in the
past.

Consumer A thread execution:
	regulator_disable(S1)
	mutex_lock(S1)
	_regulator_disable(S1)
	_notifier_call_chain(S1)
	mutex_lock(L2)

Consumer B thread execution:
	regulator_enable(L2)
	mutex_lock(L2)
	_regulator_enable(L2)
	mutex_lock(S1)

The locks for S1 and L2 are taken in opposite orders in the two threads;
therefore, it is possible to achieve deadlock.  I am not sure about the
best way to resolve this situation.  Is there a correctness requirement
that regulator_enable holds the child regulator's lock when it attempts to
enable the parent regulator?  Likewise, is the lock around
_notifier_call_chain required?

Thanks,
David Collins

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
