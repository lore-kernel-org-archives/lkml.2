Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab0DVPxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 11:53:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34024 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab0DVPxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 11:53:31 -0400
Date: Thu, 22 Apr 2010 08:52:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: mgross@linux.intel.com
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [patch] pm-qos refresh
Message-Id: <20100422085231.3b8d1f43.randy.dunlap@oracle.com>
In-Reply-To: <20100422144158.GA22565@linux.intel.com>
References: <20100422144158.GA22565@linux.intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BD070D9.0004:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010 07:41:58 -0700 mark gross wrote:

> From 72a6d704fd27639a8fb6ce4499a87ac1804a2551 Mon Sep 17 00:00:00 2001
> From: mgross <mark.gross@gmail.com>
> Date: Sat, 13 Mar 2010 08:18:36 -0800
> Subject: [PATCH 1/2] PM_QOS to use handle based list implementation and exported function name changes to be more descriptive of what is actually happening.
> 
> 
> Signed-off-by: markgross <mark.gross@intel.com>
> ---
>  Documentation/power/pm_qos_interface.txt |   44 +++---
>  drivers/acpi/processor_idle.c            |    2 +-
>  drivers/cpuidle/governors/ladder.c       |    2 +-
>  drivers/cpuidle/governors/menu.c         |    2 +-
>  drivers/net/e1000e/netdev.c              |   22 ++--
>  drivers/net/igbvf/netdev.c               |    6 +-
>  drivers/net/wireless/ipw2x00/ipw2100.c   |   11 +-
>  include/linux/netdevice.h                |    4 +
>  include/linux/pm_qos_params.h            |   14 +-
>  include/sound/pcm.h                      |    3 +-
>  kernel/pm_qos_params.c                   |  214 ++++++++++++++---------------
>  net/mac80211/mlme.c                      |    2 +-
>  net/mac80211/scan.c                      |    2 +-
>  sound/core/pcm.c                         |    3 -
>  sound/core/pcm_native.c                  |   14 +-
>  15 files changed, 175 insertions(+), 170 deletions(-)
> 
> diff --git a/Documentation/power/pm_qos_interface.txt b/Documentation/power/pm_qos_interface.txt
> index c40866e..2138afb 100644
> --- a/Documentation/power/pm_qos_interface.txt
> +++ b/Documentation/power/pm_qos_interface.txt
> @@ -18,44 +18,46 @@ and pm_qos_params.h.  This is done because having the available parameters
>  being runtime configurable or changeable from a driver was seen as too easy to
>  abuse.
>  
> -For each parameter a list of performance requirements is maintained along with
> +For each parameter a list of performance requests is maintained along with
>  an aggregated target value.  The aggregated target value is updated with
> -changes to the requirement list or elements of the list.  Typically the
> -aggregated target value is simply the max or min of the requirement values held
> +changes to the request list or elements of the list.  Typically the
> +aggregated target value is simply the max or min of the request values held
>  in the parameter list elements.
>  
>  From kernel mode the use of this interface is simple:
> -pm_qos_add_requirement(param_id, name, target_value):
> -Will insert a named element in the list for that identified PM_QOS parameter
> -with the target value.  Upon change to this list the new target is recomputed
> -and any registered notifiers are called only if the target value is now
> -different.
>  
> -pm_qos_update_requirement(param_id, name, new_target_value):
> -Will search the list identified by the param_id for the named list element and
> -then update its target value, calling the notification tree if the aggregated
> -target is changed.  with that name is already registered.
> +handle = pm_qos_add_request(param_class, target_value):
> +Will insert a element in the list for that identified PM_QOS class with the

               an element into

> +target value.  Upon change to this list the new target is recomputed and any
> +registered notifiers are called only if the target value is now different.
> +Clients of pm_qos need to save the returned handle.
>  
> -pm_qos_remove_requirement(param_id, name):
> -Will search the identified list for the named element and remove it, after
> -removal it will update the aggregate target and call the notification tree if
> -the target was changed as a result of removing the named requirement.
> +void pm_qos_update_request(handle, new_target_value):
> +Will update list element pointed to by the handle with the new target value.

               the list element                                          value

> +And recompute the new aggregated target, calling the notification tree if the

   and

> +target is changed.
> +
> +void pm_qos_remove_request(handle):
> +Will remove the element, after removal it will update the aggregate target and

                   element. After

> +call the notification tree if the target was changed as a result of removing
> +the request.
>  
>  
>  From user mode:
> -Only processes can register a pm_qos requirement.  To provide for automatic
> +Only processes can register a pm_qos request.  To provide for automatic
>  cleanup for process the interface requires the process to register its

           of a process,

> -parameter requirements in the following way:
> +parameter requests in the following way:
>  
>  To register the default pm_qos target for the specific parameter, the process
>  must open one of /dev/[cpu_dma_latency, network_latency, network_throughput]
>  
>  As long as the device node is held open that process has a registered
> -requirement on the parameter.  The name of the requirement is "process_<PID>"
> -derived from the current->pid from within the open system call.
> +request on the parameter.
>  
>  To change the requested target value the process needs to write a s32 value to

                                                                   an s32

> -the open device node.  This translates to a pm_qos_update_requirement call.
> +the open device node.  Alternatively the user mode program could write a hex
> +string for the value using 10 char long format e.g. "0x12345678".  This
> +translates to a pm_qos_update_request call.
>  
>  To remove the user mode request for a target value simply close the device
>  node.

---
~Randy
