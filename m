Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab2JWWLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:11:43 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53727 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab2JWWLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:11:41 -0400
Message-ID: <50871695.2040904@gmail.com>
Date: Wed, 24 Oct 2012 00:13:41 +0200
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Hongbo Zhang <hongbo.zhang@linaro.org>
CC: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org,
        amit.kachhap@linaro.org
Subject: Re: [PATCH 1/5] Thermal: do bind operation after thermal zone or
 cooling device register returns.
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com> <1350387889-15324-2-git-send-email-hongbo.zhang@linaro.com> <5083C8E4.7090007@gmail.com> <CAJLyvQyrZ56_KhUTpuv=2fet=12QHSCUjgUKHF9n3cmaATke5w@mail.gmail.com>
In-Reply-To: <CAJLyvQyrZ56_KhUTpuv=2fet=12QHSCUjgUKHF9n3cmaATke5w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On 10/23/2012 10:23 AM, Hongbo Zhang wrote:
> Hi Francesco,
> I found out more points about this issue.
> 
> [1]
> cdev should be ready when get_max_state callback be called, otherwise
> parameter cdev is useless, imagine there may be cases that
> get_max_state call back is shared by more than one cooling devices of
> same kind, like this:
> common_get_max_state(*cdev, *state)
> {
>     if (cdev == cdev1)  *state = 3;
>     else if (cdev == cdev)  *state = 5;
>     else
> }
> 
> [2]
> In my cpufreq cooling case(in fact cdev is not used to calculate
> max_state), the cooling_cpufreq_list should be ready when
> get_max_state call back is called. In this patch I defer the binding
> when registration finished, but this is not perfect now, see this
> routine in cpufreq_cooling_register:
> 
> thermal_cooling_device_register;
> at this time: thermal_bind_work -> get_max_state -> get NULL
> cooling_cpufreq_list
> and then: list_add_tail(&cpufreq_dev->node, &cooling_cpufreq_list)
> This is due to we cannot know exactly when the bind work is executed.
> (and this can be fixed by moving mutex_lock(&cooling_cpufreq_lock)
> aheadof thermal_cooling_device_register and other corresponding
> modifications, but I found another way as below)
> 
> [3]
> Root cause of this problem is calling get_max_state in register -> bind routine.
> Better solution is to add another parameter in cooling device register
> function, also add a max_state member in struct cdev, like:
> thermal_cooling_device_register(char *type, void *devdata, const
> struct thermal_cooling_device_ops *ops, unsigned long max_state)
> and then in the bind function:
> if(cdev->max_state)
>     max_state = cdev->max_state;
> else
>     cdev->get_max_state(cdev, &max_state)
> 
> It is common sense that the cooling driver should know its cooling
> max_state(ability) before registration, and it can be offered when
> register.
> I think this way doesn't change both thermal and cooling layer much,
> it is more clear.
> I will update this patch soon.

I still believe the thermal layer doesn't need any change to work around
this problem, and I still believe that when a cooling device is being
registered, all of its ops should be fully functional.
The problem with the cpufreq cooling device driver is that its callbacks
use the internal list of devices to retrieve the struct
cpufreq_cooling_device instance corresponding to a given struct
thermal_cooling_device. This is not necessary, because the struct
thermal_cooling_device has a private data pointer (devdata) which in
this case is exactly a reference to the struct cpufreq_cooling_device
instance the callbacks are looking for. In fact, I think the
cooling_cpufreq_list is not necessary at all, and should be removed from
the cpufreq cooling driver.
So the 3 callbacks, instead of iterating through the device list, should
have something like:
struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
That would do the trick.

--
Francesco
