Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab2L2Rwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 12:52:51 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:48919 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab2L2Rws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 12:52:48 -0500
Date: Sat, 29 Dec 2012 09:56:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Roland Dreier <roland@kernel.org>
Cc: Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH] printk: Fix incorrect length from print_time() when
 seconds > 99999
Message-ID: <20121229175625.GA1963@kroah.com>
References: <1356754984-13917-1-git-send-email-roland@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356754984-13917-1-git-send-email-roland@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 08:23:04PM -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> print_prefix() passes a NULL buf to print_time() to get the length of
> the time prefix; when printk times are enabled, the current code just
> returns the constant 15, which matches the format "[%5lu.%06lu] " used
> to print the time value.  However, this is obviously incorrect when
> the whole seconds part of the time gets beyond 5 digits (100000
> seconds is a bit more than a day of uptime).
> 
> The simple fix is to use snprintf(NULL, 0, ...) to calculate the
> actual length of the time prefix.  This could be micro-optimized but
> it seems better to have simpler, more readable code here.
> 
> The bug leads to the syslog system call miscomputing which messages
> fit into the userspace buffer.  If there are enough messages to fill
> log_buf_len and some have a timestamp >= 100000, dmesg may fail with:
> 
>     # dmesg
>     klogctl: Bad address
> 
> When this happens, strace shows that the failure is indeed EFAULT due
> to the kernel mistakenly accessing past the end of dmesg's buffer,
> since dmesg asks the kernel how big a buffer it needs, allocates a bit
> more, and then gets an error when it asks the kernel to fill it:
> 
>     syslog(0xa, 0, 0)                       = 1048576
>     mmap(NULL, 1052672, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fa4d25d2000
>     syslog(0x3, 0x7fa4d25d2010, 0x100008)   = -1 EFAULT (Bad address)
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>

Nice work.  When did you start seeing this problem, 3.6 or so?  I ask as
it's probably something that should go to stable as well if so.

Andrew seems to be keeping the printk patches these days, so I'll let
him pick this up with:

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

