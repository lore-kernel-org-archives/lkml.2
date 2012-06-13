Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab2FMMo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:44:58 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38066 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201Ab2FMMo5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:44:57 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.97.133]
In-Reply-To: <4FD27000.7000208@linaro.org>
References: <1339171365-4098-1-git-send-email-daniel.lezcano@linaro.org>
	<4FD23752.6090101@linux.vnet.ibm.com>
	<4FD27000.7000208@linaro.org>
Date: Wed, 13 Jun 2012 14:44:55 +0200
Message-ID: <CAORVsuXEkyU_OkjqLDhe_OMq-uLEBaMLnz-pkJ1jtgnmcNxZpw@mail.gmail.com>
Subject: Re: [linux-pm] [RFC 1/4] cpuidle: define the enter function in the
 driver structure
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Fri, Jun 8, 2012 at 11:34 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> On 06/08/2012 07:33 PM, Deepthi Dharwar wrote:
>> Hi Daniel,
>
> Hi Deepthi,
>
>> On 06/08/2012 09:32 PM, Daniel Lezcano wrote:
>>
>>> We have the state index passed as parameter to the 'enter' function.
>>> Most of the drivers assign their 'enter' functions several times in
>>> the cpuidle_state structure, as we have the index, we can delegate
>>> to the driver to handle their own callback array.
>>>
>>> That will have the benefit of removing multiple lines of code in the
>>> different drivers.
>>>
>>> In order to smoothly modify the driver, the 'enter' function are in
>>> the driver structure and in the cpuidle state structure. That will
>>> let the time to modify the different drivers one by one.
>>> So the 'cpuidle_enter' function checks if the 'enter' callback is
>>> assigned in the driver structure and use it, otherwise it invokes
>>> the 'enter' assigned to the cpuidle_state.
>>
>>
>> Currently, the backend driver initializes
>> all the cpuidle states supported on the platform,
>> and each state can have its own enter routine
>> which can be unique This is a clean approach.
>
> Yes, I perfectly understood the purpose of this field but as clean it is
> it does not make sense as it is not used in this way. If it is supposed
> to be done in the way you are describing here, we should have the same
> number of states and enter functions. Here it is how it is used:
>
>  --------------------------------------------------
> | Arch             | nr states | nr enter function |
>  --------------------------------------------------
> | x86 (nehalem)    |    3      |         1         |
>  --------------------------------------------------
> | x86 (snb)        |    4      |         1         |
>  --------------------------------------------------
> | x86 (atom)       |    4      |         1         |
>  --------------------------------------------------
> | ARM tegra        |    1      |         1         |
>  --------------------------------------------------
> | ARM omap3        |    7      |         2         |
>  --------------------------------------------------
> | ARM omap4        |    3      |         1         |
>  --------------------------------------------------
> | ARM ux500        |    2      |         1         |
>  --------------------------------------------------
> | ARM shmobile     |    1      |         1         |
>  --------------------------------------------------
> | ARM davinci      |    2      |         1         |
>  --------------------------------------------------
> | ARM at91         |    2      |         1         |
>  --------------------------------------------------
> | ARM s3c64xx      |    1      |         1         |
>  --------------------------------------------------
> | ARM exynos       |    2      |         1         |
>  --------------------------------------------------
> | ARM kirkwood     |    2      |         1         |
>  --------------------------------------------------
> | SH               |    3      |         1         |
>  --------------------------------------------------
> | PPC              |    2      |         2         |
>  --------------------------------------------------
> |                  |           |                   |
> | TOTAL            |    39     |        17         |
> |                  |           |                   |
>  --------------------------------------------------
>
>
> As you can see most of the enter functions are only used as one.
> The Omap3 cpuidle driver enter function for C2 calls the enter function
> of C1. Other arch, already use a table of callbacks or the index.
There is a plan to remove the extra enter function as part of an
optimization, cf. [1]. The fix is planned to reach the 3.6 mainline
kernel via Kevin's tree [2].

[1] http://marc.info/?l=linux-omap&m=133856365818099&w=2
[2] http://git.kernel.org/?p=linux/kernel/git/khilman/linux-omap-pm.git;a=shortlog;h=refs/heads/for_3.6/pm/performance

The result is that there will be only one enter function for OMAP3.

Regards,
Jean

>> By moving the enter routine into the driver,
>> we are enforcing in having only one enter state.
>> There is unnecessary overhead involved
>> in calling a wrapper routine just to
>> index into the right idle state routine
>> for many platforms at runtime.
>
> I don't agree. For the sake of encapsulated code, we duplicate n-times a
> field and that is not used in this way. It is quite easy to have in the
> driver specific code a common enter function to ventilate to the right
> routine without adding extra overhead and let the common code use a
> single enter routine (which is already the case today).
>
>
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/linux-pm
