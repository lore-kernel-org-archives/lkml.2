Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0F1Tjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:39:42 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46058 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab0F1Tjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:39:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6027"; a="45674571"
Subject: Re: [RFC] [PATCH] timer: Added usleep[_range][_interruptable] timer
From: Daniel Walker <dwalker@codeaurora.org>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, sboyd@codeaurora.org, tglx@linutronix.de,
       mingo@elte.hu, heiko.carstens@de.ibm.com, eranian@google.com,
       schwidefsky@de.ibm.com, linux-arm-msm@vger.kernel.org
In-Reply-To: <4C28E3DF.1000907@codeaurora.org>
References: <4C225EED.5040600@codeaurora.org>
	 <1277323537.15159.30.camel@c-dwalke-linux.qualcomm.com>
	 <4C226CCA.20601@codeaurora.org>
	 <1277326605.15159.70.camel@c-dwalke-linux.qualcomm.com>
	 <4C28E3DF.1000907@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Jun 2010 12:39:39 -0700
Message-ID: <1277753979.5186.97.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-28 at 11:03 -0700, Patrick Pannuto wrote:

> Well here we go then.

Great.


> *** RESULTS ***
> 
> Complete results are attached (please forgive the ugly stats.py, it
> evolved; it's functional for the task at hand, but certainly not pretty).
> 
> --> Long results also at end of email
> 
> From the final results, after 240s:
> 
> TIME	STATE		#TIMES CALLED	 TIME IN STATE		| DELTA FROM ORG
> 
> ////////////////////////////////////////////////////////////////////////////////
> === origin (10 samples) =================================== RUNTIME: 241.535 ===

What's the 10 samples here?

> 240	idle-spin    --	2.3              1.45001e-05     
> 240	not-idle     --	88368.2          67.8311703321   
> 240	idle-request --	88367.2          23337.6322655   
> 240	idle-wfi     --	88364.9          172.296383696

I'm going to assume you did ten in "origin" (i.e. control runs) and
averaged. However, you need to explicitly say that ..

What units is "time in state", and what interfacing does the timing? Are
these states in order from least power saving to most power savings?

> === over1000 (10 samples) ====== (delta: -0.00999999998604) RUNTIME: 241.525 ===
> 240	idle-spin    --	3.1              1.91666e-05      	| 4.6665e-06
> 240	not-idle     --	88723.9          65.6361809172    	| -2.1949894149
> 240	idle-request --	88722.9          23311.9855603    	| -25.6467051707
> 240	idle-wfi     --	88719.8          174.493487111    	| 2.1971034149
> === over500 (10 samples) ======== (delta: -0.0339999999851) RUNTIME: 241.501 ===
> 240	idle-spin    --	2.3              1.88334e-05      	| 4.3333e-06
> 240	not-idle     --	88636.3          67.0242803241    	| -0.806890008
> 240	idle-request --	88635.3          23280.1632631    	| -57.469002442
> 240	idle-wfi     --	88633.0          173.077055869    	| 0.7806721723
> === over100 (10 samples) ======== (delta: -0.0539999999921) RUNTIME: 241.481 ===
> 240	idle-spin    --	0.9              6.6666e-06       	| -7.8335e-06
> 240	not-idle     --	88599.0          67.190273164     	| -0.6408971681
> 240	idle-request --	88597.9          23253.4797828    	| -84.1524827638
> 240	idle-wfi     --	88597.0          172.884529866    	| 0.5881461694
> === equal100 (10 samples) ================== (delta: -0.025) RUNTIME: 241.51 ===
> 240	idle-spin    --	1.4              9.5002e-06       	| -4.9999e-06
> 240	not-idle     --	88685.9          66.5067348407    	| -1.3244354914
> 240	idle-request --	88684.9          23294.4341497    	| -43.1981158192
> 240	idle-wfi     --	88683.5          173.60379269     	| 1.3074089936
> === equal50 (10 samples) ======== (delta: -0.0289999999804) RUNTIME: 241.506 ===
> 240	idle-spin    --	2.0              9.6664e-06       	| -4.8337e-06
> 240	not-idle     --	88537.4          65.8619214556    	| -1.9692488765
> 240	idle-request --	88536.4          22979.3665406    	| -358.265724952
> 240	idle-wfi     --	88534.4          174.247270576    	| 1.9508868794
> 
> 
> There appears to be very little change outside of noise from origin through
> equal100, however, once equal50 is reached, there is a noticeable change.

it all looks pretty noisy still, but it could be that your just
providing too much information ...

Ok, so the idle-request state had residency of 22979us (guessing units)
in equal50, and 23338us in the control. Which is %1.5 less. I would
think you want more residency rather than less right?

Replacing 50us udelays with timers will cause more timers to trigger at
a high frequency, which would cause you to be running timer code more
often rather than doing something else (maybe being in a sleep state).
So the number make some sense.

Does over100 include everything from 100 to 1000 ?

Daniel

