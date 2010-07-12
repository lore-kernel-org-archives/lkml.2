Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0GLVNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:13:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57026 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0GLVNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:13:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] sound/oss: convert to unlocked_ioctl
Date: Mon, 12 Jul 2010 23:13:03 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.90; x86_64; ; )
Cc: Jaroslav Kysela <perex@perex.cz>, LKML <linux-kernel@vger.kernel.org>,
        John Kacur <jkacur@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        ALSA development <alsa-devel@alsa-project.org>
References: <1278798701-11171-1-git-send-email-arnd@arndb.de> <201007121953.19531.arnd@arndb.de> <s5hocec5tby.wl%tiwai@suse.de>
In-Reply-To: <s5hocec5tby.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007122313.03465.arnd@arndb.de>
X-Provags-ID: V02:K0:sJiwXtDbNlnebFLSRampGsDT3aVVavH7fit5fvrRdkS
 3St/xgNxhIqN/+7bbk1Q+FQs7x3kcbVAqTZPQUmzVCufljxCPv
 08hPbeXUOBhjry7EyGqj46aXw+sGrujUW5eVEEPDFEzfLZ6l41
 Bpz7ZAhWX6U9PqubBY5JYkssxlLfgHK8pbXDVymb9KKcu2LyEG
 23NWrpnGJsRsXyShevnNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 July 2010 22:38:25 Takashi Iwai wrote:
> Now the rest is eliminating each lock_kernel() in sound/oss/*.c :)

For other files, I've used a script (see below) to do this, it probably
works with the OSS files as well, although I have not tried yet.

Of course, another option for OSS device drivers would be to
remove the entire driver ;). Either way, my feeling is that the
OSS drivers are not stopping anyone from building a kernel without
CONFIG_BKL once we have introduced that symbol and made the drivers
depend on it.

	Arnd

---
#!/bin/bash
file=$1
name=$2
if grep -q lock_kernel ${file} ; then
    if grep -q 'include.*linux.mutex.h' ${file} ; then
            sed -i '/include.*<linux\/smp_lock.h>/d' ${file}
    else
            sed -i 's/include.*<linux\/smp_lock.h>.*$/include <linux\/mutex.h>/g' ${file}
    fi
    sed -i ${file} \
        -e "/^#include.*linux.mutex.h/,$ {
                1,/^\(static\|int\|long\)/ {
                     /^\(static\|int\|long\)/istatic DEFINE_MUTEX(${name}_mutex);

} }"  \
    -e "s/\(un\)*lock_kernel\>[ ]*()/mutex_\1lock(\&${name}_mutex)/g" \
    -e '/[      ]*cycle_kernel_lock();/d'
else
    sed -i -e '/include.*\<smp_lock.h\>/d' ${file}  \
                -e '/cycle_kernel_lock()/d'
fi
