Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab1AMQeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:34:44 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:38427 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756934Ab1AMQen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:34:43 -0500
Message-ID: <4D2F299B.4000509@free.fr>
Date: Thu, 13 Jan 2011 17:34:35 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Containers <containers@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFD] reboot / shutdown of a container
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

in the container implementation, we are facing the problem of a process 
calling the sys_reboot syscall which of course makes the host to 
poweroff/reboot.

If we drop the cap_sys_reboot capability, sys_reboot fails and the 
container reach a shutdown state but the init process stay there, hence 
the container becomes stuck waiting indefinitely the process '1' to exit.

The current implementation to make the shutdown / reboot of the 
container to work is we watch, from a process outside of the container, 
the <rootfs>/var/run/utmp file and check the runlevel each time the file 
changes. When the 'reboot' or 'shutdown' level is detected, we wait for 
a single remaining in the container and then we kill it.

That works but this is not efficient in case of a large number of 
containers as we will have to watch a lot of utmp files. In addition, 
the /var/run directory must *not* mounted as tmpfs in the distro. 
Unfortunately, it is the default setup on most of the distros and tends 
to generalize. That implies, the rootfs init's scripts must be modified 
for the container when we put in place its rootfs and as /var/run is 
supposed to be a tmpfs, most of the applications do not cleanup the 
directory, so we need to add extra services to wipeout the files.

More problems arise when we do an upgrade of the distro inside the 
container, because all the setup we made at creation time will be lost. 
The upgrade overwrite the scripts, the fstab and so on.

We did what was possible to solve the problem from userspace but we 
reach always a limit because there are different implementations of the 
'init' process and the init's scripts differ from a distro to another 
and the same with the versions.

We think this problem can only be solved from the kernel.

The idea was to send a signal SIGPWR to the parent of the pid '1' of the 
pid namespace when the sys_reboot is called. Of course that won't occur 
for the init pid namespace.

Does it make sense ?

Any idea is very welcome :)

   -- Daniel




