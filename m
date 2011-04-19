Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1DSLnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:43:06 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57261 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1DSLnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:43:04 -0400
Date: Tue, 19 Apr 2011 07:42:55 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Dave Jones <davej@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110419114255.GB3030@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
	Kay Sievers <kay.sievers@vrfy.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
 <20110412190934.GA12082@redhat.com>
 <20110412192103.GA13278@redhat.com>
 <87tye1ckhr.fsf@linux.vnet.ibm.com>
 <BANLkTik68Q2bpgF7GpcOs+YF44B9TL60qQ@mail.gmail.com>
 <20110418230254.GA22588@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418230254.GA22588@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 07:02:55PM -0400, Dave Jones wrote:
>  > Your code looks like you copy the bytes to the in-kernel superblock
>  > structure without noticing any later changes on disk? How is that
>  > supposed to work?
> 
> I thought tune2fs on a mounted filesystem was always a
> "you get to keep both pieces if it breaks" situation.

It's actually something that we've supported for a long time, and we
go to some lengths to make it be safe.  Ext[234] always directly
checks things that could be safely changed by tune2fs directly in the
buffer cache where the superblock is stored, and tune2fs checks to see
if the file system is mounted, and (a) will refuse to make certain
changes that are unsafe, and (b) make the changes to the buffer cache
by seeking to the right place in the superblock and only writing the
1/2/4 bytes which are needed to make the change.

So it is something that we've advertised will work, although some
changes only take effect when the file system is mounted and
remounted, even if you are allowed to make the change while the file
system is mounted.  The best known example of this is being able to
on-line convert a mounted root file system to add a journal.  You can
do that while it is mounted, but you have to reboot and/or
mount/remount the file system in order for the journal to start
getting used.

						- Ted
