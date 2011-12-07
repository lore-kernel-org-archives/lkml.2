Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463Ab1LGVhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:37:06 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:44017 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756617Ab1LGVhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:37:05 -0500
Message-ID: <4EDFDC65.20105@free.fr>
Date: Wed, 07 Dec 2011 22:36:37 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: serge.hallyn@canonical.com, oleg@redhat.com,
        containers@lists.linux-foundation.org, gkurz@fr.ibm.com,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH 1/1][V3] Add reboot_pid_ns to handle the reboot syscall
References: <1323030290-22216-1-git-send-email-daniel.lezcano@free.fr>	<1323030290-22216-2-git-send-email-daniel.lezcano@free.fr> <20111206171617.e31bc3a6.akpm@linux-foundation.org>
In-Reply-To: <20111206171617.e31bc3a6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 02:16 AM, Andrew Morton wrote:
> On Sun,  4 Dec 2011 21:24:50 +0100
> Daniel Lezcano <daniel.lezcano@free.fr> wrote:
>
>> In the case of a child pid namespace, rebooting the system does not
>> really makes sense. When the pid namespace is used in conjunction
>> with the other namespaces in order to create a linux container, the
>> reboot syscall leads to some problems.
>>
>> A container can reboot the host. That can be fixed by dropping
>> the sys_reboot capability but we are unable to correctly to poweroff/
>> halt/reboot a container and the container stays stuck at the shutdown
>> time with the container's init process waiting indefinitively.
>>
>> After several attempts, no solution from userspace was found to reliabily
>> handle the shutdown from a container.
>>
>> This patch propose to store the reboot value in the 16 upper bits of the
>> exit code from the processes belonging to a pid namespace which has
>> rebooted. When the reboot syscall is called and we are not in the initial
>> pid namespace, we kill the pid namespace.
>>
>> By this way the parent process of the child pid namespace to know if
>> it rebooted or not and take the right decision.
> hm, modifying the exit code in this manner is a strange interface.  I
> didn't see that coming.  Perhaps some additional justification for this
> idea should be added to the changelog, along with discussion of
> alternative schemes.  I don't immediately see any problems with it,
> but, odd...  I wonder what potential it has to upset existing
> userspace.

At the first glance, that shouldn't interact with the userspace application.
This happens only when waiting the init process of a child pid namespace
if one process of this namespace call 'reboot'. I don't have the
pretension to know all the applications of the world but this case
should be very rare expect for the containers implementations, lxc and
libvirt's LXC, which need this feature.

Well written applications should use WIFEXITED, WIFSIGNALED, ... These
macros mask the upper bits of the exit code. IMHO, the applications
shouldn't be impacted by this modification.

> Also, do we need to reserve all upper 16 bits of the exit code?  It
> would be better to formally leave some free for future use.

Yes, that's right, 4 bits should be enough.
> Also, this alters the interface of wait4() and friends, yes?  If so,
> that should be documented in the manpages.  Please Cc Michael on such
> changes.

Sure, I will add a more precise description in the changelog for Michael.

> Also, this affects the data delivered by taskstats, I believe.  Please
> check this, test it, document it in the changelog and update
> getdelays.c appropriately.

Thanks for spotting this. I will check.

> Also, glibc might be affected.  For symmetry we might want to add a
> WIFREBOOT() or something.  And we now expect waitid() to fill in extra
> bits in siginfo_t.si_status, which assumes that glibc (and other
> libc's!) aren't using a u8 in there somewhere.  etcetera.  This all
> should be tested, and reviewed by Uli (please).

Ok, I will add some test cases to the the patch 0/1 with the macro
definition and in addition a better description.

Thanks for your comments.

  -- Daniel

>> ...
>>
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -444,6 +444,9 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>>  	                magic2 != LINUX_REBOOT_MAGIC2C))
>>  		return -EINVAL;
>>  
>> +	if (task_active_pid_ns(current) != &init_pid_ns)
>> +		return reboot_pid_ns(task_active_pid_ns(current), cmd);
> This adds a bunch of useless code if CONFIG_PID_NS=n.  It would be
> better to do
>
> #ifdef CONFIG_PID_NS
> extern void pidns_handle_reboot(int cmd);
> #else
> static inline void pidns_handle_reboot(int cmd)
> {
> }
> #endif
>
>
>

    * Unknown - detected
    * English
    * French

    * English
    * French

<javascript:void(0);><#>
