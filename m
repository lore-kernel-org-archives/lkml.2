Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab2GJOqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 10:46:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57223 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab2GJOp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 10:45:58 -0400
Date: Tue, 10 Jul 2012 07:45:54 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] usb: host: Fix possible kernel crash
Message-ID: <20120710144554.GC15912@kroah.com>
References: <Pine.LNX.4.44L0.1207091028200.1954-100000@iolanthe.rowland.org>
 <4FFBAEFF.5060407@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFBAEFF.5060407@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 09:56:39AM +0530, Venu Byravarasu wrote:
> Thanks Alan for your comments.
> 
> On Monday 09 July 2012 08:04 PM, Alan Stern wrote:
> >On Mon, 9 Jul 2012, Venu Byravarasu wrote:
> >
> >>In functions itd_complete &  sitd_complete, a pointer
> >>by name stream may get dereferenced after freeing it, when
> >>iso_stream_put is called with stream->refcount = 2.
> >I don't understand the problem.  Did you actually see this happen or is
> >it only theoretical?
> 
> Yes it is a theoretical problem, as complained by Coverity.
> 
> >  	/* for each uframe with a packet */
> >  	for (uframe = 0; uframe < 8; uframe++) {
> >@@ -1783,7 +1784,8 @@ itd_complete (
> >  			dev->devpath, stream->bEndpointAddress & 0x0f,
> >  			(stream->bEndpointAddress & USB_DIR_IN) ? "in" : "out");
> >  	}
> >-	iso_stream_put (ehci, stream);
> >+	stream_ref_count = stream->refcount;
> >+	iso_stream_put(ehci, stream);
> >This iso_stream_put removes the reference held by the URB.  Before it
> >is called, stream->refcount must be >= 3:
> >
> >	refcount is set to 1 when the stream is created;
> >
> >	each active URB holds a reference;
> >
> >	each itd holds a reference.
> >
> >So after the call, the refcount value must be >= 2 and the stream could
> >not have been deallocated.
> >
> >>  done:
> >>  	itd->urb = NULL;
> >>@@ -1797,7 +1799,7 @@ done:
> >>  		 * Move it to a safe place until a new frame starts.
> >>  		 */
> >>  		list_move(&itd->itd_list, &ehci->cached_itd_list);
> >>-		if (stream->refcount == 2) {
> >>+		if (stream_ref_count == 3) {
> >Therefore this seems unnecessary.
> 
> As per the logic you explained above, this change is not needed.
> However coverity was complaining as below:
> 
> /kernel/drivers/usb/host/ehci-sched.c 1777 USE_AFTER_FREE
> Dereferencing freed pointer "stream"
> 
> Hence to pacify coverity, this change is done.

Why are you trying to "pacify" coverity, when the tool is wrong in this
case?  Go poke the owners of that tool to get it to stop emitting this
false warning.  Don't paper over it in the kernel.  Especially for a
tool that none of us can run on our own.

greg k-h
