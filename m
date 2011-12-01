Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1LAA1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:27:14 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52155 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab1LAA1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:27:13 -0500
MIME-Version: 1.0
In-Reply-To: <1322691367.10023.10.camel@Joe-Laptop>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
 <1322683014-13285-5-git-send-email-jim.cromie@gmail.com> <20111130220351.GC2500@redhat.com>
 <1322691367.10023.10.camel@Joe-Laptop>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 30 Nov 2011 17:26:41 -0700
Message-ID: <CAJfuBxzhBf4YY-A9k9ZXhQeJV9bPPcm7En5pXVT1X5Sz=UWUQg@mail.gmail.com>
Subject: Re: [PATCH 04/25] dynamic_debug: make dynamic-debug supersede DEBUG ccflag
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@redhat.com>, greg@kroah.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 3:16 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2011-11-30 at 17:03 -0500, Jason Baron wrote:
>> I think it's this patach that is causing a lot of "=p" when I boot up
>> using a 'make defconfig'.
>
> =p?
>

Thats referring to the new enabled indicator in control,
its more greppable than plain old 'p', and has better memonics
(p-flag is set)

root@voyage:~# grep =p /dbg/dynamic_debug/control
fs/sysfs/mount.c:66 [mount]sysfs_fill_super =p "%s: could not get root
dentry!\012"
fs/sysfs/mount.c:59 [mount]sysfs_fill_super =p "sysfs: could not get
root inode\012"
drivers/rtc/class.c:102 [rtc_core]rtc_resume =p "%s:  time travel!\012"
drivers/rtc/class.c:94 [rtc_core]rtc_resume =p "%s:  bogus resume time\012"

>>  I'm a bit surprised at how many files have
>> 'DEBUG' defined.
>

thats at least partly due to defconfig
I turn on a few things via bootline and /etc/modprobe.d/dyndbg.conf

handy for seeing boot-time dyndbg processing,
you;ll want to turn it off before catting control..
 dynamic_debug.verbose=1

root@voyage:~# more /etc/modprobe.d/dyndbg.conf
options scx200_acb dyndbg=+mfp
options pc87360 dyndbg=+p

root@voyage:~# grep =p /dbg/dynamic_debug/control  |wc
     42     302    3950


dynamic_debug:ddebug_change: changed drivers/hwmon/pc87360.c:1506
[pc87360]pc87360_update_device =p
dynamic_debug:ddebug_exec_query: applied: func="" file=""
module="pc87360" format="" lineno=0-0
dynamic_debug:ddebug_exec_queries: processed 1 queries, with 20 matches, 0 errs
dynamic_debug:ddebug_module_parse_args: Finished pc87360 parsing

root@voyage:~# grep =p /dbg/dynamic_debug/control  |grep pc87 |wc
     20     137    1867

> Also look for DDEBUG in Makefiles.
>
>> Are we sure that we are setting the 'p' flag for the
>> same set of debug statements that would be set if CONFIG_DYNAMIC_DEBUG
>> were not set?
>
> ?

FWIW, I have a few that Im not setting explicitly,
which are probably set by *_DEBUG, as Joe suggested

root@voyage:~# zgrep -i rtc /proc/config.gz | grep DEBUG
CONFIG_RTC_DEBUG=y

root@voyage:~# grep =p /dbg/dynamic_debug/control  |grep rtc |wc
     12      84     989


>
>> Also, it seems a bit strange to me, if I now enable all debug statements
>> and then clear everything (common pattern, I think), that I'm now
>> disabling stuff that was enabled by default.
>
> I don't think that's a common pattern and I
> also don't think that's bad.
>

moreover, we'd need another bit (at least) to distinguish default
flags from current flags.

the query-cmd language lets you constrain, but without any,
all sites *should* be affected

root@voyage:~# echo +p > /dbg/dynamic_debug/control
dynamic_debug:ddebug_exec_queries: processed 1 queries, with 613 matches, 0 errs
uart_wait_until_sent(0), jiffies=703813, expire=703855...
root@voyage:~# grep =p /dbg/dynamic_debug/control |wc
uart_wait_until_sent(0), jiffies=724988, expire=725030...
    613    4683   56064
uart_wait_until_sent(0), jiffies=725263, expire=725305...
root@voyage:~# echo -p > /dbg/dynamic_debug/control
uart_wait_until_sent(0), jiffies=742213, expire=742255...
dynamic_debug:ddebug_exec_queries: processed 1 queries, with 613 matches, 0 errs
root@voyage:~# grep =p /dbg/dynamic_debug/control |wc
      0       0       0
