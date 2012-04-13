Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab2DMI4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:56:22 -0400
Received: from bar.sig21.net ([80.81.252.164]:50945 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757500Ab2DMI4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:56:17 -0400
Date: Fri, 13 Apr 2012 10:56:07 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org
Subject: ehci dynamic debug problem
Message-ID: <20120413085607.GA18024@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a quirky device and enabled dynamic debug to
see the ehci driver debug messages to help me diagnose
the problem.  I see stuff like this:

[1790542.363321] ehci_hub_control:940: ehci_hcd 0000:00:1a.0: \xffffffd8\xffffff94\xffffff94\xffffffa8\xffffff81\xffffffff\xffffffff\xffffffff\xffffffff}[<\xffffff81\xffffffff\xffffffff\xffffffff\xffffffff\x01
[1790542.363470] ehci_hub_control:940: ehci_hcd 0000:00:1a.0: \xffffffd8\xffffff94\xffffff94\xffffffa8\xffffff81\xffffffff\xffffffff\xffffffff\xffffffff}[<\xffffff81\xffffffff\xffffffff\xffffffff\xffffffff\x01

The problem is in ehci-dbg.c:

#define dbg_port(ehci, label, port, status) { \
	char _buf [80]; \
	dbg_port_buf (_buf, sizeof _buf, label, port, status); \
	ehci_dbg (ehci, "%s\n", _buf); \
}

dbg_port_buf() is a no op when DEBUG is not defined, thus
the ehci_dbg() prints uninitialized memory.


Does dynamic debug offer an "is the message two lines below enabled" test?
Simply changing the "#ifdef DEBUG" for dbg_port_buf()
to "#if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)"
is probably not acceptable due to the overhead of dbg_port_buf()?


Thanks,
Johannes
