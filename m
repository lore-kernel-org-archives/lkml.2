Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab1AaW7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:59:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756822Ab1AaW7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:59:42 -0500
Date: Mon, 31 Jan 2011 17:59:39 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: kosaki.motohiro@jp.fujitsu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Subject: Query about kdump_msg hook into crash_kexec()
Message-ID: <20110131225939.GH11974@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed following commit which hooks into crash_kexec() for calling
kmsg_dump().

I think it is not a very good idea to pass control to modules after
crash_kexec() has been called. Because modules can try to take locks
or try to do some other operations which we really should not be doing
now and fail kdump also. The whole design of kdump is built on the
fact that in crashing kernel we do minimal thing and try to make 
transition to second kernel robust. Now with this hook, kmsg dumper
breaks that assumption.

Anyway, if an image is loaded and we have setup to capture dump also
why do we need to save kmsg with the help of an helper. I am assuming
this is more of a debugging aid if we have no other way to capture the
kernel log buffer. So if somebody has setup kdump to capture the
vmcore, why to call another handler which tries to save part of the
vmcore (kmsg) separately.

Thanks
Vivek

commit 0f4bd46ec252887f44f1f065b41867cac8f70dfb
Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date:   Tue Dec 22 03:15:43 2009 +0000

    kmsg_dump: Dump on crash_kexec as well
    
    crash_kexec gets called before kmsg_dump(KMSG_DUMP_OOPS) if
    panic_on_oops is set, so the kernel log buffer is not stored
    for this case.
    
    This patch adds a KMSG_DUMP_KEXEC dump type which gets called
    when crash_kexec() is invoked. To avoid getting double dumps,
    the old KMSG_DUMP_PANIC is moved below crash_kexec(). The
    mtdoops driver is modified to handle KMSG_DUMP_KEXEC in the
    same way as a panic.
    
    Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    Acked-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

Thanks
Vivek
