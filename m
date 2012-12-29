Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2L2UI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 15:08:59 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:54351 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752748Ab2L2UI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 15:08:58 -0500
Message-ID: <1356811734.16149.1.camel@joe-AO722>
Subject: Re: [PATCH] printk: Fix incorrect length from print_time() when
 seconds > 99999
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sylvain Munaut <s.munaut@whatever-company.com>
Cc: Roland Dreier <roland@kernel.org>, Kay Sievers <kay@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Roland Dreier <roland@purestorage.com>
Date: Sat, 29 Dec 2012 12:08:54 -0800
In-Reply-To: <20121229175625.GA1963@kroah.com>
References: <1356754984-13917-1-git-send-email-roland@kernel.org>
	 <20121229175625.GA1963@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-29 at 09:56 -0800, Greg Kroah-Hartman wrote:
> On Fri, Dec 28, 2012 at 08:23:04PM -0800, Roland Dreier wrote:
> > From: Roland Dreier <roland@purestorage.com>
> > 
> > print_prefix() passes a NULL buf to print_time() to get the length of
> > the time prefix; when printk times are enabled, the current code just
> > returns the constant 15, which matches the format "[%5lu.%06lu] " used
> > to print the time value.  However, this is obviously incorrect when
> > the whole seconds part of the time gets beyond 5 digits (100000
> > seconds is a bit more than a day of uptime).
> > 
> > The simple fix is to use snprintf(NULL, 0, ...) to calculate the
> > actual length of the time prefix.  This could be micro-optimized but
> > it seems better to have simpler, more readable code here.
> > 
> > The bug leads to the syslog system call miscomputing which messages
> > fit into the userspace buffer.  If there are enough messages to fill
> > log_buf_len and some have a timestamp >= 100000, dmesg may fail with:
> > 
> >     # dmesg
> >     klogctl: Bad address
> > 
> > When this happens, strace shows that the failure is indeed EFAULT due
> > to the kernel mistakenly accessing past the end of dmesg's buffer,
> > since dmesg asks the kernel how big a buffer it needs, allocates a bit
> > more, and then gets an error when it asks the kernel to fill it:
> > 
> >     syslog(0xa, 0, 0)                       = 1048576
> >     mmap(NULL, 1052672, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fa4d25d2000
> >     syslog(0x3, 0x7fa4d25d2010, 0x100008)   = -1 EFAULT (Bad address)
> > 
> > Signed-off-by: Roland Dreier <roland@purestorage.com>
> 
> Nice work.  When did you start seeing this problem, 3.6 or so?  I ask as
> it's probably something that should go to stable as well if so.
> 
> Andrew seems to be keeping the printk patches these days, so I'll let
> him pick this up with:

Sylvan Munaut did something similar
https://lkml.org/lkml/2012/12/5/168

It's been around quite awhile.


