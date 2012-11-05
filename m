Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab2KEKdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:33:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab2KEKdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:33:49 -0500
Subject: Re: VFS hot tracking: How to calculate data temperature?
From: Steven Whitehouse <swhiteho@redhat.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, cmm@us.ibm.com,
        linux-fsdevel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
        Ben Chociej <bchociej@gmail.com>,
        James Northrup <northrup.james@gmail.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
In-Reply-To: <CAEH94LhbiHdsTCzsH6K8g3WH02_5-dnUPRZBCJW9vtpgAuuGtg@mail.gmail.com>
References: <CAEH94LjTedn0n00ZtqFxBL=kDA3u8G39q+x79-vPoMYvEKW1gw@mail.gmail.com>
	 <CAEH94LgUcAL6RquMZKTrDg87_0J2sEqTsDXUbnhrQ37KuMJ4sg@mail.gmail.com>
	 <1351891622.23963.4.camel@oc2046235844.ibm.com>
	 <CAEH94LiuKGPi+k=pA9P-FFsosnwG7PRBK5DjjaGf20S+pyrzpA@mail.gmail.com>
	 <20121105082828.GJ29378@dastard>
	 <CAEH94LhbiHdsTCzsH6K8g3WH02_5-dnUPRZBCJW9vtpgAuuGtg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 05 Nov 2012 10:33:08 +0000
Message-ID: <1352111588.2705.7.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2012-11-05 at 16:44 +0800, Zhi Yong Wu wrote:
> On Mon, Nov 5, 2012 at 4:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Nov 05, 2012 at 10:35:50AM +0800, Zhi Yong Wu wrote:
> >> On Sat, Nov 3, 2012 at 5:27 AM, Mingming.cao <cmm@us.ibm.com> wrote:
> >> > On Fri, 2012-11-02 at 14:38 +0800, Zhi Yong Wu wrote:
> >> >> Here also has another question.
> >> >>
> >> >> How to save the file temperature among the umount to be able to
> >> >> preserve the file tempreture after reboot?
> >> >>
> >> >> This above is the requirement from DB product.
> >> >> I thought that we can save file temperature in its inode struct, that
> >> >> is, add one new field in struct inode, then this info will be written
> >> >> to disk with inode.
> >> >>
> >> >> Any comments or ideas are appreciated, thanks.
> >> >>
> >> >>
> >> >
> >> > Maybe could save the last file temperature with extended attributes.
> >> It seems that only ext4 has the concept of extended attributes.
> >
> > All major filesystems have xattr support. They are used extensively
> > by the security and integrity subsystems, for example.
> got it, thanks.
> >
> > Saving the information might be something that is useful to certian
> > applications, but lets have the people that need that functionality
> > spell out their requirements before discussing how or what to
> > implement.  Indeed, discussion shoul dreally focus on getting the
> > core, in-memory infrastructure sorted out first before trying to
> > expand the functionality further...
> ah, but the latest patchset need some love from experienced FS guys:).......

There is one other possible issue with saving the data into the
filesystem, which is that it may disturb what you are trying to measure.
Some filesystems (GFS2 is one) store data for small inodes in the same
block as the inode itself. So that means the accesses to the saved hot
tracking info may potentially affect the data access times too. Also
there is a very limited amount of space to expand the number of fields
in the inode, so xattr may be the only solution, depending on how much
data needs to be stored in each case.

In the GFS2 case (I don't think it is unique in this) xattrs are stored
out of line and having to access them in every open means an extra block
read per inode, which again has performance implications.

So that is not an insurmountable problem, but something to take into
account in selecting a solution,

Steve.



