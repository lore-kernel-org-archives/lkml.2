Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab0HIGhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:37:51 -0400
Received: from smtp-out-166.synserver.de ([212.40.180.166]:1068 "HELO
	smtp-out-165.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751270Ab0HIGhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:37:50 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 4983
Date: Mon, 9 Aug 2010 08:37:42 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: walt <w41ter@gmail.com>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: [BISECTED] Today's Linus.git hangs during boot: can't find the
 floppy controller
Message-ID: <20100809063742.GA1632@arch.tripp.de>
References: <i3n3dh$t48$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <i3n3dh$t48$1@dough.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 08, 2010 at 01:17:53PM -0700, walt wrote:
> This commit produces the error:
> 
> commit 6ee0578b4daaea01c96b172c6aacca43fd9807a6
> Author: Suresh Siddha <suresh.b.siddha@intel.com>
> Date:   Fri Jul 30 14:57:37 2010 -0700
> 
>     workqueue: mark init_workqueues() as early_initcall()
> 
>     Mark init_workqueues() as early_initcall() and thus it will be initialized
>     before smp bringup. init_workqueues() registers for the hotcpu notifier
>     and thus it should cope with the processors that are brought online after
>     the workqueues are initialized.
> 
>     x86 smp bringup code uses workqueues and uses a workaround for the
>     cold boot process (as the workqueues are initialized post smp_init()).
>     Marking init_workqueues() as early_initcall() will pave the way for
>     cleaning up this code.
> 
>     Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>     Signed-off-by: Tejun Heo <tj@kernel.org>
>     Cc: Oleg Nesterov <oleg@redhat.com>
>     Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> 
> Just after the error message about the floppy controller not found, the
> machine hangs for two minutes and then this message:
> 
> task swapper:1 blocked for greater than 120 seconds, followed by a stack
> trace, and again every two minutes AFAICT.
> 
> I'm not including all the gory messages and stack traces because I'm
> hoping you'll know what the problem is without them. (Fingers crossed.)
> 
> BTW, I see this problem only on my dual-core machine, not the older single
> single processor machine, as I would expect from reading the commit message.
> (Both machine have properly functioning floppy drives.)

(Added Tejun to CC)

I see a similar problem here. The kernel will boot, but the system will
not initialize (no X11). 
After reverting the commit, the system starts normally and the only
workqueue problem left is drm related:

% dmesg | grep ERROR
[drm:drm_kms_helper_poll_enable] *ERROR* delayed enqueue failed 1
[drm:output_poll_execute] *ERROR* delayed enqueue failed 1
[drm:output_poll_execute] *ERROR* delayed enqueue failed 1
[drm:output_poll_execute] *ERROR* delayed enqueue failed 1
[drm:output_poll_execute] *ERROR* delayed enqueue failed 1
[drm:output_poll_execute] *ERROR* delayed enqueue failed 1
[drm:output_poll_execute] *ERROR* delayed enqueue failed 1
[drm:output_poll_execute] *ERROR* delayed enqueue failed 1
...


-- 
»A man who doesn't know he is in prison can never escape.«
William S. Burroughs
