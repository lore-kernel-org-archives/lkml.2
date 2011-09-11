Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1IKUod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 16:44:33 -0400
Received: from netrider.rowland.org ([192.131.102.5]:40756 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754128Ab1IKUoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 16:44:32 -0400
Date: Sun, 11 Sep 2011 16:44:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ming Lei <tom.leiming@gmail.com>
cc: rjw@sisk.pl, <linux-pm@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] PM/runtime: handle ->runtime_suspend failure correctly
In-Reply-To: <1315665442-4194-2-git-send-email-tom.leiming@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1109111636410.21533-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Sep 2011 tom.leiming@gmail.com wrote:

> From: Ming Lei <tom.leiming@gmail.com>
> 
> If ->runtime_suspend returns -EAGAIN or -EBUSY, the device should
> still be in ACTIVE state, so it is not needed to handle defered
> resume and idle notification to its parent; if ->runtime_suspend
> returns other fatal failure, it doesn't make sense to process defered
> resume and send idle notification to its parent.

> @@ -422,6 +425,9 @@ static int rpm_suspend(struct device *dev, int rpmflags)
>  	}
>  	wake_up_all(&dev->power.wait_queue);
>  
> +	if (retval)
> +		goto out;
> +
>  	if (dev->power.deferred_resume) {
>  		rpm_resume(dev, 0);
>  		retval = -EAGAIN;

If there's a suspend failure, the deferred_resume flag gets turned off 
anyway.  But skipping this test won't hurt, and skipping the parent 
notification is a good idea.

In fact, it might be even better to put a copy of the wake_up_all() in
the "if (retval)" branch after the suspend callback and then go
directly to out.  The "else" branch could then become part of the
straight-through code, not indented.

Alan Stern

