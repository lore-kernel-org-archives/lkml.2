Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab1HSJ0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 05:26:00 -0400
Received: from fep22.mx.upcmail.net ([62.179.121.42]:58738 "EHLO
	fep22.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab1HSJZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 05:25:59 -0400
X-SourceIP: 178.83.227.111
Message-ID: <4E4E2B2A.40100@odi.ch>
Date: Fri, 19 Aug 2011 11:21:46 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: contention on long-held spinlock
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=8S1SuMVx/U5/1YzUNNnU6kT28Pe+FrAffnosugit2uo= c=1 sm=0 a=qwWq2mCMaEgA:10 a=8nJEP1OIZ-IA:10 a=xxrzofrVVTDJoQHq9W8A:9 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have observed a bad behaviour that is likely caused by spinlocks in 
the qla2xxx driver. This is a QLogic Fibre Channel storage driver.

Somehow the attached SAN had a problem and became unresponsive. Many 
processes queued up waiting to write to the device. The processes were 
doing nothing but wait, but system load increased to insane values (40 
and above on a 4 core machine). The system was very sluggish and 
unresponsive, making it very hard and slow to see what actually was the 
problem.

I didn't run an indepth analysis, but this is my guess: I see that 
qla2xxx uses spinlocks to guard the HW against concurrent access. So if 
the HW becomes unresponsive all waiters would busy spin and burn 
resources, right? Those spinlocks are superfast as long as the HW 
responds well, but become a CPU burner once the HW becomes slow.

I wonder if spinlocks could be made aware of such a situation and relax. 
Something like if spinning for more than 1000 times, perform a simple 
backoff and sleep. A spinlock should never spin busy for several 
seconds, right?

Thanks,

Ortwin
