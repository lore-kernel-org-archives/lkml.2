Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab1BOR5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:57:48 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:3717 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab1BOR5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:57:46 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Ray Jui" <rjui@broadcom.com>
To: "Tejun Heo" <tj@kernel.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Feb 2011 09:57:21 -0800
Subject: RE: Questions about Linux workqueue in 2.6.36
Thread-Topic: Questions about Linux workqueue in 2.6.36
Thread-Index: AcvMR8pZSHZn4UkNQKSdVEvzZx9sbQA8Sxdg
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADDDF03CDD8A@SJEXCHCCR02.corp.ad.broadcom.com>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADDDF02C2EAC@SJEXCHCCR02.corp.ad.broadcom.com>
 <20110209102847.GE3770@htj.dyndns.org>
 <8628FE4E7912BF47A96AE7DD7BAC0AADDDF02C3163@SJEXCHCCR02.corp.ad.broadcom.com>
 <20110214130300.GH18742@htj.dyndns.org>
In-Reply-To: <20110214130300.GH18742@htj.dyndns.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 6144608B3DG9842406-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Regarding your second patch, which changes the initial mayday timeout to
MAYDAY_INITIAL_TIMEOUT	= HZ / 100 >= 2 ? HZ / 100 : 2,

That's a minimum of 2 timer ticks, which is 20 ms in our system. Since the timer resolution in our system is 10 ms and it takes 15 ~ 20 ms to create a new kworker during kernel startup in our system, I verified that I need to change the minimum timer tick to 3 for the rescuer NOT to kick in our system during startup.

Thanks,

Ray

-----Original Message-----
From: Tejun Heo [mailto:htejun@gmail.com] On Behalf Of Tejun Heo
Sent: Monday, February 14, 2011 5:03 AM
To: Ray Jui
Cc: linux-kernel@vger.kernel.org
Subject: Re: Questions about Linux workqueue in 2.6.36

Hello,

On Wed, Feb 09, 2011 at 02:38:36PM -0800, Ray Jui wrote:
> You are right. The problem with the rescuer is that when it is
> leaving a gcwq, it does not check to see whether it needs to wake up
> a worker to process subsequent work items. After applying your
> patch, I see pid 26 getting waken up by the rescuer and work items
> from mmc1 and mmc2 are now being processed properly.

Cool, I'll send the patch to upstream and stable.

> I also did a quick profiling on the amount of time it takes to
> create a new worker on our system. It takes 15 ~ 20 ms. This is not
> surprising as it's an embedded system and it was during kernel boot
> up and the system was getting quite busy. Regardless, the current 10
> ms initial mayday timeout has resolution issues on a lot of embedded
> systems with worse timer resolutions (e.g., 10 ms on our system).

Can you please verify the second patch removes the unncessary rescuer
invocation?

Thanks.

-- 
tejun


