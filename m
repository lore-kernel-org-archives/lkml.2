Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab2DMOgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:36:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34040 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751535Ab2DMOgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:36:00 -0400
Date: Fri, 13 Apr 2012 10:35:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Johannes Stezenbach <js@sig21.net>
cc: Jason Baron <jbaron@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: ehci dynamic debug problem
In-Reply-To: <20120413085607.GA18024@sig21.net>
Message-ID: <Pine.LNX.4.44L0.1204131019380.1185-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012, Johannes Stezenbach wrote:

> Hi,
> 
> I have a quirky device and enabled dynamic debug to
> see the ehci driver debug messages to help me diagnose
> the problem.  I see stuff like this:
> 
> [1790542.363321] ehci_hub_control:940: ehci_hcd 0000:00:1a.0: \xffffffd8\xffffff94\xffffff94\xffffffa8\xffffff81\xffffffff\xffffffff\xffffffff\xffffffff}[<\xffffff81\xffffffff\xffffffff\xffffffff\xffffffff\x01
> [1790542.363470] ehci_hub_control:940: ehci_hcd 0000:00:1a.0: \xffffffd8\xffffff94\xffffff94\xffffffa8\xffffff81\xffffffff\xffffffff\xffffffff\xffffffff}[<\xffffff81\xffffffff\xffffffff\xffffffff\xffffffff\x01
> 
> The problem is in ehci-dbg.c:
> 
> #define dbg_port(ehci, label, port, status) { \
> 	char _buf [80]; \
> 	dbg_port_buf (_buf, sizeof _buf, label, port, status); \
> 	ehci_dbg (ehci, "%s\n", _buf); \
> }
> 
> dbg_port_buf() is a no op when DEBUG is not defined, thus
> the ehci_dbg() prints uninitialized memory.

Interesting.  I have never run across this, because I never use dynamic 
debug.

> Does dynamic debug offer an "is the message two lines below enabled" test?
> Simply changing the "#ifdef DEBUG" for dbg_port_buf()
> to "#if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)"
> is probably not acceptable due to the overhead of dbg_port_buf()?

I don't understand your question.  Doesn't dbg_port_buf need to be 
defined whenever dynamic debugging is enabled?

Alternatively, the definition of dbg_port_buf (and related routines) in 
the !defined(DEBUG) case could be changed; you could add

	buf[0] = 0;

That way you wouldn't get garbage out, although you wouldn't get 
anything useful either.

Alan Stern

