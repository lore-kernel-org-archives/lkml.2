Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889Ab0HLQjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:39:32 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48456 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933749Ab0HLQja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:39:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6072"; a="50790049"
Message-ID: <4C6423C1.9060509@codeaurora.org>
Date: Thu, 12 Aug 2010 09:39:29 -0700
From: Gregory Bean <gbean@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
CC: tsoni@qualcomm.com
Subject: [RFC] the right way to use gpiolib hooks to automate power management?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks:

On MSM, we have a bank of gpios whose physical characteristics are
controlled via a 'gpiomux' subsystem, which sets things like drive
strength, pull-up, pull-down, gpio functional assignment, and the like.

We have a written a software driver which reference-counts these gpio
lines (via a put()/get() api), putting them in their "high-power" active
configurations when they're in use, and dropping them down into a
high-impedance low-power setting when they're not.

We can't use gpiolib for this because many of these gpios are set to
'non-gpio' mux settings: they get assigned to busses as data or address
lines (for example) and are not used as gpios after that.

However, for those gpios which are left in 'gpio mode', we DO want
gpiolib to 'do the right thing' as regards power management.  From the
following text in Documentation/gpio.txt:

   int gpio_request(unsigned gpio, const char *label);
   void gpio_free(unsigned gpio);

   ...Some platforms may also use knowledge about what GPIOs are
   active for power management, such as by powering down unused
   chip sectors and, more easily, gating off unused clocks...

I interpret from this that it is 'healthy' behavior to put a call to our
gpiomux get() in our gpio_chip's gpio_request(), and a matching call to
our gpiomux put() in gpio_free().  It seems to me that this would bring
lines out of low-power mode when they're first requested, and put them
back to sleep when they're released, exactly as we want.

Is this the right thing to be doing, or is this going to get us in
trouble? I want to make sure we're using the system as it was intended.

Thanks!
-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
