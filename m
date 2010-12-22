Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab0LVW2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 17:28:10 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60469 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab0LVW2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 17:28:09 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6205"; a="67932057"
Message-ID: <4D127B78.7060707@codeaurora.org>
Date: Wed, 22 Dec 2010 14:28:08 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>, Kees Cook <kees.cook@canonical.com>,
        James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
        linux-arm-msm@vger.kernel.org, smuckle@codeaurora.org
Subject: release_console_sem() and disabling interrupts
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release_console_sem() disables interrupts while it calls upon the 
console drivers to dump the pending characters. This disabling of 
interrupt is delaying the handling of interrupts leading to weird 
latencies and bugs.

The specific scenario is while resuming, the __log_buf has accumulated 
around 11,000 bytes of characters and resume_console takes for ever to 
send them out. On my system with serial running at 115200 baud it takes 
almost a second to flush 11,000 bytes.

I was thinking about limiting the characters to say N bytes and before 
  the next set of N bytes is sent, we enable interrupts and do the 
spin_lock_irqsave again. Basically spin in the for ( ; ; ) loop until 
all the outstanding bytes are sent in sets of N bytes.

This issue has been brought up many times earlier -
http://www.webservertalk.com/archive242-2006-6-1537307.html
http://www.webservertalk.com/archive242-2007-11-2129981.html

One reason I gather is that we want to prevent interrupts from printing 
unorderly stuff in the __log_buf. But dont interrupts get the 
spin_lock(&logbuf_lock) and then update the log_[end/start], con_start 
etc? If so we wont see unorderly prints in the __log_buf, the spin_lock 
protects those pointers.

Would like ask if limiting the number of characters per loop in 
release_console_sem() is a good idea.

Thanks
Abhijeet

Sent by an Employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc is a member of code aurora forum.
