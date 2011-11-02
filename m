Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab1KBVeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:34:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25859 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab1KBVeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:34:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133820725"
Message-ID: <4EB1B74B.8060006@codeaurora.org>
Date: Wed, 02 Nov 2011 14:34:03 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 02/34] msm: clock: Always use an array to iterate
 over clocks
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org> <1320258991-22325-3-git-send-email-davidb@codeaurora.org> <20111102194555.GE12913@n2100.arm.linux.org.uk>
In-Reply-To: <20111102194555.GE12913@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/11 12:45, Russell King - ARM Linux wrote:
> On Wed, Nov 02, 2011 at 11:35:59AM -0700, David Brown wrote:
>> If the array of clk_lookups contains aliases for the same struct
>> clk, msm_clock_init() will add the clock to the clocks list
>> twice.  This would cause list corruption so let's just remove the
>> clocks list and any associated code and iterate over the array
>> instead.
> Hmm...
>
>> @@ -158,13 +152,13 @@ void __init msm_clock_init(struct clk_lookup *clock_tbl, unsigned num_clocks)
>>   */
>>  static int __init clock_late_init(void)
>>  {
>> +	unsigned i, count = 0;
>>  	unsigned long flags;
>> -	struct clk *clk;
>> -	unsigned count = 0;
>>  
>>  	clock_debug_init();
>> -	mutex_lock(&clocks_mutex);
>> -	list_for_each_entry(clk, &clocks, list) {
>> +	for (i = 0; i < msm_num_clocks; i++) {
>> +		struct clk *clk = msm_clocks[i].clk;
>> +
>>  		clock_debug_add(clk);
> This means you'll end up calling clock_debug_add() twice for the same
> struct clk - this sounds like a bad idea in itself.  It looks like
> there's no protection within that function against it being called
> twice with the same struct clk.
>
> Are you sure this is safe?

This hasn't proven to be a problem so far because debugfs returns an
error when you create a directory with the same name twice. If we ever
do something more in clock_debug_add() we would have a problem.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

