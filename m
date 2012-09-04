Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab2IDQCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:02:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab2IDQCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:02:23 -0400
Date: Tue, 4 Sep 2012 18:04:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Vagin <avagin@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, criu@openvz.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] kernel: limit a value of ns_last_pid to (0, max_pid)
Message-ID: <20120904160442.GB8199@redhat.com>
References: <1346746632-3025128-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346746632-3025128-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04, Andrew Vagin wrote:
>
> The kernel doesn't check pid on a negative values, so if
> you would try to write -2 in /proc/sys/kernel/ns_last_pid,
> you will get a kernel panic.
>
> In this case the next pid is -1, and alloc_pidmap will try to access
> to a nonexistent pidmap.
>
> map = &pid_ns->pidmap[pid/BITS_PER_PAGE];

Yes, alloc_pidmap() assumes that pid_ns->last_pid + 1 is positive...

So ".extra1 = &zero" is not enough, INT_MAX can overflow as well.

>  static struct ctl_table pid_ns_ctl_table[] = {
>  	{
>  		.procname = "ns_last_pid",
>  		.maxlen = sizeof(int),
>  		.mode = 0666, /* permissions are checked in the handler */
>  		.proc_handler = pid_ns_ctl_handler,
> +		.extra1 = &zero,
> +		.extra2 = &pid_max,

Acked-by: Oleg Nesterov <oleg@redhat.com>

