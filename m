Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab2BGAiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:38:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57888 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2BGAiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:38:20 -0500
Date: Tue, 7 Feb 2012 00:38:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josh Hunt <johunt@akamai.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] poll() in 32-bit applications does not handle
 timeout of -1 properly on 64-bit kernels
Message-ID: <20120207003819.GH23916@ZenIV.linux.org.uk>
References: <4F306ACA.4090404@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F306ACA.4090404@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 06:05:30PM -0600, Josh Hunt wrote:
> We've hit an issue where our 32-bit applications, when running on a
> 64-bit kernel, using poll() and passing in a value of -1 for the timeout
> return after ~49 days (2^32 msec). Instead of waiting indefinitely as it
> is stated they should. Reproducing the issue is trivial. I've
> instrumented the kernel and found we are hitting the case where poll()
> believes we've passed in a positive number and thus creates a timespec,
> etc. Currently poll() is defined in userspace as:
> 
> int poll(struct pollfd *ufds, nfds_t nfds, int timeout);
> 
> but in the kernel timeout is of type long.
> 
> I can think of a few ways to solve this. One, which is the patch I've
> attached, is to change the type of timeout to int in the kernel. I'm not
> certain the ramifications this may have since it's changing a syscall's
> arguments which may be a big no-no :) Another way I am proposing is by
> bounds checking. Currently we do the following:
> 
> if (timeout_msecs >= 0) {
>         to = &end_time;
>         poll_select_set_timeout(to, timeout_msecs / MSEC_PER_SEC,
>                         NSEC_PER_MSEC * (timeout_msecs % MSEC_PER_SEC));
> }
> 
> We could add an upper bound on timeout_msecs to say < 0xffffffff. I'm
> not sure if either is acceptable though.

Or just add compat_sys_poll() with that argument being int and have it call
sys_poll().  The value will be sign-extended...
