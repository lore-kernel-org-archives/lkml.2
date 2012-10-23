Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab2JWIXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:23:46 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44098 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab2JWIXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:23:43 -0400
MIME-Version: 1.0
In-Reply-To: <5083C8E4.7090007@gmail.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1350387889-15324-2-git-send-email-hongbo.zhang@linaro.com>
	<5083C8E4.7090007@gmail.com>
Date: Tue, 23 Oct 2012 16:23:43 +0800
Message-ID: <CAJLyvQyrZ56_KhUTpuv=2fet=12QHSCUjgUKHF9n3cmaATke5w@mail.gmail.com>
Subject: Re: [PATCH 1/5] Thermal: do bind operation after thermal zone or
 cooling device register returns.
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org,
        amit.kachhap@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Francesco,
I found out more points about this issue.

[1]
cdev should be ready when get_max_state callback be called, otherwise
parameter cdev is useless, imagine there may be cases that
get_max_state call back is shared by more than one cooling devices of
same kind, like this:
common_get_max_state(*cdev, *state)
{
    if (cdev == cdev1)  *state = 3;
    else if (cdev == cdev)  *state = 5;
    else
}

[2]
In my cpufreq cooling case(in fact cdev is not used to calculate
max_state), the cooling_cpufreq_list should be ready when
get_max_state call back is called. In this patch I defer the binding
when registration finished, but this is not perfect now, see this
routine in cpufreq_cooling_register:

thermal_cooling_device_register;
at this time: thermal_bind_work -> get_max_state -> get NULL
cooling_cpufreq_list
and then: list_add_tail(&cpufreq_dev->node, &cooling_cpufreq_list)
This is due to we cannot know exactly when the bind work is executed.
(and this can be fixed by moving mutex_lock(&cooling_cpufreq_lock)
aheadof thermal_cooling_device_register and other corresponding
modifications, but I found another way as below)

[3]
Root cause of this problem is calling get_max_state in register -> bind routine.
Better solution is to add another parameter in cooling device register
function, also add a max_state member in struct cdev, like:
thermal_cooling_device_register(char *type, void *devdata, const
struct thermal_cooling_device_ops *ops, unsigned long max_state)
and then in the bind function:
if(cdev->max_state)
    max_state = cdev->max_state;
else
    cdev->get_max_state(cdev, &max_state)

It is common sense that the cooling driver should know its cooling
max_state(ability) before registration, and it can be offered when
register.
I think this way doesn't change both thermal and cooling layer much,
it is more clear.
I will update this patch soon.


On 21 October 2012 18:05, Francesco Lavra <francescolavra.fl@gmail.com> wrote:
> Hi,
>
> On 10/16/2012 01:44 PM, hongbo.zhang wrote:
>> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
>>
>> In the previous bind function, cdev->get_max_state(cdev, &max_state) is called
>> before the registration function finishes, but at this moment, the parameter
>> cdev at thermal driver layer isn't ready--it will get ready only after its
>> registration, so the the get_max_state callback cannot tell the max_state
>> according to the cdev input.
>> This problem can be fixed by separating the bind operation out of registration
>> and doing it when registration completely finished.
>
> When thermal_cooling_device_register() is called, the thermal framework
> assumes the cooling device is "ready", i.e. all of its ops callbacks
> return meaningful results. If the cooling device is not ready at this
> point, then this is a bug in the code that registers it.
> Specifically, the faulty code in your case is in the cpufreq cooling
> implementation, where the cooling device is registered before being
> added to the internal list of cpufreq cooling devices. So, IMHO the fix
> is needed there.
>
> --
> Francesco
