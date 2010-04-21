Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab0DUDEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 23:04:45 -0400
Received: from kroah.org ([198.145.64.141]:53013 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab0DUDE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 23:04:28 -0400
Date: Tue, 20 Apr 2010 20:04:06 -0700
From: Greg KH <greg@kroah.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
       Ashwin Ganti <ashwin.ganti@gmail.com>, rsc@swtch.com, ericvh@gmail.com,
       linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>,
       jt.beard@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com,
       Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Message-ID: <20100421030406.GB10258@kroah.com>
References: <20100421012749.GA21338@us.ibm.com> <20100421012908.GB24251@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421012908.GB24251@us.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 08:29:08PM -0500, Serge E. Hallyn wrote:
> This is a driver that adds Plan 9 style capability device
> implementation.  See Documentation/p9auth.txt for a description
> of how to use this.

Hm, you didn't originally write this driver, so it would be good to get
some original authorship information in here to keep everything correct,
right?

>  Documentation/p9auth.txt     |   47 ++++
>  drivers/char/Kconfig         |    2 +
>  drivers/char/Makefile        |    2 +
>  drivers/char/p9auth/Kconfig  |    9 +
>  drivers/char/p9auth/Makefile |    1 +
>  drivers/char/p9auth/p9auth.c |  517 ++++++++++++++++++++++++++++++++++++++++++

Is this code really ready for drivers/char/?  What has changed in it
that makes it ok to move out of the staging tree?

And who is going to maintain it?  You?  Or someone else?

>  6 files changed, 578 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/p9auth.txt
>  create mode 100644 drivers/char/p9auth/Kconfig
>  create mode 100644 drivers/char/p9auth/Makefile
>  create mode 100644 drivers/char/p9auth/p9auth.c
> 
> diff --git a/Documentation/p9auth.txt b/Documentation/p9auth.txt
> new file mode 100644
> index 0000000..14a69d8
> --- /dev/null
> +++ b/Documentation/p9auth.txt
> @@ -0,0 +1,47 @@
> +The p9auth device driver implements a plan-9 factotum-like
> +capability API.  Tasks which are privileged (authorized by
> +possession of the CAP_GRANT_ID privilege (POSIX capability))
> +can write new capabilities to /dev/caphash.  The kernel then
> +stores these until a task uses them by writing to the
> +/dev/capuse device.  Each capability represents the ability
> +for a task running as userid X to switch to userid Y and
> +some set of groups.  Each capability may be used only once,
> +and unused capabilities are cleared after two minutes.
> +
> +The following examples shows how to use the API.  Shell 1
> +contains a privileged root shell.  Shell 2 contains an
> +unprivileged shell as user 501 in the same user namespace.  If
> +not already done, the privileged shell should create the p9auth
> +devices:
> +
> +	majfile=/sys/module/p9auth/parameters/cap_major
> +	minfile=/sys/module/p9auth/parameters/cap_minor
> +	maj=`cat $majfile`
> +	mknod /dev/caphash c $maj 0
> +	min=`cat $minfile`
> +	mknod /dev/capuse c $maj 1
> +	chmod ugo+w /dev/capuse

That is incorrect, you don't need the cap_major/minor files at all, the
device node should be automatically created for you, right?

And do you really want to do all of this control through a device node?
Why?

> +DEFINE_MUTEX(cap_mutex); /* TODO fix up the locking one day */

One might hope that today would be that day...

Also, please run this through sparse.  This is a variable that doesn't
need to be global.

> +struct cap_dev {
> +	struct cdev cdev;
> +};

Do you really need to do it this way?  A cdev for a single device node?
That's major overkill.

> +static int cap_major = CAP_MAJOR;
> +static int cap_minor;

Just always use a dynamic misc device, you never need a whole major for
this.

> +module_param(cap_major, int, S_IRUGO);
> +module_param(cap_minor, int, S_IRUGO);

Can be removed.

> +MODULE_AUTHOR("Ashwin Ganti");

Hm, who is going to maintain this, you, or Ashwin?

> +static void hexdump(unsigned char *buf, unsigned int len)
> +{
> +	while (len--)
> +		printk(KERN_DEBUG "%02x", *buf++);
> +	printk(KERN_DEBUG "\n");
> +}

We have a built-in function for this already.

Oh, this function is also incorrect, which is a good reason to use the
built-in ones.

I'm going to stop now, this doesn't belong in drivers/char/ yet, it
needs work...

thanks,

greg k-h

> +/*
> + * read an entry.  For now it is
> + * source_user@target_user@rand
> + * Next it will become
> + * source_user@target_user@target_group@numgroups@grp1..@grpn@rand
> + */

Hm, wait, one more....  The kernel/user api is going to change some time
in the future?  Please fix this now before it gets merged.
