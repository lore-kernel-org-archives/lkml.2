Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637Ab1ESUS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:18:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35087 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933926Ab1ESUS0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:18:26 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+mw+c/ei2mC81yUf2p9zMsfzuswzrTRkpQ/HPzXX
	GNpM0oMYst1GLd
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: "richard -rw- weinberger" <richard.weinberger@gmail.com>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
Date: Thu, 19 May 2011 22:18:16 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.6; KDE/4.6.3; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
References: <201105191526.31904.toralf.foerster@gmx.de> <BANLkTi=FinuAYpYXf1K6pQ-3i2vRJS=g9g@mail.gmail.com>
In-Reply-To: <BANLkTi=FinuAYpYXf1K6pQ-3i2vRJS=g9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105192218.18261.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


richard -rw- weinberger wrote at 19:00:35
> Can you bisect the issue?

tfoerste@n22 ~/devel/linux-2.6 $ git bisect bad
2e12978a9f7a7abd54e8eb9ce70a7718767b8b2c is the first bad commit
commit 2e12978a9f7a7abd54e8eb9ce70a7718767b8b2c
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Wed Dec 22 14:18:50 2010 +0800

    futex,plist: Pass the real head of the priority list to plist_del()
    
    Some plist_del()s in kernel/futex.c are passed a faked head of the
    priority list.
    
    It does not fail because the current code does not require the real head
    in plist_del(). The current code of plist_del() just uses the head for 
checking,
    so it will not cause a bad result even when we use a faked head.
    
    But it is undocumented usage:
    
    /**
     * plist_del - Remove a @node from plist.
     *
     * @node:   &struct plist_node pointer - entry to be removed
     * @head:   &struct plist_head pointer - list head
     */
    
    The document says that the @head is the "list head" head of the priority 
list.
    
    In futex code, several places use "plist_del(&q->list, &q->list.plist);",
    they pass a fake head. We need to fix them all.
    
    Thanks to Darren Hart for many suggestions.
    
    Acked-by: Darren Hart <dvhart@linux.intel.com>
    Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
    LKML-Reference: <4D11984A.5030203@cn.fujitsu.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

:040000 040000 78d47de377f8da1c131007a17ca915fbd13f7ff6 
ffac93205aaf22fda0667d6395c8da7c7bf692e4 M      kernel

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
