Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761727Ab2KAOeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:34:09 -0400
Received: from claranet-outbound-smtp03.uk.clara.net ([195.8.89.36]:36672 "EHLO
	claranet-outbound-smtp03.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761624Ab2KAOeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:34:07 -0400
X-Greylist: delayed 2718 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2012 10:34:07 EDT
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Jan Kara <jack@suse.cz>, John McCutchan <john@johnmccutchan.com>,
        Robert Love <rlove@rlove.org>, Eric Paris <eparis@parisplace.org>,
        Eric Paris <eparis@redhat.com>, Nepomuk Mailing List <nepomuk@kde.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Filesystem Development Mailinglist 
	<linux-fsdevel@vger.kernel.org>
Subject: Re: Better support for (desktop) file search / indexing applications
Date: Thu, 01 Nov 2012 13:48:22 +0000
Message-ID: <6898338.Kmf2pUBmi1@deuteros>
User-Agent: KMail/4.8.4 (Linux/3.4.6-2.fc17.x86_64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <201211011352.42476.Martin@lichtvoll.de>
References: <201211011352.42476.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2012 13:52:42 Martin Steigerwald wrote:
...
> The following two main issues led to the discussion about adding
> notification about user inotify watch limit or even having it raised
> automatically via some policy kit mechanism:
> 
> 1) Watches are not working recursively. Thus one has to add a watch to
> each sub directory.
> 
> 2) There are inotify file move events. But one has to watch source and
> destination directory to get notified of a file move between these. Thus
> one has to watch each directory again. File moves outside the watched
> home directory will go unnotified unless every other accessible directory
> is watched as well.
> 
> 
> What would be nice to have for file indexers would be:
> 
> 1) Recursive notifications. I.e. one watch for /home/martin can notify
> about everything what happens in sub directories of that directory.
> 
> 2) File move events that work from the source directory. I.e. if
> watching a directory like /home/martin recursively it would be nice to
> be notified about:
> 
> a) A file is moved from one sub directory inside /home/martin to another
> one inside it.
> 
> b) A file is moved outside /home/martin
> 
> While these enhancement would likely fix the issues desktop file search
> applications have with the kernel notification APIs, there might be other
> approaches I did not yet thought off... so feel free to comment with your
> thoughts on it.

I will only comment on the real time indexing part since I had some part in 
the inception of fanotify and still remember a thing or two about it.

Perhaps you should look into how hard would it be to add directory or rename, 
and unlink events to fanotify. It may not be too hard.

In that case, even though it does not support recursive directory watches (I 
tried to implement this some time around 2009. but found it impossible to 
wedge into the fanotify locking model), it does support mount point watches. 
Which for the desktop use might be sufficient, assuming /home is typically a 
separate filesystem.

Downside with  this approach is that you have to filter out the events you do 
not care about like /home/some-other-user, or even more if /home is not a 
separate filesystem. Which with the current fanotify state can be done using 
paths, but that includes resolving a link in procfs which may be a too 
expensive thing to do.

Or perhaps it is acceptable, if you for example only cared about CLOSE_WRITE 
events (closure of file which were open for writing).

So I think for this part you have two options, have a go of extending 
directory watches to be recursive, or live with the mount watches giving you 
too much traffic.

Regards,

Tvrtko
