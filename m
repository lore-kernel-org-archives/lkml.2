Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2DPPye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:54:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab2DPPyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:54:32 -0400
Date: Mon, 16 Apr 2012 11:54:24 -0400
From: Jason Baron <jbaron@redhat.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: ehci dynamic debug problem
Message-ID: <20120416155423.GB2345@redhat.com>
References: <20120413174107.GA6021@sig21.net>
 <Pine.LNX.4.44L0.1204131411010.1166-100000@iolanthe.rowland.org>
 <20120413190311.GA6238@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413190311.GA6238@sig21.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 09:03:11PM +0200, Johannes Stezenbach wrote:
> On Fri, Apr 13, 2012 at 02:13:58PM -0400, Alan Stern wrote:
> > On Fri, 13 Apr 2012, Johannes Stezenbach wrote:
> > 
> > > > But there is no such thing as dynamic debug for ehci, is there?  
> > > > There's a separate dynamic debug setting for each dev_dbg statement.
> > > > So your ideal solution makes no sense.
> > > 
> > > When CONFIG_DYNAMIC_DEBUG=y but ehci debug is disabled
> > 
> > There is no such thing as ehci debug!  So how can it be disabled?
> > There's only an individual setting for each line of debugging code.
> > 
> > > in /sys/kernel/debug/dynamic_debug/control, then
> > > dbg_port() calls dbg_port_buf() which would
> > > format the string, then calls ehci_dbg() which
> > > calls dev_dbg() which discards it.
> > > 
> > > Does it make sense now?
> > 
> > No.  What happens if dynamic debug is enabled for one line that calls 
> > dbg_port_buf() but not for another?  There's no way to avoid the string 
> > formatting in both lines, even though one of them discards the result.
> 
> That's why I said in my initial mail:
> 
>   Does dynamic debug offer an "is the message two lines below enabled" test?
> 

Sorry was away for a bit...

dynamic debug doesn't offer any is enabled test, its hidden from the
user. That said, in this case, you can delay the printing to the buffer
with:


diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
index d6d74d2..fd90ccd 100644
--- a/drivers/usb/host/ehci-dbg.c
+++ b/drivers/usb/host/ehci-dbg.c
@@ -254,7 +255,7 @@ dbg_command_buf (char *buf, unsigned len, const char *label, u32 command)
 		);
 }
 
-static int
+static char *
 dbg_port_buf (char *buf, unsigned len, const char *label, int port, u32 status)
 {
 	char	*sig;
@@ -267,7 +268,7 @@ dbg_port_buf (char *buf, unsigned len, const char *label, int port, u32 status)
 	default: sig = "?"; break;
 	}
 
-	return scnprintf (buf, len,
+	scnprintf (buf, len,
 		"%s%sport:%d status %06x %d %s%s%s%s%s%s "
 		"sig=%s%s%s%s%s%s%s%s%s%s%s",
 		label, label [0] ? " " : "", port, status,
@@ -293,6 +294,8 @@ dbg_port_buf (char *buf, unsigned len, const char *label, int port, u32 status)
 		(status & PORT_PE) ? " PE" : "",
 		(status & PORT_CSC) ? " CSC" : "",
 		(status & PORT_CONNECT) ? " CONNECT" : "");
+
+	return buf;
 }
 
 #else
@@ -333,8 +336,7 @@ dbg_port_buf (char *buf, unsigned len, const char *label, int port, u32 status)
 
 #define dbg_port(ehci, label, port, status) { \
 	char _buf [80]; \
-	dbg_port_buf (_buf, sizeof _buf, label, port, status); \
-	ehci_dbg (ehci, "%s\n", _buf); \
+	ehci_dbg (ehci, "%s\n", dbg_port_buf (_buf, sizeof _buf, label, port, status)); \
 }
 
 /*-------------------------------------------------------------------------*/


That seems to do what you want, at least with my compiler - gcc (GCC)
4.6.2 20111027 (Red Hat 4.6.2-1).

Thanks,

-Jason
