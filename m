Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1DSIfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:35:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1DSIfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:35:19 -0400
Subject: Re: Linux 2.6.39-rc3
From: Steven Whitehouse <swhiteho@redhat.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <87ipuar6nq.fsf@linux.vnet.ibm.com>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
	 <20110412190934.GA12082@redhat.com> <20110412192103.GA13278@redhat.com>
	 <87tye1ckhr.fsf@linux.vnet.ibm.com>
	 <BANLkTik68Q2bpgF7GpcOs+YF44B9TL60qQ@mail.gmail.com>
	 <87ipuar6nq.fsf@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 19 Apr 2011 09:37:47 +0100
Message-ID: <1303202267.2702.6.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2011-04-19 at 13:53 +0530, Aneesh Kumar K.V wrote:
> On Tue, 19 Apr 2011 00:57:27 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > On Thu, Apr 14, 2011 at 10:20, Aneesh Kumar K.V
> > <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > > On Tue, 12 Apr 2011 15:21:03 -0400, Dave Jones <davej@redhat.com> wrote:
> > >> On Tue, Apr 12, 2011 at 03:09:34PM -0400, Dave Jones wrote:
> > >>
> > >>  > however, the output of mount looks very confused..
> > >>  >
> > >>  > .38:
> > >>  > /dev/mapper/vg_adamo-lv_home on /home type ext4 (rw,relatime,seclabel,barrier=1,data=ordered)
> > >>  >
> > >>  > .39:
> > >>  > - on /home type 79a9-4526-888c-1f86d35a6704 (rw,relatime,ext4)
> > >>  >
> > >>  > It looks like /proc/self/mountinfo broke abi.
> > >>  >
> > >>  > .38:
> > >>  > 48 45 253:3 / /home rw,relatime - ext4 /dev/mapper/vg_adamo-lv_home rw,seclabel,barrier=1,data=ordered
> > >>  >
> > >>  > .39:
> > >>  > 46 22 253:3 / /home rw,relatime uuid:f3971858-79a9-4526-888c-1f86d35a6704 - ext4 /dev/mapper/vg_adamo-lv_home rw,seclabel,user_xattr,barrier=1,data=ordered
> > >>
> > >> looks like this was caused by 93f1c20bc8cdb757be50566eff88d65c3b26881f
> > >>
> > >> perhaps adding that string to the end of the line would preserve what mount expects ?
> > >
> > > uuid:<value> is the option field  as per
> > > Documentation/filesystem/proc.txt. There was an error in libmount
> > > parsing which got fixed upstream recently
> > 
> > Just a simple question about this approach in general? A filesystem
> > UUID can be changed on disk at any time (tune2fs -U ...).
> > 
> > Your code looks like you copy the bytes to the in-kernel superblock
> > structure without noticing any later changes on disk? How is that
> > supposed to work?
> > 
> 
> Isn't that true even for the fsid returned by statfs ?.  IIUC tune2fs
> won't change even the ext4_super_block.s_uuid .
> 
> -aneesh

For gfs2 we insist that the volume label (lock table name) and the uuid
do not change during the lifetime of a mount since they are used as
identifiers by the userland infrastructure. We include them with all
uevent messages, for example, and we do not have a "uuid changed"
uevent. So we use exactly the behaviour proposed: copying the info from
the sb at mount time and then never changing it during the lifetime of
the mount.

The doesn't prevent someone making an on-disk change though while the fs
is mounted with tunegfs2 (or gfs2_tool for older gfs2-utils).

One question though, is why would it be useful to change the uuid of a
mounted filesystem? It seems likely to lead to confusion for no useful
gain,

Steve.


