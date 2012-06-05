Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761452Ab2FEJbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:31:08 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:35632 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2FEJbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:31:06 -0400
Message-ID: <4FCDD1A0.7040402@free.fr>
Date: Tue, 05 Jun 2012 11:30:08 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, devel@openvz.org, kir@parallels.com,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] allow a task to join a pid namespace
References: <1338816828-25312-1-git-send-email-glommer@parallels.com> <20120604165117.GA13091@redhat.com>
In-Reply-To: <20120604165117.GA13091@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 06:51 PM, Oleg Nesterov wrote:
> On 06/04, Glauber Costa wrote:
>>
>> Currently, it is possible for a process  to join existing
>> net, uts and ipc namespaces. This patch allows a process to join an
>> existing pid namespace as well.
> 
> I can't understand this patch... but probably I missed something,
> I never really understood setns.

Hi Oleg,

let me clarify why is needed setns. In the world of container, setns
allows to administrate the container from outside. One good example is
to shutdown the container. The users setup their hosts with the init's
services to startup the containers when the system starts, but they have
no way to invoke 'shutdown' from inside the container when the system
goes down except doing some trick with the signals. The setns syscall
with the pid namespace support will allow to do that.

Also a complete setns support will allow to write some administrative
tools to have a global view of the different separated resources running
in several containers.

For example, if you are the administrator of the host and you have
hundred of containers running on it, you can use setns to run netstat
within each container and build a view of the different network stack.
The same applies for 'ps' or 'top'.

Without setns, things are much more complicated and in some cases,
impossible. For instance, you can run a daemon inside the container,
send command to it and redirect its output to the fifo  but that
increase the number of processes and has some limitations. Also that
means the command you want to run is present in the container's FS.

The setns syscall is highly needed for the VRF, where a single process
can handle thousand of network namespaces and switch from a network
namespace to another network namespace with one syscall. The usage of
the file descriptors pins the namespace and prevent it from being
destroyed when switching from one namespace to another.

In other words, +1 for pid ns support with setns :)

  -- Daniel
