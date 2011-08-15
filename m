Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab1HORuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 13:50:00 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:43394 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab1HORt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 13:49:59 -0400
Message-ID: <4E495C4A.5040101@free.fr>
Date: Mon, 15 Aug 2011 19:50:02 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
        bonbons@linux-vserver.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
 when reboot
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr> <20110814161707.GB30846@redhat.com> <20110814213642.GB13799@hallyn.com> <20110815144744.GA9660@redhat.com> <20110815173940.GA19620@hallyn.com>
In-Reply-To: <20110815173940.GA19620@hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 07:39 PM, Serge E. Hallyn wrote:
> Quoting Oleg Nesterov (oleg@redhat.com):
>> On 08/14, Serge E. Hallyn wrote:
>>> Quoting Oleg Nesterov (oleg@redhat.com):
>>>> On 08/11, Daniel Lezcano wrote:
>>>>> In the case of a VPS, when we shutdown/halt/reboot the container, the
>>>>> reboot utility will invoke the sys_reboot syscall which has the bad
>>>>> effect to reboot the host.
>>>> Stupid question. Can't sys_reboot() simply kill init (and thus the whole
>>>> pid_ns) in this case?
>>> The goal is to be able to distinguish a request for reboot from shutdown.
>>> If we just kill the init, then the parent of init (the container monitor)
>>> cannot restart the container to emulate reboot.
>> OK, thanks.
>>
>> What if init reports the reason it was killed?
>>
>> Ignoring LINUX_REBOOT_CMD_CAD_/etc, I mean, roughly,
>>
>> 	- add "int reboot_cmd" into struct pid_namespace
>>
>> 	- sys_reboot(cmd) does
>>
>> 		if (!global_namespace) {
>> 			task_active_pid_ns(current)->reboot_cmd = cmd;
>> 			sigkill_my_init();
>> 		}
>>
>> 	- change zap_pid_ns_processes() to do
>>
>> 		if (pid_ns->reboot_cmd)	// approximately
>> 			current->exit_state = pid_ns->reboot_cmd;
>>
>> Then its parent can look at status after wait(&status).
> That looks good to me.  Daniel, is there a reason this wouldn't work?

No, it is an alternative we can try. Oleg raise a good point about the
SIGCHLD not being queue.
Let me write this patch and test it.

  -- Daniel


