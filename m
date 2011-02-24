Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab1BXJ0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 04:26:31 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:12653 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966Ab1BXJ02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 04:26:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAayZU15LFEb/2dsb2JhbACmInS9DA2DC4JIBJF0
Date: Thu, 24 Feb 2011 20:26:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Linda A. Walsh" <lkml@tlinx.org>
Cc: PXXdraig Brady <P@draigBrady.com>, LKML <linux-kernel@vger.kernel.org>,
        xfs-oss <xfs@oss.sgi.com>
Subject: Re: write 'O_DIRECT' file w/odd amount of data: desirable result?
Message-ID: <20110224092625.GA3087@dastard>
References: <4D648D7D.7040500@tlinx.org>
 <4D64E2BB.7010000@draigBrady.com>
 <4D654C2E.2000703@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D654C2E.2000703@tlinx.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 10:04:30AM -0800, Linda A. Walsh wrote:
> 
> 
> FWIW -- xfs-oss, included as 'last line' was of minor interest; known bug on
> this kernel?:
> Linux Ishtar 2.6.35.7-T610-Vanilla-1 #2 SMP PREEMPT Mon Oct 11
> 17:19:41 PDT 2010 x86_64 x86_64 x86_64 GNU/Linux
....
> Of *SIGNIFICANT* note.  In trying to create an empty file of the size
> used, from scratch, using 'xfs_mkfile', I got an error:
> 
> > xfs_mkfile 5776419696 testfile
> pwrite64: Invalid argument

xfs_mkfile does not create an "empty" file. It creates a file that
is full of zeros.

iAnd you're getting that erro because:

5776419696 / 512 = 11,282,069.7188

the last write is not a multiple of the sector size and xfs_mkfile
uses direct IO. It has always failed when you try to do this. If you
want to create allocated, zeroed files of abitrary size, then use:

xfs_io -f -c "truncate $size" -c "resvsp 0 $size" $filename

to preallocate it. it'll be much, much faster than xfs_mkfile.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
