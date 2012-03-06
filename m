Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab2CFAhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 19:37:24 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:18071 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab2CFAhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 19:37:21 -0500
Date: Mon, 5 Mar 2012 19:37:16 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: getdents - ext4 vs btrfs performance
Message-ID: <20120306003716.GD4191@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
 <20120301143859.GX5054@shiny>
 <CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
 <20120302140038.GD5054@shiny>
 <CADDYkjT8apYQpdZqr1gZKiHbm9xfTaLr=8GEJF0VKF9neHwgOg@mail.gmail.com>
 <20120302142651.GH5054@shiny>
 <CADDYkjRyQruZgFHDsyAgAV7J3yvunU5YuwmmbxK=1WXJLHw98Q@mail.gmail.com>
 <CADDYkjSWpWAW0dxmMEWjHaRV=jS+U5obeau_GPEgwnJuPBLe3w@mail.gmail.com>
 <CADDYkjQ+N1O0x=_JUdCAdNgrp6mQM44VBzZf6V8e2B5OK6fp1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADDYkjQ+N1O0x=_JUdCAdNgrp6mQM44VBzZf6V8e2B5OK6fp1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F555C3F.0082,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 12:32:45PM +0100, Jacek Luczak wrote:
> 2012/3/4 Jacek Luczak <difrost.kernel@gmail.com>:
> > 2012/3/3 Jacek Luczak <difrost.kernel@gmail.com>:
> >> 2012/3/2 Chris Mason <chris.mason@oracle.com>:
> >>> On Fri, Mar 02, 2012 at 03:16:12PM +0100, Jacek Luczak wrote:
> >>>> 2012/3/2 Chris Mason <chris.mason@oracle.com>:
> >>>> > On Fri, Mar 02, 2012 at 11:05:56AM +0100, Jacek Luczak wrote:
> >>>> >>
> >>>> >> I've took both on tests. The subject is acp and spd_readdir used with
> >>>> >> tar, all on ext4:
> >>>> >> 1) acp: http://91.234.146.107/~difrost/seekwatcher/acp_ext4.png
> >>>> >> 2) spd_readdir: http://91.234.146.107/~difrost/seekwatcher/tar_ext4_readir.png
> >>>> >> 3) both: http://91.234.146.107/~difrost/seekwatcher/acp_vs_spd_ext4.png
> >>>> >>
> >>>> >> The acp looks much better than spd_readdir but directory copy with
> >>>> >> spd_readdir decreased to 52m 39sec (30 min less).
> >>>> >
> >>>> > Do you have stats on how big these files are, and how fragmented they
> >>>> > are?  For acp and spd to give us this, I think something has gone wrong
> >>>> > at writeback time (creating individual fragmented files).
> >>>>
> >>>> How big? Which files?
> >>>
> >>> All the files you're reading ;)
> >>>
> >>> filefrag will tell you how many extents each file has, any file with
> >>> more than one extent is interesting.  (The ext4 crowd may have better
> >>> suggestions on measuring fragmentation).
> >>>
> >>> Since you mention this is a compile farm, I'm guessing there are a bunch
> >>> of .o files created by parallel builds.  There are a lot of chances for
> >>> delalloc and the kernel writeback code to do the wrong thing here.
> >>>
> >>
> > [Most of files are B and K size]
> >>
> >> All files scanned: 1978149
> >> Files fragmented: 313 (0.015%) where 11 have 3+ extents
> >> Total size of fragmented files: 7GB (~13% of dir size)

Ok, so I don't have a lot of great new ideas.  My guess is that inode
order and disk order for the blocks aren't matching up.  You can confirm
this with:

acp -b some_dir

You can also try telling acp to make a bigger read ahead window:

acp -s 4096 -r 128 some_dir

You can tell acp to scan all the files in the directory tree first
(warning, this might use a good chunk of ram)

acp -w some_dir

and you can combine all of these together  None of the above
will actually help in your workload, but it'll help narrow down what is
actually seeky on disk.

-chris
