Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab1DDXrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 19:47:07 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44463 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab1DDXrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 19:47:02 -0400
Subject: Re: Minimal requirements for RTC drivers
From: John Stultz <john.stultz@linaro.org>
To: Michael Hunold <hunold@linuxtv.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4D996B74.4070502@linuxtv.org>
References: <4D996B74.4070502@linuxtv.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 16:46:50 -0700
Message-ID: <1301960810.2319.63.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 08:55 +0200, Michael Hunold wrote:
> I have been working on a new RTC driver for some custom RTC device
> lately. It has the usual features like AIE, UIE and PIE.
> 
> I cloned the rtc-test.c driver as Documentation/rtc.txt suggested and
> noticed that my driver would work with the test application even though
> some of the driver functions were not implemented at all...
> 
> So I found out about your recent changes with regard to "RTC
> virtualisation" and I understood the steps you have taken. It's not
> necessary to provide all functionality through the RTC driver directly
> any more, because some of the stuff is emulated via hrtimers.
> 
> One problem is that the documentation and the code have gotten out of
> sync. People like me, who dive into the RTC subsystem for the first
> time, can be easily fooled now.

So I have committed some cleanups to the documentation already in
2.6.39-rc1, but I'd be greatly interested in examples of where you found
it confusing. 


> So the main question now is what the minimal required functionality for
> a RTC driver now actually is. Can you give me some hints?

Well, it depends on the functionality that is available. Completely
minimal might be just clock-only functions:
	int (*read_time)(struct device *, struct rtc_time *);
	int (*set_time)(struct device *, struct rtc_time *);
or
	int (*set_mmss)(struct device *, unsigned long secs);


Then to get interrupt/alarm functionality:
	int (*alarm_irq_enable)(struct device *, unsigned int enabled);
	int (*set_alarm)(struct device *, struct rtc_wkalrm *);

To have persistence over reboots:
	int (*read_alarm)(struct device *, struct rtc_wkalrm *);


These are completely optional:
	int (*proc)(struct device *, struct seq_file *);
	int (*ioctl)(struct device *, unsigned int, unsigned long);
	int (*open)(struct device *);
	void (*release)(struct device *);
	int (*read_callback)(struct device *, int data);


> I think it would be best if the rtc-test.c driver could be updated to
> have a template new drivers can be cloned from.

So upstream in 2.6.39-rc1 I think this has been done, but please let me
know if there are any improvements you see that could be made.

> Another thing that catched my eye is the current use of the read_alarm()
> member in struct rtc_class_ops in rtc_read_alarm() in
> drivers/rtc/interface.c. This is the only place where the member is used
> and it's only used as a boolean there. The driver specific read_alarm()
> op is never actually called, so I think that op can be transformed into
> a boolean and all the read_alarm() functions from all the rtc drivers
> can be removed - that's quite a lot of a code.

Yes, I actually tried to remove it, but realized we need it to restore
the aie_timer state at boot. 

Please check 2.6.39-rc1, and let me know if your concerns have not been
addressed already?

thanks
-john


