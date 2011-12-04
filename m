Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab1LDXIo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 18:08:44 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:37348 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272Ab1LDXIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 18:08:43 -0500
Message-ID: <4EDBFD67.1040009@free.fr>
Date: Mon, 05 Dec 2011 00:08:23 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: akpm@linux-foundation.org, serge.hallyn@canonical.com, oleg@redhat.com,
        containers@lists.linux-foundation.org, gkurz@fr.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1][V3] Handle reboot in a child pid namespace
References: <1323030290-22216-1-git-send-email-daniel.lezcano@free.fr> <20111204212756.GB16362@khazad-dum.debian.net>
In-Reply-To: <20111204212756.GB16362@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2011 10:27 PM, Henrique de Moraes Holschuh wrote:
> On Sun, 04 Dec 2011, Daniel Lezcano wrote:
>>  * V3
>>    - removed lock and serialization of pid_ns_reboot
>>  * V2
>>    - added a lock for the pid namespace to prevent racy call
>>      to the 'reboot' syscall
>>    - Moved 'reboot' command assigned in zap_pid_ns_processes
>>      instead of wait_task_zombie
>>    - added tasklist lock around force_sig
>>    - added do_exit in pid_ns_reboot
>>    - used task_active_pid_ns instead of declaring a new variable in sys_reboot
>>    - moved code up before POWER_OFF changed to HALT in sys_reboot
> Daniel, can you address Miquel's concern?  Is it a valid concern, or
> not?  I assume CAP_REBOOT functionality is still in place inside the
> container, so it really does look like userspace would need to know
> whether it should drop CAP_REBOOT or not, in order to automatically use
> the new feature.

Hmm, I missed its email. I think it is worth to have such ability to
detect how behaves the reboot syscall vs the pid ns. At present, if we
call 'reboot' in a child pid namespace, that will affect the host, we
are changing this behavior with this patch. I don't think there is any
application doing a shutdown from a child pid namespace, that don't
makes sense as the shutdown is invoked after killing all the processes
on the system and that could only be done from the init_pid_ns.

I would like to address this in a separate patch in order to discuss the
best way to do that. Adding a fake 'reboot' parameter returning EINVAL
or 0 seems a good solution to detect at runtime if the shutdown is
correctly supported inside a container.

