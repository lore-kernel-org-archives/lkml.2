Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab2BCPW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:22:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab2BCPW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:22:26 -0500
Message-ID: <4F2BFBAF.5020703@redhat.com>
Date: Fri, 03 Feb 2012 16:22:23 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: util-linux@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC] fs: filesystem specific options and remount
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When remounted without option specified, some filesystems keep the
options that are already set (e.g. procfs, fat) and some reset them to
default (e.g. devpts).
Regarding options that are specified at remount, behavior of
filesystems also differ: some apply them (procfs, devpts), some
silently disregard them (e.g. fat) and some have a more elaborate
behavior (e.g. xfs apparently allows a subset of options to be changed
and issues warning if someone tries to change any other option).

Is there any policy regarding what the correct behavior should be?
This variety of behaviors tends to confuse mount utility which often
does not show the correct option actually set after a remount and
most certainly confuses the users as well.

Here is a example of discrepancy between mount (/etc/mtab) and
/proc/mounts:

$ grep proc /proc/mounts
/proc /proc proc rw,relatime 0 0
$ mount | grep proc
proc on /proc type proc (rw)

$ mount -o remount,hidepid=2 /proc/
$ grep proc /proc/mounts
/proc /proc proc rw,relatime,hidepid=2 0 0
$ mount | grep proc
proc on /proc type proc (rw,hidepid=2)

$ mount -o remount /proc/
$ grep proc /proc/mounts
/proc /proc proc rw,relatime,hidepid=2 0 0
$ mount | grep proc
proc on /proc type proc (rw)

And here is the discrepancy: mount does not show "hidepid=2" option
that is actually still set and enforced. Note that mount also missed
the relatime option to begin with.

Regards,
Jerome
