Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab1LEWim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 17:38:42 -0500
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2584 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab1LEWil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:38:41 -0500
Date: Mon, 5 Dec 2011 23:38:31 +0100
Message-Id: <201112052238.pB5McVkM000865@xs8.xs4all.nl>
From: "Miquel van Smoorenburg" <mikevs@xs4all.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Miquel van Smoorenburg" <mikevs@xs4all.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1][V3] Handle reboot in a child pid namespace
X-Newsgroups: lists.linux.kernel
In-Reply-To: <20111205205035.GB7422@redhat.com>
References: <1323030290-22216-1-git-send-email-daniel.lezcano@free.fr> <20111204212756.GB16362@khazad-dum.debian.net> <4EDBFD67.1040009@free.fr>
Organization: 
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <xs4all.20111205205035.GB7422@redhat.com> you write:
>On 12/05, Daniel Lezcano wrote:
>>
>> On 12/04/2011 10:27 PM, Henrique de Moraes Holschuh wrote:
>> > On Sun, 04 Dec 2011, Daniel Lezcano wrote:
>> > Daniel, can you address Miquel's concern?  Is it a valid concern, or
>> > not?  I assume CAP_REBOOT functionality is still in place inside the
>> > container, so it really does look like userspace would need to know
>> > whether it should drop CAP_REBOOT or not, in order to automatically use
>> > the new feature.
>>
>> Hmm, I missed its email.
>
>Me too... so I am not sure I really understand the problem.

In order to use this new functionality, a container has to have
the CAP_REBOOT capability.

So if that container setup runs on a modern kernel with this patch
applied all is well and sys_reboot() will just reboot the container.
But on an older kernel, that sys_reboot() call will reboot the host.
You really really want to prevent that.

So there should be a way for the system setting up the container
(e.g. lxc-start) to know if this new reboot-the-container-instead-
of-the-host is implemented. If not, it should drop CAP_REBOOT.

That's why I proposed adding a LINUX_REBOOT_CMD_ISCONTAINER
(or whatever) pseudo command for sys_reboot that would only
return 0 for the reboot-the-name-space version of sys_reboot().

lxc-start or equivalent would then do:

	if (sys_reboot(LINUX_REBOOT_CMD_ISCONTAINER) != 0)
		cap_drop(CAP_REBOOT);

Mike.
