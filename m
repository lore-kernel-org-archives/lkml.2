Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab2HNSbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:31:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37729 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab2HNSbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:31:44 -0400
Date: Tue, 14 Aug 2012 19:31:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 3/8] procfs: Add ability to plug in auxiliary fdinfo
 providers
Message-ID: <20120814183142.GH23464@ZenIV.linux.org.uk>
References: <20120814140342.354405844@openvz.org>
 <20120814140620.033884909@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814140620.033884909@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 06:03:45PM +0400, Cyrill Gorcunov wrote:
> This patch brings ability to plug in auxiliary fdinfo providers.
> For example in further patches eventfd, evenpoll and fsnotify
> will print out information associated with files.
> 
> This feature is CONFIG_CHECKPOINT_RESTORE guarded to eliminate
> overhead for those who don't need it at all (this
> unfortunately makes patch bigger than I wanted).
> 
> The basic usage rule is the following
> 
>  - fdinfo provider should register own "show" method
>    via proc_register_fdinfo_driver call, where "show"
>    methods are rather well known seq-file operations
> 
>  - once the kernel opens /proc/$pid/fdinfo/$fd file
>    it calls for ->probe() method in registered fdinfo
>    drivers, and if probe success, then seq-file "show"
>    operations will be called to provide out additional
>    infomation
> 
> Initially we considered to inject some "show" metod to
> file_operations but since there really a number of
> file_operations declared inside kernel (and in real the
> further patches cover onle eventfd/epoll/inotify) the
> waste of memory space will be inacceptable I think.

NAK.  This is too ugly to live.  Put it into file_operations,
with NULL meaning default output, or don't do it at all.

And no, "it's only if you enable CONFIG_SOME_SHIT" gambit won't
fly - we have all seen it played too many times.  All it takes
is one politically-inclined induhvidual adding a dependency to
some "vertically integrated" turd (*cough* systemd *spit* udev
*cough*) and we are stuck with the damn thing.  CGROUP shite
is already there, DEVTMPFS is well on its way, etc.
