Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030781Ab2CFOgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:36:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:58120 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030748Ab2CFOgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:36:21 -0500
Date: Tue, 6 Mar 2012 15:36:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.2.9-rt16
In-Reply-To: <1331041818.25686.375.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1203061524310.2742@ionos>
References: <alpine.LFD.2.02.1203061118050.2742@ionos> <1331041818.25686.375.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012, Steven Rostedt wrote:

> Note, yesterday while running some stress tests I hit a live lock here:
> ... 
> When it fails to grab either the inode->i_lock or the parent->d_lock it
> returns back to dput() and dput() will retry. We get into another one of
> these cases where we can spin blocking the holder of the locks.

Nasty.
 
> I experimented with adding a grab lock of the inode->i_lock or
> parent->d_lock if they existed (required initializing parent to NULL),
> which seemed to help a lot, but then eventually it locked up. As I'm not
> sure its safe to grab them straight here even after we release the
> dentry->d_lock. I'll have to enable full lockdep to see if this breaks
> the ordering.
> 
> I haven't looked too deeply into this code yet, but I'm assuming that
> dput() can be called where we can't just take the inode or parent lock?

If you read the top of fs/dcache.c then you find an explanation of the
lock ordering. This code takes the locks in reverse order. That's why
it uses trylock.

Thanks,

	tglx
    
