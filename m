Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab2AELqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 06:46:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab2AELqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 06:46:54 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=QcgJSxWpgi8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=yGs7r1cpJES-BhCyZUwA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325764011.12696.38.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 05 Jan 2012 06:46:51 -0500
In-Reply-To: <20120105091916.GA22598@elte.hu>
References: <20111221123624.193898256@goodmis.org>
	 <20120101180949.GA25066@elte.hu> <20120102105856.GA6661@elte.hu>
	 <20120102134856.GA32673@elte.hu>
	 <1325635373.12696.4.camel@gandalf.stny.rr.com>
	 <1325635922.12696.8.camel@gandalf.stny.rr.com>
	 <1325653301.12696.20.camel@gandalf.stny.rr.com>
	 <20120104141107.GA24770@elte.hu>
	 <1325696759.12696.24.camel@gandalf.stny.rr.com>
	 <20120105091916.GA22598@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-05 at 10:19 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:

> > I actually haven't looked at the NMI branch yet. I'm still 
> > trying to figure out why the ftrace one would lockup. I'll try 
> > another box to see if that one also locks up on tip/master 
> > with your config.
> 
> Any update on this?

No, for some reason my other box doesn't want to boot your config (no
root found). But I noticed that my first box fails on tip/master with
just my min-config. I ran the bisect and hit this as the bad commit:


commit 41e95d95208c62d4b0fbcee5f16d93e23ca32984
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Sep 17 23:12:20 2009 +0200

    <not-for-merge> Disable DEVTMPFS_MOUNT for now
    
    Causing bootup problems - /dev/zero and /dev/null not being there, etc.
    
    NOT-Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index ee37727..c52aaad 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -28,6 +28,7 @@ config DEVTMPFS
 config DEVTMPFS_MOUNT
        bool "Automount devtmpfs at /dev"
        depends on DEVTMPFS
+       depends on 0
        help
          This will mount devtmpfs at /dev if the kernel mounts the root
          filesystem. It will not affect initramfs based mounting.


When I reverted this, my machine booted. I'm now trying that machine
again with your allyesconfig.

Is there other strange things in tip/master that I should be aware
about?

Again, do you see these errors when just booting my branch directly?
(not merging the branch into another branch).


> 
> I'm also seeing build failures with certain configs:
> 
> kernel/trace/trace_stack.c:387:3: error: implicit declaration of function ‘ftrace_set_early_filter’ 
> [-Werror=implicit-function-declaration]

Hmm, your right. It depends on dyn_ftrace to be configured. Strange that
my tests didn't catch that as I thought one of my tests compiles with
static ftrace. I'll have to look into why my test didn't catch that.
I'll send a fix later today.

Thanks,

-- Steve


