Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab1CGJVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 04:21:33 -0500
Received: from mail.monfort.co.il ([212.150.31.124]:1245 "EHLO monfort.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245Ab1CGJVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 04:21:32 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Mar 2011 04:21:32 EST
Date: Mon, 07 Mar 2011 11:13:00 +0200
From: Oran Agra <oran@monfort.co.il>
Subject: Disk access scheduling - FS cache dispensing - process priorities
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Message-ID: <ed957dbc.1cbdca7.2304247e.29@monfort.co.il>
X-Priority: 3
Organization: Monfort Software
X-Mailer: Outlook Connector for MDaemon 2.2.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-SGPtrLookup-Result: hardfail ip=172.16.50.10 (no PTR records found)
X-SGHeloLookup-Result: hardfail smtp.helo=Paramyxo.monfort.local (does not exist)
X-SGMailLookup-Result: pass smtp.mail=oran@monfort.co.il (ip=172.16.50.10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'll try to be brief.

In the context of CPU time scheduling and process priorities the disk access scheduler does not seem to consider the requesting process priority when it handles disk access requests.
This can create a situation where a 'real-time like' high priority process will be stuck or have reduced performance due to a low priority process being a write-hog (or read-hog).

Furthermore, a similar issue resides in the file-system cache dispensing mechanism.
In a system with low amount of RAM, a low priority read/write hog might squeeze a high priority process's data out of the disk-cache resulting in poor performance for the high priority process.

This is even more severe since the cache is used to memory map the executable code into the RAM, and the RSS of that mapping is being reduced. 
In that case the performance of the high priority process will be reduced even if the user code doesn't issue any file system requests, but since the RSS portion of its executable memory mapping was reduced, thrashing will occur when the process calls an executable area that isn't currently cached.

Fist of all, am I missing something? 
Is there any way for a user to overcome this behavior and improve on the I/O scheduling and cache dispensing of a prioritized process?
If not:

[Suggestions]
I want to suggest a few options if these mechanisms are ever re-worked:
- Disk access scheduling based on requesting process priority.
- File system cache dispensing based on process priority.
- Ability (system call api, or /proc entry) to do any of the following:
 1) Limit a certain process's (the hog) maximum cache consumption.
 2) Reserve a certain amount of cache for a certain (high priority) process.
 3) Limit the amount of cache consumption for a certain folder (e.g logs).
 4) Reserve an amount of cache for a file or folder (executable, libraries).

[Reading is optional]
Maybe a little bit of background on the scenario where I stumbled upon this will assist your understanding:
Life assist medical device running Linux kernel (2.6.17.9) + busybox etc, running on ARM9 + 64MB of RAM, no swap space, and flash based disk.
One high priority process handles the critical tasks, and one low priority process handles the GUI.
When the GUI starts TAR-ring log files onto a removable flash drive, it suffocates the high priority critical process.
Although the high priority process doesn't issue any disk requests, the RAM is SO tight that the memory mapped portions of the executable are squeezed out of the cache.

Many thanks for a great work, and for reading thoughts.
Oran Agra.



