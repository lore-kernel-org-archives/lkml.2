Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab2EMEk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 00:40:57 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45019 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab2EMEkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 00:40:55 -0400
Date: Sun, 13 May 2012 00:40:52 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: =?iso-8859-1?Q?Bj=F6rn?= Christoph <einkaufenbc09@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: jbd2 slowing down file copies even though no journaling
 file system is used
Message-ID: <20120513044052.GC31866@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	=?iso-8859-1?Q?Bj=F6rn?= Christoph <einkaufenbc09@googlemail.com>,
	linux-kernel@vger.kernel.org
References: <CAHOpdHWMcV6LjpaEhk27ULkz-wGUD0-pNH=PC+ahDn47VQ+qmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHOpdHWMcV6LjpaEhk27ULkz-wGUD0-pNH=PC+ahDn47VQ+qmQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 01:21:00AM +0200, Björn Christoph wrote:
> 
> IOTOP shows this in some cases, mostly jbd2 is not there:
>   PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND
>   416 be/3 root        0.00 B/s   97.65 M/s  0.00 % 13.74 % [jbd2/dm-1-8]

Well, the file system in that has the huge write bandwidth is
whichever device is associated with device mapper device dm-1 (i.e.,
with a device mapper minor number of 1).  What does "ls -l
/dev/mapper" show you?

Whatever file system is associated with it is clearly generating a lot
of journal activity.

Something that may help in determining what process is generating all
of this journal activity (which is likely the result of something
calling fsync a lot) is to try this:

echo 1 > /sys/kernel/debug/tracing/events/ext4/ext4_sync_file_enter/enable

... then wait for a minute or so, and then capture the output of:

cat /sys/kernel/debug/tracing/trace

See if that shows up anything useful.

Regards,

					- Ted
