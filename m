Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215Ab1ERRFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 13:05:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62826 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910Ab1ERRFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 13:05:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bzxrxQBSBscTpmd1kYSpvxdqteN9Z2H8Z4XGCumD+cr8flIb868mGf+sT0Ri9v/Quf
         xIrtJDB64ebAXwr6PohmnRqzM8Q9zIqJ1PLPSn6indJlaxIzK569sUt6XjpPehPk5JS4
         +SaUDHW5FiOaIVi+CaPo9cqqEZIEkoihiS/g0=
Date: Wed, 18 May 2011 21:05:45 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        Eugene Teo <eugeneteo@gmail.com>
Subject: Re: [RFC] add mount options to sysfs
Message-ID: <20110518170545.GA4435@albatros>
References: <20110518163142.GA3367@albatros>
 <20110518163951.GA24143@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518163951.GA24143@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 09:39 -0700, Greg KH wrote:
> On Wed, May 18, 2011 at 08:31:44PM +0400, Vasiliy Kulikov wrote:
> > Currently there is no good way to effectively globally restrict an
> > access to sysfs files.  It's possible only to chmod the sysfs'
> > root/directories to fully deny access to sysfs (sub-)tree to some users
> > or chmod files after they are created.  The latter approach is racy,
> > however.
> 
> Why do you want to do this?  What is in sysfs files that is not
> gloabally ok to access?  That should be fixed first, if at all, instead
> of wanting to modify the whole sysfs tree, right?

I don't hide the goal (I didn't find any other weird permissions, if
you mean this).  It is primary about additional global controlable
layer of defining permission:

1) *IF* another sensitive file with weird permissions is found, mount
option is IMO the best temporary workaround.

2) Somebody might be worried about information leaks via world readable
files - not strict bugs, but leaks in sense of local policy.  See numerous
discussions about hiding kernel addresses - there is no unified opinion
about it.  Some admins would be happy with denying access to almost all
system information except some white list.

> > The patch introduces sysfs mount options parsing and adds 4 new options:
> > uid, gid, mode and umask.  uid, gid, and umask are classical options,
> > mode is a global restricting mode mask that defined the most relaxed
> > possible file mode.  E.g. if mode=0750 then "chmod 0664" changes file's
> > permissions to 0640.
> 
> What is going to break if you do this?  Have you tested it?  I'd be very
> worried about this.

I've tested it on my laptop (I'm writing booted with this kernel).  By
default nothing has changed (umask=0000, mode=0777).  Mounting sysfs
with mode=0770 leads to the predictable state - no sysfs information is
available to nonroot, e.g.  no ACPI battery state.  umask is tested with
pluging a USB flash.

mode has one advantage over umask.  It is temporary - "mount -o
remount,mode=0777" restores the initial state.


I'd want to implement similar options for debugfs.

Thanks,

-- 
Vasiliy
