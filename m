Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1LVDvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 22:51:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33256 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab1LVDvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 22:51:04 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=8xUFYJNJWbUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=wer3SAH9o4edcoTTCO4A:9 a=2RA5eKLPcfj46D1qi64A:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324525862.5916.121.camel@gandalf.stny.rr.com>
Subject: Re: Problem: plist_add undefined!
From: Steven Rostedt <rostedt@goodmis.org>
To: Monica Puig-Pey <puigpeym@unican.es>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 21 Dec 2011 22:51:02 -0500
In-Reply-To: <4EF05465.7050507@unican.es>
References: <4EF05465.7050507@unican.es>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-20 at 10:24 +0100, Monica Puig-Pey wrote:
> Hi there,
> 
> As I told in previous posts in this list I'm developing drivers for the
> 
> linux-rt kernel version in Ubuntu 10.04, based on 2.6.31 with rt_preempt 
> patch.
> 
> Currently I'm studying how to use priority lists (linux/plist.h) in a 
> module. I read some pages from the Linux Kernel Development book to 
> learn how linked list work in the kernel.
> 
> I made and easy example, shown below, trying to put three elements, with 
> their priorities, in a plist_head.
> 
> Then, I had two problems:
> 
> * First error:
> 
>    An error is produced when using the MACROs:
>      - PLIST_HEAD_INIT(head, _lock)
>      - PLIST_NODE_INIT(node, __prio)

Right, the macros are for static declarations. Either global variables
or a variable marked as static:

struct plist_head myhead = PLIST_HEAD_INIT(myhead, mylock);

or

int foo() {
	static struct plist_head bar = PLIST_HEAD_INIT(bar, mylock);

	[...]
}

or

struct foo bar = {
	.zoop = PLIST_HEAD_INIT(bar.zoop, mylock),
};


> 
>    it says :
> 
> 
> /home/monica/Escritorio/plists/priolist.c: In function 'init_module': 
> /home/monica/Escritorio/plists/priolist.c:67: error: expected expression 
> before '.' token
> 
> 
>    --> To solve this I used the functions:
> 
> 
> - static inline void plist_head_init(struct plist_head *head, struct 
> spinlock *lock)
> 
> - static inline void plist_node_init(struct plist_node *node, int prio)

Right, for runtime code you must use these.


> 
>    But I still have the problem with the MACRO
> 
> 
> 
> 
> * Second error, problem using plist_add:
> 
>    It says:
> 
> 
> “WARNING: "plist_add" [/home/monica/Escritorio/plists/priolist.ko] 
> undefined! ”

Simple, plist_add() isn't exported to modules.

Hmm, none of the plist functions are. I guess it wouldn't hurt to make
them EXPORT_SYMBOL_GPL()

Maybe we'll do that. Is this just for learning or are you planing on
adding a real GPL module to Linux that uses plists. For learning, it may
not be worth adding these symbols, but if you have a legit reason for
modules to use plists, than I don't see any harm in exporting them.

-- Steve

> 
>    I made the module GPL, I don't know what am I doing wrong.
> 
> Does anybody have an idea what is happening?
> 
> Thanks in advance for any help,
> 
> Cheers,
> 


