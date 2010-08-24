Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933678Ab0HXXLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:11:23 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:15264
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933627Ab0HXXLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:11:17 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2010 19:11:17 EDT
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2cK146fK4015Lzz1202hzz8275dhz2fh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
Message-ID: <4C744DC5.3040106@am.sony.com>
Date: Tue, 24 Aug 2010 15:55:01 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux kernel <linux-kernel@vger.kernel.org>
Subject: Possible kmemleak issue, but I'm confused
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

I wasn't sure what list to post this to.  Is there a list where
kmemleak is predominately discussed, outside of LKML?

I have a "fix" for kmemleak that we are using in Sony's
Linux kernel (circa 2.6.29), that I wanted to discuss with
you and possibly push upstream.  However, I'm confused about
the status of kmemleak in current mainline.

In our patch set against 2.6.29, there are some kmemleak
instrumentation hooks in kernel/module.c, in the routines
percpu_modalloc and  percpu_modfree.  I thought that all
of kmemleak got mainlined in 2.6.34, but I don't see these
hooks in Linus' latest tree.

I found the commit that we are modifying, in your tree at:
http://git.kernel.org/?p=linux/kernel/git/cmarinas/linux-2.6-cm.git;a=commitdiff;h=4f2294b6dc88d99295230d97fef2c9863cec44c3

What is the status of this patch relative to linux-next or Linus'
tree?

Here's the issue we found (I'm parroting this from some
developers in Japan who are actually found the issue, so please
forgive me if I mangle the explanation):

The kmemleak_alloc and kmemleak_free in percpu_modalloc
and percpu_modfree routines are capturing allocations/frees
of percpu data areas when a module is loaded or unloaded,
respectively.  However, on some platforms, the percpu
memory area is instantiated by the bootmem allocator,
and the memory in question is already tracked by kmemleak.

When a module is loaded and unloaded multiple times, it
causes problems for kmemleak.  The bug report I'm looking at
says "kmemleak stops", but I don't know what that means. I
can ask for clarification if needed.

Have you heard of this issue?

Our solution was just to make these specific calls to kmemleak_alloc
and kmemleak_free (in module.c) compile-time configurable.
I suspect that there is a better way to do this -- possibly by
detecting or noting that this situation exists for certain
platforms, and avoiding it without specific user interaction.

Anyway, any help you can provide would be appreciated.

I thought I'd contact you and clarify the situation before
trying to push our existing patch, or reimplement it based on
my current understanding.

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Network Entertainment
=============================

