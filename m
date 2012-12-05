Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab2LEDYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 22:24:20 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44052 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab2LEDYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 22:24:16 -0500
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
References: <1354557399-6202-1-git-send-email-sickamd@gmail.com> <20121204202416.GB9451@dastard>
In-Reply-To: <20121204202416.GB9451@dastard>
Mime-Version: 1.0 (1.0)
Message-Id: <424C1F3A-E96F-485B-BAE5-02CE41C0DBFF@whamcloud.com>
Cc: yangsheng <sickamd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "adilger@dilger.ca" <adilger@dilger.ca>
From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] Update atime from future.
Date: Tue, 4 Dec 2012 17:22:32 -0700
To: Dave Chinner <david@fromorbit.com>
X-Mailer: iPhone Mail (10A523)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-04, at 13:24, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Dec 04, 2012 at 01:56:39AM +0800, yangsheng wrote:
>> Relatime should update the inode atime if it is more than a day in the
>> future.  The original problem seen was a tarball that had a bad atime,
>> but could also happen if someone fat-fingers a "touch".  The future
>> atime will never be fixed.  Before the relatime patch, the future atime
>> would be updated back to the current time on the next access.
> 
> So if someone accidentally changes time back a few days, access
> times go backwards for everything?

And they will go forward again if the files are accessed again in the future. 

> That doesn't sound right to me -
> it's going to seriously screw up backups and other scanners that use
> atime to determine "newly accessed files"....

I think it is equally as easy to say that if someone accidentally sets the time too far in the future (e.g. 2102 instead of 2012) for a while, then the atimes will be even more broken since the kernel will never update them again even after the clock is fixed. 

The point is that the behaviour before the relatime patch was that the kernel updated the atime to the current time as the kernel knows about it, it didn't make any decision about "the past" or "the future".

Relatime is about reducing the frequency of atime updates, not about deciding that one timestamp is more correct than another. 

I'd be ok to change the margin for what constitutes a "future" time (a few days or a week?), but if atime updates happen once a day for times in the past  I don't think it is incorrect to update the atime if it is more than a day in the future. 

Cheers, Andreas

> IMO, if you fat-finger a manual atime update or use atimes direct
> from tarballs, then that's your problem as a user and not the
> responsibility of the kernel to magically fix for you....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
