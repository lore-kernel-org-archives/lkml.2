Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab1LDT0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 14:26:12 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:54508 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab1LDT0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 14:26:10 -0500
Message-ID: <4EDBC93D.2080201@free.fr>
Date: Sun, 04 Dec 2011 20:25:49 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: akpm@linux-foundation.org, serge.hallyn@canonical.com,
        containers@lists.linux-foundation.org, gkurz@fr.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1][v2] Add reboot_pid_ns to handle the reboot syscall
References: <1322956280-13831-1-git-send-email-daniel.lezcano@free.fr> <1322956280-13831-2-git-send-email-daniel.lezcano@free.fr> <20111204154543.GA23805@redhat.com>
In-Reply-To: <20111204154543.GA23805@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2011 04:45 PM, Oleg Nesterov wrote:
> On 12/04, Daniel Lezcano wrote:
>> @@ -32,6 +32,8 @@ struct pid_namespace {
>>  #endif
>>  	gid_t pid_gid;
>>  	int hide_pid;
>> +	int reboot;
>> +	spinlock_t reboot_lock;
>>  };
> Well. I was thinking about the serialization too, but this
> ->reboot_lock asks for v3 imho ;)
>
> First of all, do we really care? force_sig(SIGKILL, child_reaper)
> can't race with itself, it does nothing if init is already killed.
>
> So why it is important to protect pid_ns->reboot? Yes, it is possible
> to change it again if two callers do sys_reboot() "at the same time".
> But in this case we can't predict which caller wins anyway, so why
> should we worry?
>
> IOW. Say, we have the 2 tasks doing HALT and RESTART in parallel.
> It is possible that HALT sets ->reboot and kills init first, then
> RESTART changes ->reboot and the second force_sig() does nothing.
> In this case we can simply pretend that RESTART wins and the dying
> init kills HALT before it calls sys_reboot().

In the case of racy access, your argument makes sense but it is also to
prevent multiple calls to 'reboot'. In the init_pid_ns, when a shutdown
is on the way, the lock will prevent another task to invoke a machine
restart.  But anyway, we can get ride of this lock and the
serialization, it is a nit we can fix later if that makes sense with the
couple of lines you specified below.

> In any case. Even if you want to serialize, instead of adding the
> new lock reboot_pid_ns() can simply do:
>
> 	if (cmpxchg(&pid_ns->reboot, 0, reboot) != 0)
> 		return -EBUSY;
>
> this looks much simpler to me.

Yes, definitively :)

Thanks
  -- Daniel



