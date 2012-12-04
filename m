Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab2LDTlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 14:41:09 -0500
Received: from tetsuo.zabbo.net ([50.193.208.193]:59712 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab2LDTlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 14:41:07 -0500
Date: Tue, 4 Dec 2012 11:41:06 -0800
From: Zach Brown <zab@zabbo.net>
To: yangsheng <sickamd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger@dilger.ca
Subject: Re: [PATCH] Update atime from future.
Message-ID: <20121204194106.GA2200@lenny.home.zabbo.net>
References: <1354557399-6202-1-git-send-email-sickamd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354557399-6202-1-git-send-email-sickamd@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 01:56:39AM +0800, yangsheng wrote:
> Relatime should update the inode atime if it is more than a day in the
> future.  The original problem seen was a tarball that had a bad atime,
> but could also happen if someone fat-fingers a "touch".  The future
> atime will never be fixed.  Before the relatime patch, the future atime
> would be updated back to the current time on the next access.

I guess.

>  	/*
> +	 * Is the previous atime value in future? If yes,
> +	 * update atime:
> +	 */
> +	if ((long)(now.tv_sec - inode->i_atime.tv_sec) < -RELATIME_MARGIN)
> +		return 1;

But this is confusing to read.  "If atime is less than a negative day in
the past.. wait, what?"

It seems like we should combine the two RELATIME_MARGIN tests.

	/*
	 * Update atime if it's older than a day or more than a day
	 * in the future, which we assume is corrupt.
	 */
	if (abs(inode->i_atime.tv_sec - now.tv_sec)) >= RELATIME_MARGIN)
		return 1;

(I don't know if you'd still need the (long) cast in there, given the
type tests in abs()).

- z
