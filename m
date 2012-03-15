Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032297Ab2COUMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:12:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56200 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032210Ab2COUMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:12:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6650"; a="172874708"
Message-ID: <4F624D32.9030801@codeaurora.org>
Date: Thu, 15 Mar 2012 13:12:34 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] firmware_class: Move request_firmware_nowait() to workqueues
References: <1331841015-26684-1-git-send-email-sboyd@codeaurora.org> <201203152107.57501.chunkeey@googlemail.com>
In-Reply-To: <201203152107.57501.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/12 13:07, Christian Lamparter wrote:
> On Thursday, March 15, 2012 08:50:15 PM Stephen Boyd wrote:
>> Oddly enough a work_struct was already part of the firmware_work
>> structure but nobody was using it. Instead of creating a new
>> kthread for each request_firmware_nowait() just schedule the work
>> on the system workqueue. This should avoid some overhead in
>> forking new threads when they're not strictly necessary if
>> workqueues are available.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Kay Sievers <kay.sievers@vrfy.org>
>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
>> ---
>>
>> I saw this while looking at this problem we're having.
> Correct me if I'm wrong, but wouldn't that stall all other
> global workqueue tasks for up to 60 seconds [in worst case]?
>
> But I think we can get rid of the firmware_work work struct...
>

My understanding is that with concurrency managed workqueues when the
work item blocks another will be scheduled to run almost immediately. So
before that change by Tejun workqueues would have been a bad idea
because it could have blocked up to 60 second but now it should be fine
because that work item will just be put to sleep and another request
will run.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

