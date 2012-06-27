Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab2F0R6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:58:11 -0400
Received: from smtp.witbe.net ([81.88.96.48]:60313 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab2F0R6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:58:10 -0400
Date: Wed, 27 Jun 2012 19:58:08 +0200
From: Paul Rolland <rol@as2917.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Paul Rolland <rol@as2917.net>
Subject: 3.5.0-rc3 - Issue with CFQ and cgroup
Message-ID: <20120627195808.31714295@tux.DEF.witbe.net>
Organization: AS2917.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.7; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When I first booted my 3.5.0-rc3 config, I've some :
Default I/O scheduler not found. Using noop.
which surprised me. so, after the boot completed, I had a look at the
system messages, and found :

...
io scheduler noop registered
io scheduler deadline registered
------------[ cut here ]------------
WARNING: at block/blk-cgroup.c:867 blkcg_policy_register+0xb5/0xc0()
Hardware name: Vostro 1520
Modules linked in:
Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc3 #1
Call Trace:
 [<ffffffff8103a59a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81cafbed>] ? deadline_init+0x12/0x12
 [<ffffffff8103a5e5>] warn_slowpath_null+0x15/0x20
 [<ffffffff8131a6f5>] blkcg_policy_register+0xb5/0xc0
 [<ffffffff81cafc2f>] cfq_init+0x42/0x9f
 [<ffffffff810001ba>] do_one_initcall+0x3a/0x160
 [<ffffffff81c8ed08>] kernel_init+0x137/0x1bb
 [<ffffffff81c8e5c5>] ? do_early_param+0x87/0x87
 [<ffffffff8169e3d4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81c8ebd1>] ? start_kernel+0x3b2/0x3b2
 [<ffffffff8169e3d0>] ? gs_change+0xb/0xb
---[ end trace 82bc55f036371117 ]---

So, at the time cfq should have registered, something went wrong.
It looks that this comes from my config defining CFQ, CGROUP but no
CFQ_CGROUP_IOSCHED.
...
CONFIG_CGROUPS=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_CFQ_GROUP_IOSCHED is not set
...

as the code is :
static struct blkcg_policy blkcg_policy_cfq __maybe_unused;
...
#ifdef CONFIG_CFQ_GROUP_IOSCHED
static struct blkcg_policy blkcg_policy_cfq = {
        .pd_size                = sizeof(struct cfq_group),
        .cftypes                = cfq_blkcg_files,
        
        .pd_init_fn             = cfq_pd_init,
        .pd_reset_stats_fn      = cfq_pd_reset_stats,
};
#endif
...
static int __init cfq_init(void)
{
...
        ret = blkcg_policy_register(&blkcg_policy_cfq);


Not sure what's the best fix is... Could someone shed some light on this ?

Paul

PS: Just checked 3.5-rc4, source code there is the same.
