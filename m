Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab1GSUqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 16:46:01 -0400
Received: from mail.dasr.de ([217.69.77.164]:38633 "EHLO mail.dasr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab1GSUqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 16:46:01 -0400
X-Greylist: delayed 2573 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jul 2011 16:46:00 EDT
Message-ID: <4E25E2F5.7090807@dasr.de>
Date: Tue, 19 Jul 2011 22:03:01 +0200
From: Harald Laabs <kernelml@dasr.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG] null-pointer in task_rq_lock (2.6.35 to 3.0-rc7)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
reloading an apache httpd can crash the kernel since 2.6.35.
It seems that tasks are removed between creating the task-list and
calling wake_up_sem_queue_do in freeary. The pointers to the
task_struct elements end up in try_to_wake_up and sometimes contain
0x0 there.
The problem did not exist in 2.6.34. It does not show up on single
processor systems. Depending on the apache httpd settings it only
takes a few tries to kill the system on our 8-core servers. Dualcore
did not want to crash, maybe it really needs more than one real CPU.
Various gcc versions (4.1 to 4.6) were used.

If anyone wants to crash a system using an prefork apache httpd:
<IfModule mpm_prefork_module>
        ServerLimit             512
        StartServers             50
        MinSpareServers          50
        MaxSpareServers         100
        MaxClients              200
        MaxRequestsPerChild     500
</IfModule>
(Details do not seem to matter but some settings did not die fast.)

I'm not able to fix or understand this bug myself, its already in
bugzilla with the call trace:
https://bugzilla.kernel.org/show_bug.cgi?id=27142

Is there any more useful information I can provide? Anything to test?
Does anyone know of changes from 2.6.34 to 2.6.35 that might have
broken this? (The diff and the changelog do not enlighten me, too
much changed and I understand little of it.)

Thanks,
Harald
