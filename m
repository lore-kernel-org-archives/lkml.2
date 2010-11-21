Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab0KUK4D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 05:56:03 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:56311 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab0KUK4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 05:56:01 -0500
Date: Sun, 21 Nov 2010 05:55:55 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: should list poisoning only kick in after selecting
 CONFIG_DEBUG_LIST?
Message-ID: <alpine.DEB.2.00.1011210549540.17255@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  a bit confused about list poisoning.  there's this from
<linux/list.h>:

#ifndef CONFIG_DEBUG_LIST
static inline void list_del(struct list_head *entry)
{
        __list_del(entry->prev, entry->next);
        entry->next = LIST_POISON1;
        entry->prev = LIST_POISON2;
}
#else
extern void list_del(struct list_head *entry);
#endif

which seems a bit weird since, even if you *don't* select
CONFIG_DEBUG_LIST, the deleted node's pointers are poisoned.  why?
that's certainly being done in the debug version of list_del() in
lib/list_debug.c, but why is it also being done above?  for what
purpose?

  and if i don't select that debugging option, should *anything* be
checking for those poison values?

$ grep -r -A2 LIST_POISON drivers
drivers/usb/host/xhci-hub.c:		if (cmd->cmd_list.next != LIST_POISON1)
drivers/usb/host/xhci-hub.c-			list_del(&cmd->cmd_list);
drivers/usb/host/xhci-hub.c-		spin_unlock_irqrestore(&xhci->lock, flags);
--
drivers/usb/host/xhci.c:		if (reset_device_cmd->cmd_list.next != LIST_POISON1)
drivers/usb/host/xhci.c-			list_del(&reset_device_cmd->cmd_list);
drivers/usb/host/xhci.c-		spin_unlock_irqrestore(&xhci->lock, flags);
$

  that looks just plain odd.  why would normal driver code that is not
dependent on CONFIG_DEBUG_LIST be checking for poison values?  and if
it finds them, why is that not treated as that something has gone
significantly wrong, rather than quietly glossing over it?

rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
