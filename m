Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab2KTMGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:06:55 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:44605 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab2KTMGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:06:52 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Rickard Andersson <rickard.andersson@stericsson.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH v3] cpufreq: ondemand: handle SW coordinated CPUs
Date: Tue, 20 Nov 2012 13:06:15 +0100
Message-Id: <1353413176-21723-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this patch fixes an issue with the ondemand governor, which currently
does not handle properly software coordinated CPUs - i.e. CPUs groups
with a common clock and a single governor, as in the u8500:

root@genericarmv7a:~# cpufreq-info -d
DB8500
root@genericarmv7a:~# cpufreq-info -a
0 1

In this case, with a non-patched kernel, if a process is loading only
the secondary CPU while the first one is idle, the ondemand governor may
take a long time before firing up the load sampling routine
(dbs_check_cpu()), leaving both cores running at minimum frequency even
if one of them is fully loaded.

The problem can be reproduced with standard utils, as in:

root@genericarmv7a:~# cpufreq-info --cpu 1 -f
200000
root@genericarmv7a:~# taskset 2 yes > /dev/null &
root@genericarmv7a:~# sleep 3
root@genericarmv7a:~# cpufreq-info --cpu 1 -f
200000

while there is no other process loading the other core - here I'm using
a minimal oe-core image.

To fix the problem, this patch modifies the governor to use an
individual deferrable work for each CPU, instead that just one for the
main one.

This patch has been tested on an U8500 system (dual cortex-A9) and on a
standard x86_64 dual-core laptop.

The patch is based on the original one by Rickard Andersson, developed
for ST-Ericsson and posted some months ago on the list, hence I'm
tagging as "v3" to avoid confusion.

Regards,
Fabio

---

Rickard Andersson (1):
  cpufreq: ondemand: handle SW coordinated CPUs

 drivers/cpufreq/cpufreq_ondemand.c | 141 ++++++++++++++++++++++++++++++++-----
 1 file changed, 122 insertions(+), 19 deletions(-)

-- 
1.7.12.1

