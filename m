Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab1FLDKZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 23:10:25 -0400
Received: from host1743200242118.direcway.com ([174.32.118.242]:47282 "EHLO
	aexorsyst.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1FLDKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 23:10:24 -0400
From: "John Z. Bohach" <jzb2@aexorsyst.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel bug in root=nfsroot codepath
Date: Sat, 11 Jun 2011 20:06:16 -0700
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106112006.16407.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a problem with S5 and nfsroot.

The kernel will NOT enter S5 if and only if root=nfsroot.

With the same rootfs burned to disk, it works fine.  I've tracked this 
done to the

 __raw_notifier_call_chain()

function.  The call trace is sequence is:

kernel_power_off()
  ...
  disable_nonboot_cpus()
    _cpu_down()
      ...
      cpu_die()
      cpu_notify_nofail()
        cpu_notify()
          ...
          __cpu_notify()
            __raw_notifier_call_chain()
              notifier_call_chain()
            ?? strange second call from unknown location to:
              __raw_notifier_call_chain()
            then it just stops...

Machine does not hang as I can see NFS timeout messages after a few 
minutes (probably interrupt context), but no further printk's are 
manifest, and system stays in this state until physically reset and is 
unresponsive.

This is the third time I'm posting this...any ideas?  If I simply skip 
the disable_nonboot_cpus()  call, then it powers down fine.  This only 
happens with root=nfsroot.  This happens with multiple kernels and goes 
back to at least 2.6.16 and is there even with today's latest kernel.

To try to duplicate this, boot an nfsroot-ed machine into run-level 1, 
and run 'halt -n -d -f -p'.

Thanks,
John
