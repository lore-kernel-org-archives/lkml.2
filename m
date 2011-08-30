Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1H3V2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 17:28:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab1H3V2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 17:28:06 -0400
Date: Tue, 30 Aug 2011 14:26:00 -0700
From: Greg KH <gregkh@suse.de>
To: Rajan Aggarwal <rajan.aggarwal85@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Free fw_priv in fw_create_instance
Message-ID: <20110830212600.GA10417@suse.de>
References: <1314731192-1960-1-git-send-email-rajan.aggarwal85@gmail.com>
 <20110830191937.GA8689@suse.de>
 <CALN+fr1Nke3kgEpJbb8fbzAd=dB_KhKP71rZRpm7TjOmkE5Jwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALN+fr1Nke3kgEpJbb8fbzAd=dB_KhKP71rZRpm7TjOmkE5Jwg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 01:16:24AM +0530, Rajan Aggarwal wrote:
> Hi,
> 
> 
> On Wed, Aug 31, 2011 at 12:49 AM, Greg KH <gregkh@suse.de> wrote:
> > On Wed, Aug 31, 2011 at 12:36:32AM +0530, Rajan Aggarwal wrote:
> >> fw_priv is not being freed in some of the error scenarios in
> >> fw_create_instance.
> >
> > Not true.
> >
> >> This patch makes sure that this is kfreed properly in all error
> >> situations in the fw_create_instance logic where it is required.
> >
> > Nope, this will cause a double-free to happen.
> 
> >From what you say, the only suspicious line seems to be the following
> assignment:
> f_dev = &fw_priv->dev;
> However, I cannot make out how this can be freed by device_del or
> put_device as I don't see the logic anywhere where f_dev is
> decremented to get the address of fw_priv.

Look at the release function for the f_dev that was set up when the
class pointer was assigned to it.  That function takes a pointer to a
"base" struct device, and back casts it to the fw_priv structure, and
then frees it.

That is how the driver core, and the kobject, and the kref model works.
When the last reference to the object is released, the release
function is called, freeing up the memory of the object.

Take a look at the Documentation/kobject.txt file for details as to how
this all works if you are still curious.

Hope this helps,

greg k-h
