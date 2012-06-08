Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760391Ab2FHVfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 17:35:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41682 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2FHVfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 17:35:01 -0400
Message-ID: <4FD27000.7000208@linaro.org>
Date: Fri, 08 Jun 2012 23:34:56 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [RFC 1/4] cpuidle: define the enter function in the
 driver structure
References: <1339171365-4098-1-git-send-email-daniel.lezcano@linaro.org> <4FD23752.6090101@linux.vnet.ibm.com>
In-Reply-To: <4FD23752.6090101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 07:33 PM, Deepthi Dharwar wrote:
> Hi Daniel,

Hi Deepthi,

> On 06/08/2012 09:32 PM, Daniel Lezcano wrote:
> 
>> We have the state index passed as parameter to the 'enter' function.
>> Most of the drivers assign their 'enter' functions several times in
>> the cpuidle_state structure, as we have the index, we can delegate
>> to the driver to handle their own callback array.
>>
>> That will have the benefit of removing multiple lines of code in the
>> different drivers.
>>
>> In order to smoothly modify the driver, the 'enter' function are in
>> the driver structure and in the cpuidle state structure. That will
>> let the time to modify the different drivers one by one.
>> So the 'cpuidle_enter' function checks if the 'enter' callback is
>> assigned in the driver structure and use it, otherwise it invokes
>> the 'enter' assigned to the cpuidle_state.
> 
> 
> Currently, the backend driver initializes
> all the cpuidle states supported on the platform,
> and each state can have its own enter routine
> which can be unique This is a clean approach.

Yes, I perfectly understood the purpose of this field but as clean it is
it does not make sense as it is not used in this way. If it is supposed
to be done in the way you are describing here, we should have the same
number of states and enter functions. Here it is how it is used:

 --------------------------------------------------
| Arch             | nr states | nr enter function |
 --------------------------------------------------
| x86 (nehalem)    |    3      |         1         |
 --------------------------------------------------
| x86 (snb)        |    4      |         1         |
 --------------------------------------------------
| x86 (atom)       |    4      |         1         |
 --------------------------------------------------
| ARM tegra        |    1      |         1         |
 --------------------------------------------------
| ARM omap3        |    7      |         2         |
 --------------------------------------------------
| ARM omap4        |    3      |         1         |
 --------------------------------------------------
| ARM ux500        |    2      |         1         |
 --------------------------------------------------
| ARM shmobile     |    1      |         1         |
 --------------------------------------------------
| ARM davinci      |    2      |         1         |
 --------------------------------------------------
| ARM at91         |    2      |         1         |
 --------------------------------------------------
| ARM s3c64xx      |    1      |         1         |
 --------------------------------------------------
| ARM exynos       |    2      |         1         |
 --------------------------------------------------
| ARM kirkwood     |    2      |         1         |
 --------------------------------------------------
| SH               |    3      |         1         |
 --------------------------------------------------
| PPC              |    2      |         2         |
 --------------------------------------------------
|                  |           |                   |
| TOTAL            |    39     |        17         |
|                  |           |                   |
 --------------------------------------------------


As you can see most of the enter functions are only used as one.
The Omap3 cpuidle driver enter function for C2 calls the enter function
of C1. Other arch, already use a table of callbacks or the index.

> By moving the enter routine into the driver,
> we are enforcing in having only one enter state.
> There is unnecessary overhead involved
> in calling a wrapper routine just to
> index into the right idle state routine
> for many platforms at runtime.

I don't agree. For the sake of encapsulated code, we duplicate n-times a
field and that is not used in this way. It is quite easy to have in the
driver specific code a common enter function to ventilate to the right
routine without adding extra overhead and let the common code use a
single enter routine (which is already the case today).


