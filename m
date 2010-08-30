Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab0H3OVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 10:21:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:38809 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab0H3OVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:21:52 -0400
Message-ID: <4C7BBE4E.8080901@kernel.org>
Date: Mon, 30 Aug 2010 16:21:02 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: CAI Qian <caiqian@redhat.com>
CC: kexec <kexec@lists.infradead.org>, linux-next@vger.kernel.org,
        torvalds@linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdump regression compared to v2.6.35
References: <1141332926.1524871283176937097.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1141332926.1524871283176937097.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 14:21:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/30/2010 04:02 PM, CAI Qian wrote:
>> Hmm, odd.  So, here's the said debug patch.  It will periodically
>> check all works and report if any work is being delayed for too long.
>> If the max wait goes over 30secs, it will dump all task states and
>> disable itself.  Can you please apply the patch on top of rc2 +
>> wq#for-linus and report the output?  It should tell us who's stuck
>> where.
>
> Nothing new was printed after around 10 minutes.

Eh... that's interesting.  That means no work is stalled on
workqueues, so it at least is not a workqueue stall.  Can you please
try the following then?  Or if sysrq wasn't working because your
keyboard wasn't initialized at that point, you can setup serial
console and trigger sysrq that way.

Thanks.

diff --git a/init/main.c b/init/main.c
index 94ab488..e156b8f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -423,11 +423,19 @@ static void __init setup_command_line(char *command_line)

 static __initdata DECLARE_COMPLETION(kthreadd_done);

+static void show_state_timer_fn(unsigned long data)
+{
+	show_state();
+}
+static DEFINE_TIMER(show_state_timer, show_state_timer_fn, 0, 0);
+
 static noinline void __init_refok rest_init(void)
 	__releases(kernel_lock)
 {
 	int pid;

+	printk("XXX show_state_timer registered\n");
+	mod_timer(&show_state_timer, jiffies + 180 * HZ);
 	rcu_scheduler_starting();
 	/*
 	 * We need to spawn init first so that it obtains pid 1, however
