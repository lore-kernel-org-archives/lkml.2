Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab2BAXPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 18:15:36 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54865 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab2BAXPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 18:15:34 -0500
MIME-Version: 1.0
In-Reply-To: <m1ehueyz20.fsf_-_@fess.ebiederm.org>
References: <4F27120A.4040106@suse.cz> <20120130220611.GA26655@kroah.com>
 <20120130221059.26ab5edf@pyramind.ukuu.org.uk> <20120130222717.GA6393@kroah.com>
 <m18vkoirv9.fsf@fess.ebiederm.org> <4F27C6EB.2070305@suse.cz>
 <m14nvc82jo.fsf@fess.ebiederm.org> <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org> <m1ehueyz20.fsf_-_@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Feb 2012 15:15:14 -0800
X-Google-Sender-Auth: 1gTS8fgesG0aWta1vBxPcy2Q448
Message-ID: <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
Subject: Re: [PATCH] sysfs: Optionally count subdirectories to support buggy applications
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 2:21 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> lm_sensors and possibly other applications get confused if all sysfs
> directories return nlink == 1.  The lm_sensors code that got confused
> was just wrong and a fixed version of lm_sensors should be released
> shortly.

I think this patch is horrible, and broken.

And making the feature a config option is just stupid.

The simple approach is to

 - implement a inode->i_op->getattr function for sysfs

 - make it call generic_fillattr()

 - after filling in the generic fields, count the number of sysfs
children it has and update stat->nlink appropriately.

No extra "keep track of inode counts by hand" crap, and no idiotic
config options that just make it easy to (conditionally) get things
wrong. Just do it right, and do it *unconditionally* right.

The Linux VFS layer is smart, and allows filesystems to do these kinds
of fixups.

                  Linus
